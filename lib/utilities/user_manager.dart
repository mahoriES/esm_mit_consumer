import 'dart:async';
import 'dart:convert';

import 'package:eSamudaay/modules/Profile/model/profile_update_model.dart';
import 'package:eSamudaay/modules/address/models/addess_models.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/repository/database_manage.dart';
import 'package:eSamudaay/utilities/stringConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static Future<Data> userDetails() async {
    var dbClient = await DatabaseManager().db;
    List<Map> maps = await dbClient.rawQuery('SELECT * FROM User');
    if (maps.length > 0) {
      return Data.fromJson(jsonDecode(maps.first['user']));
    }
    return null;
  }

  static UserManager shared = UserManager();

  Future<bool> isLoggedIn() async => await userDetails().then((user) {
        return user != null;
      });

  Future<bool> isSkipPressed() async => await getSkipStatus().then((value) {
        return value != null && value == true;
      });

  static Future<void> deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dbClient = await DatabaseManager().db;
    await saveSkipStatus(status: false);
    prefs.remove(StringConstants.tokenKey);
    int resp = await dbClient.delete('User');
    await CartDataSource.resetCart();
    print(resp);
  }

  static Future<bool> getSkipStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(StringConstants.skipKey);
    return value;
  }

  static Future<void> saveSkipStatus({status: bool}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StringConstants.skipKey, status);
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(StringConstants.tokenKey);
    print("retrived token : $value");
    return value;
  }

  static Future<List<AddressResponse>> getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(StringConstants.userAddressKey);
    if (value == null) return null;
    var data = jsonDecode(value);
    List<AddressResponse> addressResponse = [];
    if (data is List) {
      data.forEach((element) {
        addressResponse.add(AddressResponse.fromJson(element));
      });
    } else {
      addressResponse.add(AddressResponse.fromJson(data));
    }
    return addressResponse;
  }

  static Future<void> saveToken({token: String}) async {
    print("saved token : $token");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(StringConstants.tokenKey, token);
  }

  static Future<void> saveAddress({address: String}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(StringConstants.userAddressKey, address);
  }

  static Future<void> deleteAddress({address: String}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(StringConstants.userAddressKey);
  }

  static Future<String> getFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(StringConstants.fcmToken);
    print("retrived token : $value");
    return value;
  }

  static Future<void> saveFcmToken({token: String}) async {
    print("saved token : $token");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(StringConstants.fcmToken, token);
  }

  static Future<int> saveUser(Data user) async {
    var dbClient = await DatabaseManager().db;
    Map<String, String> userData = Map<String, String>();
    userData['user'] = jsonEncode(user.toJson());
    userData['id'] = user.userProfile.userId;
    int resp = await dbClient.delete('User');
    int res = await dbClient.insert("User", userData);
    return res;
  }
}

var userManager = UserManager();
