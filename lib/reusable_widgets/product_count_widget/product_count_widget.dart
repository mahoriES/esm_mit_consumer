import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/cart/views/cart_sku_bottom_sheet.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import '../../presentations/custom_confirmation_dialog.dart';
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
  final int skuIndex;

  const ProductCountWidget({
    @required this.product,
    @required this.selectedMerchant,
    @required this.isSku,
    this.skuIndex,
  }) : assert(
            (isSku == true && skuIndex != null) ||
                (isSku == false && skuIndex == null),
            "skuIndex is required when isSkusBottomSheet = true");

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
        skuIndex: skuIndex,
      ),
      builder: (context, snapshot) {
        return snapshot.getItemCount() == 0
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
                count: snapshot.getItemCount(),
              );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  final Product product;
  final Business selectedMerchant;
  final bool isSku;
  final int skuIndex;

  _ViewModel(
      {@required this.product,
      @required this.selectedMerchant,
      @required this.isSku,
      @required this.skuIndex});

  List<Product> localCartItems;
  Function(bool, VoidCallback, BuildContext) updateCart;
  int Function() getItemCount;
  Business cartMerchant;

  _ViewModel.build({
    this.product,
    this.selectedMerchant,
    this.isSku,
    this.skuIndex,
    this.localCartItems,
    this.updateCart,
    this.getItemCount,
    this.cartMerchant,
  }) : super(equals: [localCartItems, cartMerchant]);

  bool get isItemOutOfStock =>
      isSku ? !product.skus[skuIndex].inStock : !product.inStock;

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      product: this.product,
      selectedMerchant: this.selectedMerchant,
      isSku: this.isSku,
      skuIndex: this.skuIndex,
      localCartItems: state.cartState.localCartItems,
      cartMerchant: state.cartState.cartMerchant,
      getItemCount: () {
        if (state.cartState.localCartItems.isEmpty) return 0;
        if (isSku) {
          Product prod = state.cartState.localCartItems.firstWhere(
            (element) {
              return element.productId == product.productId &&
                  element.selectedSkuId ==
                      product.skus[skuIndex].skuId.toString();
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
          BuildContext context) {
        // if product skus are null or 0 then show error message.
        if (product.skus?.isEmpty ?? true) {
          Fluttertoast.showToast(msg: 'Item not available');
        }

        // if there are multiple skus , show bottom sheet with sku items.
        if (!isSku && product.skus.length > 1) {
          showMultipleSkuOptions();
          return;
        }

        bool isDiffrentMerchantAddedInCart =
            state.cartState.cartMerchant != null &&
                state.cartState.cartMerchant.businessId !=
                    selectedMerchant.businessId;

        if (isDiffrentMerchantAddedInCart) {
          showDialog(
            context: context,
            barrierDismissible: false,
            child: CustomConfirmationDialog(
              title: tr("product_details.replace_cart_items"),
              message: tr('new_changes.clear_info'),
              positiveButtonText: tr('new_changes.continue'),
              negativeButtonText: tr("screen_account.cancel"),
              positiveAction: () async {
                Navigator.pop(context);
                await CartDataSource.deleteCartMerchant();
                await CartDataSource.deleteAllProducts();
                await CartDataSource.insertCartMerchant(selectedMerchant);
                await dispatchFuture(UpdateCartMerchantAction());
                Business updatedMerchant =
                    await CartDataSource.getCartMerchant();

                if (updatedMerchant.businessId == selectedMerchant.businessId) {
                  _updateQuantity(
                    isAddAction,
                    () => dispatch(
                      AddToCartLocalAction(
                        product: product,
                        selectedMerchant: selectedMerchant,
                      ),
                    ),
                    () => dispatch(RemoveFromCartAction(product: product)),
                  );
                }
              },
            ),
          );
        } else {
          _updateQuantity(
            isAddAction,
            () => dispatch(
              AddToCartLocalAction(
                product: product,
                selectedMerchant: selectedMerchant,
              ),
            ),
            () => dispatch(RemoveFromCartAction(product: product)),
          );
        }
      },
    );
  }

  _updateQuantity(
    bool isAddAction,
    VoidCallback addAction,
    VoidCallback removeAction,
  ) {
    // increment/decrement the sku count.
    product.selectedSkuIndex = isSku ? skuIndex : 0;

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
