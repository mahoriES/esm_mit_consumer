import 'package:flutter/cupertino.dart';

class ComponentsLoadingState {
  final bool videosLoading;
  final bool circleBannersLoading;
  final bool circleTopBannerLoading;
  final bool circleCategoriesLoading;
  final bool businessListLoading;
  final bool nearbyCirclesLoading;
  final bool businessesUnderCategoryLoading;

  ComponentsLoadingState(
      {@required this.videosLoading,
      @required this.circleBannersLoading,
      @required this.circleTopBannerLoading,
      @required this.businessesUnderCategoryLoading,
      @required this.circleCategoriesLoading,
      @required this.nearbyCirclesLoading,
      @required this.businessListLoading});

  factory ComponentsLoadingState.initial() {
    return ComponentsLoadingState(
        videosLoading: false,
        businessesUnderCategoryLoading: false,
        circleBannersLoading: false,
        circleTopBannerLoading: false,
        nearbyCirclesLoading: false,
        circleCategoriesLoading: false,
        businessListLoading: false);
  }

  ComponentsLoadingState copyWith(
      {bool videosLoading,
      bool circleBannersLoading,
      bool circleTopBannerLoading,
      bool circleCategoriesLoading,
      bool businessesUnderCategoryLoading,
      bool nearbyCirclesLoading,
      bool businessListLoading}) {
    return ComponentsLoadingState(
        businessesUnderCategoryLoading: businessesUnderCategoryLoading ??
            this.businessesUnderCategoryLoading,
        nearbyCirclesLoading: nearbyCirclesLoading ?? this.nearbyCirclesLoading,
        videosLoading: videosLoading ?? this.videosLoading,
        circleBannersLoading: circleBannersLoading ?? this.circleBannersLoading,
        circleTopBannerLoading:
            circleTopBannerLoading ?? this.circleTopBannerLoading,
        circleCategoriesLoading:
            circleCategoriesLoading ?? this.circleCategoriesLoading,
        businessListLoading: businessListLoading ?? this.businessListLoading);
  }
}
