import 'package:eSamudaay/redux/states/home_page_state.dart';
import 'package:eSamudaay/redux/states/product_categories_state.dart';
import 'package:eSamudaay/redux/states/product_state.dart';
import 'package:eSamudaay/redux/states/videos_state.dart';

import 'auth_state.dart';

class AppState {
  final bool isLoading;
  final AuthState authState;
  final HomePageState homePageState;
  final ProductState productState;
  final VideosState videosState;
  final LandingPageComponentsState homeCategoriesState;
  const AppState({
    this.authState,
    this.isLoading,
    this.homeCategoriesState,
    this.homePageState,
    this.productState,
    this.videosState,
  });

  static AppState fromJson(dynamic json) => AppState(
        isLoading: json == null ? false : json["isLoading"],
        authState: json == null ? AuthState.initial() : json['authState'],
      );

  dynamic toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isLoading'] = this.isLoading;
    data['authState'] = this.authState;
    return data;
  }

  factory AppState.initial() => AppState(
        authState: AuthState.initial(),
        isLoading: false,
        productState: ProductState.initial(),
        homePageState: HomePageState.initial(),
        videosState: VideosState.initial(),
        homeCategoriesState: LandingPageComponentsState.initial(),
      );

  AppState copyWith({
    AuthState authState,
    bool isLoading,
    HomePageState homePageState,
    ProductState productState,
    LandingPageComponentsState homeCategoriesState,
    VideosState videosState,
  }) {
    return AppState(
      productState: productState ?? this.productState,
      authState: authState ?? this.authState,
      isLoading: isLoading ?? this.isLoading,
      homeCategoriesState: homeCategoriesState ?? this.homeCategoriesState,
      homePageState: homePageState ?? this.homePageState,
      videosState: videosState ?? this.videosState,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          authState == other.authState &&
          homePageState == other.homePageState &&
          productState == other.productState &&
          videosState == other.videosState &&
          isLoading == other.isLoading;

  @override
  int get hashCode => authState.hashCode;
  @override
  String toString() {
    return '';
  }
}
