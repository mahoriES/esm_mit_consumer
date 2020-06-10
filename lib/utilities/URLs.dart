//Login

class ApiURL {
  static const developmentURL = "http://13.127.43.195/api/ChangePay/";
  static const liveURL = "https://sewer-viewer.com";
  static const baseURL = developmentURL;
  static const generateOTPUrl = "Customer/v4/Login";
  static const generateOtpRegisterUrl = "Customer/v4/RegisterNewCustomer";
  static const updateCustomerDetails =
      "Customer/v4/UpdateTemporaryCustomerDetails";

  static const getMerchantsUrl = "Customer/v4/merchantSearchEnhanced";
  static const bannerUrl = "Customer/v4/getLandingPageOffers";
  static const getCatalogUrl = "Customer/v4/getCatalog";
  static const placeOrderUrl = "Customer/v4/placeOrderAtMerchant";
  static const updateOrderUrl = "Customer/v4/updateOrders";
  static const getOrderTaxUrl = "Customer/v4/populateOrderCharges";
  static const getOrderListUrl = "Customer/v4/getOrders";
  static const getCategories = "Customer/v4/getCategories";
  static const searchURL = "Customer/v4/search";
  static const reviewOrderURL = "Review/addReview";
  static const supportURL = "Support/raiseSupportTicket";
  static const logoutURL = "Customer/v4/Logout";
  static const recommendStoreURL = "Customer/v4/recommendAStore";
  static const profileUpdateURL = "Customer/v4/updateDetails";
}
