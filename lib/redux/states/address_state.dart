import 'package:eSamudaay/modules/address/models/addess_models.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:uuid/uuid.dart';

class AddressState {
  final List<AddressResponse> savedAddressList;
  final bool isLoading;
  final bool isRegisterFlow;
  final bool fetchedAddressDetails;
  final AddressRequest addressRequest;
  final AddressRequest selectedAddressForRegister;
  final PlacesAutocompleteResponse placesSearchResponse;
  final String sessionToken;
  final AddressResponse selectedAddressForDelivery;

  const AddressState({
    this.savedAddressList,
    this.isLoading,
    this.isRegisterFlow,
    this.fetchedAddressDetails,
    this.selectedAddressForRegister,
    this.addressRequest,
    this.placesSearchResponse,
    this.sessionToken,
    this.selectedAddressForDelivery,
  });

  factory AddressState.initial() => AddressState(
        savedAddressList: null,
        isLoading: false,
        isRegisterFlow: false,
        fetchedAddressDetails: false,
        selectedAddressForRegister: null,
        addressRequest: new AddressRequest(
          geoAddr: new GeoAddr(),
        ),
        placesSearchResponse: null,
        sessionToken: Uuid().v4(),
        selectedAddressForDelivery: null,
      );

  AddressState copyWith({
    List<AddressResponse> savedAddressList,
    bool isLoading,
    bool isRegisterFlow,
    bool fetchedAddressDetails,
    AddressRequest addressRequest,AddressRequest selectedAddressForRegister,
    PlacesAutocompleteResponse placesSearchResponse,
    String sessionToken,
    AddressResponse selectedAddressForDelivery,
  }) {
    return AddressState(
      savedAddressList: savedAddressList ?? this.savedAddressList,
      isLoading: isLoading ?? this.isLoading,
      isRegisterFlow: isRegisterFlow ?? this.isRegisterFlow,
      selectedAddressForRegister: selectedAddressForRegister ?? this.selectedAddressForRegister,
      fetchedAddressDetails:
          fetchedAddressDetails ?? this.fetchedAddressDetails,
      addressRequest: addressRequest ?? this.addressRequest,
      placesSearchResponse: placesSearchResponse ?? this.placesSearchResponse,
      sessionToken: sessionToken ?? this.sessionToken,
      selectedAddressForDelivery:
          selectedAddressForDelivery ?? this.selectedAddressForDelivery,
    );
  }

  AddressState reset({
    bool fetchedAddressDetails,
    PlacesAutocompleteResponse placesSearchResponse,
  }) {
    return AddressState(
      placesSearchResponse: placesSearchResponse,
      fetchedAddressDetails: fetchedAddressDetails,
      savedAddressList: this.savedAddressList,
      isLoading: this.isLoading,
      isRegisterFlow: this.isRegisterFlow,
      addressRequest: this.addressRequest,
      sessionToken: this.sessionToken,
      selectedAddressForDelivery: this.selectedAddressForDelivery,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressState &&
          runtimeType == other.runtimeType &&
          savedAddressList == other.savedAddressList &&
          isLoading == other.isLoading &&
          isRegisterFlow == other.isRegisterFlow &&
          fetchedAddressDetails == other.fetchedAddressDetails &&
          addressRequest == other.addressRequest &&
          selectedAddressForRegister == other.selectedAddressForRegister &&
          placesSearchResponse == other.placesSearchResponse &&
          sessionToken == other.sessionToken &&
          selectedAddressForDelivery == other.selectedAddressForDelivery;

  @override
  int get hashCode =>
      savedAddressList.hashCode ^
      isLoading.hashCode ^
      isRegisterFlow.hashCode ^
      fetchedAddressDetails.hashCode ^
      addressRequest.hashCode ^
      selectedAddressForRegister.hashCode ^
      placesSearchResponse.hashCode ^
      sessionToken.hashCode ^
      selectedAddressForDelivery.hashCode;
}
