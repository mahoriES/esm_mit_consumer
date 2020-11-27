import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/cart/models/charge_details_response.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/home/models/cluster.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/home/models/video_feed_response.dart';
import 'package:eSamudaay/modules/orders/models/order_models.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';

// TODO : seperate the catalogue and cart state variables.

class ProductState {
  final List<Product> productListingDataSource;
  final List<Product> searchResultProducts;
  final List<Product> singleCategoryFewProducts;
  final List<Merchants> searchResults;
  final bool currentOrderIsPickUp;
  final bool searchForProductsComplete;
  final List<Product> localCartItems;
  final List<Product> spotlightItems;
  final List<JITProduct> localFreeFormCartItems;
  final List<Charge> charges;
  final List<String> customerNoteImages;
  final CategoriesNew selectedCategory;
  final PlaceOrderResponse placeOrderResponse;
  final VideoFeedResponse videosResponse;
  final Business selectedMerchant;
  final GetOrderListResponse getOrderListResponse;
  final String supportOrder;
  final List<CategoriesNew> categories;
  final Cluster selectedCluster;
  final List<ApplicationMeta> upiApps;
  final Product selectedProductForDetails;
  final Map<int, List<CategoriesNew>> categoryIdToSubCategoryData;
  final Map<int, CatalogSearchResponse> subCategoryIdToProductData;
  final Map<int, bool> isLoadingMore;
  final CatalogSearchResponse allProductsForMerchant;

  ProductState({
    @required this.localCartItems,
    @required this.charges,
    @required this.singleCategoryFewProducts,
    @required this.spotlightItems,
    @required this.customerNoteImages,
    @required this.localFreeFormCartItems,
    @required this.searchForProductsComplete,
    @required this.upiApps,
    @required this.selectedCluster,
    @required this.placeOrderResponse,
    @required this.getOrderListResponse,
    @required this.selectedCategory,
    @required this.selectedMerchant,
    @required this.searchResults,
    @required this.videosResponse,
    @required this.productListingDataSource,
    @required this.supportOrder,
    @required this.categories,
    @required this.currentOrderIsPickUp,
    @required this.searchResultProducts,
    @required this.selectedProductForDetails,
    @required this.categoryIdToSubCategoryData,
    @required this.subCategoryIdToProductData,
    @required this.isLoadingMore,
    @required this.allProductsForMerchant,
  });

  factory ProductState.initial() {
    return new ProductState(
      customerNoteImages: [],
      localFreeFormCartItems: [],
      upiApps: [],
      searchForProductsComplete: false,
      selectedCluster: null,
      charges: [],
      categories: [],
      supportOrder: "",
      getOrderListResponse: GetOrderListResponse(results: []),
      localCartItems: [],
      searchResults: [],
      selectedMerchant: null,
      productListingDataSource: [],
      searchResultProducts: [],
      selectedCategory: null,
      placeOrderResponse: null,
      currentOrderIsPickUp: false,
      selectedProductForDetails: null,
      categoryIdToSubCategoryData: {},
      subCategoryIdToProductData: {},
      isLoadingMore: {},
      allProductsForMerchant: null,
      videosResponse: VideoFeedResponse(
        count: 0,
        results: [],
      ),
      spotlightItems: [],
      singleCategoryFewProducts: [],
    );
  }

  ProductState copyWith({
    List<Product> productListingDataSource,
    bool searchForProductsComplete,
    List<String> customerNoteImages,
    List<Product> searchResultProducts,
    List<Product> localCartItems,
    List<JITProduct> localFreeFormCartItems,
    List<CategoriesNew> categories,
    List<Merchants> searchResults,
    List<Charge> charges,
    List<ApplicationMeta> upiApps,
    Business selectedMerchant,
    PlaceOrderResponse placeOrderResponse,
    GetOrderListResponse getOrderListResponse,
    CategoriesNew selectedCategory,
    String supportOrder,
    bool currentOrderIsPickUp,
    Cluster selectedCluster,
    Product selectedProductForDetails,
    Map<int, List<CategoriesNew>> categoryIdToSubCategoryData,
    Map<int, CatalogSearchResponse> subCategoryIdToProductData,
    Map<int, bool> isLoadingMore,
    CatalogSearchResponse allProductsForMerchant,
    VideoFeedResponse videosResponse,
    List<Product> singleCategoryFewProducts,
    List<Product> spotlightItems,
  }) {
    return ProductState(
      customerNoteImages: customerNoteImages ?? this.customerNoteImages,
      searchForProductsComplete:
          searchForProductsComplete ?? this.searchForProductsComplete,
      upiApps: upiApps ?? this.upiApps,
      charges: charges ?? this.charges,
      selectedCluster: selectedCluster ?? this.selectedCluster,
      searchResults: searchResults ?? this.searchResults,
      getOrderListResponse: getOrderListResponse ?? this.getOrderListResponse,
      placeOrderResponse: placeOrderResponse ?? this.placeOrderResponse,
      localCartItems: localCartItems ?? this.localCartItems,
      localFreeFormCartItems:
          localFreeFormCartItems ?? this.localFreeFormCartItems,
      searchResultProducts: searchResultProducts ?? this.searchResultProducts,
      selectedMerchant: selectedMerchant ?? this.selectedMerchant,
      productListingDataSource:
          productListingDataSource ?? this.productListingDataSource,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      supportOrder: supportOrder ?? this.supportOrder,
      categories: categories ?? this.categories,
      currentOrderIsPickUp: currentOrderIsPickUp ?? this.currentOrderIsPickUp,
      selectedProductForDetails:
          selectedProductForDetails ?? this.selectedProductForDetails,
      categoryIdToSubCategoryData:
          categoryIdToSubCategoryData ?? this.categoryIdToSubCategoryData,
      subCategoryIdToProductData:
          subCategoryIdToProductData ?? this.subCategoryIdToProductData,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      allProductsForMerchant:
          allProductsForMerchant ?? this.allProductsForMerchant,
      spotlightItems: spotlightItems ?? this.spotlightItems,
      videosResponse: videosResponse ?? this.videosResponse,
      singleCategoryFewProducts:
          singleCategoryFewProducts ?? this.singleCategoryFewProducts,
    );
  }
}
