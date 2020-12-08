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
import 'package:eSamudaay/utilities/keys.dart';
import 'package:google_maps_webservice/places.dart';

class AddAddressAction extends ReduxAction<AppState> {
  final AddressRequest request;

  AddAddressAction({@required this.request});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.addressUrl,
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.status == ResponseStatus.success200) {
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
    }
    return null;
  }

  void before() => dispatch(UpdateAddressLoadingStatus(true));

  void after() => dispatch(UpdateAddressLoadingStatus(false));
}

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
      url: ApiURL.deleteAddressUrl(addressId),
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

class UpdateIsRegisterFlow extends ReduxAction<AppState> {
  bool isRegisterView;
  UpdateIsRegisterFlow(this.isRegisterView);
  @override
  FutureOr<AppState> reduce() async {
    return state.copyWith(
      addressState: state.addressState.copyWith(isRegisterFlow: isRegisterView),
    );
  }
}

class GetInitialLocation extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    debugPrint(
        "get initial location ************************* ${position.latitude}");

    LatLng _latLng = LatLng(position.latitude, position.longitude);

    store.dispatch(GetAddressForLocation(_latLng));

    return state.copyWith(
      addressState: state.addressState.copyWith(
        addressRequest: state.addressState.addressRequest.copyWith(
          lat: position.latitude,
          lon: position.longitude,
        ),
      ),
    );
  }

  @override
  void before() => dispatch(UpdateAddressLoadingStatus(true));

  @override
  void after() => dispatch(UpdateAddressLoadingStatus(false));
}

class GetAddressForLocation extends ReduxAction<AppState> {
  final LatLng position;
  GetAddressForLocation(this.position);
  @override
  FutureOr<AppState> reduce() async {
    debugPrint(
        "get address for location  ************************** ${position.latitude}");
    List<Address> address = await Geocoder.local.findAddressesFromCoordinates(
      new Coordinates(position.latitude, position.longitude),
    );

    debugPrint(
        "get address for location 2  ************************** ${address.length}");

    if (address != null && address.isNotEmpty) {
      return state.copyWith(
        addressState: state.addressState.copyWith(
          addressRequest: state.addressState.addressRequest.copyWith(
            prettyAddress: address.first.addressLine,
            geoAddr: state.addressState.addressRequest.geoAddr.copyWith(
              pincode: address.first.postalCode,
              city: address.first.subLocality,
            ),
          ),
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
        isLoading: isLoading,
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
        addressRequest: state.addressState.addressRequest.copyWith(
          lat: position.latitude,
          lon: position.longitude,
        ),
      ),
    );
  }
}

class UpdateAddressName extends ReduxAction<AppState> {
  final String addressName;
  UpdateAddressName(this.addressName);
  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      addressState: state.addressState.copyWith(
        addressRequest: state.addressState.addressRequest.copyWith(
          addressName: addressName,
        ),
      ),
    );
  }
}

class UpdateAddressLandmark extends ReduxAction<AppState> {
  final String landmark;
  UpdateAddressLandmark(this.landmark);
  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      addressState: state.addressState.copyWith(
        addressRequest: state.addressState.addressRequest.geoAddr.copyWith(
          landmark: landmark,
        ),
      ),
    );
  }
}

class UpdateAddressHouse extends ReduxAction<AppState> {
  final String house;
  UpdateAddressHouse(this.house);
  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      addressState: state.addressState.copyWith(
        addressRequest: state.addressState.addressRequest.geoAddr.copyWith(
          house: house,
        ),
      ),
    );
  }
}

class GetSuggestionsAction extends ReduxAction<AppState> {
  String input;
  GetSuggestionsAction(this.input);
  @override
  FutureOr<AppState> reduce() async {
    PlacesAutocompleteResponse geocodingResponse =
        await new GoogleMapsPlaces(apiKey: Keys.googleAPIkey).autocomplete(
      input,
      sessionToken: state.addressState.sessionToken,
      types: ["address"],
      components: [Component("country", "in")],
    );

    if (geocodingResponse.isOkay || geocodingResponse.hasNoResults) {
      return state.copyWith(
        addressState: state.addressState.copyWith(
          placesSearchResponse: geocodingResponse,
        ),
      );
    } else {
      Fluttertoast.showToast(msg: "Some Error Occured");
      return null;
    }
  }
}

class GetAddressDetailsAction extends ReduxAction<AppState> {
  String placeId;
  GetAddressDetailsAction(this.placeId);
  @override
  FutureOr<AppState> reduce() async {
    PlacesDetailsResponse placesDetailsResponse =
        await new GoogleMapsPlaces(apiKey: Keys.googleAPIkey)
            .getDetailsByPlaceId(
      placeId,
      sessionToken: state.addressState.sessionToken,
    );

    if (placesDetailsResponse.isOkay) {
      PlaceDetails placeDetails = placesDetailsResponse.result;
      String pinCode = "";
      String city = "";

      placeDetails.addressComponents.forEach((element) {
        if (element.types.contains("postal_code")) {
          pinCode = element.longName ?? "";
        } else if (element.types.contains("administrative_area_level_2")) {
          city = element.longName ?? "";
        }
      });

      return state.copyWith(
        addressState: state.addressState.copyWith(
          fetchedAddressDetails: true,
          addressRequest: state.addressState.addressRequest.copyWith(
            prettyAddress: placeDetails.formattedAddress,
            lat: placeDetails.geometry.location.lat,
            lon: placeDetails.geometry.location.lng,
            geoAddr: state.addressState.addressRequest.geoAddr.copyWith(
              pincode: pinCode,
              city: city,
            ),
          ),
        ),
      );
    } else if (placesDetailsResponse.hasNoResults) {
      Fluttertoast.showToast(msg: "No Results Found");
      return null;
    } else {
      Fluttertoast.showToast(msg: "Some Error Occured");
      return null;
    }
  }

  @override
  void before() => dispatch(UpdateAddressLoadingStatus(true));

  @override
  void after() => dispatch(UpdateAddressLoadingStatus(false));
}

class ResetSearchAdressValues extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      addressState: state.addressState.reset(
        fetchedAddressDetails: false,
        placesSearchResponse: null,
      ),
    );
  }
}
