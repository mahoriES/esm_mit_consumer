import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/home/models/cluster.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/home/models/video_feed_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// TODO : seperate the catalogue and cart state variables.

class ProductState {
  final List<Product> searchResultProducts;
  final List<Product> singleCategoryFewProducts;
  final List<Merchants> searchResults;
  final bool currentOrderIsPickUp;
  final bool searchForProductsComplete;
  final List<Product> spotlightItems;
  final CategoriesNew selectedCategory;
  final PlaceOrderResponse placeOrderResponse;
  final VideoFeedResponse videosResponse;
  final Business selectedMerchant;
  final List<CategoriesNew> categories;
  final Cluster selectedCluster;
  final Product selectedProductForDetails;
  final Map<int, List<CategoriesNew>> categoryIdToSubCategoryData;
  final Map<int, CatalogSearchResponse> subCategoryIdToProductData;
  final Map<int, bool> isLoadingMore;
  final CatalogSearchResponse allProductsForMerchant;

  ProductState({
    @required this.singleCategoryFewProducts,
    @required this.spotlightItems,
    @required this.searchForProductsComplete,
    @required this.selectedCluster,
    @required this.placeOrderResponse,
    @required this.selectedCategory,
    @required this.selectedMerchant,
    @required this.searchResults,
    @required this.videosResponse,
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
      searchForProductsComplete: false,
      selectedCluster: null,
      categories: [],
      searchResults: [],
      selectedMerchant: null,
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
    bool searchForProductsComplete,
    List<Product> searchResultProducts,
    List<CategoriesNew> categories,
    List<Merchants> searchResults,
    Business selectedMerchant,
    PlaceOrderResponse placeOrderResponse,
    CategoriesNew selectedCategory,
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
      searchForProductsComplete:
          searchForProductsComplete ?? this.searchForProductsComplete,
      selectedCluster: selectedCluster ?? this.selectedCluster,
      searchResults: searchResults ?? this.searchResults,
      placeOrderResponse: placeOrderResponse ?? this.placeOrderResponse,
      searchResultProducts: searchResultProducts ?? this.searchResultProducts,
      selectedMerchant: selectedMerchant ?? this.selectedMerchant,
      selectedCategory: selectedCategory ?? this.selectedCategory,
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

  // The problem with copyWith function is that we can not set any value to null
  // as it has null check and assigns previous value in this case.
  //
  // When switching between merchants, the cached product lists must be reset to null
  // created reset method for the same.
  // This can be modified to be more generic in future as needed.

  ProductState reset() {
    return ProductState(
      // update these values
      categories: [],
      categoryIdToSubCategoryData: {},
      subCategoryIdToProductData: {},
      isLoadingMore: {},
      allProductsForMerchant: null,

      // These values should not change.
      searchForProductsComplete: this.searchForProductsComplete,
      selectedCluster: this.selectedCluster,
      searchResults: this.searchResults,
      placeOrderResponse: this.placeOrderResponse,
      searchResultProducts: this.searchResultProducts,
      selectedMerchant: this.selectedMerchant,
      selectedCategory: this.selectedCategory,
      currentOrderIsPickUp: this.currentOrderIsPickUp,
      selectedProductForDetails: this.selectedProductForDetails,
      spotlightItems: this.spotlightItems,
      videosResponse: this.videosResponse,
      singleCategoryFewProducts: this.singleCategoryFewProducts,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductState &&
          runtimeType == other.runtimeType &&
          searchResultProducts == other.searchResultProducts &&
          singleCategoryFewProducts == other.singleCategoryFewProducts &&
          searchResults == other.searchResults &&
          currentOrderIsPickUp == other.currentOrderIsPickUp &&
          searchForProductsComplete == other.searchForProductsComplete &&
          spotlightItems == other.spotlightItems &&
          selectedCategory == other.selectedCategory &&
          placeOrderResponse == other.placeOrderResponse &&
          videosResponse == other.videosResponse &&
          selectedMerchant == other.selectedMerchant &&
          categories == other.categories &&
          selectedCluster == other.selectedCluster &&
          selectedProductForDetails == other.selectedProductForDetails &&
          categoryIdToSubCategoryData == other.categoryIdToSubCategoryData &&
          subCategoryIdToProductData == other.subCategoryIdToProductData &&
          isLoadingMore == other.isLoadingMore &&
          allProductsForMerchant == other.allProductsForMerchant;

  @override
  int get hashCode =>
      searchResultProducts.hashCode ^
      singleCategoryFewProducts.hashCode ^
      searchResults.hashCode ^
      currentOrderIsPickUp.hashCode ^
      searchForProductsComplete.hashCode ^
      spotlightItems.hashCode ^
      selectedCategory.hashCode ^
      placeOrderResponse.hashCode ^
      videosResponse.hashCode ^
      selectedMerchant.hashCode ^
      categories.hashCode ^
      selectedCluster.hashCode ^
      selectedProductForDetails.hashCode ^
      categoryIdToSubCategoryData.hashCode ^
      subCategoryIdToProductData.hashCode ^
      isLoadingMore.hashCode ^
      allProductsForMerchant.hashCode;
}
