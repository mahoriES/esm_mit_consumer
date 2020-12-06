import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/actions/address_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatefulWidget {
  final VoidCallback goToConfirmLocation;
  GoogleMapView({@required this.goToConfirmLocation});
  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      onInit: (store) {
        store.dispatch(GetInitialLocation());
      },
      builder: (context, snapshot) {
        return snapshot.currentPosition == null
            ? Center(child: CircularProgressIndicator())
            : GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: snapshot.currentPosition,
                  zoom: 14.4746,
                ),
                markers: Set<Marker>.from(
                  [
                    new Marker(
                      markerId: new MarkerId("pinLocation"),
                      position: snapshot.currentPosition,
                    ),
                  ],
                ),
                onMapCreated: (controllerValue) => setState(() {
                  _controller.complete(controllerValue);
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

  LatLng currentPosition;
  Function(CameraPosition) updateMarkerPosition;
  Function() updateAddress;

  _ViewModel.build({
    this.currentPosition,
    this.updateMarkerPosition,
    this.updateAddress,
  }) : super(equals: [currentPosition]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      currentPosition: state.addressState.currentPosition,
      updateMarkerPosition: (position) {
        dispatch(UpdateCurrentPosition(
            LatLng(position.target.latitude, position.target.longitude)));
      },
      updateAddress: () =>
          dispatch(GetAddressForLocation(state.addressState.currentPosition)),
    );
  }
}
