import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/actions/home_page_actions.dart';
import 'package:eSamudaay/modules/home/models/cluster.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    if (!_serviceEnabled) return state.copyWith(
        authState: state.authState.copyWith(
        nearbyClusters: null
    ));

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return state.copyWith(authState: state.authState.copyWith(
          nearbyClusters: null
        ));
      }
    }
    _locationData = await location.getLocation();

    if (_locationData.latitude == null || _locationData.longitude == null)
      return state.copyWith(authState: state.authState.copyWith(
          nearbyClusters: null
      ));
    debugPrint('The location is ${_locationData.toString()}');
    var response = await APIManager.shared.request(
      url: ApiURL.getClustersUrl,
      requestType: RequestType.get,
      params: {
        "lon" : _locationData.longitude.toString(),
        "lat" : _locationData.latitude.toString(),
        "search_query" : "",

       }
    );
    debugPrint('1++++++++++++++++++ ${response.toString()}');
    if (response.status == ResponseStatus.success200) {
      debugPrint('Success getting nearby circles');
      List<Cluster> nearbyCircles = [];
      response.data.forEach((item) {
        if (!state.authState.myClusters.contains(Cluster.fromJson(item)))
          nearbyCircles.add(Cluster.fromJson(item));
      });

      return state.copyWith(
        authState: state.authState.copyWith(
          nearbyClusters: nearbyCircles,
        ),
      );

    } else {
      debugPrint('Error occurred fetching nearby circles');
      return state.copyWith(authState: state.authState.copyWith(
          nearbyClusters: null
      ));
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

class AddCircleToProfileAction extends ReduxAction<AppState> {

  final String circleCode;

  AddCircleToProfileAction({@required this.circleCode});

  @override
  FutureOr<AppState> reduce() async {

    var response = await APIManager.shared.request(
      requestType: RequestType.post,
      url: ApiURL.getClustersUrl,
      params: {
        "cluster_code" : circleCode,
      }
    );

    if (response.status == ResponseStatus.success200) {
      await dispatchFuture(GetClusterDetailsAction());
      await dispatchFuture(GetNearbyCirclesAction());
      Fluttertoast.showToast(msg: 'Successfully added the circle to '
          'profile!');
    } else {
      Fluttertoast.showToast(msg: 'Error : '
          '${response.data['status']}');
    }
    return null;
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

class RemoveCircleFromProfileAction extends ReduxAction<AppState> {

  final String circleCode;
  final String circleId;

  RemoveCircleFromProfileAction({
    @required this.circleCode,
    @required this.circleId,
  });

  @override
  FutureOr<AppState> reduce() async {
    if (state.authState.myClusters.length == 1) {
      Fluttertoast.showToast(msg: 'At least one circle is required!');
      return null;
    }
    debugPrint('1');
    var response = await APIManager.shared.request(
        requestType: RequestType.delete,
        url: ApiURL.getClustersUrl+"/$circleId",
        params: {
          "cluster_code" : circleCode
        }
    );
    debugPrint('2 ${response.toString()}');
    if (response.status == ResponseStatus.success200) {
      await dispatchFuture(GetClusterDetailsAction());
      await dispatchFuture(GetNearbyCirclesAction());
      Fluttertoast.showToast(msg: 'Successfully removed the circle from '
          'profile!');
    } else {
      Fluttertoast.showToast(msg: 'Error : '
          '${response.data['status']}');
    }
    return null;
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
