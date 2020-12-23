import 'dart:async';
import 'dart:convert';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/models/addess_models.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:eSamudaay/utilities/user_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart' as location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:eSamudaay/utilities/keys.dart';
import 'package:google_maps_webservice/places.dart';

class AddAddressAction extends ReduxAction<AppState> {
  final AddressRequest request;

  AddAddressAction({@required this.request});

  @override
  FutureOr<AppState> reduce() async {
    final ResponseModel response = await APIManager.shared.request(
        url: ApiURL.addressUrl,
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.status == ResponseStatus.success200) {
      final AddressResponse responseModel =
          AddressResponse.fromJson(response.data);

      final List<AddressResponse> _updatedAddressList =
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
    try {
      final ResponseModel response = await APIManager.shared.request(
        url: ApiURL.addressUrl,
        params: null,
        requestType: RequestType.get,
      );

      if (response.status == ResponseStatus.success200) {
        if (response.data == null) {
          throw Exception();
        }
        final List<AddressResponse> responseModel = List<AddressResponse>();

        response?.data?.forEach((e) {
          responseModel.add(AddressResponse.fromJson(e));
        });

        await UserManager.saveAddress(address: jsonEncode(responseModel));

        return state.copyWith(
          addressState: state.addressState.copyWith(
            savedAddressList: responseModel,
          ),
        );
      } else {
        Fluttertoast.showToast(
            msg: response.data != null ? response?.data['message'] ?? tr("common.some_error_occured") : tr("common.some_error_occured") );
        return null;
      }
    } catch (e) {

      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
      return null;
    }
  }
}

class DeleteAddressAction extends ReduxAction<AppState> {
  final String addressId;

  DeleteAddressAction(this.addressId);

  @override
  FutureOr<AppState> reduce() async {
    final ResponseModel response = await APIManager.shared.request(
      url: ApiURL.deleteAddressUrl(addressId),
      params: null,
      requestType: RequestType.delete,
    );

    if (response.status == ResponseStatus.success200) {
      final List<AddressResponse> responseModel =
          state.addressState.savedAddressList;

      responseModel.removeWhere((element) => element.addressId == addressId);

      await UserManager.saveAddress(address: jsonEncode(responseModel));

      // If the deleted address was selected in cart
      // then update the selected addresss to first one in list by default.

      AddressResponse _selectedAddressForDelivery =
          state.addressState.selectedAddressForDelivery;

      if (state.addressState?.selectedAddressForDelivery?.addressId ==
          addressId) {
        _selectedAddressForDelivery = state.addressState.savedAddressList.first;
      }

      return state.copyWith(
        addressState: state.addressState.copyWith(
          savedAddressList: responseModel,
          selectedAddressForDelivery: _selectedAddressForDelivery,
        ),
      );
    } else {
      Fluttertoast.showToast(
          msg: response.data['message'] ?? tr("common.some_error_occured"));
    }
    return null;
  }

  void before() => dispatch(UpdateAddressLoadingStatus(true));

  void after() => dispatch(UpdateAddressLoadingStatus(false));
}

class GetAddressFromLocal extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    final List<AddressResponse> address = await UserManager.getAddress();
    return state.copyWith(
      addressState: state.addressState.copyWith(savedAddressList: address),
    );
  }
}

class UpdateIsRegisterFlow extends ReduxAction<AppState> {
  final bool isRegisterView;

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
    location.LocationData _locationData =
        await location.Location().getLocation().timeout(
              Duration(seconds: 30),
              onTimeout: () => null,
            );

    if (_locationData?.latitude != null && _locationData?.longitude != null) {
      final LatLng _latLng =
          LatLng(_locationData.latitude, _locationData.longitude);

      store.dispatch(GetAddressForLocation(_latLng));

      return state.copyWith(
        addressState: state.addressState.copyWith(
          addressRequest: state.addressState.addressRequest.copyWith(
            lat: _locationData.latitude,
            lon: _locationData.longitude,
          ),
        ),
      );
    }

    Fluttertoast.showToast(msg: "common.location_error".tr());
    return null;
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
    final List<Address> address =
        await Geocoder.local.findAddressesFromCoordinates(
      new Coordinates(position.latitude, position.longitude),
    );

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
    } else {
      Fluttertoast.showToast(msg: "Could not fetch address");
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

class UpdateSelectedAddressForRegister extends ReduxAction<AppState> {
  final AddressRequest addressRequest;

  UpdateSelectedAddressForRegister(this.addressRequest);

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      addressState: state.addressState.copyWith(
        selectedAddressForRegister: addressRequest,
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
  final String input;

  GetSuggestionsAction(this.input);

  @override
  FutureOr<AppState> reduce() async {
    final PlacesAutocompleteResponse geocodingResponse =
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
  final String placeId;

  GetAddressDetailsAction(this.placeId);

  @override
  FutureOr<AppState> reduce() async {
    final PlacesDetailsResponse placesDetailsResponse =
        await new GoogleMapsPlaces(apiKey: Keys.googleAPIkey)
            .getDetailsByPlaceId(
      placeId,
      sessionToken: state.addressState.sessionToken,
    );

    if (placesDetailsResponse.isOkay) {
      final PlaceDetails placeDetails = placesDetailsResponse.result;
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

class UpdateSelectedAddressForDelivery extends ReduxAction<AppState> {
  final AddressResponse address;

  UpdateSelectedAddressForDelivery(this.address);

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      addressState: state.addressState.copyWith(
        selectedAddressForDelivery: address,
      ),
    );
  }
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
