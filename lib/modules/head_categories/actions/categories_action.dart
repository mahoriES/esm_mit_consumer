import 'dart:async';
import 'package:eSamudaay/modules/head_categories/models/main_categories_response.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GetHomePageCategoriesAction extends ReduxAction<AppState> {
  GetHomePageCategoriesAction();

  @override
  FutureOr<AppState> reduce() async {
    final response = await APIManager.shared.request(
        url: ApiURL.getHomePageCategoriesUrl(state.authState.cluster.clusterId),
        requestType: RequestType.get,
        params: null);

    if (response.status == ResponseStatus.success200) {
      if (response.data != null && response.data is Map) {
        final parsedCategoriesResponse =
            HomePageCategoriesResponse.fromJson(response.data);
        debugPrint(
            'Before putting in state ${parsedCategoriesResponse.catalogCategories.length}');
        return state.copyWith(
            homeCategoriesState: state.homeCategoriesState.copyWith(
          homePageCategories: parsedCategoriesResponse,
        ));
      }
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
    }
    return null;
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeCircleCategoriesLoadingAction(true));
    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeCircleCategoriesLoadingAction(false));
    super.after();
  }

}

class SelectHomePageCategoryAction extends ReduxAction<AppState> {
  final HomePageCategoryResponse selectedCategory;

  SelectHomePageCategoryAction({@required this.selectedCategory})
      : assert(selectedCategory != null);

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        homeCategoriesState: state.homeCategoriesState
            .copyWith(selectedCategory: selectedCategory));
  }
}

class ClearPreviousCategoryDetailsAction extends ReduxAction<AppState> {
  ClearPreviousCategoryDetailsAction();

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        homeCategoriesState: state.homeCategoriesState.copyWith(
            previouslyBoughtBusinessUnderSelectedCategory: [],
            businessesUnderSelectedCategory: []));
  }
}

class GetPreviouslyBoughtBusinessesListAction extends ReduxAction<AppState> {
  GetPreviouslyBoughtBusinessesListAction();

  @override
  FutureOr<AppState> reduce() async {
    final response = await APIManager.shared.request(
        url: ApiURL.getBusinessesUrl,
        requestType: RequestType.get,
        params: {
          "cluster_id": state.authState.cluster.clusterId,
          "ordered": true,
          "ag_orderitems": true,
        });
    if (response.status == ResponseStatus.success200) {
      if (response.data != null &&
          response.data is Map &&
          response.data['results'] != null &&
          response.data['results'] is List) {
        final List<Business> parsedPreviouslyBoughtBusinesses =
            (response.data['results'] as List).map((v) {
          return Business.fromJson(v);
        }).toList();
        return state.copyWith(
            homeCategoriesState: state.homeCategoriesState.copyWith(
          previouslyBoughtBusinesses: parsedPreviouslyBoughtBusinesses,
        ));
      }
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
    }
    return null;
  }
}

class GetPreviouslyBoughtBusinessesListUnderSelectedCategoryAction
    extends ReduxAction<AppState> {
  final String categoryId;

  GetPreviouslyBoughtBusinessesListUnderSelectedCategoryAction(
      {@required this.categoryId})
      : assert(categoryId != null);

  @override
  FutureOr<AppState> reduce() async {
    final response = await APIManager.shared.request(
        url: ApiURL.getBusinessesUrl,
        requestType: RequestType.get,
        params: {
          "cluster_id": state.authState.cluster.clusterId,
          "ordered": true,
          "ag_orderitems": true,
          "bcat_id": categoryId
        });
    if (response.status == ResponseStatus.success200) {
      if (response.data != null &&
          response.data is Map &&
          response.data['results'] != null &&
          response.data['results'] is List) {
        final List<Business>
            parsedPreviouslyBoughtBusinessesUnderSelectedCategory =
            (response.data['results'] as List).map((v) {
          return Business.fromJson(v);
        }).toList();
        return state.copyWith(
            homeCategoriesState: state.homeCategoriesState.copyWith(
          previouslyBoughtBusinessUnderSelectedCategory:
              parsedPreviouslyBoughtBusinessesUnderSelectedCategory,
        ));
      }
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
    }
    return null;
  }
}

class GetBusinessesUnderSelectedCategory extends ReduxAction<AppState> {
  final String categoryId;
  final String getBusinessesUrl;

  GetBusinessesUnderSelectedCategory(
      {@required this.categoryId, @required this.getBusinessesUrl})
      : assert(categoryId != null),
        assert(getBusinessesUrl != null);

  @override
  FutureOr<AppState> reduce() async {
    final response = await APIManager.shared.request(
        url: ApiURL.getBusinessesUrl,
        requestType: RequestType.get,
        params: {
          "bcat": categoryId,
          "cluster_id": state.authState.cluster.clusterId
        });
    final businessesResponse = GetBusinessesResponse.fromJson(response.data);
    if (response.status == ResponseStatus.success200) {
      if (response.data != null &&
          response.data is Map &&
          response.data['results'] != null &&
          response.data['results'] is List) {
        final List<Business> businessesUnderSelectedCategory =
            (response.data['results'] as List).map((v) {
          return Business.fromJson(v);
        }).toList();

        if (getBusinessesUrl != ApiURL.getBusinessesUrl &&
            state.homeCategoriesState.businessesUnderSelectedCategory
                .isNotEmpty) {
          final List<Business> previousBusinesses = List.from(
              state.homeCategoriesState.businessesUnderSelectedCategory);
          final List<Business> joinedListOfBusinesses =
              previousBusinesses + businessesUnderSelectedCategory;
          return state.copyWith(
            homeCategoriesState: state.homeCategoriesState.copyWith(
              businessesUnderSelectedCategory: joinedListOfBusinesses,
              currentBusinessResponse: businessesResponse,
            ),
          );
        }
        return state.copyWith(
          homeCategoriesState: state.homeCategoriesState.copyWith(
            businessesUnderSelectedCategory: businessesUnderSelectedCategory,
            currentBusinessResponse: businessesResponse,
          ),
        );
      }
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
    }
    return null;
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeBusinessUnderCategoryLoadingAction(true));
    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeBusinessUnderCategoryLoadingAction(false));
    super.after();
  }

}

class ChangeVideoFeedLoadingAction extends ReduxAction<AppState> {
  final bool value;

  ChangeVideoFeedLoadingAction(this.value);

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      componentsLoadingState: state.componentsLoadingState.copyWith(
        videosLoading: value,
      ),
    );
  }
}

class ChangeBusinessListLoadingAction extends ReduxAction<AppState> {
  final bool value;

  ChangeBusinessListLoadingAction(this.value);

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      componentsLoadingState: state.componentsLoadingState.copyWith(
        businessListLoading: value,
      ),
    );
  }
}

class ChangeCircleBannersLoadingAction extends ReduxAction<AppState> {
  final bool value;

  ChangeCircleBannersLoadingAction(this.value);

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      componentsLoadingState: state.componentsLoadingState.copyWith(
        circleBannersLoading: value,
      ),
    );
  }
}

class ChangeCircleTopBannerLoadingAction extends ReduxAction<AppState> {
  final bool value;

  ChangeCircleTopBannerLoadingAction(this.value);

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      componentsLoadingState: state.componentsLoadingState.copyWith(
        circleTopBannerLoading: value,
      ),
    );
  }
}

class ChangeCircleCategoriesLoadingAction extends ReduxAction<AppState> {
  final bool value;

  ChangeCircleCategoriesLoadingAction(this.value);

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      componentsLoadingState: state.componentsLoadingState.copyWith(
        circleCategoriesLoading: value,
      ),
    );
  }
}

class ChangeNearbyCircleLoadingAction extends ReduxAction<AppState> {
  final bool value;

  ChangeNearbyCircleLoadingAction(this.value);

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      componentsLoadingState: state.componentsLoadingState.copyWith(
        nearbyCirclesLoading: value,
      ),
    );
  }
}

class ChangeBusinessUnderCategoryLoadingAction extends ReduxAction<AppState> {

  final bool value;

  ChangeBusinessUnderCategoryLoadingAction(this.value);

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      componentsLoadingState: state.componentsLoadingState.copyWith(
        businessesUnderCategoryLoading: value,
      ),
    );
  }
}