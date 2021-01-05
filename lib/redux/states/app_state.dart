import 'package:eSamudaay/redux/states/components_loading_state.dart';
import 'package:eSamudaay/redux/states/address_state.dart';
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
  final ComponentsLoadingState componentsLoadingState;
  final AddressState addressState;
  final String versionString;
  final bool isInitializationDone;

  const AppState({
    this.authState,
    this.isLoading,
    this.isInitializationDone,
    this.componentsLoadingState,
    this.homeCategoriesState,
    this.homePageState,
    this.productState,
    this.videosState,
    this.addressState,
    this.versionString,
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
        isInitializationDone: false,
        componentsLoadingState: ComponentsLoadingState.initial(),
        productState: ProductState.initial(),
        homePageState: HomePageState.initial(),
        videosState: VideosState.initial(),
        homeCategoriesState: LandingPageComponentsState.initial(),
        addressState: AddressState.initial(),
        versionString: "",
      );

  AppState copyWith({
    AuthState authState,
    bool isInitializationDone,
    ComponentsLoadingState componentsLoadingState,
    bool isLoading,
    HomePageState homePageState,
    ProductState productState,
    LandingPageComponentsState homeCategoriesState,
    VideosState videosState,
    AddressState addressState,
    String versionString,
  }) {
    return AppState(
      isInitializationDone: isInitializationDone ?? this.isInitializationDone,
      productState: productState ?? this.productState,
      authState: authState ?? this.authState,
      componentsLoadingState:
          componentsLoadingState ?? this.componentsLoadingState,
      isLoading: isLoading ?? this.isLoading,
      homeCategoriesState: homeCategoriesState ?? this.homeCategoriesState,
      homePageState: homePageState ?? this.homePageState,
      videosState: videosState ?? this.videosState,
      addressState: addressState ?? this.addressState,
      versionString: versionString ?? this.versionString,
    );
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          authState == other.authState &&
          homePageState == other.homePageState &&
          productState == other.productState &&
          videosState == other.videosState &&
          homeCategoriesState == other.homeCategoriesState &&
          componentsLoadingState == other.componentsLoadingState &&
          addressState == other.addressState &&
          versionString == other.versionString &&
          isInitializationDone == other.isInitializationDone;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      authState.hashCode ^
      homePageState.hashCode ^
      productState.hashCode ^
      videosState.hashCode ^
      homeCategoriesState.hashCode ^
      componentsLoadingState.hashCode ^
      addressState.hashCode ^
      versionString.hashCode ^
      isInitializationDone.hashCode;

  @override
  String toString() {
    return '';
  }
}
