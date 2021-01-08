import 'package:eSamudaay/modules/orders/models/order_models.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

///
///This is a utility class for performing all operations related to Razorpay. It is a
///singleton class.
///
class RazorpayUtility {
  ///Singleton which is null initially, but holds an instance of this class when
  ///invoked for the first time
  ///
  static RazorpayUtility _instance;

  ///A static variable which holds instance of [Razorpay] class. Initialised when
  ///this class is initialised.
  ///All Razorpay related operations are performed using this variable.
  ///
  static Razorpay _razorpay;

  ///This method is invoked only ONCE when [_instance] is null.
  ///
  RazorpayUtility._internal() {
    ///Assigning an instance of the [Razorpay] class to the top-level variable
    ///
    _razorpay = Razorpay();

    ///Specifying the handler for the Payment Successful Event
    ///
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);

    ///Specifying the handler for the Payment Failed / Payment related error Event
    ///
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentFailure);

    ///Specifying the handler for the Payment made via External Wallet (viz. PayTM, OlaMoney etc.)
    ///Event
    ///
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    ///Assigning instance of this class to the private instance variable
    ///
    _instance = this;
  }

  ///
  ///Factory constructor to get the singleton instance for this class
  ///
  factory RazorpayUtility() => _instance ?? RazorpayUtility._internal();

  ///
  ///When making payment, this method is invoked. It shall launch an embedded web view, and the
  ///payment process is delegated off to Razorpay. When performing checkout a Map<String, dynamic> of the
  ///options must be provided.
  ///This is obtained from the backend and held by the [RazorpayCheckoutOptions] class
  ///
  void checkout(Map<String, dynamic> options) {
    try {
      ///
      /// This shall launch the Razorpay checkout flow and the exection is delegated to Razorpay
      /// Upon completion, we get a response, depending on how the transaction went.
      ///
      _razorpay.open(options ??
          {
            'key': 'rzp_test_HEfHoaeCTIXx8m',
            'amount': 50000,
            'currency': 'INR',
            'order_id': 'order_GM6XNMa0Bys9IU',
            'name': 'Kaustubh',
            'description': 'Payment for order',
            'prefill': {
              'contact': '9540651948',
              'email': 'kaustubh@esamudaay.com'
            },
            'external': {
              'wallets': ['paytm']
            }
          });
    } catch (exception, stackTrace) {
      /// It is essential to record the error and send off the Crashlytics if the razorpay checkout
      /// option fails. This essentially happens due to a bug or server error.
      ///
      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: exception, stack: stackTrace));
    }
  }

  ///Handles the payment success event.
  void _handlePaymentSuccess(PaymentSuccessResponse paymentSuccessResponse) {
    debugPrint('Payment was successful! ${paymentSuccessResponse.paymentId}');
    Fluttertoast.showToast(msg: 'Payment Successful!');
  }

  ///Handle payment failure event.
  void _handlePaymentFailure(PaymentFailureResponse paymentFailureResponse) {
    debugPrint('Payment failed');
    _handleSpecificError(
        paymentFailureResponse.code, paymentFailureResponse.message);
  }

  ///
  ///Handle payment made via external wallet.
  ///NOTE - Razorpay doesn't provide much info with the [ExternalWalletResponse],
  ///we only have access to the wallet name. More details are provided via Webhook
  ///to the backend
  ///
  void _handleExternalWallet(ExternalWalletResponse externalWalletResponse) {
    Fluttertoast.showToast(msg: externalWalletResponse.walletName);
  }

  ///This function handles the [PaymentFailureResponse] from Razorpay at a more
  ///granular level.
  ///Depending on the error type following actions are performed:
  ///   i) Show a toast to the user if required
  ///   ii) Log the error in the [FirebaseCrashlytics] with stringified error message
  ///
  /// This may be extended further to execute a callback or similar handling may be
  /// included if required
  ///
  void _handleSpecificError(int errorCode, String errorMsg) {
    switch (errorCode) {

      /// This error would occur very rarely. But it means something serious went wrong!
      /// This basically means that we don't exactly know what caused the failure.
      /// We, record this error in Crashlytics and also show a toast to the user.
      ///
      case Razorpay.UNKNOWN_ERROR:
        _recordErrorInCrashlytics(
            "An unknown error occured. Details -> $errorMsg");
        Fluttertoast.showToast(msg: 'Unknown Error');
        break;

      /// This error indicates a code-level error.
      ///
      /// We, record this error in Crashlytics and also show a toast to the user.
      ///
      case Razorpay.INCOMPATIBLE_PLUGIN:
        _recordErrorInCrashlytics(
            "There is some error with compatibility of the plugin. Details -> $errorMsg");
        Fluttertoast.showToast(msg: 'Incompatible Plugin');
        break;

      /// This essentially indicates that there was some connectivity issue which led to failure
      /// Multiple reasons may lead to this sort of failure... Connectivity issues with Razorpay,
      /// Backend related issues, but commonly due to connectivity issues on the client side
      ///
      /// We, record this error in Crashlytics and also show a toast to the user.
      ///
      case Razorpay.NETWORK_ERROR:
        Fluttertoast.showToast(msg: 'Network Error');
        break;

      /// Will be encountered only due to issues on the client side.
      /// This essentially indicated that the client device doesn't support TLS connection, hence
      /// Razorpay checkout won't work as it happens over a secure channel
      ///
      /// We, record this error in Crashlytics and also show a toast to the user.
      ///
      case Razorpay.TLS_ERROR:
        _recordErrorInCrashlytics(
            "User's device does not support secure payments over secure TLS layer. Details -> $errorMsg");
        Fluttertoast.showToast(msg: 'Secure payments not supported');
        break;

      /// The checkout options (A HashMap object containing the amount, name, key, order_id etc.) provided
      /// is not valid hence checkout will not be possible.
      ///
      /// We, record this error in Crashlytics and also show a toast to the user.
      ///
      case Razorpay.INVALID_OPTIONS:
        _recordErrorInCrashlytics(
            "The checkout options provided is invalid. Commonly this happens due to passing an orderId which already has a successful transaction associated. Details -> $errorMsg");
        Fluttertoast.showToast(msg: 'Invalid Options');
        break;

      /// The payment was cancelled by the user. Either the user pressed back button on tapped the
      /// "X" icon on the Razorpay checkout screen
      ///
      /// Since this a voluntary action we simply let the user know about the same via a toast
      ///
      case Razorpay.PAYMENT_CANCELLED:
        Fluttertoast.showToast(msg: 'Payment Cancelled');
        break;
    }
  }

  /// This function submits a Crashlytics report of the error / issue encountered.
  /// The Exception to be logged is formed using the message String passed.
  /// Moreover, the current stacktrace is also recorded for more investigation.
  void _recordErrorInCrashlytics(String message) {
    FirebaseCrashlytics.instance
        .recordError(Exception([message]), StackTrace.current);
  }

  ///
  /// Called on the singleton [Razorpay] instance to clear all the event listeners
  /// added in the initialisation method.
  ///
  static void clear() {
    _razorpay.clear();
  }
}
