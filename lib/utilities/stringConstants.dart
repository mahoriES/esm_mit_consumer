const tokenKey = 'token';
const userKey = 'user';
const addressKey = 'address';
const skipKey = "skip";
const fcmToken = "fcm";
const userAddressKey = "address_esamuday";
//Errors
const emailError = "Email is not valid.";
const mobileNumberError = 'Mobile number is not valid.';
const firstNameError = 'Username is not valid.';
const lastNameError = 'Username is not valid.';
const errorMessage = "Enter a valid value.";

const password_error = "OTP should be at least 6 symbols long.";
const password_match_error = "Passwords are not match.";
const code_error = "Code is not valid.";

// URL's

const generateOtp = "";

const countryCode = "+91";

const thirdPartyId = "5d730376-72ed-478c-8d5e-1a3a6aee9815";

// The constants must be defined within a class, there is no need of global const.
// TODO : move the existing strings in StringConstants class .
class StringConstants {
  static const sharingLinkPrefix = 'https://esamudaay.page.link';
  static final businessSharingLinkUrl =
      ({String businessId}) => 'https://esamudaay.com?businessId=$businessId';
  static final productSharingLinkUrl = (
          {String productId, String businessId}) =>
      'https://esamudaay.com?businessId=$businessId&productId=$productId';
  static const packageName = 'com.esamudaay.customer';
  static const appStoreId = '1532727652';
  static final linkPreviewTitle = (String storeName) =>
      'Hello! You can now order online from $storeName using this link.';
  static const linkPreviewMessage =
      'You can pay online using GooglePay, PayTM, PhonePe, UPI apps or Cash on delivery.';
  static const esamudaayLogoUrl =
      'https://lh3.googleusercontent.com/b5-o56HDsZhnCfYavGxGcfZHmZp51AzbzXQXllZ19FlVyIwhMI9i0fFuTu_9oe1MYlQ=s180';

  static const List<String> addressTagList = ["Home", "Work", "Other"];
}
