import 'package:eSamudaay/modules/address/models/addess_models.dart';
import 'package:geocoder/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressState {
  final List<AddressResponse> savedAddressList;
  final bool isAddressLoading;
  final Address addressDetails;
  final LatLng currentPosition;
  final String addressTag;
  final AddressRequest addressRequest;
  final bool isRegisterView;

  const AddressState({
    this.savedAddressList,
    this.addressDetails,
    this.isAddressLoading,
    this.currentPosition,
    this.addressTag,
    this.addressRequest,
    this.isRegisterView,
  });

  factory AddressState.initial() => AddressState(
        savedAddressList: null,
        addressDetails: null,
        isAddressLoading: false,
        currentPosition: null,
        addressTag: null,
        addressRequest: null,
        isRegisterView: false,
      );

  AddressState copyWith({
    List<AddressResponse> savedAddressList,
    bool isAddressLoading,
    Address addressDetails,
    LatLng currentPosition,
    String addressTag,
    AddressRequest addressRequest,
    bool isRegisterView,
  }) {
    return AddressState(
      savedAddressList: savedAddressList ?? this.savedAddressList,
      isAddressLoading: isAddressLoading ?? this.isAddressLoading,
      addressDetails: addressDetails ?? this.addressDetails,
      currentPosition: currentPosition ?? this.currentPosition,
      addressTag: addressTag ?? this.addressTag,
      addressRequest: addressRequest ?? this.addressRequest,
      isRegisterView: isRegisterView ?? this.isRegisterView,
    );
  }
}
