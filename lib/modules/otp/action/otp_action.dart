import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/login/actions/login_actions.dart';
import 'package:esamudaayapp/modules/login/model/authentication_response.dart';
import 'package:esamudaayapp/modules/otp/model/validate_otp_request.dart';
import 'package:esamudaayapp/modules/register/action/register_Action.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';
import 'package:esamudaayapp/utilities/stringConstants.dart';
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
    var request = state.authState.validateOTPRequest;
    request.thirdPartyId = thirdPartyId;
    var response = await APIManager.shared.request(
        url: ApiURL.generateOTPUrl,
        params: request.toJson(),
        requestType: RequestType.post);
    if (response.status == ResponseStatus.success200) {
      AuthResponse authResponse = AuthResponse.fromJson(response.data);
      await UserManager.saveToken(token: authResponse.token);
      if (state.authState.isSignUp) {
        dispatch(NavigateAction.pushNamed("/registration"));
      } else {
//        UserManager.saveUser(User(
//          id: authResponse.customer.customerID,
//          firstName: authResponse.customer.name,
//          address: authResponse.customer.addresses.isEmpty
//              ? ""
//              : authResponse.customer.addresses.first.addressLine1,
//          phone: authResponse.customer.phoneNumber,
//        )).then((onValue) {
//          store.dispatch(GetUserFromLocalStorageAction());
//        });
        dispatchFuture(GetUserDetailAction()).whenComplete(() {
          dispatch(CheckTokenAction());
          store.dispatch(GetUserFromLocalStorageAction());
          dispatch(NavigateAction.pushNamedAndRemoveAll("/myHomeView"));
        });
      }
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
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
