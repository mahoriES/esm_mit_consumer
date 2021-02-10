import 'dart:convert';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/repository/database_manage.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartDataSource {
  static const String _cartTable = DatabaseManager.cartTable;
  static const String _merchantKey = "business";
  static const String _listImagesKey = "customerNoteImagesList";

  static Future<void> resetCart() async {
    await CartDataSource.deleteCartMerchant();
    await CartDataSource.deleteAllProducts();
    await CartDataSource.insertCustomerNoteImagesList([]);
  }

  static Future<void> insertProduct(Product product) async {
    final dbClient = await DatabaseManager().db;
    Map<String, String> cart = Map<String, String>();
    cart["product"] = jsonEncode(product.toJson());
    cart['id'] = product.productId.toString();
    cart['variation'] = product.selectedSkuId;
    try {
      await dbClient.insert(_cartTable, cart);
    } on DatabaseException catch (_) {
      await CartDataSource.reCreateCartTable();
      await dbClient.insert(_cartTable, cart);
    }
  }

  static Future<List<Photo>> getCustomerNoteImagesList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonImages = prefs.getStringList(_listImagesKey) ?? [];
    List<Photo> images = [];
    if (jsonImages != null) {
      jsonImages.forEach((v) {
        images.add(new Photo.fromJson(jsonDecode(v)));
      });
    }
    return images;
  }

  static Future<void> insertCustomerNoteImagesList(
      List<Photo> customerNoteImages) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonImages = [];
    if (customerNoteImages != null) {
      customerNoteImages.forEach((v) {
        jsonImages.add(jsonEncode(v.toJson()));
      });
    }
    await prefs.setStringList(_listImagesKey, jsonImages);
  }

  ///This function will drop the cart SQL table and recreate it. It is a fix to
  ///address FE-65 since it modifies the cart table and thus Cart table ought to
  ///be recreated for users who are updating the app to the new version.
  ///Moreover this shall also be useful in future, when the cart table has to be
  ///modified to incorporate more horizontals.
  static Future<void> reCreateCartTable() async {
    debugPrint('INVOKED PERFORM UPDATE');
    await CartDataSource.deleteAllProducts();
    final dbClient = await DatabaseManager().db;

    await dbClient.execute('''
    drop table if exists $_cartTable
    ''');

    await dbClient.execute('''
    create table if not exists $_cartTable (
    _id integer primary key autoincrement,
    id text,
    product text,
    variation text
    )
    ''');
  }

  static Future<void> insertCartMerchant(Business business) async {
    String data = jsonEncode(business?.toJson());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_merchantKey, data);
  }

  static Future<Business> getCartMerchant() async {
    final prefs = await SharedPreferences.getInstance();
    String data = prefs.getString(_merchantKey);
    if (data == null) return null;
    Business merchant = Business.fromJson(jsonDecode(data));

    if (merchant == null) {
      // check if merchant is stored in older format
      var dbClient = await DatabaseManager().db;
      List<Map> list = await dbClient.query("Merchants");
      List<Business> merchantsList = list
          .map((item) => Business.fromJson(jsonDecode(item["business"])))
          .toList();
      if (merchantsList != null && merchantsList.isNotEmpty) {
        // if yes, then save the value in new key, delete old one and return the data.
        await dbClient.delete("Merchants");
        await insertCartMerchant(merchantsList.first);
        return merchantsList.first;
      } else {
        return null;
      }
    }
    return merchant;
  }

  static Future<List<Product>> getListOfProducts() async {
    final dbClient = await DatabaseManager().db;
    try {
      final List<Map> list = await dbClient.query(_cartTable);
      final List<Product> products = list.map(
        (item) {
          Map<String, dynamic> products =
              jsonDecode(item["product"].toString());
          return Product.fromJson(products);
        },
      ).toList();
      return products ?? [];
    } on DatabaseException catch (_) {
      await CartDataSource.reCreateCartTable();
      final List<Map> list = await dbClient.query(_cartTable);
      final List<Product> products = list.map(
        (item) {
          Map<String, dynamic> products =
              jsonDecode(item["product"].toString());
          return Product.fromJson(products);
        },
      ).toList();
      return products ?? [];
    }
  }

  static Future<void> deleteAllProducts() async {
    var dbClient = await DatabaseManager().db;
    await dbClient.delete(_cartTable);
  }

  static Future<void> deleteCartMerchant() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_merchantKey);
  }

  static Future<void> deleteCartProduct(Product product) async {
    final dbClient = await DatabaseManager().db;
    try {
      await dbClient.delete(
        _cartTable,
        where: "id = ? AND variation = ?",
        whereArgs: [product.productId, product.selectedSkuId],
      );
    } on DatabaseException catch (_) {
      await CartDataSource.reCreateCartTable();
      await dbClient.delete(
        _cartTable,
        where: 'id = ? AND variation = ?',
        whereArgs: [product.productId, product.selectedSkuId],
      );
    }
  }

  static Future<void> updateCartProduct(Product product) async {
    var dbClient = await DatabaseManager().db;
    Map<String, String> cart = Map<String, String>();
    cart["product"] = jsonEncode(product.toJson());
    cart['id'] = product.productId.toString();
    cart['variation'] = product.selectedSkuId;
    try {
      await dbClient.update(
        _cartTable,
        cart,
        where: 'id = ? AND variation = ?',
        whereArgs: [product.productId, product.selectedSkuId],
      );
    } on DatabaseException catch (_) {
      await CartDataSource.reCreateCartTable();
      await dbClient.update(
        _cartTable,
        cart,
        where: 'id = ? AND variation = ?',
        whereArgs: [product.productId, product.selectedSkuId],
      );
    }
  }
}
