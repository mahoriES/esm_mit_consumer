import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/User.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/login/actions/login_actions.dart';
import 'package:esamudaayapp/modules/login/model/authentication_response.dart';
import 'package:esamudaayapp/modules/otp/model/validate_otp_request.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
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

  ValidateOtpAction({this.isSignUp});

  @override
  FutureOr<AppState> reduce() async {
    //6282742294//8113970370
    var response = await APIManager.shared.request(
        url: isSignUp ? ApiURL.generateOtpRegisterUrl : ApiURL.generateOTPUrl,
        params: state.authState.validateOTPRequest,
        requestType: RequestType.post);
    if (response.data['statusCode'] == 200) {
      if (state.authState.isSignUp) {
        dispatch(NavigateAction.pushNamed("/registration"));
      } else {
        AuthResponse authResponse = AuthResponse.fromJson(response.data);
        UserManager.saveToken(token: authResponse.customer.customerID);
        UserManager.saveUser(User(
          id: authResponse.customer.customerID,
          firstName: authResponse.customer.name,
          address: authResponse.customer.addresses.isEmpty
              ? ""
              : authResponse.customer.addresses.first.addressLine1,
          phone: authResponse.customer.phoneNumber,
        )).then((onValue) {
          store.dispatch(GetUserFromLocalStorageAction());
        });
        dispatch(CheckTokenAction());
        dispatch(NavigateAction.pushNamedAndRemoveAll("/myHomeView"));
      }
    } else {
      Fluttertoast.showToast(msg: response.data['status']);
    }

    return state.copyWith(authState: state.authState.copyWith());
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
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
