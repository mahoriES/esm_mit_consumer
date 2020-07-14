import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/accounts/model/recommend_request.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/redux/states/auth_state.dart';
import 'package:eSamudaay/redux/states/home_page_state.dart';
import 'package:eSamudaay/redux/states/product_state.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:eSamudaay/utilities/push_notification.dart';
import 'package:eSamudaay/utilities/user_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutAction extends ReduxAction<AppState> {
  LogoutAction();

  @override
  FutureOr<AppState> reduce() async {
//    var response = await APIManager.shared.request(
//        url: ApiURL.logoutURL, requestType: RequestType.post, params: {});
//
//    if (response.data['statusCode'] == 200) {
//      await CartDataSource.deleteAllMerchants();
//      await CartDataSource.deleteAll();
//      dispatch(NavigateAction.pushNamedAndRemoveAll('/loginView'));
//    } else {
//      Fluttertoast.showToast(msg: response.data['status']);
//      //throw UserException(response.data['status']);
//    }
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    await CartDataSource.deleteAllMerchants();
    await CartDataSource.deleteAll();
    await UserManager.deleteUser();
    PushNotificationsManager().signOut();
    dispatch(NavigateAction.pushNamedAndRemoveAll('/loginView'));

    return state.copyWith(
        authState: AuthState.initial(),
        isLoading: false,
        productState: ProductState.initial(),
        homePageState: HomePageState.initial());
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}

class RecommendAction extends ReduxAction<AppState> {
  final RecommendedShopRequest request;

  RecommendAction({this.request});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.recommendStoreURL,
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.data['statusCode'] == 200) {
      Fluttertoast.showToast(
          msg: "Successfully recommended ${request.storeName} ");
      dispatch(NavigateAction.pop());
    } else {
      Fluttertoast.showToast(msg: response.data['status']);
      //throw UserException(response.data['status']);
    }

    return state.copyWith(authState: state.authState.copyWith());
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}
