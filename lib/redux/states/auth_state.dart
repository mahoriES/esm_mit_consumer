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
  final String userNameForSignup;
  final Cluster cluster;
  final List<Cluster> myClusters;
  final List<Cluster> nearbyClusters;
  final List<Cluster> suggestedClusters;
  final List<Cluster> trendingClusters;
  final bool locationEnabled;

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
    @required this.userNameForSignup,
    @required this.trendingClusters,
    @required this.locationEnabled,
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
      trendingClusters: null,
      nearbyClusters: null,
      suggestedClusters: null,
      token: "",
      isLoggedIn: false,
      loadingStatus: LoadingStatusApp.success,
      isOnboardingCompleted: false,
      locationEnabled: true,
      user: null,
      isPhoneNumberValid: true,
      isOtpEntered: false,
      getOtpRequest: null,
      validateOTPRequest: null,
      updateCustomerDetailsRequest: null,
      isSignUp: false,
      deviceToken: "",
      userNameForSignup: ""
    );
  }

  AuthState copyWith({
    Data user,
    LoadingStatusApp loadingStatus,
    String mobileNumber,
    bool emailError,
    bool locationEnabled,
    Cluster cluster,
    bool mobileNumberError,
    String emailErrorMessage,
    String passwordErrorMessage,
    String token,
    bool isLoggedIn,
    String userNameForSignup,
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
    List<Cluster> trendingClusters,
  }) {
    return new AuthState(
        locationEnabled: locationEnabled ?? this.locationEnabled,
        deviceToken: token,
        cluster: cluster ?? this.cluster,
        myClusters: myClusters ?? this.myClusters,
        trendingClusters: trendingClusters ?? this.trendingClusters,
        nearbyClusters: nearbyClusters ?? this.nearbyClusters,
        suggestedClusters: suggestedClusters ?? this.suggestedClusters,
        user: user ?? this.user,
        userNameForSignup: userNameForSignup ?? this.userNameForSignup,
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          deviceToken == other.deviceToken &&
          loadingStatus == other.loadingStatus &&
          getOtpRequest == other.getOtpRequest &&
          validateOTPRequest == other.validateOTPRequest &&
          updateCustomerDetailsRequest == other.updateCustomerDetailsRequest &&
          cluster == other.cluster &&
          userNameForSignup == other.userNameForSignup &&
          myClusters == other.myClusters &&
          nearbyClusters == other.nearbyClusters &&
          suggestedClusters == other.suggestedClusters &&
          trendingClusters == other.trendingClusters &&
          locationEnabled == other.locationEnabled &&
          token == other.token &&
          isLoggedIn == other.isLoggedIn &&
          isOnboardingCompleted == other.isOnboardingCompleted &&
          user == other.user &&
          isPhoneNumberValid == other.isPhoneNumberValid &&
          isOtpEntered == other.isOtpEntered &&
          isSignUp == other.isSignUp;

  @override
  int get hashCode =>
      deviceToken.hashCode ^
      loadingStatus.hashCode ^
      getOtpRequest.hashCode ^
      validateOTPRequest.hashCode ^
      updateCustomerDetailsRequest.hashCode ^
      cluster.hashCode ^
      myClusters.hashCode ^
      userNameForSignup.hashCode ^
      nearbyClusters.hashCode ^
      suggestedClusters.hashCode ^
      trendingClusters.hashCode ^
      locationEnabled.hashCode ^
      token.hashCode ^
      isLoggedIn.hashCode ^
      isOnboardingCompleted.hashCode ^
      user.hashCode ^
      isPhoneNumberValid.hashCode ^
      isOtpEntered.hashCode ^
      isSignUp.hashCode;
}
