import 'package:eSamudaay/modules/cart/models/charge_details_response.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:flutter/material.dart';

class CartState {
  final List<Product> localCartItems;
  final List<String> customerNoteImages;
  final TextEditingController customerNoteMessage;
  final String selectedDeliveryType;
  final Business cartMerchant;
  final CartCharges charges;
  final bool isCartLoading;
  final bool isImageUploading;

  CartState({
    @required this.localCartItems,
    @required this.customerNoteImages,
    @required this.customerNoteMessage,
    @required this.selectedDeliveryType,
    @required this.cartMerchant,
    @required this.charges,
    @required this.isCartLoading,
    @required this.isImageUploading,
  });

  factory CartState.initial() {
    return new CartState(
      customerNoteImages: [],
      localCartItems: [],
      cartMerchant: null,
      charges: null,
      isCartLoading: false,
      isImageUploading: false,
      selectedDeliveryType: null,
      customerNoteMessage: new TextEditingController(),
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
    // we need to set cartMerchant as null when no products are added in cart.
    bool isMerchantAllowedToBeNull = false,
    List<Product> localCartItems,
    List<String> customerNoteImages,
    Business cartMerchant,
    CartCharges charges,
    bool isCartLoading,
    String selectedDeliveryType,
    bool isImageUploading,
  }) {
    return new CartState(
      customerNoteImages: customerNoteImages ?? this.customerNoteImages,
      localCartItems: localCartItems ?? this.localCartItems,
      cartMerchant: cartMerchant ??
          (isMerchantAllowedToBeNull ? null : this.cartMerchant),
      charges: charges ?? this.charges,
      isCartLoading: isCartLoading ?? this.isCartLoading,
      customerNoteMessage: this.customerNoteMessage,
      selectedDeliveryType: selectedDeliveryType ?? this.selectedDeliveryType,
      isImageUploading: isImageUploading ?? this.isImageUploading,
    );
  }
}
