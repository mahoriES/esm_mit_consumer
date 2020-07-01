import 'package:esamudaayapp/modules/cart/models/cart_model.dart';
import 'package:esamudaayapp/modules/cart/models/charge_details_response.dart';
import 'package:esamudaayapp/modules/home/models/category_response.dart';
import 'package:esamudaayapp/modules/home/models/cluster.dart';
import 'package:esamudaayapp/modules/home/models/merchant_response.dart';
import 'package:esamudaayapp/modules/orders/models/order_models.dart';
import 'package:esamudaayapp/modules/store_details/models/catalog_search_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProductState {
//  final LoadingStatus loadingStatus;
  final List<Product> productListingDataSource;
  final List<Product> productListingTempDataSource;
  final List<Merchants> searchResults;
  final bool currentOrderIsPickUp;
  final List<Product> localCartItems;
  final List<Charge> charges;
  final CategoriesNew selectedCategory;
  final PlaceOrderResponse placeOrderResponse;
  final Business selectedMerchand;
  final GetOrderListResponse getOrderListResponse;
  final String supportOrder;
  final List<CategoriesNew> categories;
  final Cluster selectedCluster;

  ProductState(
      {@required this.localCartItems,
      @required this.charges,
      @required this.selectedCluster,
      @required this.placeOrderResponse,
      @required this.getOrderListResponse,
      @required this.selectedCategory,
      @required this.productListingTempDataSource,
      @required this.selectedMerchand,
      @required this.searchResults,
      @required this.productListingDataSource,
      @required this.supportOrder,
      @required this.categories,
      @required this.currentOrderIsPickUp});

  factory ProductState.initial() {
    return new ProductState(
        selectedCluster: null,
        charges: [],
        categories: [],
        supportOrder: "",
        getOrderListResponse: GetOrderListResponse(results: []),
        localCartItems: [],
        searchResults: [],
        selectedMerchand: null,
        productListingTempDataSource: [],
        productListingDataSource: [],
        selectedCategory: null,
        placeOrderResponse: null,
        currentOrderIsPickUp: false);
  }

  ProductState copyWith(
      {List<Product> productListingDataSource,
      List<Product> productListingTempDataSource,
      List<Product> localCartItems,
      List<CategoriesNew> categories,
      List<Merchants> searchResults,
      List<Charge> charges,
      Business selectedMerchant,
      PlaceOrderResponse placeOrderResponse,
      GetOrderListResponse getOrderListResponse,
      CategoriesNew selectedCategory,
      String supportOrder,
      bool currentOrderIsPickUp,
      Cluster selectedCluster}) {
    return ProductState(
        charges: charges ?? this.charges,
        selectedCluster: selectedCluster ?? this.selectedCluster,
        searchResults: searchResults ?? this.searchResults,
        getOrderListResponse: getOrderListResponse ?? this.getOrderListResponse,
        placeOrderResponse: placeOrderResponse ?? this.placeOrderResponse,
        productListingTempDataSource:
            productListingTempDataSource ?? this.productListingTempDataSource,
        localCartItems: localCartItems ?? this.localCartItems,
        selectedMerchand: selectedMerchant ?? this.selectedMerchand,
        productListingDataSource:
            productListingDataSource ?? this.productListingDataSource,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        supportOrder: supportOrder ?? this.supportOrder,
        categories: categories ?? this.categories,
        currentOrderIsPickUp:
            currentOrderIsPickUp ?? this.currentOrderIsPickUp);
  }
}
