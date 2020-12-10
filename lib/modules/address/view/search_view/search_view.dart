import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/actions/address_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';

class SearchAddressView extends StatefulWidget {
  SearchAddressView({
    Key key,
  }) : super(key: key);

  @override
  _SearchAddressViewState createState() => _SearchAddressViewState();
}

class _SearchAddressViewState extends State<SearchAddressView> {
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
        builder: (context, snapshot) {
          WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) {
              if (snapshot.isSuccess) {
                Navigator.pop(context);
              }
            },
          );

          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: 12.toWidth, vertical: 12.toHeight),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomTheme.of(context).colors.placeHolderColor,
                      ),
                    ),
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (input) async {
                    if (input.trim() != "" && !snapshot.isLoading) {
                      snapshot.getSuggestions(input);
                    }
                  },
                ),
                SizedBox(height: 12.toHeight),
                if (!snapshot.isLoading) ...[
                  ListView.builder(
                    itemCount: snapshot
                            .placesAutocompleteResponse?.predictions?.length ??
                        0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () => snapshot.getPlaceDetails(
                            snapshot.placesAutocompleteResponse
                                ?.predictions[index].placeId,
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.toWidth,
                              vertical: 12.toHeight,
                            ),
                            child: Text(
                              snapshot.placesAutocompleteResponse
                                  ?.predictions[index].description,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ]
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

  Function(String) getSuggestions;
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
  }) : super(
          equals: [
            placesAutocompleteResponse,
            isLoading,
            isSuccess,
          ],
        );

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      getSuggestions: (input) => dispatch(GetSuggestionsAction(input)),
      getPlaceDetails: (placeId) => dispatch(GetAddressDetailsAction(placeId)),
      placesAutocompleteResponse: state.addressState.placesSearchResponse,
      isLoading: state.addressState.isLoading,
      isSuccess: state.addressState.fetchedAddressDetails,
    );
  }
}
