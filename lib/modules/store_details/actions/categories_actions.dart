import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/home/models/merchant_response.dart';
import 'package:esamudaayapp/modules/store_details/models/categories_models.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GetCategoriesAction extends ReduxAction<AppState> {
  final String merchantId;

  GetCategoriesAction({this.merchantId});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.getCategories,
        params: {"merchantID": merchantId},
        requestType: RequestType.post);
    if (response.data['statusCode'] == 200) {
      GetCategoriesResponse responseModel =
          GetCategoriesResponse.fromJson(response.data);
      Merchants merchants = Merchants();
      merchants = state.productState.selectedMerchand;
      merchants.categories = responseModel.categories;
      return state.copyWith(
          productState:
              state.productState.copyWith(selectedMerchant: merchants));
    } else {
      Fluttertoast.showToast(msg: response.data['status']);
    }

    return state.copyWith(authState: state.authState.copyWith());
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}
