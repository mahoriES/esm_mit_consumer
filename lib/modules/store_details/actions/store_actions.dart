import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/home/models/category_response.dart';
import 'package:esamudaayapp/modules/store_details/models/catalog_search_models.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/repository/cart_datasourse.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';

class GetCatalogDetailsAction extends ReduxAction<AppState> {
  final String query;

  GetCatalogDetailsAction({this.query});
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url:
            "api/v1/businesses/${state.productState.selectedMerchand.businessId}/catalog/categories/${state.productState.selectedCategory.categoryId}/products",
        params: query == null ? {"": ""} : {"filter": query},
        requestType: RequestType.get);
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      var responseModel = CatalogSearchResponse.fromJson(response.data);
      var items = responseModel.results;

      var products = items.map((f) {
        f.count = 0;
        return f;
      }).toList();

      List<Product> allCartItems = await CartDataSource.getListOfCartWith();

      products.forEach((item) {
        allCartItems.forEach((localCartItem) {
          if (item.productId == localCartItem.productId) {
            item.count = localCartItem.count;
          }
        });
      });

      return state.copyWith(
          productState:
              state.productState.copyWith(productListingDataSource: products));
    }
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
    super.after();
  }
}

class UpdateSelectedCategoryAction extends ReduxAction<AppState> {
  final CategoriesNew selectedCategory;

  UpdateSelectedCategoryAction({this.selectedCategory});

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        productState: state.productState.copyWith(
            selectedCategory: selectedCategory,
            productListingTempDataSource: []));
  }
}

class UpdateProductListingTempDataAction extends ReduxAction<AppState> {
  final List<Product> listingData;

  UpdateProductListingTempDataAction({this.listingData});
  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        productState: state.productState
            .copyWith(productListingTempDataSource: listingData));
  }
}

class UpdateProductListingDataAction extends ReduxAction<AppState> {
  final List<Product> listingData;

  UpdateProductListingDataAction({this.listingData});
  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        productState:
            state.productState.copyWith(productListingDataSource: listingData));
  }
}
