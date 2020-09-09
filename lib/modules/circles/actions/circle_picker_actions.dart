import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:location/location.dart';

class GetNearbyCirclesAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {

    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled)
      _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) return null;

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    _locationData = await location.getLocation();

    if (_locationData.latitude == null || _locationData.longitude == null)
      return null;

    var response = await APIManager.shared.request(
      url: ApiURL.getNearbyClustersUrl,
      params: {
        "lon" : _locationData.longitude.toString(),
        "lat" : _locationData.latitude.toString(),
       }
    );

    if (response.status != ResponseStatus.success200) {

    } else {

    }


  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));
    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
    super.after();
  }
}
