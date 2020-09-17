import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/cart/models/charge_details_response.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/home/models/cluster.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/orders/models/order_models.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';

class ProductState {
//  final LoadingStatus loadingStatus;
  final List<Product> productListingDataSource;
  final List<Product> productListingTempDataSource;
  final List<Product> searchResultProducts;
  final List<Merchants> searchResults;
  final bool currentOrderIsPickUp;
  final List<Product> localCartItems;
  final List<Charge> charges;
  final CategoriesNew selectedCategory;
  final CategoriesNew selectedSubCategory;
  final PlaceOrderResponse placeOrderResponse;
  final Business selectedMerchand;
  final GetOrderListResponse getOrderListResponse;
  final String supportOrder;
  final List<CategoriesNew> categories;
  final List<CategoriesNew> subCategories;
  final Cluster selectedCluster;
  final CatalogSearchResponse productResponse;
  final List<ApplicationMeta> upiApps;

  ProductState(
      {@required this.localCartItems,
      @required this.charges,
      @required this.upiApps,
      @required this.selectedCluster,
      @required this.placeOrderResponse,
      @required this.getOrderListResponse,
      @required this.selectedCategory,
      @required this.productListingTempDataSource,
      @required this.selectedMerchand,
      @required this.searchResults,
      @required this.productListingDataSource,
      @required this.supportOrder,
      @required this.subCategories,
      @required this.categories,
      @required this.currentOrderIsPickUp,
      @required this.productResponse,
      @required this.selectedSubCategory,
      @required this.searchResultProducts,});

  factory ProductState.initial() {
    return new ProductState(
        upiApps: [],
        productResponse: CatalogSearchResponse(),
        selectedCluster: null,
        charges: [],
        categories: [],
        subCategories: [],
        supportOrder: "",
        getOrderListResponse: GetOrderListResponse(results: []),
        localCartItems: [],
        searchResults: [],
        selectedMerchand: null,
        productListingTempDataSource: [],
        productListingDataSource: [],
        searchResultProducts: [],
        selectedCategory: null,
        selectedSubCategory: null,
        placeOrderResponse: null,
        currentOrderIsPickUp: false);
  }

  ProductState copyWith(
      {List<Product> productListingDataSource,
      List<Product> productListingTempDataSource,
      List<Product> searchResultProducts,
      List<Product> localCartItems,
      List<CategoriesNew> categories,
      List<CategoriesNew> subCategories,
      List<Merchants> searchResults,
      List<Charge> charges,
      List<ApplicationMeta> upiApps,
      Business selectedMerchant,
      PlaceOrderResponse placeOrderResponse,
      GetOrderListResponse getOrderListResponse,
      CategoriesNew selectedCategory,
      CategoriesNew selectedSubCategory,
      String supportOrder,
      bool currentOrderIsPickUp,
      CatalogSearchResponse productResponse,
      Cluster selectedCluster}) {
    return ProductState(
        upiApps: upiApps ?? this.upiApps,
        productResponse: productResponse ?? this.productResponse,
        charges: charges ?? this.charges,
        selectedCluster: selectedCluster ?? this.selectedCluster,
        searchResults: searchResults ?? this.searchResults,
        getOrderListResponse: getOrderListResponse ?? this.getOrderListResponse,
        placeOrderResponse: placeOrderResponse ?? this.placeOrderResponse,
        productListingTempDataSource:
            productListingTempDataSource ?? this.productListingTempDataSource,
        localCartItems: localCartItems ?? this.localCartItems,
        searchResultProducts: searchResultProducts ?? this.searchResultProducts,
        selectedMerchand: selectedMerchant ?? this.selectedMerchand,
        productListingDataSource:
            productListingDataSource ?? this.productListingDataSource,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        supportOrder: supportOrder ?? this.supportOrder,
        categories: categories ?? this.categories,
        subCategories: subCategories ?? this.subCategories,
        selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
        currentOrderIsPickUp:
            currentOrderIsPickUp ?? this.currentOrderIsPickUp);
  }
}
