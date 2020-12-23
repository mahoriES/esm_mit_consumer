import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eSamudaay/utilities/size_config.dart';

// TODO : This should be a global widget.

class _ViewModel extends BaseModel<AppState> {
  List<Product> localCart;
  List<JITProduct> localFreeFormItems;
  Function() getCartTotalPrice;

  _ViewModel();

  _ViewModel.build({
    this.getCartTotalPrice,
    this.localFreeFormItems,
    this.localCart,
  }) : super(equals: [localCart, localFreeFormItems]);

  bool allItemsHaveZeroQuantity(List<JITProduct> givenList) {
    for (final item in givenList) {
      if (item.quantity != 0 && item.quantity != null) return false;
    }
    return true;
  }

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      localCart: state.cartState.localCartItems,
      localFreeFormItems: state.cartState.localFreeFormCartItems,
      // TODO : optimize getCartTotalPrice.
      getCartTotalPrice: () {
        if (state.cartState.localCartItems.isNotEmpty &&
            (state.cartState.localFreeFormCartItems.isEmpty ||
                allItemsHaveZeroQuantity(
                    state.cartState.localFreeFormCartItems))) {
          final formatCurrency = new NumberFormat.simpleCurrency(
            name: "INR",
          );
          var total =
              state.cartState.localCartItems.fold(0, (previous, current) {
                    double price = current.selectedSkuPrice * current.count;

                    return (double.parse(previous.toString()) + price);
                  }) ??
                  0.0;
          if (state.cartState.charges != null &&
              state.cartState.charges != null) {
            // TODO : this widget will be refactored.
            // state.cartState.charges.forEach((element) {
            //   debugPrint('Getting here to add price ${element.chargeValue}');
            //   if (element.businessId ==
            //       state.cartState.cartMerchant.businessId) {
            //     debugPrint('PRice to be added ${element.chargeValue}');
            //     total += (element.chargeValue / 100).toDouble();
            //   }
            // });
          } else {
            debugPrint('This is null man:(');
          }
          return formatCurrency.format(total.toDouble());
        } else if (state.cartState.localCartItems.isNotEmpty ||
            state.cartState.localFreeFormCartItems.isNotEmpty) {
          var totalItemCount = 0;
          state.cartState.localCartItems.forEach((element) {
            totalItemCount += element.count;
          });
          state.cartState.localFreeFormCartItems.forEach((element) {
            totalItemCount += element.quantity;
          });
          return "${totalItemCount.toString()} Items";
        } else {
          return "Cart is empty";
        }
      },
    );
  }
}

class BottomView extends StatefulWidget {
  final String buttonTitle;
  final VoidCallback didPressButton;
  final double height;

  const BottomView({
    Key key,
    this.didPressButton,
    this.buttonTitle,
    this.height,
  }) : super(key: key);

  @override
  _BottomViewState createState() => _BottomViewState();
}

class _BottomViewState extends State<BottomView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        // this widget should be active only if there are nonZero items in the cart.
        bool isActive = snapshot.localFreeFormItems.isNotEmpty ||
            snapshot.localCart.isNotEmpty;
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: CustomTheme.of(context).colors.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: CustomTheme.of(context).colors.shadowColor,
                offset: Offset(0, -1),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 24.toWidth, right: 4.toWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${snapshot.localCart.length} ${(snapshot.localCart.length > 1 ? tr("product_details.items") : tr("product_details.item")).toUpperCase()}",
                        style: CustomTheme.of(context)
                            .textStyles
                            .body1
                            .copyWith(
                              color:
                                  CustomTheme.of(context).colors.positiveColor,
                            ),
                      ),
                      SizedBox(height: 3.toHeight),
                      Flexible(
                        child: FittedBox(
                          child: RichText(
                            text: TextSpan(
                              text: snapshot.getCartTotalPrice(),
                              style: CustomTheme.of(context)
                                  .textStyles
                                  .merchantCardTitle
                                  .copyWith(
                                    color: CustomTheme.of(context)
                                        .colors
                                        .positiveColor,
                                    fontSize: 20.toFont,
                                    height: 1.35,
                                  ),
                              children: [
                                TextSpan(
                                  text: snapshot.getCartTotalPrice() ==
                                          "Cart is empty"
                                      ? ""
                                      : "  + taxes",
                                  style: CustomTheme.of(context)
                                      .textStyles
                                      .body1
                                      .copyWith(
                                        color: CustomTheme.of(context)
                                            .colors
                                            .positiveColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: isActive ? widget.didPressButton : null,
                  child: Container(
                    color: isActive
                        ? CustomTheme.of(context).colors.positiveColor
                        : CustomTheme.of(context).colors.disabledAreaColor,
                    height: widget.height,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 24.toFont,
                          color: CustomTheme.of(context).colors.backgroundColor,
                        ),
                        SizedBox(width: 15.toWidth),
                        Text(
                          snapshot
                                  .getCartTotalPrice()
                                  .toString()
                                  .contains("Items")
                              // TODO : Doesn't seem like a good logic
                              ? "SEND REQUEST"
                              : widget.buttonTitle,
                          style: CustomTheme.of(context)
                              .textStyles
                              .sectionHeading2
                              .copyWith(
                                color: CustomTheme.of(context)
                                    .colors
                                    .backgroundColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
