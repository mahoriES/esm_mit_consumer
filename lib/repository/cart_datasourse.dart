import 'dart:convert';

import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/repository/database_manage.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String cartTable = "Cart";
final String merchantTable = "Merchants";

class CartDataSource {
  static Future<void> insert({Product product, String variation}) async {
    var dbClient = await DatabaseManager().db;
    Map<String, String> cart = Map<String, String>();
    cart["product"] = jsonEncode(product.toJson());
    cart['id'] = product.productId.toString();
    cart['variation'] = variation;
    try {
      var id = await dbClient.insert(cartTable, cart);
      print(id);
    } on DatabaseException catch (error) {
      await CartDataSource.reCreateCartTable();
      var id = await dbClient.insert(cartTable, cart);
      print(id);
      print(error);
    }
  }

  static Future<List<JITProduct>> getFreeFormItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<JITProduct> jsonDecodedJITItems = [];
      List<String> jsonEncodedJITItems = prefs.getStringList("freeFormItemsList");
      jsonEncodedJITItems.forEach((element) {
        jsonDecodedJITItems.add(JITProduct.fromJson(jsonDecode(element)));
      });
      return jsonDecodedJITItems;
    } catch(e) {
      debugPrint("Error occurred getting free form items ${e.toString()}");
      return <JITProduct>[];
    }
  }

  static Future<void> insertFreeFormItemsList(
      List<JITProduct> freeFormItemsList) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonEncodedJITItems = [];
    freeFormItemsList.forEach((element) {
      jsonEncodedJITItems.add(jsonEncode(element.toJson()));
    });
    prefs.setStringList('freeFormItemsList', jsonEncodedJITItems);
  }

  static Future<List<String>> getCustomerNoteImagesList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList("customerNoteImagesList") ?? [];
    } catch(e) {
      debugPrint("Error occurred getting customer note images ${e.toString()}");
      return <String>[];
    }
  }

  static Future<void> insertCustomerNoteImagesList(
      List<String> customerNoteImages) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("customerNoteImagesList", customerNoteImages);
  }

  ///This function will drop the cart SQL table and recreate it. It is a fix to
  ///address FE-65 since it modifies the cart table and thus Cart table ought to
  ///be recreated for users who are updating the app to the new version.
  ///Moreover this shall also be useful in future, when the cart table has to be
  ///modified to incorporate more horizontals.
  static Future<void> reCreateCartTable() async {
    debugPrint('INVOKED PERFORM UPDATE');
    await CartDataSource.deleteAll();
    var dbClient = await DatabaseManager().db;

    await dbClient.execute('''
    drop table if exists $cartTable
    ''');

    await dbClient.execute('''
    create table if not exists $cartTable (
    _id integer primary key autoincrement,
    id text,
    product text,
    variation text
    )
    ''');
  }

  static Future<void> insertToMerchants({Business business}) async {
    var dbClient = await DatabaseManager().db;
    Map<String, String> data = Map<String, String>();
    data['business'] = jsonEncode(business.toJson());
    try {
      var id = await dbClient.insert(merchantTable, data);
      print(id);
    } catch (error) {
      print(error);
    }
  }

  static Future<List<Business>> getListOfMerchants() async {
    var dbClient = await DatabaseManager().db;
    List<Map> list = await dbClient.query(merchantTable);
    var products = list
        .map((item) => Business.fromJson(jsonDecode(item["business"])))
        .toList();
    return products;
  }

  static Future<List<Product>> getListOfCartWith() async {
    var dbClient = await DatabaseManager().db;

    try {
      await dbClient.query(cartTable, columns: ['variation']);
    } on DatabaseException catch (e) {
      CartDataSource.reCreateCartTable();
    }
    List<Map> list = await dbClient.query(cartTable);
    var products = list.map((item) {
      Map<String, dynamic> user = jsonDecode(item["product"].toString());

      return Product.fromJson(user);
    }).toList();
    return products;
  }

  static Future<bool> isAvailableInCart({String id, String variation}) async {
    var dbClient = await DatabaseManager().db;
    List<Map> list = await dbClient.query(cartTable,
        where: 'id = ? AND variation = ?', whereArgs: [id, variation]);
    return list.isNotEmpty;
  }

  static Future<int> deleteAll() async {
    var dbClient = await DatabaseManager().db;
    return await dbClient.delete(cartTable);
  }

  static Future<int> deleteAllMerchants() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dbClient = await DatabaseManager().db;
    return await dbClient.delete(merchantTable);
  }

  static Future<int> deleteCartItemWith(String id, String variation) async {
    var dbClient = await DatabaseManager().db;
    return await dbClient.delete(cartTable,
        where: "id = ? AND variation = ?", whereArgs: [id, variation]);
  }

  static Future<int> delete(String id, variation) async {
    var dbClient = await DatabaseManager().db;
    return await dbClient.delete(cartTable,
        where: 'id = ? AND variation = ?', whereArgs: [id, variation]);
  }

  static Future<int> update(Product product, String variation) async {
    var dbClient = await DatabaseManager().db;
    Map<String, String> cart = Map<String, String>();
    cart["product"] = jsonEncode(product.toJson());
    cart['id'] = product.productId.toString();
    cart['variation'] = variation;
    try {
      return await dbClient.update(cartTable, cart,
          where: 'id = ? AND variation = ?',
          whereArgs: [product.productId, variation]);
    } on DatabaseException catch (e) {
      await CartDataSource.reCreateCartTable();
      return await dbClient.update(cartTable, cart,
          where: 'id = ? AND variation = ?',
          whereArgs: [product.productId, variation]);
    }
  }
}
