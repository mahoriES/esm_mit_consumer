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
    // TODO: Handle location timeout, errors, default cases gracefully!
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) _serviceEnabled = await location.requestService();
    if (!_serviceEnabled)
      return state.copyWith(
          authState: state.authState.copyWith(locationEnabled: false,nearbyClusters: null));

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return state.copyWith(
            authState: state.authState.copyWith(locationEnabled: false,nearbyClusters: null));
      }
    }

    ///If location fetching takes more than 20 seconds(average for A-GPS) we
    ///stop further wait; so yeah, timeout!
    _locationData = await location.getLocation().timeout(Duration(seconds: 20));

    if (_locationData == null ||
        _locationData.latitude == null ||
        _locationData.longitude == null)
      return state.copyWith(
          authState: state.authState.copyWith(locationEnabled: true,nearbyClusters: null));
    debugPrint('The location is ${_locationData.toString()}');
    var response = await APIManager.shared.request(
        url: ApiURL.getClustersUrl,
        requestType: RequestType.get,
        params: {
          "lon": _locationData.longitude.toString(),
          "lat": _locationData.latitude.toString(),
        });
    if (response.status == ResponseStatus.success200) {
      debugPrint('Success getting nearby circles ${response.data.length}');
      List<Cluster> nearbyCircles = [];
      response.data.forEach((item) {
        if (state.authState.myClusters == null) {
          nearbyCircles.add(Cluster.fromJson(item));
        } else {
          if (!state.authState.myClusters.contains(Cluster.fromJson(item)))
            nearbyCircles.add(Cluster.fromJson(item));
        }
      });

      return state.copyWith(
        authState: state.authState.copyWith(
          locationEnabled: true,
          nearbyClusters: nearbyCircles,
//          cluster: state.authState.myClusters == null
//              ? state.authState.cluster == null
//                  ? nearbyCircles.first
//                  : state.authState.cluster
//              : state.authState.myClusters.first,
        ),
      );
    } else {
      debugPrint('Error occurred fetching nearby circles');
      return state.copyWith(
          authState: state.authState.copyWith(locationEnabled: true,nearbyClusters: null));
    }
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeNearbyCircleLoadingAction(true));
    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeNearbyCircleLoadingAction(false));
    super.after();
  }
}

class GetSuggestionsForCircleAction extends ReduxAction<AppState> {
  final String queryText;

  GetSuggestionsForCircleAction({@required this.queryText});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
      requestType: RequestType.get,
      url: ApiURL.getClustersUrl,
      params: {
        "search_query": queryText,
      },
    );

    if (response.status == ResponseStatus.success200) {
      if (response.data == null || response.data.isEmpty) return null;

      List<Cluster> suggestedCircles = [];

      response.data.forEach((item) {
        suggestedCircles.add(Cluster.fromJson(item));
      });
      return state.copyWith(
        authState: state.authState.copyWith(
          suggestedClusters: suggestedCircles,
        ),
      );
    } else {
      Fluttertoast.showToast(
          msg: 'Error : '
              '${response.data['status']}');
    }
    return null;
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeSuggestedCircleLoadingAction(true));
    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeSuggestedCircleLoadingAction(false));
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
          "cluster_code": circleCode,
        });

    if (response.status == ResponseStatus.success200) {
      await dispatchFuture(GetClusterDetailsAction());
      await dispatchFuture(GetNearbyCirclesAction());
      Fluttertoast.showToast(
          msg: 'Successfully added the circle to '
              'profile!');
    } else {
      Fluttertoast.showToast(
          msg: 'Error : '
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
        url: ApiURL.getClustersUrl + "/$circleId",
        params: {"cluster_code": circleCode});
    debugPrint('2 ${response.toString()}');
    if (response.status == ResponseStatus.success200) {
      await dispatchFuture(GetClusterDetailsAction());
      await dispatchFuture(GetNearbyCirclesAction());
      Fluttertoast.showToast(
          msg: 'Successfully removed the circle from '
              'profile!');
    } else {
      Fluttertoast.showToast(
          msg: 'Error : '
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

class ChangeNearbyCircleLoadingAction extends ReduxAction<AppState> {
  final bool value;

  ChangeNearbyCircleLoadingAction(this.value);

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      componentsLoadingState: state.componentsLoadingState.copyWith(
        nearbyCirclesLoading: value,
      ),
    );
  }
}

class ChangeSuggestedCircleLoadingAction extends ReduxAction<AppState> {
  final bool value;

  ChangeSuggestedCircleLoadingAction(this.value);

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      componentsLoadingState: state.componentsLoadingState.copyWith(
        suggestedCirclesLoading: value,
      ),
    );
  }
}

class ChangeSavedCircleLoadingAction extends ReduxAction<AppState> {
  final bool value;

  ChangeSavedCircleLoadingAction(this.value);

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      componentsLoadingState: state.componentsLoadingState.copyWith(
        savedCirclesLoading: value,
      ),
    );
  }
}
