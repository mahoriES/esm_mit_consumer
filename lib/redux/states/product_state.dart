import 'package:esamudaayapp/modules/cart/models/cart_model.dart';
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
  final List<Product> localCartItems;
  final Categories selectedCategory;
  final PlaceOrderResponse placeOrderResponse;
  final Merchants selectedMerchand;
  final GetOrderListResponse getOrderListResponse;
  final String supportOrder;

  ProductState(
      {@required this.localCartItems,
      @required this.placeOrderResponse,
      @required this.getOrderListResponse,
      @required this.selectedCategory,
      @required this.productListingTempDataSource,
      @required this.selectedMerchand,
      @required this.searchResults,
      @required this.productListingDataSource,
      @required this.supportOrder});

  factory ProductState.initial() {
    return new ProductState(
        supportOrder: "",
        getOrderListResponse: GetOrderListResponse(orders: []),
        localCartItems: [],
        searchResults: [],
        selectedMerchand: null,
        productListingTempDataSource: [],
        productListingDataSource: [],
        selectedCategory: null,
        placeOrderResponse: null);
  }

  ProductState copyWith(
      {List<Product> productListingDataSource,
      List<Product> productListingTempDataSource,
      List<Product> localCartItems,
      List<Merchants> searchResults,
      Merchants selectedMerchant,
      PlaceOrderResponse placeOrderResponse,
      GetOrderListResponse getOrderListResponse,
      Categories selectedCategory,
      String supportOrder}) {
    return ProductState(
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
        supportOrder: supportOrder ?? this.supportOrder);
  }
}
