import 'dart:math';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/Profile/model/profile_update_model.dart';
import 'package:eSamudaay/modules/address/models/addess_models.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/cart/models/charge_details_response.dart';
import 'package:eSamudaay/modules/cart/views/cart_bottom_view.dart';
import 'package:eSamudaay/modules/home/actions/home_page_actions.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/modules/store_details/views/stepper_view.dart';
import 'package:eSamudaay/modules/store_details/views/store_categories_details_view.dart';
import 'package:eSamudaay/modules/store_details/views/store_product_listing_view.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/custom_widgets.dart';
import 'package:eSamudaay/utilities/user_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CartView extends StatefulWidget {
  int radioValue = 0;
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  TextEditingController requestController = TextEditingController();
  String deliveryCharge = "0";
  double totalValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.icColors, //change your color here
        ),
        centerTitle: false,
//        titleSpacing: 0.0,
//        leading: IconButton(
//            icon: Icon(
//              Icons.arrow_back,
//              color: Colors.black,
//            ),
//            onPressed: () {
//              store.dispatch(GetCartFromLocal());
//              Navigator.pop(context);
//            }),
        title: // Cart
            Text('cart.title',
                    style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Avenir-Medium",
                        fontStyle: FontStyle.normal,
                        fontSize: 20.0),
                    textAlign: TextAlign.left)
                .tr(),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: StoreConnector<AppState, _ViewModel>(
          model: _ViewModel(),
          onInit: (store) {
            widget.radioValue = widget.radioValue == 0
                ? store.state.productState.selectedMerchand != null
                    ? store.state.productState.selectedMerchand.hasDelivery
                        ? 1
                        : 2
                    : 0
                : widget.radioValue;
            if (store.state.productState.localCartItems.isNotEmpty) {
              store.dispatch(GetOrderTaxAction());
            }
          },
          builder: (context, snapshot) {
            return ModalProgressHUD(
              progressIndicator: Card(
                child: Image.asset(
                  'assets/images/indicator.gif',
                  height: 75,
                  width: 75,
                ),
              ),
              inAsyncCall: snapshot.loadingStatus == LoadingStatusApp.loading,
              child: Container(
                child: snapshot.localCart.isEmpty
                    ? snapshot.loadingStatus != LoadingStatusApp.loading
                        ? EmptyView()
                        : Container()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: ListView(
                                shrinkWrap: true,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.localCart.length,
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          height: 10,
                                        );
                                      },
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                            child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                      snapshot.localCart[index]
                                                          .productName,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff515c6f),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              "Avenir-Medium",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 15.0),
                                                      textAlign:
                                                          TextAlign.left),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      CSStepper(
                                                        value: snapshot
                                                            .localCart[index]
                                                            .count
                                                            .toString(),
                                                        addButtonAction: () {
                                                          var item = snapshot
                                                              .localCart[index];
                                                          item.count =
                                                              ((item?.count ??
                                                                          0) +
                                                                      1)
                                                                  .clamp(
                                                                      0,
                                                                      double
                                                                          .nan);
                                                          snapshot.addToCart(
                                                              item, context);
                                                          snapshot.getOrderTax(
                                                              widget
                                                                  .radioValue);
                                                        },
                                                        removeButtonAction: () {
                                                          var item = snapshot
                                                              .localCart[index];
                                                          item.count =
                                                              ((item?.count ??
                                                                          0) -
                                                                      1)
                                                                  .clamp(
                                                                      0,
                                                                      double
                                                                          .nan);
                                                          snapshot
                                                              .removeFromCart(
                                                                  item);
                                                          snapshot.getOrderTax(
                                                              widget
                                                                  .radioValue);
                                                        },
                                                      ),
                                                      // ₹ 55.00
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            "₹ ${snapshot.localCart[index].skus[snapshot.localCart[index].selectedVariant].basePrice / 100}",
                                                            style: const TextStyle(
                                                                color: const Color(
                                                                    0xff5091cd),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    "Avenir-Medium",
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 18.0),
                                                            textAlign:
                                                                TextAlign.left),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            // 500GMS
                                            Text(
                                                snapshot
                                                        .localCart[index]
                                                        .skus
                                                        [snapshot.localCart[index]
                                                          .selectedVariant]
                                                        .variationOptions
                                                        .weight ??
                                                    "",
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xffa7a7a7),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Avenir-Medium",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14.0),
                                                textAlign: TextAlign.left)
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        ));
                                      },
                                    ),
                                  ),
                                  MySeparator(),
                                  Container(
                                      height: 60,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: // Delivery Available
                                          Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8),
                                                child: snapshot.selectedMerchant
                                                        .hasDelivery
                                                    ? Image.asset(
                                                        'assets/images/delivery.png')
                                                    : Image.asset(
                                                        'assets/images/no_delivery.png'),
                                              ),
                                              Text(
                                                  snapshot.selectedMerchant
                                                          .hasDelivery
                                                      ? tr("shop.delivery_ok")
                                                      : tr("shop.delivery_no"),
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff6f6f6f),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          "Avenir-Medium",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16.0),
                                                  textAlign: TextAlign.left),
                                            ],
                                          ),
                                          Container(
                                            child: // Add more
                                                Material(
                                              type: MaterialType.transparency,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.add,
                                                      size: 12.0,
                                                      color: Color(0xff5091cd),
                                                    ),
                                                    Text("new_changes.add_more",
                                                            style: const TextStyle(
                                                                color: const Color(
                                                                    0xff5091cd),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontFamily:
                                                                    "Avenir-Medium",
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 12.0),
                                                            textAlign: TextAlign
                                                                .center)
                                                        .tr(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(boxShadow: [
                                        BoxShadow(
                                            color: const Color(0x29000000),
                                            offset: Offset(0, 3),
                                            blurRadius: 6,
                                            spreadRadius: 0)
                                      ], color: const Color(0xffffffff))),
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: TextField(
                                      style: const TextStyle(
                                          color: const Color(0xff796c6c),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Avenir-Medium",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                      decoration: const InputDecoration(
                                        prefixIcon: ImageIcon(AssetImage(
                                            'assets/images/notepad.png')),
                                        hintText:
                                            'Any Request to the Merchant?',
                                        labelText:
                                            'Any Request to the Merchant?',
                                      ),
                                      autofocus: false,
                                      maxLines: null,
                                      controller: requestController,
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    padding: EdgeInsets.only(
                                        left: 18,
                                        top: 20,
                                        bottom: 13,
                                        right: 22),
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        // Payment Details
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text("cart.payment_details",
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff000000),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          "Avenir-Medium",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16.0),
                                                  textAlign: TextAlign.center)
                                              .tr(),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Column(
                                            children: <Widget>[
                                              ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    snapshot.charges.length + 1,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return index == 0
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            // Item Total
                                                            Text("screen_order.item_total",
                                                                    style: const TextStyle(
                                                                        color: const Color(
                                                                            0xff696666),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontFamily:
                                                                            "Avenir-Medium",
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .normal,
                                                                        fontSize:
                                                                            16.0),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left)
                                                                .tr(), // ₹ 175.00
                                                            Text(
                                                                "₹ ${snapshot.getCartTotal()}",
                                                                style: const TextStyle(
                                                                    color: const Color(
                                                                        0xff696666),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        "Avenir-Medium",
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        16.0),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left)
                                                          ],
                                                        )
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            // Item Total
                                                            Text(
                                                                snapshot
                                                                    .charges[
                                                                        index -
                                                                            1]
                                                                    .chargeName,
                                                                style: const TextStyle(
                                                                    color: const Color(
                                                                        0xff696666),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        "Avenir-Medium",
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        16.0),
                                                                textAlign: TextAlign
                                                                    .left), // ₹ 175.00
                                                            Text(
                                                                snapshot
                                                                            .charges[index -
                                                                                1]
                                                                            .chargeName
                                                                            .contains(
                                                                                "DELIVERY") &&
                                                                        widget.radioValue ==
                                                                            2
                                                                    ? "0"
                                                                    : "₹ ${snapshot.charges[index - 1].chargeValue / 100}",
                                                                style: const TextStyle(
                                                                    color: const Color(
                                                                        0xff696666),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        "Avenir-Medium",
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        16.0),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left)
                                                          ],
                                                        );
                                                  return Container();
                                                },
                                                separatorBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Container(
                                                    height: 13,
                                                  );
                                                },
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      height: 0.5,
                                                      margin: EdgeInsets.only(
                                                          bottom: 10),
                                                      color: Colors.grey,
                                                    ),
                                                    // Amount to be paid
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text("cart.total_amount",
                                                                style: const TextStyle(
                                                                    color: const Color(
                                                                        0xff696666),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        "Avenir-Medium",
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        16.0),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left)
                                                            .tr(),
                                                        // ₹ 195.00
                                                        // ₹ 195.00
                                                        //update with addition of tax etc
                                                        Text(
                                                            "₹ ${snapshot.getOrderTax(widget.radioValue) ?? 0.0}",
                                                            style: const TextStyle(
                                                                color: const Color(
                                                                    0xff5091cd),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    "Avenir-Medium",
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 16.0),
                                                            textAlign:
                                                                TextAlign.left)
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 82,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Radio(
                                            activeColor: AppColors.icColors,
                                            value: 1,
                                            groupValue: snapshot
                                                    .selectedMerchant
                                                    .hasDelivery
                                                ? widget.radioValue
                                                : null,
                                            onChanged: ((value) {
                                              if (snapshot.selectedMerchant
                                                  .hasDelivery) {
                                                setState(() {
                                                  widget.radioValue = value;
                                                });
                                              }
                                            })),
                                        // Delivery
                                        Text('cart.delivery',
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff2f2e2e),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Avenir-Medium",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14.0),
                                                textAlign: TextAlign.left)
                                            .tr(),
                                        Radio(
                                            activeColor: AppColors.icColors,
                                            value: 2,
                                            groupValue: widget.radioValue,
                                            onChanged: ((value) {
                                              setState(() {
                                                widget.radioValue = value;
                                              });
                                            })),
                                        // Pickup
                                        Text('cart.pickup',
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff2f2e2e),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Avenir-Medium",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14.0),
                                                textAlign: TextAlign.left)
                                            .tr()
                                      ],
                                    ),
                                  ),
                                  snapshot.selectedMerchant.hasDelivery
                                      ? widget.radioValue != 1
                                          ? Container()
                                          : Container(
                                              color: Colors.white,
                                              padding: EdgeInsets.only(
                                                  top: 15, bottom: 15),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: ImageIcon(
                                                        AssetImage(
                                                            'assets/images/home41.png'),
                                                        color:
                                                            AppColors.icColors,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text("Deliver to:",
                                                              style: const TextStyle(
                                                                  color: const Color(
                                                                      0xff000000),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      "Avenir-Medium",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      16.0),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                          // NJRA135, Second cross road,  Indiranagar- 6987452
                                                          Text(
                                                              snapshot.address
                                                                  .prettyAddress ?? "",
                                                              style: const TextStyle(
                                                                  color:
                                                                      const Color(
                                                                          0xff4b4b4b),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      "Avenir-Medium",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      14.0),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left)
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                      : Container(
                                          color: Colors.white,
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 15),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8),
                                                  child: ImageIcon(
                                                    AssetImage(
                                                        'assets/images/pen2.png'),
                                                    color: AppColors.icColors,
                                                  ),
                                                ),
                                                // Door number 1244 ,  Indiranagar, 2nd cross road
                                                // Delivering to:
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text("cart.note",
                                                              style: const TextStyle(
                                                                  color: const Color(
                                                                      0xff000000),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      "Avenir-Medium",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      16.0),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center)
                                                          .tr(),
                                                      // NJRA135, Second cross road,  Indiranagar- 6987452
                                                      Text("cart.please_collect",
                                                              style: const TextStyle(
                                                                  color: const Color(
                                                                      0xff4b4b4b),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      "Avenir-Medium",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      14.0),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left)
                                                          .tr()
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                  snapshot.selectedMerchant.hasDelivery &&
                                          widget.radioValue == 1
                                      ? Container()
                                      : Container(
                                          color: Colors.white,
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 15),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8),
                                                  child: ImageIcon(
                                                    AssetImage(
                                                      'assets/images/path330.png',
                                                    ),
                                                    color: AppColors.icColors,
                                                  ),
                                                ),
                                                // Door number 1244 ,  Indiranagar, 2nd cross road
                                                // Delivering to:
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text("cart.store_address",
                                                              style: const TextStyle(
                                                                  color: const Color(
                                                                      0xff000000),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      "Avenir-Medium",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      16.0),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center)
                                                          .tr(),
                                                      // NJRA135, Second cross road,  Indiranagar- 6987452
                                                      Text(
                                                          snapshot
                                                                  .selectedMerchant
                                                                  ?.address
                                                                  ?.prettyAddress ??
                                                              "",
                                                          style: const TextStyle(
                                                              color: const Color(
                                                                  0xff4b4b4b),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  "Avenir-Medium",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 14.0),
                                                          textAlign:
                                                              TextAlign.left)
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15),
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8),
                                              child: Icon(
                                                Icons.error_outline,
                                                color: AppColors.mainColor,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                      "cart.confirm_order_detail",
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff000000),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              "Avenir-Medium",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14.0),
                                                      textAlign: TextAlign.left)
                                                  .tr(),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          BottomView(
                            storeName: snapshot.selectedMerchant.businessName,
                            buttonTitle: tr('cart.confirm_order'),
                            height: 80,
                            didPressButton: () async {
                              if (widget.radioValue == 0) {
                                Fluttertoast.showToast(
                                    msg: tr("new_changes.choose_one"));
//                                return;
                              } else {
                                var address = await UserManager.getAddress();
                                List<Product> cart =
                                    await CartDataSource.getListOfCartWith();
                                var merchats =
                                    await CartDataSource.getListOfMerchants();
                                PlaceOrderRequest request = PlaceOrderRequest();
                                request.businessId = merchats.first.businessId;
                                request.deliveryAddressId =
                                    widget.radioValue == 1
                                        ? address.addressId
                                        : null;
                                request.deliveryType = widget.radioValue == 1
                                    ? "DA_DELIVERY"
                                    : "SELF_PICK_UP";
                                request.orderItems = cart
                                    .map((e) => OrderItems(
                                        skuId: e.skus[e.selectedVariant].skuId,
                                        quantity: e.count))
                                    .toList();
                                request.customerNote =
                                    requestController.text ?? "";

                                snapshot.placeOrder(request);
                              }
                            },
                          )
                        ],
                      ),
              ),
            );
          }),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: ClipPath(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.45,
                    color: const Color(0xfff0f0f0),
                  ),
                  clipper: CustomClipPath(),
                ),
              ),
              Positioned(
                  bottom: 20,
                  right: MediaQuery.of(context).size.width * 0.15,
                  child: Image.asset(
                    'assets/images/clipart.png',
                    fit: BoxFit.cover,
                  )),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Text('cart.empty_cart',
                  style: const TextStyle(
                      color: const Color(0xff1f1f1f),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Avenir-Medium",
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                  textAlign: TextAlign.left)
              .tr(),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30),
            child: Text('cart.empty_hint',
                    style: const TextStyle(
                        color: const Color(0xff6f6d6d),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Avenir-Medium",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.center)
                .tr(),
          ),
          SizedBox(
            height: 30,
          ),
          StoreConnector<AppState, _ViewModel>(
              model: _ViewModel(),
              builder: (context, snapshot) {
                return InkWell(
                  onTap: () {
                    snapshot.navigateToStore();
                  },
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      height: 46,
                      width: 160,
                      decoration: BoxDecoration(
                        color: AppColors.icColors,
                        borderRadius: BorderRadius.circular(23),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'common.view_store',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Avenir-Medium-Medium',
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.center,
                            ).tr(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  List<Product> localCart;
  Function(Product, BuildContext) addToCart;
  Function(Product) removeFromCart;
  VoidCallback navigateToCart;
  Business selectedMerchant;
  List<Charge> charges;
  Function getCartTotal;
  Function(PlaceOrderRequest) placeOrder;
  Function(PlaceOrderRequest) getTaxOfOrder;
  Function(int) getOrderTax;
  LoadingStatusApp loadingStatus;
  Function(Business) updateSelectedMerchant;
  VoidCallback navigateToStore;
  Address address;
  Data user;
  _ViewModel();
  _ViewModel.build(
      {this.localCart,
      this.navigateToStore,
      this.charges,
      this.updateSelectedMerchant,
      this.placeOrder,
      this.user,
      this.getCartTotal,
      this.addToCart,
      this.removeFromCart,
      this.navigateToCart,
      this.selectedMerchant,
      this.address,
      this.getTaxOfOrder,
      this.loadingStatus,
      this.getOrderTax})
      : super(equals: [
          localCart,
          selectedMerchant,
          user,
          loadingStatus,
          address,
          charges
        ]);
  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        charges: state.productState.charges,
        address: state.authState.address,
        selectedMerchant: state.productState.selectedMerchand,
        localCart: state.productState.localCartItems,
        user: state.authState.user,
        loadingStatus: state.authState.loadingStatus,
        navigateToStore: () {
          dispatch(UpdateSelectedTabAction(0));
        },
        getCartTotal: () {
          if (state.productState.localCartItems.isNotEmpty) {
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

            return total.toDouble(); //formatCurrency.format(total.toDouble());
          } else {
            return 0.0;
          }
        },
        updateSelectedMerchant: (merchant) {
          dispatch(UpdateSelectedMerchantAction(selectedMerchant: merchant));
        },
        placeOrder: (request) {
          dispatch(GetMerchantStatusAndPlaceOrderAction(request: request));
        },
        getTaxOfOrder: (request) {
          dispatch(GetOrderTaxAction());
        },
        addToCart: (item, context) {
          dispatch(AddToCartLocalAction(product: item, context: context));
        },
        removeFromCart: (item) {
          dispatch(RemoveFromCartLocalAction(product: item));
        },
        navigateToCart: () {
          dispatch(NavigateAction.pushNamed('/CartView'));
        },
        getOrderTax: (value) {
          if (state.productState.localCartItems.isNotEmpty) {
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

            num sum = 0;
            state.productState.charges.forEach((e) {
              sum += e.chargeName.contains("DELIVERY") && value == 2
                  ? 0
                  : e.chargeValue / 100;
            });
            print(sum);

            return (total + sum)
                .toDouble(); //formatCurrency.format(total.toDouble());
          } else {
            return 0.0;
          }
        });
  }
}

extension Precision on double {
  double toPrecision(int fractionDigits) {
    double mod = pow(10, fractionDigits.toDouble());
    return ((this * mod).round().toDouble() / mod);
  }
}
