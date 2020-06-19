import 'dart:async';
import 'dart:convert';

import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/address/models/addess_models.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddAddressAction extends ReduxAction<AppState> {
  final AddressRequest request;

  AddAddressAction({this.request});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.addressUrl,
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.status == ResponseStatus.success200) {
      Address responseModel = Address.fromJson(response.data);
      await UserManager.saveAddress(
          address: jsonEncode(responseModel.toJson()));
//      AuthResponse authResponse = AuthResponse.fromJson(response.data);
//      UserManager.saveToken(token: authResponse.customer.customerID);
//      var user = User(
//        id: authResponse.customer.customerID,
//        firstName: authResponse.customer.name,
//        address: authResponse.customer.addresses.isEmpty
//            ? ""
//            : authResponse.customer.addresses.first.addressLine1,
//        phone: authResponse.customer.phoneNumber,
//      );
//      UserManager.saveUser(user).then((onValue) {
//        store.dispatch(GetUserFromLocalStorageAction());
//      });

    } else {
      Fluttertoast.showToast(msg: response.data['message']);
      //throw UserException(response.data['status']);
    }
    return null;
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}

class GetAddressAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.addressUrl, params: {"": ""}, requestType: RequestType.get);

    if (response.status == ResponseStatus.success200) {
      List<Address> responseModel = List<Address>();

      response.data.forEach((e) {
        responseModel.add(Address.fromJson(e));
      });
      if (responseModel.isNotEmpty) {
        await UserManager.saveAddress(
            address: jsonEncode(responseModel.first.toJson()));
        return state.copyWith(
            authState: state.authState.copyWith(address: responseModel.first));
      }
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
      //throw UserException(response.data['status']);
    }
    return null;
  }
}

class GetAddressFromLocal extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    Address address = await UserManager.getAddress();
    return state.copyWith(
        authState: state.authState.copyWith(address: address));
  }
}
