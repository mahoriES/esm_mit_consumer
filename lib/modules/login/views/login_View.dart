import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/reusable_widgets/ios_back_button.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/validators/validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/login/actions/login_actions.dart';
import 'package:eSamudaay/modules/login/model/get_otp_request.dart';
import 'package:eSamudaay/utilities/global.dart' as globals;
import 'package:eSamudaay/utilities/environment_config.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../redux/states/app_state.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool _isPhoneNumberValid = false;
  PhoneNumber _phoneNumber;
  String _userNameForSignup;
  // the error styling for validation in intl_phone_number_input field does not meet the UI requirements.
  // so using this variable to create custom input validation for phone number field.
  bool showPhoneNumberError = false;
  // this formkey wraps the username field and provide default input validation.
  GlobalKey<FormState> formKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        builder: (context, snapshot) {
          return SafeArea(
            child: ModalProgressHUD(
              progressIndicator: Card(
                child: Image.asset(
                  'assets/images/indicator.gif',
                  height: 75,
                  width: 75,
                ),
              ),
              inAsyncCall: snapshot.loadingStatus == LoadingStatusApp.loading,
              child: SizedBox(
                height: SizeConfig.screenHeight,
                child: Stack(
                  children: [
                    Positioned(
                      child: Image.asset(
                        ImagePathConstants.signupLoginBackdrop,
                        height: SizeConfig.screenHeight,
                        width: SizeConfig.screenWidth,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      left: 25,
                      top: 35,
                      child: CupertinoStyledBackButton(
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Positioned(
                      top: 200.toHeight,
                      left: 12.toWidth,
                      child: Container(
                        width: 351.toWidth,
                        padding: const EdgeInsets.only(
                            bottom: 12, left: 17, right: 17),
                        decoration: BoxDecoration(
                          color: CustomTheme.of(context).colors.backgroundColor,
                          border: Border.all(
                              color:
                                  CustomTheme.of(context).colors.primaryColor),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            if (snapshot.isSignUp) ...[
                              Form(
                                key: formKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: TextFormField(
                                  controller: nameController,
                                  validator: Validators.userNameValidator,
                                  onChanged: (String value) {
                                    setState(() {
                                      _userNameForSignup = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: tr('common.enter_name'),
                                    hintStyle: CustomTheme.of(context)
                                        .textStyles
                                        .sectionHeading2
                                        .copyWith(
                                            color: CustomTheme.of(context)
                                                .colors
                                                .disabledAreaColor),
                                    // override the error styling here to match it with custom error text shown for phone number validation error.
                                    errorStyle: CustomTheme.of(context)
                                        .textStyles
                                        .body2
                                        .copyWith(
                                          color: CustomTheme.of(context)
                                              .colors
                                              .secondaryColor,
                                        ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .colors
                                            .secondaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                            Container(
                              decoration: BoxDecoration(
                                border: snapshot.isSignUp
                                    ? Border(
                                        bottom: BorderSide(
                                          // if phone number input is not valid, the border should be in red color.
                                          color: showPhoneNumberError
                                              ? CustomTheme.of(context)
                                                  .colors
                                                  .secondaryColor
                                              : CustomTheme.of(context)
                                                  .colors
                                                  .disabledAreaColor,
                                        ),
                                      )
                                    : Border.all(
                                        color: CustomTheme.of(context)
                                            .colors
                                            .disabledAreaColor
                                            .withOpacity(0.3)),
                                borderRadius: snapshot.isSignUp
                                    ? null
                                    : BorderRadius.circular(4),
                              ),
                              child: InternationalPhoneNumberInput(
                                textFieldController: phoneController,
                                scrollPadding: EdgeInsets.zero,
                                selectorConfig: SelectorConfig(
                                    showFlags: true,
                                    selectorType:
                                        PhoneInputSelectorType.DIALOG),
                                initialValue: _phoneNumber != null
                                    ? PhoneNumber(isoCode: _phoneNumber.isoCode)
                                    : PhoneNumber(isoCode: 'IN'),
                                onInputChanged: validatePhoneNumber,
                                selectorTextStyle: CustomTheme.of(context)
                                    .textStyles
                                    .sectionHeading2,
                                inputDecoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 14),
                                    hintText: tr('screen_phone.hint_text'),
                                    hintStyle: CustomTheme.of(context)
                                        .textStyles
                                        .sectionHeading2
                                        .copyWith(
                                            color: CustomTheme.of(context)
                                                .colors
                                                .disabledAreaColor),
                                    labelStyle: CustomTheme.of(context)
                                        .textStyles
                                        .cardTitle),
                                spaceBetweenSelectorAndTextField: 0.0,
                              ),
                            ),
                            // show error text if phone number is not valid.
                            if (showPhoneNumberError) ...[
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  tr("screen_phone.valid_phone_error_message"),
                                  style: CustomTheme.of(context)
                                      .textStyles
                                      .body2
                                      .copyWith(
                                        color: CustomTheme.of(context)
                                            .colors
                                            .secondaryColor,
                                      ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                            const SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              width: 157.4.toWidth,
                              height: 42.toHeight,
                              child: RaisedButton(
                                // we need to show the cta button in disabled color in case any of the field inputs are invalid.
                                color: _isPhoneNumberValid &&
                                        (snapshot.isSignUp
                                            ? _userNameForSignup?.isNotEmpty ??
                                                false
                                            : true)
                                    ? CustomTheme.of(context)
                                        .colors
                                        .primaryColor
                                    : CustomTheme.of(context)
                                        .colors
                                        .disabledAreaColor,
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onPressed: (_isPhoneNumberValid &&
                                        (snapshot.isSignUp
                                            ? _userNameForSignup?.isNotEmpty ??
                                                false
                                            : true))
                                    ? () async {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());

                                        if (snapshot.isSignUp)
                                          snapshot.addNameToStoreForSignup(
                                              _userNameForSignup);

                                        snapshot.getOtpAction(
                                          GenerateOTPRequest(
                                              phone: _phoneNumber.phoneNumber,
                                              third_party_id: EnvironmentConfig
                                                  .ThirdPartyID,
                                              isSignUp: snapshot.isSignUp),
                                        );
                                      }
                                    // in case any field's input valus is invalid, we trigger validity check to display relevant error.
                                    : () {
                                        formKey.currentState.validate();
                                        validatePhoneNumber(_phoneNumber);
                                        if (!_isPhoneNumberValid) {
                                          setState(() {
                                            showPhoneNumberError = true;
                                          });
                                        }
                                      },
                                child: Center(
                                  child: Text(
                                    'screen_otp.get_otp',
                                    style: CustomTheme.of(context)
                                        .textStyles
                                        .cardTitle
                                        .copyWith(
                                            color: CustomTheme.of(context)
                                                .colors
                                                .backgroundColor),
                                  ).tr(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void validatePhoneNumber(PhoneNumber number) {
    debugPrint(number?.parseNumber());
    _phoneNumber = number;
    setState(
      () {
        if (_phoneNumber != null) {
          if (validator.phone(_phoneNumber.phoneNumber) &&
              _phoneNumber.parseNumber().length > 9) {
            this._isPhoneNumberValid = true;
            this.showPhoneNumberError = false;
          } else {
            this._isPhoneNumberValid = false;
          }
        } else {
          this._isPhoneNumberValid = false;
          this.showPhoneNumberError = true;
        }
      },
    );
  }

  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    super.dispose();
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  Function navigateToOTPPage;
  Function updatePushToken;
  Function(String) addNameToStoreForSignup;
  LoadingStatusApp loadingStatus;
  Function(GenerateOTPRequest request) getOtpAction;
  bool isPhoneNumberValid;
  Function(bool isSignup) updateIsSignUp;
  bool isSignUp;

  _ViewModel.build(
      {this.navigateToOTPPage,
      this.isPhoneNumberValid,
      this.getOtpAction,
      this.isSignUp,
      this.loadingStatus,
      this.addNameToStoreForSignup,
      this.updateIsSignUp,
      this.updatePushToken})
      : super(equals: [loadingStatus, isSignUp]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
        loadingStatus: state.authState.loadingStatus,
        navigateToOTPPage: () {
          dispatch(NavigateAction.pushNamed('/otpScreen'));
        },
        isPhoneNumberValid: state.authState.isPhoneNumberValid,
        getOtpAction: (request) {
          dispatch(GetOtpAction(request: request, fromResend: false));
        },
        addNameToStoreForSignup: (String name) {
          dispatch(AddNameToStoreForSignupAction(name));
        },
        updateIsSignUp: (isSignUp) {
          dispatch(UpdateIsSignUpAction(isSignUp: isSignUp));
        },
        updatePushToken: (token) {
          globals.deviceToken = token;
        },
        isSignUp: state.authState.isSignUp);
  }
}
