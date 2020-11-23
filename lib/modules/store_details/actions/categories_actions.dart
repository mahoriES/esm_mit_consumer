import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/home/models/video_feed_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/modules/store_details/models/categories_models.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class GetCategoriesDetailsAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url:
            "api/v1/businesses/${state.productState.selectedMerchant.businessId}/catalog/categories",
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

class RemoveCategoryAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        productState: state.productState.copyWith(
      categories: [],
    ));
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
    } else {
      Fluttertoast.showToast(msg: response.data['status']);
    }

    return state.copyWith(authState: state.authState.copyWith());
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
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
        url: ApiURL.getBusinessesUrl + businessId + "/catalog/products",
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
      url: ApiURL.getBusinessesUrl + "/$businessId/bookmark",
      params: null,
      requestType: RequestType.post,
    );
    debugPrint('For succes bookmark this is the code ${response.status}');
    if (response.status == ResponseStatus.success200) {
      debugPrint('Just got 200 now will change the status of bookmark');
      Business selectedMerchant = state.productState.selectedMerchant;
      debugPrint('Before setting this to true');
      selectedMerchant.isBookmarked = true;
      debugPrint('After setting this to true');
      return state.copyWith(
        productState: state.productState.copyWith(
            selectedMerchant: selectedMerchant
        ),
      );
    }
    return null;
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));

}

class UnBookmarkBusinessAction extends ReduxAction<AppState> {

  final String businessId;

  UnBookmarkBusinessAction({@required this.businessId});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
      url: ApiURL.getBusinessesUrl + "/$businessId/bookmark",
      params: null,
      requestType: RequestType.delete,
    );

    if (response.status == ResponseStatus.success200) {
      Business selectedMerchant = state.productState.selectedMerchant;
      selectedMerchant.isBookmarked = false;
      return state.copyWith(
        productState: state.productState.copyWith(
          selectedMerchant: selectedMerchant
        ),
      );
    }
    return null;
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));

}