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

  const AddressState({
    this.savedAddressList,
    this.isLoading,
    this.isRegisterFlow,
    this.fetchedAddressDetails,
    this.selectedAddressForRegister,
    this.addressRequest,
    this.placesSearchResponse,
    this.sessionToken,
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
      );

  AddressState copyWith({
    List<AddressResponse> savedAddressList,
    bool isLoading,
    bool isRegisterFlow,
    bool fetchedAddressDetails,
    AddressRequest addressRequest,AddressRequest selectedAddressForRegister,
    PlacesAutocompleteResponse placesSearchResponse,
    String sessionToken,
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
    );
  }
}
