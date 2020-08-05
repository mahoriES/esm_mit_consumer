import 'package:eSamudaay/models/User.dart';
import 'package:eSamudaay/models/api_response_handler.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/Profile/model/profile_update_model.dart';
import 'package:eSamudaay/modules/address/models/addess_models.dart';
import 'package:eSamudaay/modules/home/models/cluster.dart';
import 'package:eSamudaay/modules/login/model/get_otp_request.dart';
import 'package:eSamudaay/modules/otp/model/validate_otp_request.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:flutter/foundation.dart';

class AuthState {
  final String deviceToken;
  final LoadingStatusApp loadingStatus;
  final GenerateOTPRequest getOtpRequest;
  final ValidateOTPRequest validateOTPRequest;
  final CustomerDetailsRequest updateCustomerDetailsRequest;
  final Cluster cluster;
  final String token;
  final bool isLoggedIn;
  final bool isLoginSkipped;
  final Address address;
  final Data user;
  final bool isPhoneNumberValid;
  final bool isOtpEntered;
  final bool isSignUp;

  AuthState(
      {@required this.getOtpRequest,
      @required this.cluster,
      @required this.isOtpEntered,
      @required this.isPhoneNumberValid,
      @required this.user,
      @required this.isLoginSkipped,
      @required this.loadingStatus,
      @required this.token,
      @required this.isLoggedIn,
      @required this.validateOTPRequest,
      @required this.isSignUp,
      @required this.updateCustomerDetailsRequest,
      @required this.deviceToken,
      @required this.address});

  factory AuthState.initial() {
    return new AuthState(
      address: null,
      cluster: null,
      token: "",
      isLoggedIn: false,
      loadingStatus: LoadingStatusApp.success,
      isLoginSkipped: false,
      user: null,
      isPhoneNumberValid: true,
      isOtpEntered: false,
      getOtpRequest: null,
      validateOTPRequest: null,
      updateCustomerDetailsRequest: null,
      isSignUp: false,
      deviceToken: "",
    );
  }

  AuthState copyWith(
      {Data user,
      Address address,
      LoadingStatusApp loadingStatus,
      String mobileNumber,
      bool emailError,
      Cluster cluster,
      bool mobileNumberError,
      String emailErrorMessage,
      String passwordErrorMessage,
      String token,
      bool isLoggedIn,
      bool showAlert,
      bool isLoginSkipped,
      String apiErrorMessage,
      APIResponseHandlerModel apiResponseHandler,
      bool isFirstNameValid,
      bool isSecondNameValid,
      bool isPhoneNumberValid,
      bool isOtpEntered,
      GenerateOTPRequest getOtpRequest,
      ValidateOTPRequest validateOTPRequest,
      CustomerDetailsRequest updateCustomerDetailsRequest,
      bool isSignUp,
      String deviceToken}) {
    return new AuthState(
        address: address ?? this.address,
        deviceToken: token,
        cluster: cluster ?? this.cluster,
        user: user ?? this.user,
        isLoginSkipped: isLoginSkipped ?? this.isLoginSkipped,
        loadingStatus: loadingStatus ?? this.loadingStatus,
        token: token ?? this.token,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
        isOtpEntered: isOtpEntered ?? this.isOtpEntered,
        getOtpRequest: getOtpRequest ?? this.getOtpRequest,
        validateOTPRequest: validateOTPRequest ?? this.validateOTPRequest,
        updateCustomerDetailsRequest:
            updateCustomerDetailsRequest ?? this.updateCustomerDetailsRequest,
        isSignUp: isSignUp ?? this.isSignUp);
  }
}
