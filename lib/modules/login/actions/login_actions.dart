import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/Profile/model/profile_update_model.dart';
import 'package:eSamudaay/modules/login/model/get_otp_request.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:eSamudaay/utilities/user_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckTokenAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    bool status = await UserManager.shared.isLoggedIn();
    if (status) {
      return state.copyWith(
          authState: state.authState.copyWith(isLoggedIn: true));
    } else {
      return state.copyWith(
          authState: state.authState.copyWith(isLoggedIn: false));
    }
  }
}

class CheckOnBoardingStatusAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    bool status = await UserManager.shared.isSkipPressed();
    if (status) {
      return state.copyWith(
          authState: state.authState.copyWith(isOnboardingCompleted: true));
    } else {
      return state.copyWith(
          authState: state.authState.copyWith(isOnboardingCompleted: false));
    }
  }
}

class SaveTokenAction extends ReduxAction<AppState> {
  final String token;

  SaveTokenAction({this.token});
  @override
  FutureOr<AppState> reduce() async {
    String status = await UserManager.getFcmToken();
    if (status != null) {
      return state.copyWith(
          authState: state.authState.copyWith(deviceToken: token));
    } else {
      return state.copyWith(
          authState: state.authState.copyWith(deviceToken: null));
    }
  }
}

class GetOtpAction extends ReduxAction<AppState> {
  final GenerateOTPRequest request;
  final fromResend;

  GetOtpAction({this.request, this.fromResend});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: request.isSignUp
            ? ApiURL.generateOtpRegisterUrl
            : ApiURL.generateOTPUrl,
        params: request.toJson(),
        requestType: request.isSignUp ? RequestType.post : RequestType.get);

    if (response.status == ResponseStatus.success200) {
      if (response.data['token'] != null) {
        Fluttertoast.showToast(
            msg: response.data['token'], toastLength: Toast.LENGTH_LONG);
      }
      fromResend ? dispatch : dispatch(NavigateAction.pushNamed("/otpScreen"));
    } else {
      if (response.data['message'] != null) {
        Fluttertoast.showToast(msg: response.data['message']);
      } else if (response.data['detail'] != null) {
        Fluttertoast.showToast(msg: response.data['detail']);
      }
      //throw UserException(response.data['status']);
    }

    return state.copyWith(
        authState: state.authState.copyWith(getOtpRequest: request));
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}

class UpdateIsSignUpAction extends ReduxAction<AppState> {
  final bool isSignUp;

  UpdateIsSignUpAction({this.isSignUp});

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        authState: state.authState.copyWith(isSignUp: isSignUp));
  }
}

class GetUserFromLocalStorageAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    Data user = await UserManager.userDetails();
    return state.copyWith(authState: state.authState.copyWith(user: user));
  }
}
