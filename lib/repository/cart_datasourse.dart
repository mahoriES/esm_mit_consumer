import 'dart:convert';

import 'package:esamudaayapp/modules/home/models/merchant_response.dart';
import 'package:esamudaayapp/modules/store_details/models/catalog_search_models.dart';
import 'package:esamudaayapp/repository/database_manage.dart';

final String cartTable = "Cart";
final String merchantTable = "Merchants";

class CartDataSource {
  static Future<void> insert({Product product}) async {
    var dbClient = await DatabaseManager().db;
    Map<String, String> cart = Map<String, String>();
    cart["product"] = jsonEncode(product.toJson());
    cart['id'] = product.productId.toString();
    try {
      var id = await dbClient.insert(cartTable, cart);
      print(id);
    } catch (error) {
      print(error);
    }
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
    List<Map> list = await dbClient.query(cartTable);
    var products = list.map((item) {
      Map<String, dynamic> user = jsonDecode(item["product"].toString());

      return Product.fromJson(user);
    }).toList();
    return products;
  }

  static Future<bool> isAvailableInCart({String id}) async {
    var dbClient = await DatabaseManager().db;
    List<Map> list =
        await dbClient.query(cartTable, where: 'id = ?', whereArgs: [id]);
    return list.isNotEmpty;
  }

  static Future<int> deleteAll() async {
    var dbClient = await DatabaseManager().db;
    return await dbClient.delete(cartTable);
  }

  static Future<int> deleteAllMerchants() async {
    var dbClient = await DatabaseManager().db;
    return await dbClient.delete(merchantTable);
  }

  static Future<int> deleteCartItemWith(String id) async {
    var dbClient = await DatabaseManager().db;
    return await dbClient.delete(cartTable, where: "id = ?", whereArgs: [id]);
  }

  static Future<int> delete(String id) async {
    var dbClient = await DatabaseManager().db;
    return await dbClient.delete(cartTable, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> update(Product product) async {
    var dbClient = await DatabaseManager().db;
    Map<String, String> cart = Map<String, String>();
    cart["product"] = jsonEncode(product.toJson());
    cart['id'] = product.productId.toString();
    return await dbClient.update(cartTable, cart,
        where: 'id = ?', whereArgs: [product.productId]);
  }
}
