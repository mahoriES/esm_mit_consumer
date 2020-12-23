import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtility {

  static void setCurrentUserAsAdvanced() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(SharedPreferencesKeys.isAdvancedUser, true);
  }

  static Future<bool> isAdvancedUser() async{
    bool _isAdvancedUser;
    final prefs = await SharedPreferences.getInstance();
    try {
      final bool isAdvancedUser = prefs.getBool(SharedPreferencesKeys.isAdvancedUser);
      _isAdvancedUser = isAdvancedUser ?? false;
    } catch (e) {
      _isAdvancedUser = false;
      prefs.setBool(SharedPreferencesKeys.isAdvancedUser, false);
    }
    return _isAdvancedUser;
  }

}

class SharedPreferencesKeys {

  static const String isAdvancedUser = "isAdvancedUser";

}