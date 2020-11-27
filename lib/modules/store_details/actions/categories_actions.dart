import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';

class GetCategoriesDetailsAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
      url: ApiURL.getCategories(state.productState.selectedMerchant.businessId),
      params: null,
      requestType: RequestType.get,
    );
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      var responseModel = CategoryResponse.fromJson(response.data);

      return state.copyWith(
        productState: state.productState.copyWith(
          categories: responseModel.categories,
        ),
      );
    }
  }

  @override
  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  @override
  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}

// when switching to some merchant details page.
// Already cached data of products must be cleared.
class ResetCatalogueAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      productState: state.productState.copyWith(
        categories: [],
        categoryIdToSubCategoryData: {},
        subCategoryIdToProductData: {},
        isLoadingMore: {},
        allProductsForMerchant: null,
      ),
    );
  }
}
