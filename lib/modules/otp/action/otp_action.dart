import 'dart:async';
import 'dart:io' show Platform;

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/login/model/authentication_response.dart';
import 'package:eSamudaay/modules/otp/model/add_fcm_token.dart';
import 'package:eSamudaay/modules/otp/model/validate_otp_request.dart';
import 'package:eSamudaay/modules/register/action/register_Action.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:eSamudaay/utilities/environment_config.dart';
import 'package:eSamudaay/utilities/global.dart' as globals;
import 'package:eSamudaay/utilities/stringConstants.dart';
import 'package:eSamudaay/utilities/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OTPAction extends ReduxAction<AppState> {
  final bool isValid;

  OTPAction({
    this.isValid,
  });

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        authState: state.authState.copyWith(
      isOtpEntered: isValid,
    ));
  }
}

class ValidateOtpAction extends ReduxAction<AppState> {
  final bool isSignUp;

  ValidateOtpAction({@required this.isSignUp});

  @override
  FutureOr<AppState> reduce() async {
    //6282742294//8113970370
    var request = state.authState.validateOTPRequest;
    debugPrint('Validate OTP request $request');
    request.thirdPartyId = EnvironmentConfig.ThirdPartyID;
    var response = await APIManager.shared.request(
        url: ApiURL.generateOTPUrl,
        params: request.toJson(),
        requestType: RequestType.post);
    if (response.status == ResponseStatus.success200) {
      AuthResponse authResponse = AuthResponse.fromJson(response.data);
      await UserManager.saveToken(token: authResponse.token);
      if (isSignUp) {
        debugPrint('Inside add user detail*******');
        dispatch(
          AddUserDetailAction(
            request: CustomerDetailsRequest(
              profileName: state.authState.userNameForSignup,
              role: StringConstants.customerRole,
            ),
          ),
        );
      } else {
        debugPrint('Inside wrong*******');
        dispatchFuture(GetUserDetailAction())
            .whenComplete(() => dispatch(AddFCMTokenAction()));
      }
    } else {
      if (response.data['message'] != null) {
        Fluttertoast.showToast(msg: response.data['message']);
      } else if (response.data['detail'] != null) {
        Fluttertoast.showToast(msg: response.data['detail']);
      }
    }

    return state.copyWith(authState: state.authState.copyWith());
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}

class AddFCMTokenAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.addFCMTokenUrl,
        params: AddFCMTokenRequest(
                fcmToken: globals.deviceToken,
                tokenType: Platform.isAndroid ? "ANDROID" : "IOS")
            .toJson(),
        requestType: RequestType.post);
    if (response.status == ResponseStatus.success200) {
    }
    dispatch(GetUserDetailAction());
    return state.copyWith(authState: state.authState.copyWith());
  }
}

class UpdateValidationRequest extends ReduxAction<AppState> {
  final ValidateOTPRequest request;

  UpdateValidationRequest({this.request});

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        authState: state.authState.copyWith(validateOTPRequest: request));
  }
}
