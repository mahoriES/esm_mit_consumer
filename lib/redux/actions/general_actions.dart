import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/redux/states/app_state.dart';

class ChangeLoadingStatusAction extends ReduxAction<AppState> {
  final LoadingStatusApp appStatus;
  ChangeLoadingStatusAction(this.appStatus);

  @override
  AppState reduce() {
    // TODO: implement reduce
    return state.copyWith(
        authState: state.authState.copyWith(loadingStatus: appStatus));
  }
}
