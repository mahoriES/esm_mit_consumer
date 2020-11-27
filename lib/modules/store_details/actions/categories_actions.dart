import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/home/models/video_feed_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

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

      if (responseModel.categories.length <= 1) {
        await dispatchFuture(GetProductsForJustOneCategoryAction());
        return state.copyWith(
            productState: state.productState.copyWith(
          categories: responseModel.categories,
        ));
      }
      return state.copyWith(
          productState: state.productState.copyWith(
        singleCategoryFewProducts: [],
        categories: responseModel.categories,
      ));
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

class GetBusinessVideosAction extends ReduxAction<AppState> {
  final String businessId;

  GetBusinessVideosAction({@required this.businessId});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
      url: ApiURL.getVideoFeed,
      params: {
        "circle_id": state.authState.cluster.clusterId,
        "business_id": businessId
      },
      requestType: RequestType.get,
    );

    if (response.status == ResponseStatus.success200) {
      VideoFeedResponse responseModel =
          VideoFeedResponse.fromJson(response.data);

      return state.copyWith(
        productState: state.productState.copyWith(
          videosResponse: responseModel,
        ),
      );
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
    }
    return null;
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}

class GetBusinessSpotlightItems extends ReduxAction<AppState> {
  final String businessId;

  GetBusinessSpotlightItems({@required this.businessId});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.getProductsListUrl(businessId),
        params: {"spotlight": true},
        requestType: RequestType.get);

    if (response.status == ResponseStatus.success200) {
      var responseModel = CatalogSearchResponse.fromJson(response.data);
      var items = responseModel.results;

      ///Preparing a list of products from the fetched items and initialising
      ///the selected quantity for each [product] to zero.
      var products = items.map((item) {
        item.count = 0;
        item.selectedVariant = 0;
        return item;
      }).toList();

      return state.copyWith(
          productState: state.productState.copyWith(spotlightItems: products));
    } else {
      Fluttertoast.showToast(msg: response.data['status']);
    }
    return null;
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}

class BookmarkBusinessAction extends ReduxAction<AppState> {
  final String businessId;

  BookmarkBusinessAction({@required this.businessId});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
      url: ApiURL.getBookmarkBusinessUrl(businessId),
      params: null,
      requestType: RequestType.post,
    );
    if (response.status == ResponseStatus.success200) {
      Business copiedMerchantFromState =
          Business.clone(state.productState.selectedMerchant);
      copiedMerchantFromState.isBookmarked = true;

      List<Business> updatedHomeMerchants = [];
      for (final index
          in Iterable<int>.generate(state.homePageState.merchants.length)
              .toList()) {
        if (index ==
            state.homePageState.merchants
                .indexOf(state.productState.selectedMerchant))
          updatedHomeMerchants.add(copiedMerchantFromState);
        else
          updatedHomeMerchants.add(state.homePageState.merchants[index]);
      }

      return state.copyWith(
        homePageState:
            state.homePageState.copyWith(merchants: updatedHomeMerchants),
        productState: state.productState
            .copyWith(selectedMerchant: copiedMerchantFromState),
      );
    } else {
      Fluttertoast.showToast(msg: response.data['status']);
    }
    return null;
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}

// TODO : merge this action with GetAllProducts.
class GetProductsForJustOneCategoryAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    String businessId = state.productState.selectedMerchant.businessId;
    var response = await APIManager.shared.request(
      params: null,
      requestType: RequestType.get,
      url: ApiURL.getProductsListUrl(businessId),
    );

    if (response.status == ResponseStatus.success200) {
      var responseModel = CatalogSearchResponse.fromJson(response.data);
      List<Product> firstFiveProducts = [];
      if (responseModel.results.isNotEmpty) {
        firstFiveProducts = responseModel.results
            .getRange(
                0,
                responseModel.results.length < 5
                    ? responseModel.results.length
                    : 5)
            .toList();
      }

      ///Preparing a list of first few products for the single category from the fetched items and initialising
      ///the selected quantity for each [product] to zero.
      var preparedProductsForSingleCategory = firstFiveProducts.map((item) {
        item.count = 0;
        return item;
      }).toList();

      ///Getting the list of all items currently persisted in the local cart
      ///data source, since products might have been already added to cart by customer
      List<Product> allCartItems = await CartDataSource.getListOfCartWith();

      ///Initialising the selected SKU for each product (in the fetched product
      ///list) and if the item has already been added to the local cart, then
      ///updating it's quantity to that in the local cart.
      preparedProductsForSingleCategory.forEach((item) {
        item.selectedVariant = 0;
        allCartItems.forEach((localCartItem) {
          if (item.productId == localCartItem.productId) {
            item.count = localCartItem.count;
          }
        });
      });

      return state.copyWith(
          productState: state.productState.copyWith(
        singleCategoryFewProducts: preparedProductsForSingleCategory,
      ));
    } else {
      Fluttertoast.showToast(msg: response.data['status']);
    }
    return null;
  }
}

class UnBookmarkBusinessAction extends ReduxAction<AppState> {
  final String businessId;

  UnBookmarkBusinessAction({@required this.businessId});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
      url: ApiURL.getBookmarkBusinessUrl(businessId),
      params: null,
      requestType: RequestType.delete,
    );

    if (response.status == ResponseStatus.success200) {
      Business copiedMerchantFromState =
          Business.clone(state.productState.selectedMerchant);
      copiedMerchantFromState.isBookmarked = false;

      List<Business> updatedHomeMerchants = [];
      for (final index
          in Iterable<int>.generate(state.homePageState.merchants.length)
              .toList()) {
        if (index ==
            state.homePageState.merchants
                .indexOf(state.productState.selectedMerchant))
          updatedHomeMerchants.add(copiedMerchantFromState);
        else
          updatedHomeMerchants.add(state.homePageState.merchants[index]);
      }

      return state.copyWith(
        homePageState:
            state.homePageState.copyWith(merchants: updatedHomeMerchants),
        productState: state.productState
            .copyWith(selectedMerchant: copiedMerchantFromState),
      );
    } else {
      Fluttertoast.showToast(msg: response.data['status']);
    }
    return null;
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}
