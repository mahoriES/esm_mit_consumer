import 'package:eSamudaay/modules/About/view/about_view.dart';
import 'package:eSamudaay/modules/Profile/views/profile_view.dart';
import 'package:eSamudaay/modules/accounts/views/accounts_view.dart';
import 'package:eSamudaay/modules/address/view/add_new_address_view.dart/add_new_address_view.dart';
import 'package:eSamudaay/modules/address/view/change_address_view/manage_address_view.dart';
import 'package:eSamudaay/modules/address/view/search_view/search_view.dart';
import 'package:eSamudaay/modules/cart/views/cart_view.dart';
import 'package:eSamudaay/modules/catalog_search/views/product_search_view.dart';
import 'package:eSamudaay/modules/circles/views/circle_picker_screen.dart';
import 'package:eSamudaay/modules/circles/views/circle_picker_view.dart';
import 'package:eSamudaay/modules/head_categories/views/main_categories_view.dart';
import 'package:eSamudaay/modules/home/views/my_home.dart';
import 'package:eSamudaay/modules/home/views/video_player_screen.dart';
import 'package:eSamudaay/modules/language/view/language_view.dart';
import 'package:eSamudaay/modules/login/views/login_View.dart';
import 'package:eSamudaay/modules/onBoardingScreens/widgets/on_boarding_screen.dart';
import 'package:eSamudaay/modules/orders/views/orders_View.dart';
import 'package:eSamudaay/modules/orders/views/payments.dart';
import 'package:eSamudaay/modules/orders/views/support.dart';
import 'package:eSamudaay/modules/otp/view/otp_view.dart';
import 'package:eSamudaay/modules/register/view/register_view.dart';
import 'package:eSamudaay/modules/search/views/Search_View.dart';
import 'package:eSamudaay/modules/store_details/views/product_catalog_view/product_catalog.dart';
import 'package:eSamudaay/modules/store_details/views/product_details_view/product_details_view.dart';
import 'package:eSamudaay/modules/store_details/views/store_details_view/store_categories_details_view.dart';
import 'package:eSamudaay/presentations/alert.dart';
import 'package:flutter/material.dart';

class SetupRoutes {
  static Map<String, WidgetBuilder> get routes {
    return {
      "/loginView": (BuildContext context) => new LoginView(),
      "/language": (BuildContext context) => new LanguageScreen(),
      "/otpScreen": (BuildContext context) => new OtpScreen(),
      "/mobileNumber": (BuildContext context) => new LoginView(),
      "/registration": (BuildContext context) => new Registration(),
      "/myHomeView": (BuildContext context) => new MyHomeView(),
      "/CartView": (BuildContext context) => CartView(),
      "/AccountsView": (BuildContext context) => AccountsView(),
      "/StoreDetailsView": (BuildContext context) => StoreDetailsView(),
      RouteNames.PRODUCT_CATALOGUE: (BuildContext context) =>
          ProductCatalogView(),
      "/ProductSearchView": (BuildContext context) => ProductSearchView(),
      "/OrdersView": (BuildContext context) => OrdersView(),
      "/SMAlertView": (BuildContext context) => SMAlertView(),
      "/Support": (BuildContext context) => Support(),
      "/profile": (BuildContext context) => ProfileView(),
      "/about": (BuildContext context) => AboutView(),
      "/onBoarding": (BuildContext context) => OnboardingWidget(),
      "/payment": (BuildContext context) => Payments(),
      "/circles": (BuildContext context) => CirclePicker(),
      RouteNames.PRODUCT_SEARCH: (BuildContext context) =>
          MerchantProductsSearchView(),
      RouteNames.PRODUCT_DETAILS: (BuildContext context) =>
          ProductDetailsView(),
      '/videoPlayer': (BuildContext context) => VideoPlayerScreen(),
      RouteNames.CATEGORY_BUSINESSES: (BuildContext context) =>
          const BusinessesListUnderSelectedCategoryScreen(),
      RouteNames.CHANGE_ADDRESS: (BuildContext context) => ChangeAddressView(),
      RouteNames.ADD_NEW_ADDRESS: (BuildContext context) => AddNewAddressView(),
      RouteNames.SEARCH_ADDRESS: (BuildContext context) => SearchAddressView(),
      RouteNames.CIRCLE_PICKER: (BuildContext context) => const CirclePickerView(),
    };
  }
}

// Creating a new class tp contain the route names as constant string variable.
// this makes it easier to use various route names in diffrent files.
// Haven't changed the existing routenames yet, but let's use this utility to create new screens from now on.
class RouteNames {
  static const PRODUCT_DETAILS = "/productDeails";
  static const PRODUCT_CATALOGUE = "/StoreProductListingView";
  static const PRODUCT_SEARCH = "/productSearch";
  static const CATEGORY_BUSINESSES = '/businessUnderCategory';
  static const CHANGE_ADDRESS = "/changeAddress";
  static const ADD_NEW_ADDRESS = "/addNewAddress";
  static const SEARCH_ADDRESS = "/searchAddress";
  static const CIRCLE_PICKER = "/circlePicker";
}
