import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/store_details/models/categories_models.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GetCategoriesDetailsAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url:
            "api/v1/businesses/${state.productState.selectedMerchand.businessId}/catalog/categories",
        params: {"": ""},
        requestType: RequestType.get);
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      var responseModel = CategoryResponse.fromJson(response.data);

      return state.copyWith(
          productState: state.productState.copyWith(
        categories: responseModel.categories,
      ));
    }
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
    super.after();
  }
}

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
//      Merchants merchants = Merchants();
//      merchants = state.productState.selectedMerchand;
//      merchants.categories = responseModel.categories;
//      return state.copyWith(
//          productState:
//              state.productState.copyWith(selectedMerchant: merchants));
    } else {
      Fluttertoast.showToast(msg: response.data['status']);
    }

    return state.copyWith(authState: state.authState.copyWith());
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}
