import 'package:eSamudaay/utilities/environment_config.dart';
import 'package:flutter/material.dart';

class ApiURL {
  static const eSamudayDevelopmentURL = "https://api.test.esamudaay.com/";
  static const liveURL = "https://api.esamudaay.com/";

  static final baseURL = EnvironmentConfig.isProductionEnvironment
      ? liveURL
      : eSamudayDevelopmentURL;

  static const generateOTPUrl = "api/v1/auth/token/";
  static const generateOtpRegisterUrl = "api/v1/auth/user/";
  static const updateCustomerDetails = "api/v1/auth/profiles";
  static const addressUrl = "api/v1/addresses/";
  static const getBusinessesUrl = "api/v1/businesses/";
  static final getStoreStatusUrl =
      (String businessId) => "api/v1/businesses/$businessId/open";

  static final getChargesUrl =
      (String businessId) => "api/v1/businesses/$businessId/charges";

  static const bannerUrl = "Customer/v4/getLandingPageOffers";
  static const getCatalogUrl = "Customer/v4/getCatalog";
  static const placeOrderUrl = "api/v1/orders/";
  static const updateOrderUrl = "Customer/v4/updateOrders";
  static const getOrderTaxUrl = "Customer/v4/populateOrderCharges";
  static const getOrderListUrl = "Customer/v4/getOrders";

  static const searchURL = "Customer/v4/search";
  static const reviewOrderURL = "Review/addReview";
  static const supportURL = "Support/raiseSupportTicket";
  static const logoutURL = "Customer/v4/Logout";
  static const recommendStoreURL = "Customer/v4/recommendAStore";
  static const profileUpdateURL = "/api/v1/auth/profiles";
  static const getClustersUrl = "api/v1/clusters/";
  static const addFCMTokenUrl = "api/v1/notifications/mobile/tokens";
  static final imageUpload = "$baseURL" + "api/v1/media/photo/";
  static final getVideoFeed = baseURL + 'api/v1/feed/';
  static final getVideoDetails = (String businessId, String productId) =>
      baseURL + "api/v1/businesses/$businessId/catalog/products/$productId";
  static final getAllProducts = (String businessId) =>
      baseURL + "api/v1/businesses/$businessId/catalog/products";
  static final getCategories =
      (String businessId) => "api/v1/businesses/$businessId/catalog/categories";
  static final getProductsForSubcategory = (
          {@required String businessId, @required String subCategoryId}) =>
      "api/v1/businesses/$businessId/catalog/categories/$subCategoryId/products";

  // TODO : this one is duplicated.
  static final getProductsListUrl = (String businessId) =>
      baseURL + getBusinessesUrl + businessId + "/catalog/products";
  static final getBookmarkBusinessUrl = (String businessId) =>
      baseURL + getBusinessesUrl + "$businessId/bookmark";
  static final Function(String) getHomePageCategoriesUrl =
      (String circleId) => baseURL + getClustersUrl + "$circleId/categories";
  static final Function(String) getBannersUrl =
      (String circleId) => baseURL + getClustersUrl + circleId + "/banners";
  static final Function(String) getBannersV2Url =
      (String circleId) => baseURL + "api/v2/clusters/$circleId/banners";
  static final deleteAddressUrl =
      (String addressId) => "api/v1/addresses/$addressId";
  static final rateOrderUrl =
      (String orderId) => "$placeOrderUrl$orderId/rating";
  static final cancelOrderUrl =
      (String orderId) => "$placeOrderUrl$orderId/cancel";
  static final acceptOrderUrl =
      (String orderId) => "$placeOrderUrl$orderId/accept";
  static final completeOrderUrl =
      (String orderId) => "$placeOrderUrl$orderId/complete";
  static final getRazorpayOrderIdUrl =
      (String orderId) => baseURL + placeOrderUrl + orderId + "/razorpay";

  static final openMapUrl = (double latitude, double longitude) =>
      "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

  static final businessSharingLinkUrl =
      ({String businessId}) => 'https://esamudaay.com?businessId=$businessId';
  static final productSharingLinkUrl = (
          {String productId, String businessId}) =>
      'https://esamudaay.com?businessId=$businessId&productId=$productId';

  static final initiatePaymentUrl =
      (String orderId) => "api/v1/orders/$orderId/payment";
}
