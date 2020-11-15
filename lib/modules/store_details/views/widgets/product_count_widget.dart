import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/cart/views/cart_sku_bottom_sheet.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/modules/store_details/views/stepper_view.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// This Widget is an extension of CSStepper.
// This contains method to add and remove an item from cart.
// Created a common widget as this is being used at multiple places in the store_details module.

class ProductCountWidget extends StatelessWidget {
  const ProductCountWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _handleActionForMultipleSkus({
      @required Product product,
      @required String storeName,
    }) {
      showModalBottomSheet(
        context: context,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        builder: (context) => Container(
          child: SkuBottomSheet(
            product: product,
            storeName: storeName,
          ),
        ),
      );
    }

    int _getItemCount(List<Product> localCartItems, int productId) {
      int count = 0;
      localCartItems.forEach((element) {
        if (element.productId == productId) count += element.count;
      });
      debugPrint('Total count in product details $count');
      return count;
    }

    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        return CSStepper(
          fillColor: false,
          addButtonAction: () {
            if (snapshot.selectedProduct.skus.isNotEmpty) {
              if (snapshot.selectedProduct.skus.length > 1) {
                showModalBottomSheet(
                  context: context,
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  builder: (context) => Container(
                    child: SkuBottomSheet(
                      product: snapshot.selectedProduct,
                      storeName: snapshot.selectedMerchant.businessName,
                    ),
                  ),
                );
              } else {
                snapshot.selectedProduct.count =
                    ((snapshot.selectedProduct?.count ?? 0) + 1)
                        .clamp(0, double.nan);
                snapshot.addToCart(snapshot.selectedProduct, context);
              }
            }
          },
          removeButtonAction: () {
            if (snapshot.selectedProduct.skus.isNotEmpty &&
                snapshot.selectedProduct.skus.length > 1) {
              _handleActionForMultipleSkus(
                product: snapshot.selectedProduct,
                storeName: snapshot.selectedMerchant.businessName,
              );
              return;
            }
            snapshot.selectedProduct.count =
                ((snapshot.selectedProduct?.count ?? 0) - 1)
                    .clamp(0, double.nan);
            snapshot.removeFromCart(snapshot.selectedProduct);
          },
          value: _getItemCount(snapshot.localCartItems,
                      snapshot.selectedProduct.productId) ==
                  0
              ? tr("new_changes.add")
              : _getItemCount(snapshot.localCartItems,
                      snapshot.selectedProduct.productId)
                  .toString(),
        );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();
  Product selectedProduct;
  Business selectedMerchant;
  List<Product> localCartItems;
  Function(Product, BuildContext) addToCart;
  Function(Product) removeFromCart;

  _ViewModel.build({
    this.selectedProduct,
    this.selectedMerchant,
    this.localCartItems,
    this.addToCart,
    this.removeFromCart,
  }) : super(equals: [selectedProduct, selectedMerchant, localCartItems]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      selectedProduct: state.productState.selectedProductForDetails,
      selectedMerchant: state.productState.selectedMerchant,
      localCartItems: state.productState.localCartItems,
      addToCart: (item, context) {
        dispatch(AddToCartLocalAction(product: item, context: context));
      },
      removeFromCart: (item) {
        dispatch(RemoveFromCartLocalAction(product: item));
      },
    );
  }
}
