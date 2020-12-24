import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/reusable_widgets/product_count_widget/widgets/cart_sku_bottom_sheet.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
part 'widgets/add_button.dart';
part 'widgets/stepper_button.dart';

// A common widget to handle item quantity flow in cart.
// This contains method to add and remove an item from cart.

class ProductCountWidget extends StatelessWidget {
  final Product product;
  final Business selectedMerchant;

  // This value is true when button is used for sku and false when used for product.

  // when there are multiple skus for a product, a bottom sheet is shown on tap
  // so if the button is being used in that bottom sheet then keep isSkusBottomSheet = true.
  // otherwise it would be false.

  final bool isSku;

  // If isSku is true , then skuIndex is required. otherwise ignore this value.

  const ProductCountWidget({
    @required this.product,
    @required this.selectedMerchant,
    this.isSku = false,
  });

  @override
  Widget build(BuildContext context) {
    void _showMultipleSkusBottomSheet() {
      showModalBottomSheet(
        context: context,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        builder: (context) => Container(
          child: SkuBottomSheet(
            product: product,
            selectedMerchant: selectedMerchant,
          ),
        ),
      );
    }

    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(
        product: product,
        selectedMerchant: selectedMerchant,
        isSku: isSku,
      ),
      builder: (context, snapshot) {
        final int count = snapshot.getItemCount();

        return count == 0
            ? _AddButton(
                isDisabled: snapshot.isItemOutOfStock,
                buttonAction: () => snapshot.updateCart(
                  true,
                  _showMultipleSkusBottomSheet,
                  context,
                ),
              )
            : _StepperButton(
                buttonAction: (bool isAddAction) => snapshot.updateCart(
                  isAddAction,
                  _showMultipleSkusBottomSheet,
                  context,
                ),
                count: count,
              );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  final Product product;
  final Business selectedMerchant;
  final bool isSku;

  _ViewModel({
    @required this.product,
    @required this.selectedMerchant,
    @required this.isSku,
  });

  List<Product> localCartItems;
  Function(bool, VoidCallback, BuildContext) updateCart;
  int Function() getItemCount;
  Business cartMerchant;

  _ViewModel.build({
    this.product,
    this.selectedMerchant,
    this.isSku,
    this.localCartItems,
    this.updateCart,
    this.getItemCount,
    this.cartMerchant,
  }) : super(equals: [localCartItems, cartMerchant]);

  bool get isItemOutOfStock => isSku
      ? !product.skus[product.selectedSkuIndex].inStock
      : !product.inStock;

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      product: this.product,
      selectedMerchant: this.selectedMerchant,
      isSku: this.isSku,
      localCartItems: state.cartState.localCartItems,
      cartMerchant: state.cartState.cartMerchant,
      getItemCount: () {
        if (state.cartState.localCartItems.isEmpty) return 0;
        if (isSku) {
          Product prod = state.cartState.localCartItems.firstWhere(
            (element) {
              return element.productId == product.productId &&
                  element.selectedSkuId == product.selectedSkuId;
            },
            orElse: () => null,
          );
          return prod?.count ?? 0;
        } else {
          int count = 0;
          state.cartState.localCartItems.forEach((element) {
            if (element.productId == product.productId) count += element.count;
          });
          return count;
        }
      },
      updateCart: (bool isAddAction, VoidCallback showMultipleSkuOptions,
          BuildContext context) async {
        // if product skus are null or 0 then show error message.
        if (product.skus?.isEmpty ?? true) {
          Fluttertoast.showToast(msg: 'Item not available');
          return;
        }

        // if there are multiple skus , show bottom sheet with sku items.
        if (!isSku && product.skus.length > 1) {
          showMultipleSkuOptions();
          return;
        }

        dispatch(
          CheckToReplaceCartAction(
            selectedMerchant: selectedMerchant,
            onSuccess: () {
              _updateQuantity(
                isAddAction: isAddAction,
                addAction: () => dispatch(
                  AddToCartLocalAction(
                    product: product,
                    selectedMerchant: selectedMerchant,
                  ),
                ),
                removeAction: () =>
                    dispatch(RemoveFromCartAction(product: product)),
              );
            },
            context: context,
          ),
        );
      },
    );
  }

  _updateQuantity({
    @required bool isAddAction,
    @required VoidCallback addAction,
    @required VoidCallback removeAction,
  }) {
    // increment/decrement the sku count.

    Product productInLocalCart = state.cartState.localCartItems?.firstWhere(
      (element) {
        return element.productId == product.productId &&
            element.selectedSkuId == product.selectedSkuId;
      },
      orElse: () => null,
    );

    int count = productInLocalCart?.count ?? 0;

    product.count = isAddAction
        ? ++count
        : count == 0
            ? 0
            : --count;
    // update the cart accordingly in app state.
    if (isAddAction) {
      addAction();
    } else {
      removeAction();
    }
  }
}
