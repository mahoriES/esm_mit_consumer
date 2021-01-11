import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/home/actions/home_page_actions.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/models/order_models.dart';
import 'package:eSamudaay/modules/orders/views/expandable_view.dart';
import 'package:eSamudaay/payments/razorpay/utility.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/store.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/custom_widgets.dart';
import 'package:eSamudaay/utilities/order_status_info.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/extensions.dart';

class OrdersView extends StatefulWidget {
  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {

  ScrollController _scrollController = new ScrollController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh(_ViewModel snapshot) async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    if (snapshot.getOrderListResponse.previous != null) {
    } else {
      snapshot.getOrderList(ApiURL.placeOrderUrl);
    }
    if (mounted)
      setState(() {
        _scrollController.animateTo(
          0.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      });
    _refreshController.refreshCompleted();
  }

  void _onLoading(_ViewModel snapshot) async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (snapshot.getOrderListResponse.next != null) {
      snapshot.getOrderList(snapshot.getOrderListResponse.next);
    }

    if (mounted) _refreshController.loadComplete();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: false,
          titleSpacing: 30.0,
          title: // Orders
              Text("screen_order.title",
                      style: const TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Avenir-Medium",
                          fontStyle: FontStyle.normal,
                          fontSize: 20.0),
                      textAlign: TextAlign.left)
                  .tr(),
        ),
        body: StoreConnector<AppState, _ViewModel>(
            model: _ViewModel(),
            onInit: (store) {
              store.dispatch(
                  GetOrderListAPIAction(orderRequestApi: ApiURL.placeOrderUrl));
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
                child: (snapshot.getOrderListResponse == null ||
                        snapshot.getOrderListResponse.results == null ||
                        snapshot.getOrderListResponse.results.isEmpty)
                    ? snapshot.loadingStatus != LoadingStatusApp.loading
                        ? buildEmptyView(context, snapshot)
                        : Container()
                    : Container(
                        child: SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          footer: CustomFooter(
                            loadStyle: LoadStyle.ShowWhenLoading,
                            builder: (BuildContext context, LoadStatus mode) =>
                                const CupertinoActivityIndicator(),
                          ),
                          controller: _refreshController,
                          onRefresh: () {
                            _onRefresh(snapshot);
                          },
                          onLoading: () {
                            _onLoading(snapshot);
                          },
                          child: ListView.separated(
                            controller: _scrollController,
                            //shrinkWrap: true,
                            itemBuilder:
                                (BuildContext context, int merchantIndex) {
                              return NewWidget(
                                orderId: snapshot.getOrderListResponse
                                    .results[merchantIndex].orderId,
                                snapshot: snapshot,
                                merchantIndex: merchantIndex,
                                orderStatus: snapshot.getOrderListResponse
                                    .results[merchantIndex].orderStatus,
                                deliveryStatus: snapshot.getOrderListResponse
                                    .results[merchantIndex].deliveryType,
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Container(
                                height: 20,
                                color: Color(0xfff2f2f2),
                              );
                            },
                            itemCount:
                                snapshot.getOrderListResponse.results.length,
                          ),
                        ),
                      ),
              );
            }));
  }

  Container buildEmptyView(BuildContext context, _ViewModel snapshot) {
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
          Text('screen_order.not_found',
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
            child: Text('screen_order.empty_content',
                    maxLines: 2,
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
          InkWell(
            onTap: () {
              snapshot.viewStore();
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
                          fontFamily: 'Avenir-Medium',
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ).tr(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewWidget extends StatefulWidget {
  final _ViewModel snapshot;
  final String orderId;
  final merchantIndex;
  final String orderStatus;
  final String deliveryStatus;

  const NewWidget({
    Key key,
    this.deliveryStatus,
    this.merchantIndex,
    this.orderStatus,
    this.orderId,
    this.snapshot,
  }) : super(key: key);

  @override
  _NewWidgetState createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ExpandableListView(
            merchantIndex: widget.merchantIndex,
            didExpand: (status) {
              setState(() {
                expanded = !status;
              });
            },
          ),
          OrderItemBottomView(
            snapshot: widget.snapshot,
            orderId: widget.orderId,
            index: widget.merchantIndex,
            expanded: expanded,
            orderStatus: widget.orderStatus,
            deliveryStatus: widget.deliveryStatus,
          )
        ],
      ),
    );
  }
}

class OrderItemBottomView extends StatefulWidget {
  final int index;
  final String orderId;
  final _ViewModel snapshot;
  final String orderStatus;
  final String deliveryStatus;
  final bool expanded;

  const OrderItemBottomView({
    Key key,
    this.index,
    this.orderStatus,
    this.expanded,
    this.orderId,
    this.snapshot,
    this.deliveryStatus,
  }) : super(key: key);

  @override
  _OrderItemBottomViewState createState() => _OrderItemBottomViewState();
}

class _OrderItemBottomViewState extends State<OrderItemBottomView> {

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();


  Widget buildOrderInfoLabels(
      String orderStatus, _ViewModel snapshot, BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: Align(alignment: Alignment.centerLeft, child: buildIcon),
        ),
        Expanded(
            flex: OrderStatusInfoGenerator.shouldShowOrderActionButton(
                    orderStatus)
                ? 60
                : 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  OrderStatusInfoGenerator.orderStatusTitleFromKey(
                      orderStatus, widget.deliveryStatus != "SELF_PICK_UP"),
                  style: TextStyle(
                      fontSize: AppSizes.itemSubtitle2FontSize,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: AppSizes.minorTopPadding.toHeight,
                ),
                Text(
                  OrderStatusInfoGenerator.orderStatusSubtitleFromKey(
                      orderStatus, widget.deliveryStatus != "SELF_PICK_UP"),
                  style: TextStyle(
                      fontSize: AppSizes.itemSubtitle3FontSize,
                      fontStyle: FontStyle.italic,
                      color: AppColors.greyishText),
                ),
              ],
            )),
        Expanded(
            flex: OrderStatusInfoGenerator.shouldShowOrderActionButton(
                    orderStatus)
                ? 40
                : 0,
            child: OrderStatusInfoGenerator.shouldShowOrderActionButton(
                    orderStatus)
                ? buildCustomButton(snapshot, context)
                : SizedBox.shrink()),
      ],
    );
  }

  Widget buildPaymentSubSection(_ViewModel snapshot, BuildContext context) {
    bool showButton =
        OrderStatusInfoGenerator.shouldShowPaymentButton(widget.orderStatus) &&
            snapshot.getOrderListResponse.results[widget.index].paymentInfo?.status !=
                'APPROVED' &&
            showPayment(snapshot.getOrderListResponse.results
                .firstWhere((element) => element.orderId == widget.orderId));
    return Row(
      children: [
        Expanded(
          flex: showButton ? 50 : 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                OrderStatusInfoGenerator.paymentStatusMessageFromKey(
                    snapshot.getOrderListResponse.results[widget.index].paymentInfo
                        ?.status,
                    via: (snapshot.getOrderListResponse.results[widget.index]
                        .paymentInfo?.paymentMadeVia),
                    amount: (snapshot.getOrderListResponse.results[widget.index]
                                .orderTotal /
                            100)
                        .withRupeePrefix),
                style: TextStyle(
                    color: AppColors.greyishText,
                    fontSize: AppSizes.itemSubtitle3FontSize),
              ),
            ],
          ),
        ),
        Expanded(
          flex: showButton ? 40 : 0,
          child: showButton
              ? buildPaymentButton(snapshot, context)
              : SizedBox.shrink(),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
      child: Column(
        children: <Widget>[
          buildOrderInfoLabels(widget.orderStatus, widget.snapshot, context),
          widget.orderStatus == "MERCHANT_UPDATED"
              ? Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      widget.snapshot.cancelOrder(
                          widget.snapshot.getOrderListResponse.results[widget.index].orderId,
                          widget.index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 8),
                      child: Container(
                        child: // Cancel order
                            Text("Cancel order",
                                style: const TextStyle(
                                    color: const Color(0xffe33a3a),
                                    fontWeight: FontWeight.w900,
                                    fontFamily: "Avenir-Medium",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              isButtonShow
                  ? SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: AppSizes.separatorPadding,
                          right: AppSizes.separatorPadding),
                      child: InkWell(
                        onTap: () async {
                          widget.snapshot.updateOrderId(widget.orderId);
                          if (widget.snapshot.getOrderListResponse.results[widget.index]
                                      .businessPhones !=
                                  null &&
                              widget.snapshot.getOrderListResponse.results[widget.index]
                                  .businessPhones.isNotEmpty) {
                            var url =
                                'tel:${widget.snapshot.getOrderListResponse.results[widget.index].businessPhones.first}';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "No contact details available.");
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.phone,
                              size: 20,
                              color: AppColors.icColors,
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                'new_changes.call',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Avenir-Medium',
                                  fontWeight: FontWeight.w800,
                                ),
                              ).tr(),
                            ),
                            // Support
                          ],
                        ),
                      ),
                    ),
              // Support
            ],
          ),
          (widget.orderStatus == "CREATED") && widget.expanded
              ? Padding(
                  padding: EdgeInsets.only(
                      top: 10.0.toHeight,
                      left: 10.0.toWidth,
                      right: 10.0.toWidth),
                  child: InkWell(
                    onTap: () async {
                      widget.snapshot.updateOrderId(widget.orderId);
                      if (widget.snapshot.getOrderListResponse.results[widget.index]
                                  .businessPhones !=
                              null &&
                          widget.snapshot.getOrderListResponse.results[widget.index]
                              .businessPhones.isNotEmpty) {
                        var url =
                            'tel:${widget.snapshot.getOrderListResponse.results[widget.index].businessPhones.first}';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "No contact details available.");
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.phone,
                          size: 20,
                          color: AppColors.icColors,
                        ),
                        Text(
                          'new_changes.call',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Avenir-Medium',
                            fontWeight: FontWeight.w800,
                          ),
                        ).tr(),
                        // Support
                      ],
                    ),
                  ),
                )
              : Container(),
          CustomDivider(),
          buildPaymentSubSection(widget.snapshot, context),
        ],
      ),
    );
  }

  bool showPayment(PlaceOrderResponse order) {
    if (["SUCCESS", "REFUNDED"].contains(order.paymentInfo.status))
      return false;
    if (widget.orderStatus == "CREATED" ||
        widget.orderStatus == "CUSTOMER_CANCELLED" ||
        widget.orderStatus == "MERCHANT_UPDATED" ||
        widget.orderStatus == "MERCHANT_CANCELLED") return false;
    return true;
  }

  bool get isButtonShow {
    if (widget.orderStatus == "CREATED" ||
        widget.orderStatus == "COMPLETED" ||
        widget.orderStatus == "REQUESTING_TO_DA" ||
        widget.orderStatus == "MERCHANT_UPDATED" ||
        widget.orderStatus == 'MERCHANT_ACCEPTED') {
      return true;
    } else if (widget.orderStatus == "READY_FOR_PICKUP") {
      if (widget.deliveryStatus == "SELF_PICK_UP")
        return true;
      else
        return true;
    } else {
      return false;
    }
  }

  Color buttonBkColor(PaymentInfo paymentInfo) {
    if (widget.orderStatus == "COMPLETED") {
      return AppColors.icColors;
    } else if (widget.orderStatus == "CREATED") {
      return AppColors.orange;
    } else {
      if (paymentInfo.upi == null) {
        return Colors.grey.shade300;
      }
      if (paymentInfo.status == "APPROVED") {
        return Colors.grey.shade300;
      } else {
        return AppColors.icColors;
      }
    }
  }

  CustomButton buildCustomButton(_ViewModel snapshot, BuildContext context) {
    return CustomButton(
      title: title,
      backgroundColor: buttonBkColor(
          snapshot.getOrderListResponse.results[widget.index].paymentInfo),
      didPresButton: () async {
        if (widget.orderStatus == "COMPLETED") {
          //reorder api
          store
              .dispatchFuture(GetOrderDetailsAPIAction(
                  orderId:
                      snapshot.getOrderListResponse.results[widget.index].orderId))
              .whenComplete(() async {
            PlaceOrderRequest request = PlaceOrderRequest();
            request.businessId =
                snapshot.getOrderListResponse.results[widget.index].businessId;
            request.deliveryAddressId = snapshot
                .getOrderListResponse.results[widget.index].deliveryAdress.addressId;
            request.deliveryType =
                snapshot.getOrderListResponse.results[widget.index].deliveryType;
            request.orderItems =
                snapshot.getOrderListResponse.results[widget.index].orderItems;
            snapshot.placeOrder(request);
          });
        } else if (widget.orderStatus == "MERCHANT_UPDATED") {
          //accept order api
          snapshot.acceptOrder(
              snapshot.getOrderListResponse.results[widget.index].orderId, widget.index);
        } else if (widget.orderStatus == "READY_FOR_PICKUP" &&
            widget.deliveryStatus == "SELF_PICK_UP") {
          snapshot.completeOrder(
              snapshot.getOrderListResponse.results[widget.index].orderId, widget.index);
        } else {
          //cancel order api
          snapshot.cancelOrder(
              snapshot.getOrderListResponse.results[widget.index].orderId, widget.index);
        }
      },
    );
  }

  Widget buildPaymentButton(_ViewModel snapshot, BuildContext context) {
    return RoundedLoadingButton(
      height: 39,
      controller: _btnController,
      color: CustomTheme.of(context).colors.positiveColor,
      successColor: CustomTheme.of(context).colors.positiveColor,
      onPressed: () async {
        await snapshot
            .getRazorpayCheckoutOptions(
                snapshot.getOrderListResponse.results[widget.index].orderId)
            .timeout(const Duration(seconds: 10));
        _btnController.reset();
        RazorpayUtility().checkout(store.state.orderPaymentCheckoutOptions,
            onSuccess: () {
          snapshot.getOrderList(ApiURL.placeOrderUrl);
        }, onFailure: () {});
      },
      child: Text(
        tr('screen_order.pay') +
            " ${(snapshot.getOrderListResponse.results[widget.index].orderTotal / 100).withRupeePrefix}",
        style: CustomTheme.of(context)
            .textStyles
            .cardTitle
            .copyWith(color: CustomTheme.of(context).colors.backgroundColor),
      ),
    );
  }

  String get title {
    if (widget.orderStatus == "CREATED") {
      return tr('screen_order.cancel_order');
    } else if (widget.orderStatus == "MERCHANT_ACCEPTED") {
      return tr('screen_order.Pay_via_upi');
    } else if (widget.orderStatus == "CUSTOMER_CANCELLED") {
      return tr('screen_order.cancelled_customer');
    } else if (widget.orderStatus == "MERCHANT_CANCELLED") {
      return tr('screen_order.cancelled_merchant') +
          " " +
          widget.snapshot.getOrderListResponse.results[widget.index].businessName;
    } else if (widget.orderStatus == "MERCHANT_UPDATED") {
      return tr('screen_order.accept_order');
    } else if (widget.orderStatus == "COMPLETED") {
      return tr('screen_order.re_order');
    } else if (widget.orderStatus == "READY_FOR_PICKUP") {
      if (widget.deliveryStatus == "SELF_PICK_UP")
        return tr('screen_order.pickup');
      else
        return tr('screen_order.Pay_via_upi');
    } else if (widget.orderStatus == "REQUESTING_TO_DA") {
      return tr('screen_order.Pay_via_upi');
    } else if (widget.orderStatus == "ASSIGNED_TO_DA") {
      return tr('screen_order.Pay_via_upi');
    } else if (widget.orderStatus == "PICKED_UP_BY_DA") {
      return tr('screen_order.Pay_via_upi');
    } else {
      return "";
    }
  }

  Widget get buildIcon {
    if (widget.orderStatus == "CREATED") {
      return ImageIcon(
        AssetImage('assets/images/refresh_1.png'),
        color: Color(0xffeb730c),
      );
    } else if (widget.orderStatus == "MERCHANT_ACCEPTED") {
      return Icon(
        Icons.check_circle_outline,
        color: Color(0xffa4c73f),
      );
    } else if (widget.orderStatus == "CUSTOMER_CANCELLED" ||
        widget.orderStatus == "MERCHANT_CANCELLED") {
      return Icon(
        Icons.cancel,
        color: Colors.red,
      );
    } else if (widget.orderStatus == "MERCHANT_UPDATED") {
      return Icon(
        Icons.info_outline,
        color: Colors.blue,
      );
    } else if (widget.orderStatus == "COMPLETED") {
      return Icon(
        Icons.check_circle_outline,
        color: AppColors.green,
      );
    } else if (widget.orderStatus == "READY_FOR_PICKUP") {
      return Icon(
        Icons.check_circle_outline,
        color: AppColors.green,
      );
    } else if (widget.orderStatus == "REQUESTING_TO_DA") {
      return Icon(
        Icons.check_circle_outline,
        color: AppColors.green,
      );
    } else if (widget.orderStatus == "ASSIGNED_TO_DA") {
      return Icon(Icons.account_box, color: AppColors.icColors);
    } else if (widget.orderStatus == "PICKED_UP_BY_DA") {
      return Icon(Icons.account_box, color: AppColors.icColors);
    } else
      return SizedBox.shrink();
  }
}

class CustomButton extends StatelessWidget {
  final didPresButton;
  final Color backgroundColor;
  final String title;

  const CustomButton({
    Key key,
    this.didPresButton,
    this.backgroundColor,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        didPresButton();
      },
      child: Container(
        height: 39,
//        width: 160,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(),
                Container(
                  child: Text(
                    title,
                    style: CustomTheme.of(context)
                        .textStyles
                        .cardTitle
                        .copyWith(
                            color:
                                CustomTheme.of(context).colors.backgroundColor),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 12,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrdersListView extends StatefulWidget {
  final String shopImage;
  final String name;
  final String date;
  final String price;
  final String orderId;
  final _ViewModel snapshot;
  final bool deliveryStatus;
  final String items;
  final bool isExpanded;

  const OrdersListView(
      {Key key,
      this.shopImage,
      this.orderId,
      this.isExpanded,
      this.items,
      this.name,
      this.deliveryStatus,
      this.date,
      this.price,
      this.snapshot})
      : super(key: key);

  @override
  _OrdersListViewState createState() => _OrdersListViewState();
}

class _OrdersListViewState extends State<OrdersListView>
    with SingleTickerProviderStateMixin {
  AnimationController rotationController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 79,
            height: 79,
            margin: new EdgeInsets.all(10.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 5.0, // has the effect of extending the shadow
                  offset: Offset(
                    5.0, // horizontal, move right 10
                    5.0, // vertical, move down 10
                  ),
                )
              ],
            ),
            child: widget.shopImage == null
                ? Image.asset(
                    "assets/images/shop1.png",
                    fit: BoxFit.cover,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.shopImage,
                        placeholder: (context, url) => Icon(
                              Icons.image,
                              size: 30,
                            ),
                        errorWidget: (context, url, error) => Center(
                              child: Icon(
                                Icons.image,
                                size: 30,
                              ),
                            )),
                  ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.name,
                      style: const TextStyle(
                          color: const Color(0xff2c2c2c),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Avenir-Medium",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      textAlign: TextAlign.left),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(widget.date,
                        style: const TextStyle(
                            color: const Color(0xff7c7c7c),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Avenir-Medium",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                        "${tr('new_changes.order_id')} : " + widget.orderId ??
                            "",
                        style: const TextStyle(
                            color: const Color(0xff7c7c7c),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Avenir-Medium",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 8),
                    child: Row(
                      children: <Widget>[
                        widget.items == ""
                            ? Container()
                            : Expanded(
                                child: Text(
                                    widget.items ?? "Milk, Egg, Bread, Etc ….",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: const Color(0xff7c7c7c),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Avenir-Medium",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.0),
                                    textAlign: TextAlign.left),
                              ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: widget.deliveryStatus
                            ? Image.asset('assets/images/delivery.png')
                            : Image.asset('assets/images/no_delivery.png'),
                      ),
                      Flexible(
                        child: Text(
                            widget.deliveryStatus
                                ? tr("shop.home_delivery_order")
                                : tr("shop.pickup_order"),
                            style: const TextStyle(
                                color: const Color(0xff7c7c7c),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Avenir-Medium",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                            textAlign: TextAlign.left),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              RotatedBox(
                quarterTurns: widget.isExpanded ? 0 : 3,
                child: Icon(
                  Icons.expand_more,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(widget.price,
                  style: const TextStyle(
                      color: const Color(0xff5091cd),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Avenir-Medium",
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0),
                  textAlign: TextAlign.left)
            ],
          )
        ],
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  GetOrderListResponse getOrderListResponse;
  Function(String orderId) updateOrderId;
  Function(String orderId) notifyPayment;
  Function viewStore;
  Function(PlaceOrderRequest) placeOrder;
  Function(String, int) acceptOrder;
  Function(String, int) cancelOrder;
  Function(String, int) completeOrder;
  LoadingStatusApp loadingStatus;
  Function(String) getOrderList;
  Future<void> Function(String) getRazorpayCheckoutOptions;

  _ViewModel();

  _ViewModel.build(
      {this.getOrderListResponse,
      this.placeOrder,
      this.updateOrderId,
      this.getRazorpayCheckoutOptions,
      this.notifyPayment,
      this.cancelOrder,
      this.acceptOrder,
      this.loadingStatus,
      this.viewStore,
      this.getOrderList,
      this.completeOrder})
      : super(equals: [
          getOrderListResponse,
          loadingStatus,
        ]);

  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        notifyPayment: (orderId) {
          dispatch(PaymentAPIAction(orderId: orderId));
        },
        updateOrderId: (value) {
          dispatch(OrderSupportAction(orderId: value));
        },
        getOrderList: (url) {
          dispatch(GetOrderListAPIAction(orderRequestApi: url));
        },
        loadingStatus: state.authState.loadingStatus,
        getOrderListResponse: state.productState.getOrderListResponse,
        placeOrder: (request) {
          dispatchFuture(PlaceOrderAction(request: request)).whenComplete(() {
            dispatch(GetOrderListAPIAction());
          });
        },
        completeOrder: (orderId, index) {
          dispatch(CompleteOrderAPIAction(orderId: orderId, index: index));
        },
        viewStore: () {
          dispatch(UpdateSelectedTabAction(0));
        },
        cancelOrder: (id, index) {
          dispatch(CancelOrderAPIAction(orderId: id, index: index));
        },
        getRazorpayCheckoutOptions: (orderId) async {
          await dispatchFuture(ClearPreviousRazorpayCheckoutOptionsAction());
          await dispatchFuture(
              GetRazorpayCheckoutOptionsAction(orderId: orderId));
        },
        acceptOrder: (orderId, index) {
          dispatch(AcceptOrderAPIAction(orderId: orderId, index: index));
        });
  }
}
