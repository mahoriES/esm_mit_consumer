import 'package:eSamudaay/models/api_response_handler.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/Profile/model/profile_update_model.dart';
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
  final List<Cluster> myClusters;
  final List<Cluster> nearbyClusters;
  final List<Cluster> suggestedClusters;

  final String token;
  final bool isLoggedIn;
  final bool isOnboardingCompleted;
  final Data user;
  final bool isPhoneNumberValid;
  final bool isOtpEntered;
  final bool isSignUp;

  AuthState({
    @required this.getOtpRequest,
    @required this.cluster,
    @required this.isOtpEntered,
    @required this.isPhoneNumberValid,
    @required this.user,
    @required this.isOnboardingCompleted,
    @required this.loadingStatus,
    @required this.token,
    @required this.isLoggedIn,
    @required this.validateOTPRequest,
    @required this.isSignUp,
    @required this.updateCustomerDetailsRequest,
    @required this.deviceToken,
    @required this.myClusters,
    @required this.nearbyClusters,
    @required this.suggestedClusters,
  });

  factory AuthState.initial() {
    return new AuthState(
      cluster: null,
      myClusters: null,
      nearbyClusters: null,
      suggestedClusters: null,
      token: "",
      isLoggedIn: false,
      loadingStatus: LoadingStatusApp.success,
      isOnboardingCompleted: false,
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

  AuthState copyWith({
    Data user,
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
    bool isOnboardingCompleted,
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
    String deviceToken,
    List<Cluster> myClusters,
    List<Cluster> nearbyClusters,
    List<Cluster> suggestedClusters,
  }) {
    return new AuthState(
        deviceToken: token,
        cluster: cluster ?? this.cluster,
        myClusters: myClusters ?? this.myClusters,
        nearbyClusters: nearbyClusters ?? this.nearbyClusters,
        suggestedClusters: suggestedClusters ?? this.suggestedClusters,
        user: user ?? this.user,
        isOnboardingCompleted:
            isOnboardingCompleted ?? this.isOnboardingCompleted,
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
