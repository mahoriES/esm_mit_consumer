enum ENVIRONMENT { DEVELOPMENT, PRODUCTION }

class StringConstants {
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
