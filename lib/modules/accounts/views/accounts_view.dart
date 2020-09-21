import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/utilities/push_notification.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/accounts/action/account_action.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AccountsView extends StatefulWidget {
  @override
  _AccountsViewState createState() => _AccountsViewState();
}

class _AccountsViewState extends State<AccountsView> {
  String versionString = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
        titleSpacing: 30.0,
        title: // Orders
            Text(tr('screen_account.title'),
                style: const TextStyle(
                    color: const Color(0xff000000),
                    fontWeight: FontWeight.w500,
                    fontFamily: "Avenir-Medium",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0),
                textAlign: TextAlign.left),
      ),
      body: StoreConnector<AppState, _ViewModel>(
          onInit: (store) {
//                store.dispatch(GetLocationAction());
//                store.dispatch(GetCartFromLocal());
          },
          model: _ViewModel(),
          builder: (context, snapshot) {
            return ListView(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    snapshot.navigateToProfile();
                  },
                  leading: Image.asset(
                    "assets/images/AI_user.png",
                    color: AppColors.iconColors,
                  ),
                  title: Text('screen_account.profile',
                          style: const TextStyle(
                              color: const Color(0xff3c3c3c),
                              fontWeight: FontWeight.w400,
                              fontFamily: "CircularStd-Book",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.left)
                      .tr(),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
//                ListTile(
//                  leading: Image.asset("assets/images/AI_chat.png"),
//                  title: Text('screen_account.recommend',
//                          style: const TextStyle(
//                              color: const Color(0xff3c3c3c),
//                              fontWeight: FontWeight.w400,
//                              fontFamily: "CircularStd-Book",
//                              fontStyle: FontStyle.normal,
//                              fontSize: 16.0),
//                          textAlign: TextAlign.left)
//                      .tr(),
//                  trailing: Icon(Icons.keyboard_arrow_right),
//                  onTap: () {
//                    PushNotificationsManager().moveToScreen();
////                    snapshot.navigateToRecommendedShop();
//                  },
//                ),
                ListTile(
                  leading: Image.asset(
                    "assets/images/question_cr.png",
                    color: AppColors.iconColors,
                  ),
                  title: Text('screen_account.about',
                          style: const TextStyle(
                              color: const Color(0xff3c3c3c),
                              fontWeight: FontWeight.w400,
                              fontFamily: "CircularStd-Book",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.left)
                      .tr(),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    snapshot.navigateToRecommendedShop();
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    "assets/images/location2.png",
                    color: AppColors.iconColors,
                  ),
                  title: Text(tr('screen_account.circles'),
                      style: const TextStyle(
                          color: const Color(0xff3c3c3c),
                          fontWeight: FontWeight.w400,
                          fontFamily: "CircularStd-Book",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      textAlign: TextAlign.left)
                      .tr(),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    snapshot.navigateToCircles();
                  },
                ),
                ListTile(
                  onTap: () {
                    snapshot.navigateLanguage();
                  },
                  leading: Image.asset(
                    "assets/images/Group_240.png",
                    color: AppColors.iconColors,
                  ),
                  title: Text('screen_account.language',
                          style: const TextStyle(
                              color: const Color(0xff3c3c3c),
                              fontWeight: FontWeight.w400,
                              fontFamily: "CircularStd-Book",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.left)
                      .tr(),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Text("E-samudaay"),
                          content: Text(
                            'screen_account.alert_data',
                            style: const TextStyle(
                                color: const Color(0xff6f6d6d),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Avenir-Medium",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                          ).tr(),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                tr('screen_account.cancel'),
                                style: const TextStyle(
                                    color: const Color(0xff6f6d6d),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Avenir-Medium",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text(
                                tr('screen_account.logout'.toLowerCase()),
                                style: const TextStyle(
                                    color: const Color(0xff6f6d6d),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Avenir-Medium",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0),
                              ),
                              onPressed: () async {
                                snapshot.logout();
                              },
                            )
                          ],
                        ));
                  },
                  leading: Image.asset(
                    "assets/images/power.png",
                    color: AppColors.iconColors,
                  ),
                  title: Text('screen_account.logout',
                          style: const TextStyle(
                              color: const Color(0xff3c3c3c),
                              fontWeight: FontWeight.w400,
                              fontFamily: "CircularStd-Book",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.left)
                      .tr(),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                Container(
                  height: 100,
                  child: Center(
                    child: Text(versionString,
                        style: const TextStyle(
                            color: const Color(0xff848282),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                  ),
                )
              ],
            );
          }),
    );
  }

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    print("Veresion $version Build $buildNumber");

    setState(() {
      versionString = "Version $version Build $buildNumber";
    });
  }

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('screen_account.title').tr(),
//      ),
//      body: Container(),
//    );
//  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();
  LoadingStatusApp loadingStatus;
  Function navigateToRecommendedShop;
  Function navigateToProfile;
  Function navigateLanguage;
  Function navigateToCircles;
  Function logout;

  _ViewModel.build(
      {this.navigateToRecommendedShop,
      this.loadingStatus,
      this.logout,
      this.navigateToProfile,
      this.navigateLanguage,
      this.navigateToCircles,
      })
      : super(equals: [loadingStatus]);

  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        loadingStatus: state.authState.loadingStatus,
        navigateToRecommendedShop: () {
          dispatch(NavigateAction.pushNamed('/about'));
        },
        logout: () {
          dispatch(LogoutAction());
        },
        navigateLanguage: () {
          dispatch(NavigateAction.pushNamed("/language",
              arguments: {"fromAccount": true}));
        },
        navigateToProfile: () {
          dispatch(NavigateAction.pushNamed("/profile"));
        },
        navigateToCircles: () {
          dispatch(NavigateAction.pushNamed("/circles", arguments: {
            "fromAccountScreen":true
          }));
        }
    );
  }
}
