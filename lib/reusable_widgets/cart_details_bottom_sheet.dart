import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartDetailsBottomSheet extends StatelessWidget {
  final bool isOnCartScreen;

  const CartDetailsBottomSheet({this.isOnCartScreen = false, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) => AnimatedContainer(
        height:
            snapshot.totalCount == 0 ? 0 : AppSizes.cartTotalBottomViewHeight,
        duration: Duration(milliseconds: 300),
        child: Container(
          height: AppSizes.cartTotalBottomViewHeight,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    snapshot.itemsCountString.toUpperCase(),
                    style: CustomTheme.of(context)
                        .textStyles
                        .sectionHeading2Positive,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: isOnCartScreen
                      ? CustomTheme.of(context).colors.secondaryColor
                      : CustomTheme.of(context).colors.positiveColor,
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: () => isOnCartScreen
                          ? snapshot.sendRequest()
                          : snapshot.navigateToCart(),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isOnCartScreen
                                  ? Icons.send
                                  : Icons.shopping_cart_outlined,
                              color: CustomTheme.of(context)
                                  .colors
                                  .backgroundColor,
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                isOnCartScreen
                                    ? tr("cart.send_request")
                                    : tr("cart.view_cart"),
                                style: CustomTheme.of(context)
                                    .textStyles
                                    .sectionHeading3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  List<Product> productsList;
  List<String> customerNoteImages;
  VoidCallback sendRequest;
  VoidCallback navigateToCart;

  _ViewModel.build({
    this.productsList,
    this.customerNoteImages,
    this.sendRequest,
    this.navigateToCart,
  }) : super(equals: [productsList, customerNoteImages]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      productsList: state.cartState.localCartItems ?? [],
      customerNoteImages: state.cartState.customerNoteImages ?? [],
      navigateToCart: () {
        dispatch(NavigateAction.pushNamed(RouteNames.CART_VIEW));
      },
      sendRequest: () {
        if (state.cartState.selectedDeliveryType ==
                DeliveryType.DeliveryToHome &&
            state.addressState.selectedAddressForDelivery == null) {
          Fluttertoast.showToast(msg: "cart.no_address_error".tr());
        } else {
          PlaceOrderRequest orderRequest = new PlaceOrderRequest(
            businessId: state.cartState.cartMerchant.businessId,
            deliveryType: state.cartState.selectedDeliveryType,
            orderItems: List.generate(
              state.cartState.localCartItems.length,
              (index) => OrderItems.fromProductModel(
                state.cartState.localCartItems[index],
              ),
            ),
            customerNoteImages: state.cartState.customerNoteImages,
            deliveryAddressId:
                state.addressState.selectedAddressForDelivery?.addressId,
            customerNote: state.cartState.customerNoteMessage.text,
          );
          dispatch(GetMerchantStatusAndPlaceOrderAction(request: orderRequest));
        }
      },
    );
  }

  int get productsCount => productsList.length;
  int get customerNoteImagesCount => customerNoteImages.length;
  int get totalCount => productsCount + customerNoteImagesCount;

  String get itemsCountString {
    if (totalCount == 0) return "";
    return (productsCount > 0
            ? ("$productsCount " +
                tr("cart.${productsCount > 1 ? 'items' : 'item'}"))
            : "") +
        ((productsCount > 0 && customerNoteImagesCount > 0) ? " , " : "") +
        (customerNoteImagesCount > 0
            ? ("$customerNoteImagesCount " +
                tr("cart.${customerNoteImagesCount > 1 ? 'lists' : 'list'}"))
            : "");
  }
}
