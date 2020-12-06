import 'dart:async';
import 'dart:convert';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/models/addess_models.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:eSamudaay/utilities/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressAction extends ReduxAction<AppState> {
  final AddressRequest request;

  AddAddressAction({@required this.request});

  @override
  FutureOr<AppState> reduce() async {
    debugPrint("add address => ${request.toJson()}");
    var response = await APIManager.shared.request(
        url: ApiURL.addressUrl,
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.status == ResponseStatus.success200) {
      //  Fluttertoast.showToast(msg: "Updated");

      AddressResponse responseModel = AddressResponse.fromJson(response.data);

      List<AddressResponse> _updatedAddressList =
          (state.addressState.savedAddressList ?? [])..add(responseModel);

      await UserManager.saveAddress(address: jsonEncode(_updatedAddressList));

      return state.copyWith(
        addressState: state.addressState.copyWith(
          savedAddressList: _updatedAddressList,
        ),
      );
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
      //throw UserException(response.data['status']);
    }
    return null;
  }

  void before() => dispatch(UpdateAddressLoadingStatus(true));

  void after() => dispatch(UpdateAddressLoadingStatus(false));
}

// class UpdateAddressAction extends ReduxAction<AppState> {
//   final AddressRequest request;
//   final String addressID;

//   UpdateAddressAction({
//     this.request,
//     this.addressID,
//   });

//   @override
//   FutureOr<AppState> reduce() async {
//     var response = await APIManager.shared.request(
//         url: ApiURL.addressUrl + "$addressID",
//         params: request.toJson(),
//         requestType: RequestType.patch);

//     if (response.status == ResponseStatus.success200) {
//       Fluttertoast.showToast(msg: "Updated");

//       Address responseModel = Address.fromJson(response.data);
//       await UserManager.saveAddress(
//           address: jsonEncode(responseModel.toJson()));
//       return state.copyWith(
//           authState: state.authState.copyWith(address: responseModel));
//     } else {
//       Fluttertoast.showToast(msg: response.data['message']);
//       //throw UserException(response.data['status']);
//     }
//     return null;
//   }

//   void before() =>
//       dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

//   void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
// }

class GetAddressAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
      url: ApiURL.addressUrl,
      params: null,
      requestType: RequestType.get,
    );

    if (response.status == ResponseStatus.success200) {
      List<AddressResponse> responseModel = List<AddressResponse>();

      response.data.forEach((e) {
        responseModel.add(AddressResponse.fromJson(e));
      });

      await UserManager.saveAddress(address: jsonEncode(responseModel));

      return state.copyWith(
        addressState: state.addressState.copyWith(
          savedAddressList: responseModel,
        ),
      );
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
      //throw UserException(response.data['status']);
    }
    return null;
  }
}

class DeleteAddressAction extends ReduxAction<AppState> {
  String addressId;
  DeleteAddressAction(this.addressId);

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
      url: ApiURL.addressUrl,
      params: null,
      requestType: RequestType.delete,
    );

    if (response.status == ResponseStatus.success200) {
      List<AddressResponse> responseModel = state.addressState.savedAddressList;

      responseModel.removeWhere((element) => element.addressId == addressId);

      await UserManager.saveAddress(address: jsonEncode(responseModel));

      return state.copyWith(
        addressState: state.addressState.copyWith(
          savedAddressList: responseModel,
        ),
      );
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
      //throw UserException(response.data['status']);
    }
    return null;
  }

  void before() => dispatch(UpdateAddressLoadingStatus(true));

  void after() => dispatch(UpdateAddressLoadingStatus(false));
}

class GetAddressFromLocal extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    List<AddressResponse> address = await UserManager.getAddress();
    return state.copyWith(
      addressState: state.addressState.copyWith(savedAddressList: address),
    );
  }
}

class SaveAddressRequest extends ReduxAction<AppState> {
  AddressRequest addressRequest;
  SaveAddressRequest(this.addressRequest);
  @override
  FutureOr<AppState> reduce() async {
    return state.copyWith(
      addressState: state.addressState.copyWith(addressRequest: addressRequest),
    );
  }
}

class UpdateIsRegisterView extends ReduxAction<AppState> {
  bool isRegisterView;
  UpdateIsRegisterView(this.isRegisterView);
  @override
  FutureOr<AppState> reduce() async {
    return state.copyWith(
      addressState: state.addressState.copyWith(isRegisterView: isRegisterView),
    );
  }
}

class GetInitialLocation extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    LatLng _latLng = LatLng(position.latitude, position.longitude);

    dispatch(GetAddressForLocation(_latLng));

    return state.copyWith(
      addressState: state.addressState.copyWith(
        currentPosition: _latLng,
      ),
    );
  }
}

class GetAddressForLocation extends ReduxAction<AppState> {
  final LatLng position;
  GetAddressForLocation(this.position);
  @override
  FutureOr<AppState> reduce() async {
    List<Address> address = await Geocoder.local.findAddressesFromCoordinates(
      new Coordinates(position.latitude, position.longitude),
    );
    if (address != null && address.isNotEmpty) {
      return state.copyWith(
        addressState: state.addressState.copyWith(
          addressDetails: address[0],
        ),
      );
    }
    return null;
  }

  @override
  void before() => dispatch(UpdateAddressLoadingStatus(true));

  @override
  void after() => dispatch(UpdateAddressLoadingStatus(false));
}

class UpdateAddressLoadingStatus extends ReduxAction<AppState> {
  final bool isLoading;
  UpdateAddressLoadingStatus(this.isLoading);
  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      addressState: state.addressState.copyWith(
        isAddressLoading: isLoading,
      ),
    );
  }
}

class UpdateAddress extends ReduxAction<AppState> {
  final Address address;
  UpdateAddress(this.address);
  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      addressState: state.addressState.copyWith(
        addressDetails: address,
      ),
    );
  }
}

class UpdateCurrentPosition extends ReduxAction<AppState> {
  final LatLng position;
  UpdateCurrentPosition(this.position);
  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      addressState: state.addressState.copyWith(
        currentPosition: position,
      ),
    );
  }
}

class UpdateAddressTag extends ReduxAction<AppState> {
  final String tag;
  UpdateAddressTag(this.tag);
  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      addressState: state.addressState.copyWith(
        addressTag: tag,
      ),
    );
  }
}
