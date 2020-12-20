import 'package:eSamudaay/modules/cart/models/charge_details_response.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:flutter/material.dart';

class CartState {
  final List<Product> localCartItems;
  final List<JITProduct> localFreeFormCartItems;
  final List<String> customerNoteImages;
  final Business cartMerchant;
  final List<Charge> charges;

  CartState({
    @required this.localCartItems,
    @required this.localFreeFormCartItems,
    @required this.customerNoteImages,
    @required this.cartMerchant,
    @required this.charges,
  });

  factory CartState.initial() {
    return new CartState(
      customerNoteImages: [],
      localFreeFormCartItems: [],
      localCartItems: [],
      cartMerchant: null,
      charges: [],
    );
  }

  bool isAvailableInCart(Product product) {
    Product item = this.localCartItems.firstWhere(
          (element) =>
              element.productId == product.productId &&
              element.selectedSkuId == product.selectedSkuId,
          orElse: () => null,
        );

    return item != null;
  }

  CartState copyWith({
    List<Product> localCartItems,
    List<JITProduct> localFreeFormCartItems,
    List<String> customerNoteImages,
    Business cartMerchant,
    List<Charge> charges,
  }) {
    return new CartState(
      customerNoteImages: customerNoteImages ?? this.customerNoteImages,
      localCartItems: localCartItems ?? this.localCartItems,
      localFreeFormCartItems:
          localFreeFormCartItems ?? this.localFreeFormCartItems,
      cartMerchant: cartMerchant ?? this.cartMerchant,
      charges: charges ?? this.charges,
    );
  }
}
