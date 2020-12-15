import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/actions/address_actions.dart';
import 'package:eSamudaay/modules/address/models/addess_models.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter_platform_interface/src/types/marker_updates.dart';

class GoogleMapView extends StatefulWidget {
  final VoidCallback goToConfirmLocation;
  GoogleMapView({@required this.goToConfirmLocation});
  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  Completer<GoogleMapController> _completer = Completer();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      onInit: (store) {
        store.dispatchFuture(GetInitialLocation());
      },
      onDidChange: (snapshot) async {
        // if address was selected from search , then animate map location to the selected address.
        if (snapshot.gotAddressFromSearch) {
          GoogleMapController mapController = await _completer.future;
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: snapshot.location,
                zoom: 14.4746,
              ),
            ),
          );
          // reset the seardh details to avoid animating the map multiple times.
          snapshot.resetSearchDetails();
        }
      },
      builder: (context, snapshot) {
        return snapshot.isLocationNull || snapshot.location == null
            ? Center(child: CircularProgressIndicator())
            : GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: snapshot.location,
                  zoom: 14.4746,
                ),
                markers: Set<Marker>.from(
                  [
                    new Marker(
                      markerId: new MarkerId("pinLocation"),
                      position: snapshot.location,
                    ),
                  ],
                ),
                onMapCreated: (controllerValue) => setState(() {
                  _completer.complete(controllerValue);
                }),
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                onCameraMove: snapshot.updateMarkerPosition,
                onCameraIdle: () {
                  debugPrint("*********************** on Idle");
                  snapshot.updateAddress();
                },
                onCameraMoveStarted: widget.goToConfirmLocation,
                myLocationEnabled: true,
                compassEnabled: true,
                myLocationButtonEnabled: true,
              );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  AddressRequest addressRequest;
  Function(CameraPosition) updateMarkerPosition;
  Function() updateAddress;
  bool isLoading;
  bool gotAddressFromSearch;
  VoidCallback resetSearchDetails;

  _ViewModel.build({
    this.addressRequest,
    this.updateMarkerPosition,
    this.updateAddress,
    this.isLoading,
    this.gotAddressFromSearch,
    this.resetSearchDetails,
  }) : super(equals: [addressRequest, isLoading, gotAddressFromSearch]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
        addressRequest: state.addressState.addressRequest,
        gotAddressFromSearch: state.addressState.fetchedAddressDetails,
        isLoading: state.addressState.isLoading,
        updateMarkerPosition: (position) {
          dispatch(UpdateCurrentPosition(
              LatLng(position.target.latitude, position.target.longitude)));
        },
        resetSearchDetails: () => dispatch(ResetSearchAdressValues()),
        updateAddress: () {
          debugPrint("*************** update address $isLocationNull");
          dispatch(
            GetAddressForLocation(LatLng(state.addressState.addressRequest.lat,
                state.addressState.addressRequest.lon)),
          );
        });
  }

  LatLng get location => LatLng(addressRequest.lat, addressRequest.lon);

  bool get isLocationNull =>
      addressRequest?.lat == null || addressRequest?.lon == null;
}
