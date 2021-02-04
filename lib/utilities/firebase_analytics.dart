import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:firebase_analytics_platform_interface/firebase_analytics_platform_interface.dart';

/// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html
const List<String> _reservedEventNames = <String>[
  'ad_activeview',
  'ad_click',
  'ad_exposure',
  'ad_impression',
  'ad_query',
  'adunit_exposure',
  'app_clear_data',
  'app_uninstall',
  'app_update',
  'error',
  'first_open',
  'first_visit',
  'in_app_purchase',
  'notification_dismiss',
  'notification_foreground',
  'notification_open',
  'notification_receive',
  'os_update',
  'screen_view',
  'session_start',
  'user_engagement',
];

class AppFirebaseAnalytics {
  final _platformInstance = FirebaseAnalyticsPlatform.instance;

  static AppFirebaseAnalytics get instance => AppFirebaseAnalytics();

  Future<void> logEvent(
      {@required String name, Map<String, dynamic> parameters}) async {
    if (_reservedEventNames.contains(name)) {
      throw ArgumentError.value(
          name, 'name', 'Event name is reserved and cannot be used');
    }

    const String kReservedPrefix = 'firebase_';

    if (name.startsWith(kReservedPrefix)) {
      throw ArgumentError.value(name, 'name',
          'Prefix "$kReservedPrefix" is reserved and cannot be used.');
    }

    await _platformInstance.logEvent(name: name, parameters: parameters);
    debugPrint('Logged the event $name!');
  }

  Future<void> logAppLogout({String user}) {
    return logEvent(name: 'app_logout', parameters: {'user': user});
  }

  Future<void> logAppLogin({String user}) {
    return logEvent(name: 'app_login', parameters: {'user': user});
  }

  Future<void> logBookmarkBusiness({String businessId}) {
    return logEvent(
        name: 'app_bookmark_business', parameters: {'businessId': businessId});
  }

  Future<void> logCircleSelection({String circleCode}) {
    return logEvent(
        name: 'app_circle_select', parameters: {'circleCode': circleCode});
  }

  Future<void> logLanguageChange({String setLanguage}) {
    return logEvent(
        name: 'app_language_change', parameters: {'setLanguage': setLanguage});
  }

  Future<void> logAddPhotoToOrder({String photoUrl, String photoId}) {
    return logEvent(name: 'app_add_photo_order', parameters: {
      'orderId': photoUrl
    });
  }

  Future<void> logAppLaunch() async {
    String deviceId = "";
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      deviceId = deviceInfo.androidId;
    } else if (Platform.isIOS) {
      final deviceInfo = await DeviceInfoPlugin().iosInfo;
      deviceId = deviceInfo.identifierForVendor;
    }
    return logEvent(name: 'app_launch', parameters: {'device_id': deviceId});
  }

  Future<void> logAddToCart(
      {String itemSku,
      String itemName,
      String itemCategory,
      int quantity,
      double price}) {
    return FirebaseAnalytics().logAddToCart(
        itemId: itemSku,
        itemName: itemName,
        itemCategory: itemCategory,
        quantity: quantity,
        price: price);
  }

  Future<void> logRemoveFromCart(
      {String itemSku,
      String itemName,
      String itemCategory,
      int quantity,
      double price}) {
    return FirebaseAnalytics().logAddToCart(
        itemId: itemSku,
        itemName: itemName,
        itemCategory: itemCategory,
        quantity: quantity,
        price: price);
  }

  Future<void> logSearch({String searchTerm}) {
    return FirebaseAnalytics().logSearch(searchTerm: searchTerm);
  }

  Future<void> logSuccessfulPurchase(
      {double value, double tax, double shipping, String transactionId}) {
    return FirebaseAnalytics().logEcommercePurchase(
        value: value,
        tax: tax,
        shipping: shipping,
        transactionId: transactionId);
  }

  Future<void> logViewItem(
      {String itemId, String itemName, String itemCategory}) {
    return FirebaseAnalytics().logViewItem(
        itemId: itemId, itemName: itemName, itemCategory: itemCategory ?? '');
  }

  Future<void> logSelectedCategory({String itemCategory}) {
    return FirebaseAnalytics().logViewItemList(itemCategory: itemCategory);
  }

  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    if (enabled == null) {
      throw ArgumentError.notNull('enabled');
    }
    await _platformInstance.setAnalyticsCollectionEnabled(enabled);
  }

  Future<void> setUserId(String id) async {
    await _platformInstance.setUserId(id);
  }

  Future<void> setCurrentScreen(
      {@required String screenName,
      String screenClassOverride = 'Flutter'}) async {
    if (screenName == null) {
      throw ArgumentError.notNull('screenName');
    }

    await _platformInstance.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenClassOverride,
    );
  }
}
