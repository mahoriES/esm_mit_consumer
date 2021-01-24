import 'dart:io';

import 'package:eSamudaay/presentations/custom_confirmation_dialog.dart';
import 'package:eSamudaay/utilities/stringConstants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';

/// Generic methods to handle app update availavility.
class AppUpdateService {
  // Defining this class as singleton to manage state variables.
  AppUpdateService._();
  static AppUpdateService _instance = AppUpdateService._();
  factory AppUpdateService() => _instance;

  static bool _isUpdateAvailable;
  static bool _isImmediateUpdateAllowed;
  static bool _isFlexibleUpdateAllowed;
  static bool _isSelectedLater;

  static bool get isSelectedLater => _isSelectedLater;

  static Future<void> checkAppUpdateAvailability() async {
    try {
      // TODO : IOS platform implementation.
      if (Platform.isIOS) {
        throw Exception("ios implementation not found");
      }
      // InAppUpdate works for Android platform only.
      final AppUpdateInfo appUpdateInfo = await InAppUpdate.checkForUpdate();

      debugPrint("appUpdateInfo => $appUpdateInfo");

      _isUpdateAvailable = appUpdateInfo?.updateAvailable ?? false;
      _isImmediateUpdateAllowed =
          appUpdateInfo?.immediateUpdateAllowed ?? false;
      _isFlexibleUpdateAllowed = appUpdateInfo?.flexibleUpdateAllowed ?? false;
      _isSelectedLater = false;
    } catch (e) {
      _isUpdateAvailable = false;
      _isImmediateUpdateAllowed = false;
      _isFlexibleUpdateAllowed = false;
      _isSelectedLater = false;
    }
  }

  static Future<void> showUpdateDialog(BuildContext context) async {
    // show app update dialog only if update is available and update priority is atleast flexible.
    if (_isUpdateAvailable &&
        (_isImmediateUpdateAllowed || _isFlexibleUpdateAllowed)) {
      await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => Future.value(false),
            child: CustomConfirmationDialog(
              message: tr('screen_home.app_update_popup_msg'),
              showAppLogo: true,
              title: tr('screen_home.app_update_title'),
              positiveButtonText: tr('screen_home.app_update_button'),
              // if update type is immediate then don't show 'Later' option.
              negativeButtonText:
                  _isImmediateUpdateAllowed ? null : tr('screen_home.later'),
              positiveAction: updateApp,
              negativeAction: () {
                _isSelectedLater = true;
                Navigator.of(context).pop();
              },
            ),
          );
        },
      );
    }
  }

  static Future<void> updateApp() async {
    // TODO : IOS platform implementation.

    const PLAY_STORE_URL =
        'https://play.google.com/store/apps/details?id=${StringConstants.packageName}';
    if (await canLaunch(PLAY_STORE_URL)) {
      await launch(PLAY_STORE_URL);
    } else {
      throw 'Could not launch $PLAY_STORE_URL';
    }
  }
}
