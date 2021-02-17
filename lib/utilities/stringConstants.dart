enum ENVIRONMENT { DEVELOPMENT, PRODUCTION }

class StringConstants {
  /// This value is assigned by server in order to access the esamudaay APIs.
  /// Replace the value for thirdPartyId here.
  static const thirdPartyId = "5d730376-72ed-478c-8d5e-1a3a6aee9815";
  //

  /// Switch environment value here to define the development/production phase.
  /// for developement purpose, use ENVIRONMENT.DEVELOPMENT
  /// for production, use ENVIRONMENT.PRODUCTION
  static const ENVIRONMENT environmentVariable = ENVIRONMENT.DEVELOPMENT;

  // Shared Pref Key constants.
  static const tokenKey = 'token';
  static const skipKey = "skip";
  static const fcmToken = "fcm";
  static const userAddressKey = "address_esamuday";
  static const fromAccountKey = "fromAccount";

  // razorpay constants
  static const String razorpayDefaultName = "eSamudaay";
  static const int razorpayDefaultAmountInInt = 0;
  static const String razorpayDefaultCurrency = "INR";
  static const int razorpayDefaultTimeout = 60;

  // link sharing constants
  static const sharingLinkPrefix = 'https://esamudaay.page.link';
  static const packageName = 'com.esamudaay.customer';
  static const appStoreId = '1532727652';
  static final linkPreviewTitle = (String storeName) =>
      'Hello! You can now order online from $storeName using this link.';
  static const linkPreviewMessage =
      'You can pay online using GooglePay, PayTM, PhonePe, UPI apps or Cash on delivery.';
  static const esamudaayLogoUrl =
      'https://lh3.googleusercontent.com/b5-o56HDsZhnCfYavGxGcfZHmZp51AzbzXQXllZ19FlVyIwhMI9i0fFuTu_9oe1MYlQ=s180';

  static const List<String> addressTagList = ["Home", "Work", "Other"];

  static const List<String> placeDetailFields = [
    "address_component",
    "formatted_address",
    "geometry",
  ];

  static const customerRole = "CUSTOMER";
}
