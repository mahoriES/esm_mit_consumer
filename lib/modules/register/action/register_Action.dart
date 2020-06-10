import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/User.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/login/actions/login_actions.dart';
import 'package:esamudaayapp/modules/login/model/authentication_response.dart';
import 'package:esamudaayapp/modules/register/model/register_request_model.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateUserDetailAction extends ReduxAction<AppState> {
  final CustomerDetailsRequest request;

  UpdateUserDetailAction({this.request});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.updateCustomerDetails,
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.data['statusCode'] == 200) {
      AuthResponse authResponse = AuthResponse.fromJson(response.data);
      UserManager.saveToken(token: authResponse.customer.customerID);
      var user = User(
        id: authResponse.customer.customerID,
        firstName: authResponse.customer.name,
        address: authResponse.customer.addresses.isEmpty
            ? ""
            : authResponse.customer.addresses.first.addressLine1,
        phone: authResponse.customer.phoneNumber,
      );
      UserManager.saveUser(user).then((onValue) {
        store.dispatch(GetUserFromLocalStorageAction());
      });
      dispatch(CheckTokenAction());
      store.dispatch(GetUserFromLocalStorageAction());
      dispatch(NavigateAction.pushNamedAndRemoveAll("/myHomeView"));
    } else {
      Fluttertoast.showToast(msg: response.data['status']);
      //throw UserException(response.data['status']);
    }
    return state.copyWith(
        authState:
            state.authState.copyWith(updateCustomerDetailsRequest: request));
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}
