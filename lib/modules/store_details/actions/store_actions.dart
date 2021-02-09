import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/actions/dynamic_link_actions.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:eSamudaay/utilities/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GetSubCategoriesAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    // TODO : these variables should be final
    int categoryId = state.productState.selectedCategory.categoryId;
    String businessId = state.productState.selectedMerchant.businessId;

    // If the subCategory data has already loaded once
    // then no need to trigger the api again.
    if (state.productState.categoryIdToSubCategoryData
        .containsKey(categoryId)) {
      return null;
    }

    var response = await APIManager.shared.request(
      url: ApiURL.getCategories(businessId),
      params: SubCategoryRequestData(parentCategoryId: categoryId).toJson(),
      requestType: RequestType.get,
    );

    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      var responseModel = CategoryResponse.fromJson(response.data);

      // We are maintaining a map categoryIdToSubCategoryData to cache the already loaded subCategories, to avoid unnecessary Api calls.
      // update the map data for respective category and then update the app state.
      Map<int, List<CategoriesNew>> updatedSubCategoryMap =
          new Map.from(state.productState.categoryIdToSubCategoryData);
      updatedSubCategoryMap[categoryId] = responseModel.categories;

      return state.copyWith(
        productState: state.productState.copyWith(
          categoryIdToSubCategoryData: updatedSubCategoryMap,
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

class GetProductsForSubCategory extends ReduxAction<AppState> {
  final String filter;
  final String urlForNextPageResponse;
  final CategoriesNew selectedSubCategory;

  GetProductsForSubCategory({
    @required this.selectedSubCategory,
    this.filter,
    this.urlForNextPageResponse,
  });

  @override
  FutureOr<AppState> reduce() async {
    // If the call is not made for loadMore and the data has already loaded once
    // then no need to trigger the api again.
    if (urlForNextPageResponse == null &&
        state.productState.subCategoryIdToProductData
            .containsKey(selectedSubCategory.categoryId)) {
      return null;
    }
    // TODO : these variables should be final
    String businessId = state.productState.selectedMerchant.businessId;

    var response = await APIManager.shared.request(
      url: urlForNextPageResponse == null
          ? ApiURL.getProductsForSubcategory(
              businessId: businessId,
              subCategoryId: selectedSubCategory.categoryId.toString(),
            )
          : urlForNextPageResponse,
      params: SubCategoryProductsRequestData(filter: filter).toJson(),
      requestType: RequestType.get,
    );
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      final CatalogSearchResponse responseModel =
          CatalogSearchResponse.fromJson(response.data);

      // Fetch the local cart items.
      final List<Product> localCartItems =
          await CartDataSource.getListOfProducts();

      // check if any of these product items are already added in cart.
      // if yes updated the item count for the same.
      responseModel.results.forEach((item) {
        item.selectedSkuIndex = 0;
        item.count = 0;
        localCartItems.forEach((localCartItem) {
          if (item.productId == localCartItem.productId) {
            item.count = localCartItem.count;
          }
        });
      });

      // If action was triggered to load_more then append existingProducts in new data list.
      if (urlForNextPageResponse != null) {
        final List<Product> existingProducts = state.productState
            .subCategoryIdToProductData[selectedSubCategory.categoryId].results;
        responseModel.results = existingProducts + responseModel.results;
      }

      // We are maintaining a map subCategoryIdToProductData to cache the already loaded products list, to avoid unnecessary Api calls.
      // update the map data for respective subCategiry and then update the app state.
      Map<int, CatalogSearchResponse> updatedProductListMap =
          new Map.from(state.productState.subCategoryIdToProductData);
      updatedProductListMap[selectedSubCategory.categoryId] = responseModel;

      return state.copyWith(
        productState: state.productState.copyWith(
          subCategoryIdToProductData: updatedProductListMap,
        ),
      );
    }
  }

  @override
  void before() =>
      dispatch(UpdateLoadMoreStatus(true, selectedSubCategory.categoryId));

  @override
  void after() =>
      dispatch(UpdateLoadMoreStatus(false, selectedSubCategory.categoryId));
}

class GetAllProducts extends ReduxAction<AppState> {
  final String urlForNextPageResponse;

  GetAllProducts({this.urlForNextPageResponse});

  @override
  FutureOr<AppState> reduce() async {
    // If the call is not made for loadMore and the data has already loaded once
    // then no need to trigger the api again.
    if (urlForNextPageResponse == null &&
        state.productState.allProductsForMerchant != null) {
      return null;
    }

    var response = await APIManager.shared.request(
      url: urlForNextPageResponse == null
          ? ApiURL.getAllProducts(
              state.productState.selectedMerchant.businessId)
          : urlForNextPageResponse,
      params: null,
      requestType: RequestType.get,
    );

    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      final CatalogSearchResponse _responseModel =
          CatalogSearchResponse.fromJson(response.data);

      // Fetch the local cart items.
      final List<Product> _allCartItems =
          await CartDataSource.getListOfProducts();

      // check if any of these product items are already added in cart.
      // if yes updated the item count for the same.
      _responseModel.results.forEach((item) {
        item.selectedSkuIndex = 0;
        item.count = 0;
        _allCartItems.forEach((localCartItem) {
          if (item.productId == localCartItem.productId) {
            item.count = localCartItem.count;
          }
        });
      });

      // If action was triggered to load_more then append existingProducts in new data list.
      if (urlForNextPageResponse != null) {
        List<Product> existingProducts =
            state.productState.allProductsForMerchant.results;
        _responseModel.results = existingProducts + _responseModel.results;
      }

      return state.copyWith(
          productState: state.productState.copyWith(
        allProductsForMerchant: _responseModel,
      ));
    }
  }

  @override
  void before() => urlForNextPageResponse == null
      ? dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading))
      : dispatch(UpdateLoadMoreStatus(
          true,
          CustomCategoryForAllProducts().categoryId,
        ));

  @override
  void after() => urlForNextPageResponse == null
      ? dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success))
      : dispatch(UpdateLoadMoreStatus(
          false,
          CustomCategoryForAllProducts().categoryId,
        ));
}

class UpdateSelectedCategoryAction extends ReduxAction<AppState> {
  final CategoriesNew selectedCategory;

  UpdateSelectedCategoryAction({this.selectedCategory});

  @override
  FutureOr<AppState> reduce() {
    AppFirebaseAnalytics.instance
        .logSelectedCategory(itemCategory: selectedCategory.categoryName);
    return state.copyWith(
      productState: state.productState.copyWith(
        selectedCategory: selectedCategory,
      ),
    );
  }
}

class UpdateLoadMoreStatus extends ReduxAction<AppState> {
  final bool isLoadingMore;
  final int subCategoryId;

  UpdateLoadMoreStatus(this.isLoadingMore, this.subCategoryId);

  @override
  FutureOr<AppState> reduce() {
    // We are maintaining a map isLoadingMore , to remember which product lists are loading data at the same time
    Map<int, bool> updatedLoadingMoreMap =
        new Map.from(state.productState.isLoadingMore);
    updatedLoadingMoreMap[subCategoryId] = isLoadingMore;

    return state.copyWith(
      productState:
          state.productState.copyWith(isLoadingMore: updatedLoadingMoreMap),
    );
  }
}

class UpdateSelectedProductAction extends ReduxAction<AppState> {
  final Product selectedProduct;

  UpdateSelectedProductAction(this.selectedProduct);

  @override
  FutureOr<AppState> reduce() {
    AppFirebaseAnalytics.instance
        .logViewItem(itemName: selectedProduct.productName);
    return state.copyWith(
      productState: state.productState.copyWith(
        selectedProductForDetails: selectedProduct,
      ),
    );
  }
}

class GetProductDetailsByID extends ReduxAction<AppState> {
  final String productId;
  final String businessId;

  GetProductDetailsByID({@required this.productId, @required this.businessId});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
      url: ApiURL.getVideoDetails(businessId, productId),
      params: null,
      requestType: RequestType.get,
    );
    if (response.status == ResponseStatus.error404) {
      Fluttertoast.showToast(msg: 'Product Not Found');
      throw 'Something went wrong : ${response.data['message']}';
    } else if (response.status == ResponseStatus.error500) {
      Fluttertoast.showToast(msg: 'Something went wrong');
      throw 'Something went wrong : ${response.data['message']}';
    } else {
      Product responseModel = Product.fromJson(response.data);

      if (responseModel != null) {
        DynamicLinkService().isLinkPathValid = true;
        return state.copyWith(
          productState: state.productState.copyWith(
            selectedProductForDetails: responseModel,
          ),
        );
      }
    }
    return null;
  }

  @override
  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  @override
  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}
