import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartCount extends StatelessWidget {
  final Function(BuildContext context, _ViewModel count) builder;

  CartCount({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: builder,
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  List<Product> cartListDataSource;
  List<Product> localCart;
  List<JITProduct> localFreeFormItems;
  double getCartTotal;
  Function getCartTotalPrice;
  VoidCallback navigateToCart;

  _ViewModel();

  _ViewModel.build(
      {this.cartListDataSource,
      this.getCartTotalPrice,
      this.localFreeFormItems,
      this.navigateToCart,
      this.localCart,
      this.getCartTotal})
      : super(equals: [
          cartListDataSource,
          localCart,
          getCartTotal,
          localFreeFormItems
        ]);

  bool allItemsHaveZeroQuantity(List<JITProduct> givenList) {
    for (final item in givenList) {
      if (item.quantity != 0 && item.quantity != null) return false;
    }
    return true;
  }

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      cartListDataSource: [],
      //state.productState.cartListingDataSource.items,
      localCart: state.productState.localCartItems,
      localFreeFormItems: state.productState.localFreeFormCartItems,
      navigateToCart: () {
        dispatch(NavigateAction.pushNamed('/CartView'));
      },
      getCartTotalPrice: () {
        if (state.productState.localCartItems.isNotEmpty &&
            (state.productState.localFreeFormCartItems.isEmpty ||
                allItemsHaveZeroQuantity(
                    state.productState.localFreeFormCartItems))) {
          final formatCurrency = new NumberFormat.simpleCurrency(
            name: "INR",
          );
          var total =
              state.productState.localCartItems.fold(0, (previous, current) {
                    double price = double.parse(
                            (current.skus[current.selectedVariant].basePrice /
                                    100)
                                .toString()) *
                        current.count;

                    return (double.parse(previous.toString()) + price);
                  }) ??
                  0.0;

          return formatCurrency.format(total.toDouble());
        } else if (state.productState.localCartItems.isNotEmpty ||
            state.productState.localFreeFormCartItems.isNotEmpty) {
          var totalItemCount = 0;
          state.productState.localCartItems.forEach((element) {
            totalItemCount += element.count;
          });
          state.productState.localFreeFormCartItems.forEach((element) {
            totalItemCount += element.quantity;
          });
          return "${totalItemCount.toString()} Items";
        } else {
          return "Cart is empty";
        }
      },
      getCartTotal: 0.0,
    );
  }
}

class BottomView extends StatefulWidget {
  final String storeName;
  final String buttonTitle;
  final VoidCallback didPressButton;
  final double height;

  const BottomView({
    Key key,
    this.storeName,
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
          return Container(
            height: widget.height,
            padding: EdgeInsets.only(
              left: 16,
              right: 14,
            ),
//                    margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x65e7eaf0),
                  offset: Offset(0, -8),
                  blurRadius: 15,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: CartCount(builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Spacer(),
                          // TOTAL
                          Text("cart.total",
                                  style: const TextStyle(
                                      color: const Color(0xff515c6f),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "JosefinSans",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 10.0),
                                  textAlign: TextAlign.left)
                              .tr(),
                          SizedBox(
                            height: 3,
                          ),
                          // ₹ 55.00
                          Text(snapshot.getCartTotalPrice(),
                              style: const TextStyle(
                                  color: const Color(0xff515c6f),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "JosefinSans",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20.0),
                              textAlign: TextAlign.left),
                          SizedBox(
                            height: 3,
                          ),

                          // Organic Store

                          FutureBuilder(
                            future: CartDataSource.getListOfMerchants(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Business>> snapshot) {
                              return (snapshot.data == null ||
                                      snapshot.data.isEmpty)
                                  ? Container()
                                  : Text(snapshot.data.first.businessName ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: const Color(0xff727c8e),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Avenir-Medium",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.0),
                                      textAlign: TextAlign.left);
                            },
                          ),

                          Spacer(),
                        ],
                      ),
                    );
                  }),
                ),
                InkWell(
                  onTap: () {
                    widget.didPressButton();
                  },
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      height: 46,
                      width: widget.buttonTitle == tr('cart.view_cart')
                          ? 120
                          : 160,
                      decoration: BoxDecoration(
                        color: AppColors.icColors,
                        borderRadius: BorderRadius.circular(23),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              snapshot
                                      .getCartTotalPrice()
                                      .toString()
                                      .contains("Items")
                                  ? "SEND REQUEST"
                                  : widget.buttonTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Avenir',
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
