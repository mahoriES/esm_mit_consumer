import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/utilities/api_manager.dart';

class GetSubCatalogAction extends ReduxAction<AppState> {
  GetSubCatalogAction();

  @override
  FutureOr<AppState> reduce() async {
    var id = state.productState.selectedCategory.categoryId;
    var response = await APIManager.shared.request(
        url:
            "api/v1/businesses/${state.productState.selectedMerchand.businessId}/catalog/categories",
        params: {"parent_category_id": "$id"},
        requestType: RequestType.get);
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      var responseModel = CategoryResponse.fromJson(response.data);
      dispatch(UpdateSelectedSubCategoryAction(
          selectedSubCategory: responseModel.categories.length > 0
              ? responseModel.categories.first
              : null));
      return state.copyWith(
          productState: state.productState
              .copyWith(subCategories: responseModel.categories));
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

class GetCatalogDetailsAction extends ReduxAction<AppState> {
  final String query;
  final String url;

  GetCatalogDetailsAction({this.query, this.url});
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: url == null
            ? "api/v1/businesses/${state.productState.selectedMerchand.businessId}/catalog/categories/${state.productState.selectedSubCategory.categoryId}/products"
            : url,
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
        item.selectedVariant = 0;
        allCartItems.forEach((localCartItem) {
          if (item.productId == localCartItem.productId) {
            item.count = localCartItem.count;
          }
        });
      });

      if (url != null) {
        var totalProduct =
            state.productState.productResponse.results + products;
        products = totalProduct;
        responseModel.results = products;
      } else {}

      return state.copyWith(
          productState: state.productState.copyWith(
              productListingDataSource: products,
              productResponse: responseModel));
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

class UpdateSelectedSubCategoryAction extends ReduxAction<AppState> {
  final CategoriesNew selectedSubCategory;

  UpdateSelectedSubCategoryAction({this.selectedSubCategory});

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        productState: state.productState.copyWith(
            selectedSubCategory: selectedSubCategory,
            productListingTempDataSource: [],
            productListingDataSource: []));
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

class UpdateProductVariantAction extends ReduxAction<AppState> {
  final int index;

  UpdateProductVariantAction({this.index});
  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(productState: state.productState.copyWith());
  }
}
