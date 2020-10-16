import 'package:eSamudaay/modules/About/view/about_view.dart';
import 'package:eSamudaay/modules/Profile/views/profile_view.dart';
import 'package:eSamudaay/modules/accounts/views/accounts_view.dart';
import 'package:eSamudaay/modules/accounts/views/recommended_shop.dart';
import 'package:eSamudaay/modules/cart/views/cart_view.dart';
import 'package:eSamudaay/modules/catalog_search/views/product_search_view.dart';
import 'package:eSamudaay/modules/circles/views/circle_picker_screen.dart';
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
import 'package:eSamudaay/modules/store_details/views/store_categories_details_view.dart';
import 'package:eSamudaay/modules/store_details/views/store_product_listing_view.dart';
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
      "/StoreProductListingView": (BuildContext context) =>
          StoreProductListingView(),
      "/ProductSearchView": (BuildContext context) => ProductSearchView(),
      "/OrdersView": (BuildContext context) => OrdersView(),
      "/SMAlertView": (BuildContext context) => SMAlertView(),
      "/Support": (BuildContext context) => Support(),
      "/RecommendShop": (BuildContext context) => RecommendedShop(),
      "/profile": (BuildContext context) => ProfileView(),
      "/about": (BuildContext context) => AboutView(),
      "/onBoarding": (BuildContext context) => OnboardingWidget(),
      "/payment": (BuildContext context) => Payments(),
      "/circles": (BuildContext context) => CirclePicker(),
      "/productSearch": (BuildContext context) => MerchantProductsSearchView(),
      '/videoPlayer': (BuildContext context) => VideoPlayerScreen(),
    };
  }
}
