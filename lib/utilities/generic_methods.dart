import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonMethods {
  static Future<void> openMap(double latitude, double longitude) async {
    if (latitude == null || longitude == null) {
      Fluttertoast.showToast(msg: tr('store_home.no_location'));
      return;
    }
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      Fluttertoast.showToast(msg: tr('store_home.error_map'));
    }
  }
}
