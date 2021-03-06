import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/Profile/model/profile_update_model.dart';
import 'package:eSamudaay/modules/accounts/action/account_action.dart';
import 'package:eSamudaay/modules/login/actions/login_actions.dart';
import 'package:eSamudaay/modules/otp/action/otp_action.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:eSamudaay/utilities/firebase_analytics.dart';
import 'package:eSamudaay/utilities/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GetUserDetailAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.updateCustomerDetails,
        params: {"": ""},
        requestType: RequestType.get);

    if (response.status == ResponseStatus.success200) {
      dispatch(InitialiseStoreOnLogoutAction());
      GetProfileResponse authResponse =
          GetProfileResponse.fromJson(response.data);
      if (authResponse.cUSTOMER == null) {
        await dispatchFuture(
            SilentlyAddCustomerRoleToProfileAction(response.data));
      } else {
        await UserManager.saveToken(token: authResponse.cUSTOMER.token);

        Data user = authResponse.cUSTOMER.data;

        await UserManager.saveUser(user).then((onValue) {
          store.dispatch(GetUserFromLocalStorageAction());
        });

        dispatch(CheckTokenAction());
        store.dispatch(GetUserFromLocalStorageAction());
        AppFirebaseAnalytics.instance.logAppLogin(user: user.toString());
        dispatch(NavigateAction.pushNamedAndRemoveAll("/myHomeView"));
        return state.copyWith(authState: state.authState.copyWith(user: user));
      }
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
      //throw UserException(response.data['status']);
    }
    return null;
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}

class SilentlyAddCustomerRoleToProfileAction extends ReduxAction<AppState> {
  final profilesData;

  SilentlyAddCustomerRoleToProfileAction(this.profilesData);

  @override
  FutureOr<AppState> reduce() async {
    final userProfilesResponse = UserProfilesResponse.fromJson(profilesData);
    final a = userProfilesResponse?.customerProfile?.data?.profileName ?? '';
    final b = userProfilesResponse?.merchantProfile?.data?.profileName ?? '';
    final c = userProfilesResponse?.agentProfile?.data?.profileName ?? '';
    final String userName = a.isNotEmpty
        ? a
        : b.isNotEmpty
            ? b
            : c.isNotEmpty
                ? c
                : '';
    debugPrint('Add customer role profile data $profilesData');
    debugPrint('Username $userName');
    final addCustomerProfilerResponse = await APIManager.shared.request(
      url: ApiURL.updateCustomerDetails,
      requestType: RequestType.post,
      params: {
        'role': "CUSTOMER",
        'profile_name': userName,
      },
    );
    if (addCustomerProfilerResponse.status == ResponseStatus.success200) {
      final authResponse =
          UpdatedProfile.fromJson(addCustomerProfilerResponse.data);
      await UserManager.saveToken(token: authResponse.token);

      final Data user = authResponse.data;

      await UserManager.saveUser(user).then((onValue) {
        store.dispatch(GetUserFromLocalStorageAction());
      });

      await dispatchFuture(CheckTokenAction());
      await store.dispatchFuture(GetUserFromLocalStorageAction());
      AppFirebaseAnalytics.instance.logAppLogin(user: user.toString());
      dispatch(NavigateAction.pushNamedAndRemoveAll("/myHomeView"));
      return state.copyWith(authState: state.authState.copyWith(user: user));
    } else {
      Fluttertoast.showToast(msg: addCustomerProfilerResponse.data['message']);
    }
    return null;
  }
}

class AddUserDetailAction extends ReduxAction<AppState> {
  final CustomerDetailsRequest request;

  AddUserDetailAction({this.request});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.updateCustomerDetails,
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.status == ResponseStatus.success200) {
      dispatch(InitialiseStoreOnLogoutAction());
      RegisterResponse authResponse = RegisterResponse.fromJson(response.data);
      await UserManager.saveToken(token: authResponse.token);

      Data user = authResponse.data;

      await UserManager.saveUser(user).then((onValue) {
        store.dispatch(GetUserFromLocalStorageAction());
      });

      dispatch(CheckTokenAction());
      store.dispatch(GetUserFromLocalStorageAction());
      dispatch(AddFCMTokenAction());
      dispatch(NavigateAction.pushNamedAndRemoveAll("/myHomeView"));
      return state.copyWith(authState: state.authState.copyWith(user: user));
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
    }
    return state.copyWith(
        authState:
            state.authState.copyWith(updateCustomerDetailsRequest: request));
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}
