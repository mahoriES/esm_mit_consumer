import 'package:eSamudaay/modules/store_details/views/stepper_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/cart/views/cart_sku_bottom_sheet.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/redux/states/app_state.dart';

// This Widget is an extension of CSStepper.
// This contains method to add and remove an item from cart.
// Created a common widget as this is being used in multiple screens.

class ProductCountWidget extends StatelessWidget {
  final Product product;

  // This value is true when button is used for sku and false when used for product.

  // when there are multiple skus for a product, a bottom sheet is shown on tap
  // so if the button is being used in that bottom sheet then keep isSkusBottomSheet = true.
  // otherwise it would be false.

  final bool isSku;

  // If isSku is true , then skuIndex is required. otherwise ignore this value.
  final int skuIndex;

  const ProductCountWidget({
    @required this.product,
    @required this.isSku,
    this.skuIndex,
  }) : assert(
            (isSku == true && skuIndex != null) ||
                (isSku == false && skuIndex == null),
            "skuIndex is required when isSkusBottomSheet = true");

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        return CSStepper(
          fillColor: false,
          isDisabled:
              isSku ? !product.skus[skuIndex].inStock : !product.inStock,
          addButtonAction: () => _onTap(
            context: context,
            snapshot: snapshot,
            isAddAction: true,
          ),
          removeButtonAction: () => _onTap(
            context: context,
            snapshot: snapshot,
            isAddAction: false,
          ),
          count: isSku
              ? _getItemCountForSkus(
                  snapshot.localCartItems,
                  product,
                )
              : _getItemCountForProduct(
                  snapshot.localCartItems,
                  product.productId,
                ),
        );
      },
    );
  }

  _onTap({
    @required BuildContext context,
    @required _ViewModel snapshot,
    @required bool isAddAction,
  }) {
    // if isSku then increment/decrement the sku count.
    if (isSku) {
      product.selectedVariant = skuIndex;
      int count = _getItemCountForSkus(snapshot.localCartItems, product);
      product.count = isAddAction
          ? ++count
          : count == 0
              ? 0
              : --count;
      // update the cart accordingly in app state.
      if (isAddAction)
        snapshot.addToCart(product, context);
      else
        snapshot.removeFromCart(product);
    }
    // otherwise
    else {
      // if product skus are null or 0 then show error message.
      if (product.skus?.isEmpty ?? true) {
        Fluttertoast.showToast(msg: 'Item not available');
      }
      // otherwise
      else {
        // if there are multiple skus , show bottom sheet with sku items.
        if (product.skus.length > 1) {
          _handleActionForMultipleSkus(product: product, context: context);
        }
        // otherwise increment/decrement the product count.
        else {
          int count = product?.count ?? 0;
          product.count = isAddAction
              ? ++count
              : count == 0
                  ? 0
                  : --count;

          // update the cart accordingly in app state.
          if (isAddAction)
            snapshot.addToCart(product, context);
          else
            snapshot.removeFromCart(product);
        }
      }
    }
  }

  int _getItemCountForSkus(List<Product> localCartItems, Product product) {
    if (localCartItems.isEmpty) return 0;

    Product prod = localCartItems.firstWhere(
      (element) {
        return element.productId == product.productId &&
            element.skus[element.selectedVariant].variationOptions.weight ==
                product.skus[skuIndex].variationOptions.weight &&
            element.selectedVariant == skuIndex;
      },
      orElse: () => null,
    );
    return prod == null ? 0 : prod.count;
  }

  void _handleActionForMultipleSkus({
    @required Product product,
    @required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      builder: (context) => Container(
        child: SkuBottomSheet(product: product),
      ),
    );
  }

  int _getItemCountForProduct(List<Product> localCartItems, int productId) {
    int count = 0;
    localCartItems.forEach((element) {
      if (element.productId == productId) count += element.count;
    });
    return count;
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();
  List<Product> localCartItems;
  Function(Product, BuildContext) addToCart;
  Function(Product) removeFromCart;

  _ViewModel.build({
    this.localCartItems,
    this.addToCart,
    this.removeFromCart,
  }) : super(equals: [localCartItems]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
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
