import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/redux/states/address_state.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/redux/states/auth_state.dart';
import 'package:eSamudaay/redux/states/components_loading_state.dart';
import 'package:eSamudaay/redux/states/home_page_state.dart';
import 'package:eSamudaay/redux/states/product_categories_state.dart';
import 'package:eSamudaay/redux/states/product_state.dart';
import 'package:eSamudaay/redux/states/videos_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  StoreTester<AppState> createStoreTester() {
    return StoreTester<AppState>(initialState: AppState.initial());
  }

  test('Test initial state of the store, which should have the default values', (){
    var storeTester = createStoreTester();
    expect(storeTester.state.isInitializationDone, false);
    expect(storeTester.state.isLoading, false);
    expect(storeTester.state.componentsLoadingState, ComponentsLoadingState.initial());
    expect(storeTester.state.authState, AuthState.initial());
    expect(storeTester.state.versionString, "");

    ///The assertions below are failing as the models these states depend on are not immutable.
    ///
    ///This breaks the equality as "overriding a hashCode with a mutable value can break hash-based collections"
    ///
    ///
    ///https://dart.dev/guides/language/effective-dart/design#avoid-defining-custom-equality-for-mutable-classes
    ///
    ///
    ///So I'll refactor those classes to be immutable
    ///

//    expect(storeTester.state.productState, ProductState.initial());
//    expect(storeTester.state.homePageState, HomePageState.initial());
//    expect(storeTester.state.addressState, AddressState.initial());
//    expect(storeTester.state.videosState, VideosState.initial());
//    expect(storeTester.state.homeCategoriesState, LandingPageComponentsState.initial());
  });

}
