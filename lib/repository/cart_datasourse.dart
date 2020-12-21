import 'dart:convert';

import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/repository/database_manage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartDataSource {
  static const String _cartTable = DatabaseManager.cartTable;
  static const String _merchantKey = "business";
  static const String _freeFormItemsKey = "freeFormItemsList";
  static const String _listImagesKey = "customerNoteImagesList";

  static Future<void> insertProduct(Product product) async {
    final dbClient = await DatabaseManager().db;
    Map<String, String> cart = Map<String, String>();
    cart["product"] = jsonEncode(product.toJson());
    cart['id'] = product.productId.toString();
    cart['variation'] = product.selectedSkuId;
    try {
      final int id = await dbClient.insert(_cartTable, cart);
      debugPrint(id.toString());
    } on DatabaseException catch (error) {
      await CartDataSource.reCreateCartTable();
      var id = await dbClient.insert(_cartTable, cart);
      debugPrint(id.toString());
      debugPrint(error.toString());
    } catch (error) {
      debugPrint(error?.toString());
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
    }
  }

  static Future<List<JITProduct>> getFreeFormItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<JITProduct> jsonDecodedJITItems = [];
      final List<String> jsonEncodedJITItems =
          prefs.getStringList(_freeFormItemsKey);
      jsonEncodedJITItems.forEach((element) {
        jsonDecodedJITItems.add(JITProduct.fromJson(jsonDecode(element)));
      });
      return jsonDecodedJITItems;
    } catch (error) {
      debugPrint(error?.toString());
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
    }
    return [];
  }

  static Future<void> insertFreeFormItemsList(
      List<JITProduct> freeFormItemsList) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> jsonEncodedJITItems = [];
      freeFormItemsList.forEach((element) {
        jsonEncodedJITItems.add(jsonEncode(element.toJson()));
      });
      prefs.setStringList(_freeFormItemsKey, jsonEncodedJITItems);
    } catch (error) {
      debugPrint(error?.toString());
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
    }
  }

  static Future<List<String>> getCustomerNoteImagesList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_listImagesKey) ?? [];
    } catch (error) {
      debugPrint(error?.toString());
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
    }
    return [];
  }

  static Future<void> insertCustomerNoteImagesList(
      List<String> customerNoteImages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList(_listImagesKey, customerNoteImages);
    } catch (error) {
      debugPrint(error?.toString());
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
    }
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
    try {
      String data = jsonEncode(business?.toJson());
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_merchantKey, data);
    } catch (error) {
      debugPrint(error?.toString());
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
    }
  }

  static Future<Business> getCartMerchant() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String data = prefs.getString(_merchantKey);
      Business merchant = Business.fromJson(jsonDecode(data));
      return merchant;
    } catch (error) {
      debugPrint(error?.toString());
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
      return null;
    }
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
    } catch (error) {
      debugPrint(error?.toString());
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
    }
    return [];
  }

  static Future<void> deleteAllProducts() async {
    try {
      var dbClient = await DatabaseManager().db;
      await dbClient.delete(_cartTable);
    } catch (error) {
      debugPrint(error?.toString());
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
    }
  }

  static Future<void> deleteCartMerchant() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(_merchantKey);
    } catch (error) {
      debugPrint(error?.toString());
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
    }
  }

  static Future<void> deleteCartProduct(Product product) async {
    final dbClient = await DatabaseManager().db;
    try {
      return await dbClient.delete(
        _cartTable,
        where: "id = ? AND variation = ?",
        whereArgs: [product.productId, product.selectedSkuId],
      );
    } on DatabaseException catch (_) {
      await CartDataSource.reCreateCartTable();
      return await dbClient.delete(
        _cartTable,
        where: 'id = ? AND variation = ?',
        whereArgs: [product.productId, product.selectedSkuId],
      );
    } catch (error) {
      debugPrint(error?.toString());
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
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
    } catch (error) {
      debugPrint(error?.toString());
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
    }
  }
}
