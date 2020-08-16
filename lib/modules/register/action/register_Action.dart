import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/User.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/Profile/model/profile_update_model.dart';
import 'package:eSamudaay/modules/login/actions/login_actions.dart';
import 'package:eSamudaay/modules/otp/action/otp_action.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:eSamudaay/utilities/user_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GetUserDetailAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.updateCustomerDetails,
        params: {"": ""},
        requestType: RequestType.get);

    if (response.status == ResponseStatus.success200) {
      GetProfileResponse authResponse =
          GetProfileResponse.fromJson(response.data);
      if (authResponse.cUSTOMER == null) {
        dispatch(NavigateAction.pushNamed('/registration'));
      } else {
        await UserManager.saveToken(token: authResponse.cUSTOMER.token);

        Data user = authResponse.cUSTOMER.data;

        await UserManager.saveUser(user).then((onValue) {
          store.dispatch(GetUserFromLocalStorageAction());
        });

        dispatch(CheckTokenAction());
        store.dispatch(GetUserFromLocalStorageAction());

        dispatch(NavigateAction.pushNamedAndRemoveAll("/myHomeView"));
        return state.copyWith(authState: state.authState.copyWith(user: user));
      }
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
      //throw UserException(response.data['status']);
    }
    return null;
  }

//  void before() =>
//      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));
//
//  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
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
      //throw UserException(response.data['status']);
    }
    return state.copyWith(
        authState:
            state.authState.copyWith(updateCustomerDetailsRequest: request));
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}
