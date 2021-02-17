import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/address_state.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/redux/states/auth_state.dart';
import 'package:eSamudaay/redux/states/components_loading_state.dart';
import 'package:eSamudaay/redux/states/home_page_state.dart';
import 'package:eSamudaay/redux/states/product_categories_state.dart';
import 'package:eSamudaay/redux/states/product_state.dart';
import 'package:eSamudaay/redux/states/videos_state.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/utilities/firebase_analytics.dart';
import 'package:eSamudaay/utilities/push_notification.dart';
import 'package:eSamudaay/utilities/user_manager.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutAction extends ReduxAction<AppState> {
  LogoutAction();

  @override
  FutureOr<AppState> reduce() async {
    await AppFirebaseAnalytics.instance.logAppLogout
      (user: UserManager.shared.toString());
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    await CartDataSource.deleteCartMerchant();
    await CartDataSource.deleteAllProducts();
    await UserManager.deleteUser();
    await UserManager.deleteAddress();
    PushNotificationsManager().signOut();
    dispatch(NavigateAction.pushNamedAndRemoveAll(RouteNames.LANDING_PAGE));
    return null;
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() {
    dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
  }
}

class InitialiseStoreOnLogoutAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() {
    print('******Init store called');
    // this method resets all the existing data when new user logs in.
    // but app update data should not be wiped as this is not user specific.
    return AppState.initial(
      isSelectedAppUpdateLater: state.isSelectedAppUpdateLater,
    );
  }
}

class GetVersionString extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String version = packageInfo.version;
      final String buildNumber = packageInfo.buildNumber;

      return state.copyWith(
        versionString: "Version $version Build $buildNumber",
      );
    } catch (e) {
      return null;
    }
  }
}
