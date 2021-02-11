import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/accounts/action/account_action.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:eSamudaay/utilities/push_notification.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/login/actions/login_actions.dart';
import 'package:eSamudaay/modules/login/model/get_otp_request.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/custom_widgets.dart';
import 'package:eSamudaay/utilities/global.dart' as globals;
import 'package:eSamudaay/utilities/stringConstants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  String fcmToken = "";
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _isPhoneNumberValid = false;
  PhoneNumber _phoneNumber;
  String _userNameForSignup;

  fcm() {
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch called');
        return null;
      },
      onResume: (Map<String, dynamic> message) {
        print('onResume called');
        return null;
      },
      onMessage: (Map<String, dynamic> message) {
        print('onMessage called');
        return null;
      },
    );
    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
      sound: true,
      badge: true,
      alert: true,
    ));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('Hello');
    });
    _firebaseMessaging.getToken().then((token) {
      print('Hello token');
      globals.deviceToken = token;
      print(token); // Print the Token in Console
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    //Column(children: buildColumnChildren(snapshot, context),),
                    Positioned(
                      top: 241.toHeight,
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
                              TextField(
                                controller: nameController,
                                onChanged: (String value) {
                                  setState(() {
                                    _userNameForSignup = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter Name',
                                  hintStyle: CustomTheme.of(context)
                                      .textStyles
                                      .sectionHeading2
                                      .copyWith(
                                          color: CustomTheme.of(context)
                                              .colors
                                              .disabledAreaColor),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: CustomTheme.of(context)
                                        .colors
                                        .disabledAreaColor
                                        .withOpacity(0.3)),
                                borderRadius: BorderRadius.circular(4),
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
                                onInputChanged: (PhoneNumber number) {
                                  debugPrint(number.parseNumber());
                                  _phoneNumber = number;
                                  setState(
                                    () {
                                      if (validator.phone(
                                              _phoneNumber.phoneNumber) &&
                                          _phoneNumber.parseNumber().length > 9)
                                        this._isPhoneNumberValid = true;
                                      else
                                        this._isPhoneNumberValid = false;
                                    },
                                  );
                                },
                                inputDecoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Phone Number',
                                    labelStyle: CustomTheme.of(context)
                                        .textStyles
                                        .cardTitle),
                                spaceBetweenSelectorAndTextField: 0.0,
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
                                              third_party_id: thirdPartyId,
                                              isSignUp: snapshot.isSignUp),
                                        );
                                      }
                                    : null,
                                child: Center(
                                  child: Text(
                                    'GET OTP',
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

  List<Widget> buildColumnChildren(_ViewModel snapshot, BuildContext context) {
    return [
      Container(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Hero(
          tag: "#image",
          child: Image.asset('assets/images/app_main_icon.png'),
        ),
      ),
      SizedBox(
        height: 40,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: <Widget>[
            AnimatedSwitcher(
              transitionBuilder: (Widget child, Animation<double> animation) =>
                  ScaleTransition(
                scale: animation,
                child: child,
              ),
              duration: const Duration(milliseconds: 200),
              child: snapshot.isSignUp
                  ? Text("screen_phone.sign_up",
                          key: ValueKey(1),
                          style: const TextStyle(
                              color: const Color(0xff797979),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Avenir-Medium",
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0),
                          textAlign: TextAlign.left)
                      .tr()
                  : Text("screen_phone.login",
                          key: ValueKey(2),
                          style: const TextStyle(
                              color: const Color(0xff797979),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Avenir-Medium",
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0),
                          textAlign: TextAlign.left)
                      .tr(),
            ),
          ],
        ),
      ),
      //phone number
      Padding(
        padding:
            const EdgeInsets.only(top: 16.0, bottom: 29, left: 10, right: 10),
        child: TextInputBG(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Form(
                    child: TextFormField(
                        validator: (value) {
                          if (value.length == 0) return null;
                          if (value.length < 10 || !validator.phone(value)) {
                            return tr('screen_phone.valid_phone_error_message');
                          }
                          return null;
                        },
                        autovalidate: true,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: tr('screen_phone.hint_text'),
                          errorText: snapshot.isPhoneNumberValid
                              ? null
                              : tr('screen_phone.valid_phone_error_message'),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        style: const TextStyle(
                            color: const Color(0xff1a1a1a),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Avenir-Medium",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.center),
                    key: _formKey,
                  ),
                ),
                Icon(
                  Icons.phone_android,
                  color: AppColors.icColors,
                )
              ],
            ),
          ),
        ),
      ),
      // Group 230
      InkWell(
        onTap: () {
          if (validator.phone(phoneController.text) &&
              phoneController.text.length == 10) {
            FocusScope.of(context).requestFocus(FocusNode());
            snapshot.getOtpAction(GenerateOTPRequest(
                phone: "+91" + phoneController.text,
                third_party_id: thirdPartyId,
                isSignUp: snapshot.isSignUp));
          } else {}
        },
        child: Hero(
          tag: '#getOtp',
          child: Material(
            type: MaterialType.transparency,
            elevation: 6.0,
            color: Colors.transparent,
            child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 60,
                child: Stack(children: [
                  // Rectangle 10
                  PositionedDirectional(
                    top: 0,
                    start: 0,
                    child: Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 52,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            gradient: AppColors.linearGradient)),
                  ),
                  // Get OTP
                  PositionedDirectional(
                    top: 16.000030517578125,
                    start: 0,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 22,
                        child: Text('screen_phone.get_otp',
                                style: const TextStyle(
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Avenir-Medium",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0),
                                textAlign: TextAlign.center)
                            .tr()),
                  )
                ])),
          ),
        ),
      ),
      SizedBox(
        height: 50,
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
      ),

      Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            snapshot.updateIsSignUp(!snapshot.isSignUp);
          },
          child: // Already have an account? Login here
              RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    style: const TextStyle(
                        color: const Color(0xff1a1a1a),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Avenir-Medium",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    text: snapshot.isSignUp
                        ? tr("screen_phone.already_customer")
                        : tr("screen_phone.new_user")),
                TextSpan(
                    style: const TextStyle(
                        color: const Color(0xff5091cd),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Avenir-Medium",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    text: snapshot.isSignUp
                        ? tr("screen_phone.login_here")
                        : tr("screen_phone.register_now"))
              ],
            ),
          ),
        ),
      ),
      SizedBox(
        height: 40,
      )
    ];
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
    // TODO: implement fromStore
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
