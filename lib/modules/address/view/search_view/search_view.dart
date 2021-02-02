import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/actions/address_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/store.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_webservice/places.dart';

class SearchAddressView extends StatefulWidget {
  SearchAddressView({
    Key key,
  }) : super(key: key);

  @override
  _SearchAddressViewState createState() => _SearchAddressViewState();
}

class _SearchAddressViewState extends State<SearchAddressView> {
  TextEditingController addressController = new TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr("address_picker.search_location"),
          style: CustomTheme.of(context).textStyles.topTileTitle,
        ),
      ),
      body: StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        onDidChange: (snapshot) {
          if (snapshot.isSuccess) {
            Navigator.pop(context);
          }
        },
        builder: (context, snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: 12.toWidth, vertical: 12.toHeight),
            child: Column(
              children: [
                TypeAheadField<Prediction>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: addressController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              CustomTheme.of(context).colors.placeHolderColor,
                        ),
                      ),
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  suggestionsCallback: (input) async {
                    if (input.isEmpty) return null;
                    return await snapshot.getSuggestions(input);
                  },
                  onSuggestionSelected: (Prediction suggestion) async {
                    await snapshot.getPlaceDetails(suggestion.placeId);
                  },
                  itemBuilder: (context, Prediction suggestion) {
                    return ListTile(
                      title: Text(suggestion.description),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  Future<List<Prediction>> Function(String) getSuggestions;
  Function(String) getPlaceDetails;
  PlacesAutocompleteResponse placesAutocompleteResponse;
  bool isLoading;
  bool isSuccess;

  _ViewModel.build({
    this.placesAutocompleteResponse,
    this.getSuggestions,
    this.getPlaceDetails,
    this.isLoading,
    this.isSuccess,
  }) : super(equals: [isLoading, isSuccess]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      getSuggestions: (input) async {
        await dispatchFuture(GetSuggestionsAction(input));
        return store.state.addressState.placesSearchResponse?.predictions ??
            List<Prediction>();
      },
      getPlaceDetails: (placeId) => dispatch(GetAddressDetailsAction(placeId)),
      placesAutocompleteResponse: state.addressState.placesSearchResponse,
      isLoading: state.addressState.isLoading,
      isSuccess: state.addressState.fetchedAddressDetails,
    );
  }
}
