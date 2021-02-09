import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:eSamudaay/utilities/push_notification.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/login/actions/login_actions.dart';
import 'package:eSamudaay/modules/otp/action/otp_action.dart';
import 'package:eSamudaay/modules/otp/model/validate_otp_request.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  Timer _timer;
  int _start = 30;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
        onInit: (store) {
          FocusScope.of(context).requestFocus(FocusNode());
          PushNotificationsManager().init();
          startTimer();
        },
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
                        height: 667.toHeight,
                        width: SizeConfig.screenWidth,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 25,
                      top: 35,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          color: CustomTheme.of(context).colors.backgroundColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.arrow_back_ios,
                                color:
                                    CustomTheme.of(context).colors.primaryColor,
                              ),
                              Text(
                                'Back',
                                style: CustomTheme.of(context)
                                    .textStyles
                                    .sectionHeading1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 212.toHeight,
                      left: 12.toWidth,
                      child: Container(
                        width: 351.toWidth,
                        padding: const EdgeInsets.only(
                            bottom: 12, left: 5, right: 5),
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
                            SizedBox(
                              height: 42.toHeight,
                              child: Container(
                                padding: EdgeInsets.only(
                                    bottom: 8, left: 10, right: 10, top: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.grey)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      color: CustomTheme.of(context)
                                          .colors
                                          .primaryColor,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 21.toHeight,
                                      width: 1,
                                      color: CustomTheme.of(context)
                                          .colors
                                          .primaryColor,
                                    ),
                                    Expanded(
                                      child: OTPField(
                                        length: 6,
                                        fieldWidth: 28,
                                        textFieldAlignment:
                                            MainAxisAlignment.spaceAround,
                                        fieldStyle: FieldStyle.underline,
                                        style: CustomTheme.of(context)
                                            .textStyles
                                            .sectionHeading1,
                                        onChanged: (pin) {
                                          snapshot.updateOtpEnterStatus(
                                              pin.length == 6);
                                        },
                                        onCompleted: (pin) async {
                                          snapshot.updateOtpEnterStatus(
                                              pin.length == 6);

                                          snapshot.updateValidationRequest(
                                              ValidateOTPRequest(
                                                  token: pin,
                                                  phone: snapshot.phoneNumber));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              width: 157.4.toWidth,
                              height: 42.toHeight,
                              child: RaisedButton(
                                color:
                                    CustomTheme.of(context).colors.primaryColor,
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onPressed: snapshot.otpEntered ? () async {
                                  if (snapshot.otpEntered) {
                                    snapshot.verifyOTP(ValidateOTPRequest(
                                      phone: snapshot.phoneNumber,
                                    ));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: tr('screen_otp.error.plz_verify_otp'));
                                  }
                                } : null,
                                child: Center(
                                  child: Text(
                                    'VERIFY',
                                    style: CustomTheme.of(context)
                                        .textStyles
                                        .cardTitle
                                        .copyWith(
                                            color: CustomTheme.of(context)
                                                .colors
                                                .backgroundColor),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14,),
                            _start == 0
                                ? InkWell(
                                    onTap: () {
                                      snapshot.resendOtpRequest();
                                      _start = 30;
                                      startTimer();
                                    },
                                    child: Text('screen_otp.resend_otp',
                                            style: CustomTheme.of(context)
                                                .textStyles
                                                .sectionHeading1Regular
                                                .copyWith(
                                                    color:
                                                        CustomTheme.of(context)
                                                            .colors
                                                            .primaryColor),
                                            textAlign: TextAlign.left)
                                        .tr(),
                                  )
                                : Text(
                                        tr('screen_otp.resend_text') +
                                            ' $_start ' +
                                            tr('screen_otp.sec.'),
                                        style: CustomTheme.of(context)
                                            .textStyles
                                            .sectionHeading1Regular
                                            .copyWith(
                                                color: CustomTheme.of(context)
                                                    .colors
                                                    .disabledAreaColor),
                                        textAlign: TextAlign.left)
                                    .tr()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ); // OTP
        },
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  Function(ValidateOTPRequest) verifyOTP;
  Function(ValidateOTPRequest) updateValidationRequest;
  Function() resendOtpRequest;
  String phoneNumber;
  bool otpEntered;
  LoadingStatusApp loadingStatus;
  Function(bool) updateOtpEnterStatus;

  _ViewModel.build(
      {this.verifyOTP,
      this.loadingStatus,
      this.otpEntered,
      this.updateOtpEnterStatus,
      this.updateValidationRequest,
      this.phoneNumber,
      this.resendOtpRequest})
      : super(equals: [otpEntered, loadingStatus]);

  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        loadingStatus: state.authState.loadingStatus,
        verifyOTP: (request) {
          dispatch(ValidateOtpAction(isSignUp: state.authState.isSignUp));
        },
        otpEntered: state.authState.isOtpEntered,
        updateOtpEnterStatus: (newValue) {
          dispatch(OTPAction(isValid: newValue));
        },
        updateValidationRequest: (request) {
          dispatch(UpdateValidationRequest(request: request));
        },
        resendOtpRequest: () {
          dispatch(GetOtpAction(
              request: state.authState.getOtpRequest, fromResend: true));
        },
        phoneNumber: state.authState.getOtpRequest.phone);
  }
}
