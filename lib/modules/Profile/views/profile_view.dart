import 'dart:io';
import 'dart:ui';

import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/Profile/action/profile_update_action.dart';
import 'package:eSamudaay/modules/Profile/model/profile_update_model.dart';
import 'package:eSamudaay/modules/address/actions/address_actions.dart';
import 'package:eSamudaay/modules/address/models/addess_models.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/custom_widgets.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:regexed_validator/regexed_validator.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
          onInit: (store) {},
          model: _ViewModel(),
          builder: (context, snapshot) {
            if (snapshot.loadingStatus != LoadingStatusApp.loading) {
              if (snapshot.userAddress != null &&
                  snapshot.userAddress.isNotEmpty) {
                addressController.text =
                    snapshot.userAddress?.first?.prettyAddress ?? "";
              }
            }

            nameController.text = snapshot.user.profileName;
            phoneNumberController.text = snapshot.user.userProfile.phone != null
                ? snapshot.user.userProfile.phone
                : "";

            return WillPopScope(
              onWillPop: () async {
                return Future.value(
                    false); //return a `Future` with false value so this route cant be popped or closed.
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
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    brightness: Brightness.light,
                    leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
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
                            children: buildUI(context, snapshot),
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

  List<Widget> buildUI(BuildContext context, _ViewModel snapshot) {
    return <Widget>[
      SizedBox(
        height: 100,
      ),
      InkWell(
        onTap: () {
          _settingModalBottomSheet(context, snapshot);
        },
        child: Container(
          height: 80,
          width: 80,
          decoration: new BoxDecoration(
              boxShadow: [
                new BoxShadow(
                  color: Colors.white30,
                  blurRadius: 0.0,
                ),
              ],
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.cover,
                  image: _image != null
                      ? FileImage(_image)
                      : snapshot.user.profilePic.photoUrl != null
                          ? new NetworkImage(snapshot.user.profilePic.photoUrl)
                          : AssetImage('assets/images/user.jpg'))),
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
                  child: TextFormField(
                      validator: (value) {
                        if (value.length == 0) return null;
                        if (value.length < 3) {
                          return tr('screen_register.name.empty_error');
                          return null;
                        }
                        return null;
                      },
                      autovalidate: true,
                      enabled: false,
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: tr('screen_recommended.name'),
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
                Icon(
                  Icons.account_circle,
                  color: AppColors.icColors,
                )
              ],
            ),
          ),
        ),
      ),
      //pin code
      Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: TextInputBG(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                      enabled: false,
                      validator: (value) {
                        if (value.length == 0) return null;
                        if (value.length < 10 || !validator.phone(value)) {
                          return tr('screen_phone.valid_phone_error_message');
                        }
                        return null;
                      },
                      autovalidate: true,
                      controller: phoneNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: tr('screen_recommended.phone'),
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
                Icon(
                  Icons.phone_iphone,
                  color: AppColors.icColors,
                )
              ],
            ),
          ),
        ),
      ),
      //address
      Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
        child: TextInputBG(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: snapshot.navigateToAddressView,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                          maxLines: null,
                          enabled: false,
                          validator: (value) {
                            if (value.isEmpty) return null;
//                                          if (value.length < 10) {
//                                            return tr(
//                                                'screen_register.address.empty_error');
//                                            return null;
//                                          }
                            return null;
                          },
                          autovalidate: true,
                          controller: addressController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: tr('screen_register.address.title'),
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
                    Icon(
                      Icons.add_location,
                      color: AppColors.icColors,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      //location
      //Register_but
      // Rectangle 10
      Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            if (nameController.text.isNotEmpty &&
                addressController.text.isNotEmpty &&
                phoneNumberController.text.isNotEmpty) {
              if ((nameController.text.length < 3 ||
                  !nameController.text.contains(new RegExp(r'[a-z]')))) {
                Fluttertoast.showToast(
                    msg: tr('screen_register.name.empty_error'));
              } else if (phoneNumberController.text.length < 10 ||
                  !validator.phone(phoneNumberController.text)) {
                Fluttertoast.showToast(
                    msg: tr('screen_phone.valid_phone_error_message'));
              } else {
                snapshot.profileUpdate(
                  _image,
                );
              }
            } else {
              Fluttertoast.showToast(msg: "all fields required");
            }
          },
          child: Hero(
            tag: '#getOtp',
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
                          child: Text('screen_register.update',
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
      SizedBox(
        height: 50,
      ),
    ];
  }

  void _settingModalBottomSheet(context, _ViewModel snapshot) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(child: Text("Image Upload From ?")),
                ),
                new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imageSelectorCamera(snapshot);
                      Navigator.pop(context);
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_album),
                  title: new Text('Gallery'),
                  onTap: () {
                    imageSelectorGallery(snapshot);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  imageSelectorGallery(_ViewModel snapshot) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
//      snapshot.profileUpdate(_image);
    });
  }

  //display image selected from camera
  imageSelectorCamera(_ViewModel snapshot) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
//      snapshot.profileUpdate(_image);
    });
  }

  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    window.physicalSize;
//    SystemChrome.setEnabledSystemUIOverlays([]);
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  Function() getAddress;
  Data user;
  LoadingStatusApp loadingStatus;
  Function(File image) profileUpdate;
  Function navigateToHomePage;
  bool isPhoneNumberValid;
  String userPhone;
  String userName;
  List<AddressResponse> userAddress;
  VoidCallback navigateToAddressView;

  _ViewModel.build({
    this.navigateToHomePage,
    this.profileUpdate,
    this.loadingStatus,
    this.isPhoneNumberValid,
    this.userPhone,
    this.userName,
    this.userAddress,
    this.user,
    this.getAddress,
    this.navigateToAddressView,
  }) : super(equals: [
          loadingStatus,
          isPhoneNumberValid,
          userPhone,
          userName,
          userAddress,
          user
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
        user: state.authState.user,
        userAddress: state.addressState.savedAddressList ?? [],
        loadingStatus: state.authState.loadingStatus,
        navigateToHomePage: () {
          //dispatch(NavigateAction.pushNamed('/myHomeView'));
        },
        getAddress: () {
          dispatch(GetAddressAction());
        },
        navigateToAddressView: () {
          dispatch(UpdateIsRegisterFlow(false));
          dispatch(NavigateAction.pushNamed(RouteNames.CHANGE_ADDRESS));
        },
        profileUpdate: (image) {
          // if (address != null && address.prettyAddress != "") {
          //   dispatch(
          //      UpdateAddressAction(request: address, addressID: addressId));
          // }
          if (image != null) {
            dispatch(UploadImageAction(imageFile: image));
          }

          ///dispatch(UpdateProfileAction(request: request));
        });
  }
}
