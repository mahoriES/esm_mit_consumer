import 'dart:ui';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/address/actions/address_actions.dart';
import 'package:eSamudaay/modules/address/models/addess_models.dart';
import 'package:eSamudaay/modules/register/action/register_Action.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/custom_widgets.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/validators/validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> formKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
          model: _ViewModel(),
          builder: (context, snapshot) {
            return WillPopScope(
              onWillPop: () async {
                return Future.value(false);
                //return a `Future` with false value so this route cant be popped or closed.
              },
              child: ModalProgressHUD(
                progressIndicator: Card(
                  child: Image.asset(
                    'assets/images/indicator.gif',
                    height: 75,
                    width: 75,
                  ),
                ),
                inAsyncCall: snapshot.loadingStatus == LoadingStatusApp.loading,
                child: Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: SingleChildScrollView(
                      child: AnimationLimiter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 375),
                            childAnimationBuilder: (widget) => SlideAnimation(
                              horizontalOffset:
                                  MediaQuery.of(context).size.width / 2,
                              child: FadeInAnimation(child: widget),
                            ),
                            children: buildUI(context, snapshot, formKey),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  List<Widget> buildUI(
      BuildContext context, _ViewModel snapshot, GlobalKey<FormState> formKey) {
    return <Widget>[
      SizedBox(
        height: 100,
      ),
      Container(
        width: MediaQuery.of(context).size.width / 1.2,
        child: Hero(
          tag: '#text',
          child: Material(
            type: MaterialType.transparency,
            child: Text('screen_register.title',
                    style: const TextStyle(
                        color: const Color(0xff797979),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Avenir-Medium",
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0),
                    textAlign: TextAlign.left)
                .tr(),
          ),
        ),
      ),
      //name
      Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: TextInputBG(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                        validator: Validators.nameValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: tr('screen_register.name.title'),
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
                            fontSize: 13.0),
                        textAlign: TextAlign.center),
                  ),
                ),
                Icon(
                  Icons.account_circle,
                  color: AppColors.icColors,
                )
              ],
            ),
          ),
        ),
      ),

      SizedBox(
        height: 30,
      ),

      // Register Button
      Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            if (formKey.currentState.validate()) {
              snapshot.updateCustomerDetails(
                CustomerDetailsRequest(
                  profileName: nameController.text,
                  role: "CUSTOMER",
                ),
              );
            }
          },
          child: Hero(
            tag: '#register_button',
            child: Material(
              type: MaterialType.transparency,
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
                          child: Text('screen_register.register',
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
      ),
    ];
  }

 
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    window.physicalSize;
    SystemChrome.setEnabledSystemUIOverlays([]);
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  LoadingStatusApp loadingStatus;
  Function(CustomerDetailsRequest request) updateCustomerDetails;
  Function navigateToHomePage;
  String phoneNumber;
  VoidCallback navigateToAddressView;
  AddressRequest addressRequest;

  _ViewModel.build({
    this.navigateToHomePage,
    this.updateCustomerDetails,
    this.loadingStatus,
    this.phoneNumber,
    this.navigateToAddressView,
    this.addressRequest,
  }) : super(equals: [loadingStatus, phoneNumber, addressRequest]);

  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        loadingStatus: state.authState.loadingStatus,
        phoneNumber: state.authState.getOtpRequest.phone,
        addressRequest: state.addressState.selectedAddressForRegister,
        navigateToHomePage: () {
          dispatch(NavigateAction.pushNamed('/myHomeView'));
        },
        navigateToAddressView: () {
          dispatch(UpdateIsRegisterFlow(true));
          dispatch(NavigateAction.pushNamed(RouteNames.ADD_NEW_ADDRESS));
        },
        updateCustomerDetails: (request) {
          dispatchFuture(AddUserDetailAction(request: request));
        });
  }
}
