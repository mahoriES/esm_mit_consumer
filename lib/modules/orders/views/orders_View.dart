import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/cart/actions/cart_actions.dart';
import 'package:esamudaayapp/modules/cart/models/cart_model.dart';
import 'package:esamudaayapp/modules/home/actions/home_page_actions.dart';
import 'package:esamudaayapp/modules/orders/actions/actions.dart';
import 'package:esamudaayapp/modules/orders/models/order_models.dart';
import 'package:esamudaayapp/modules/orders/views/expandable_view.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/store.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/colors.dart';
import 'package:esamudaayapp/utilities/custom_widgets.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

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
    // if failed,use refreshFailed()
    if (snapshot.getOrderListResponse.previous != null) {
//      snapshot.getOrderList(snapshot.getOrderListResponse.previous);
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
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
//    items.add((items.length + 1).toString());

    if (snapshot.getOrderListResponse.next != null) {
      snapshot.getOrderList(snapshot.getOrderListResponse.next);
    }

    if (mounted) _refreshController.loadComplete();
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
                          fontFamily: "Avenir",
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
                progressIndicator: Image.asset(
                  'assets/images/indicator.gif',
                  height: 75,
                  width: 75,
                ),
                inAsyncCall: snapshot.loadingStatus == LoadingStatus.loading,
                child: (snapshot.getOrderListResponse == null ||
                        snapshot.getOrderListResponse.results == null ||
                        snapshot.getOrderListResponse.results.isEmpty)
                    ? snapshot.loadingStatus != LoadingStatus.loading
                        ? buildEmptyView(context, snapshot)
                        : Container()
                    : Container(
                        child: SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          header: WaterDropHeader(
                            complete: Image.asset(
                              'assets/images/indicator.gif',
                              height: 75,
                              width: 75,
                            ),
                            waterDropColor: AppColors.icColors,
                            refresh: Image.asset(
                              'assets/images/indicator.gif',
                              height: 75,
                              width: 75,
                            ),
                          ),
                          footer: CustomFooter(
                            loadStyle: LoadStyle.ShowWhenLoading,
                            builder: (BuildContext context, LoadStatus mode) {
                              Widget body;
                              if (mode == LoadStatus.idle) {
                                body = Text("");
                              } else if (mode == LoadStatus.loading) {
                                body = CupertinoActivityIndicator();
                              } else if (mode == LoadStatus.failed) {
                                body = Text("Load Failed!Click retry!");
                              } else if (mode == LoadStatus.canLoading) {
                                body = Text("");
                              } else {
                                body = Text("No more Data");
                              }
                              return Container(
                                height: 55.0,
                                child: Center(child: body),
                              );
                            },
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
                            shrinkWrap: true,
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
                      fontFamily: "Avenir",
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
                        fontFamily: "Avenir",
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
                  color: Color(0xff5091cd),
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
                          fontFamily: 'Avenir',
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
  const NewWidget(
      {Key key,
      this.deliveryStatus,
      this.merchantIndex,
      this.orderStatus,
      this.orderId,
      this.snapshot})
      : super(key: key);

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

class OrderItemBottomView extends StatelessWidget {
  final int index;
  final String orderId;
  final _ViewModel snapshot;
  final String orderStatus;
  final String deliveryStatus;
  final bool expanded;
  const OrderItemBottomView(
      {Key key,
      this.index,
      this.orderStatus,
      this.expanded,
      this.orderId,
      this.snapshot,
      this.deliveryStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
      child: Column(
        children: <Widget>[
          orderStatus == "MERCHANT_UPDATED"
              ? Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      snapshot.cancelOrder(
                          snapshot.getOrderListResponse.results[index].orderId,
                          index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 8),
                      child: Container(
                        child: // Cancel order
                            Text("Cancel order",
                                style: const TextStyle(
                                    color: const Color(0xffe33a3a),
                                    fontWeight: FontWeight.w900,
                                    fontFamily: "Avenir",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left),
                      ),
                    ),
                  ),
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 10),
                    child: buildIcon(),
                  ), // Processing
                  buildText()
                ],
              ),

              isButtonShow()
                  ? StoreConnector<AppState, _ViewModel>(
                      model: _ViewModel(),
                      builder: (context, snapshot) {
                        return buildCustomButton(snapshot);
                      })
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () async {
                          snapshot.updateOrderId(orderId);
                          if (snapshot.getOrderListResponse.results[index]
                                      .businessPhones !=
                                  null &&
                              snapshot.getOrderListResponse.results[index]
                                  .businessPhones.isNotEmpty) {
                            var url =
                                'tel:${snapshot.getOrderListResponse.results[index].businessPhones.first}';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "No contact details available.");
                          }
//                      Navigator.of(context).pushNamed('/Support');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.phone,
                              size: 35,
                              color: AppColors.icColors,
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                'Call shop',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            // Support
                          ],
                        ),
                      ),
                    ),
              // Support
            ],
          ),
          (orderStatus == "CREATED") && expanded
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () async {
                      snapshot.updateOrderId(orderId);
                      if (snapshot.getOrderListResponse.results[index]
                                  .businessPhones !=
                              null &&
                          snapshot.getOrderListResponse.results[index]
                              .businessPhones.isNotEmpty) {
                        var url =
                            'tel:${snapshot.getOrderListResponse.results[index].businessPhones.first}';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "No contact details available.");
                      }
//                      Navigator.of(context).pushNamed('/Support');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.phone,
                          size: 35,
                          color: AppColors.icColors,
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Call shop',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        // Support
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  bool isButtonShow() {
    if (orderStatus == "CREATED" ||
        orderStatus == "COMPLETED" ||
        orderStatus == "MERCHANT_UPDATED") {
      return true;
    } else if (orderStatus == "READY_FOR_PICKUP") {
      if (deliveryStatus == "SELF_PICK_UP")
        return true;
      else
        return false;
    } else {
      return false;
    }
  }

  CustomButton buildCustomButton(_ViewModel snapshot) {
    return CustomButton(
      title: title(),
      backgroundColor: orderStatus == "COMPLETED"
          ? AppColors.icColors
          : orderStatus == "CREATED" ? AppColors.orange : AppColors.icColors,
      didPresButton: () async {
        if (orderStatus == "COMPLETED") {
          //reorder api
          store
              .dispatchFuture(GetOrderDetailsAPIAction(
                  orderId:
                      snapshot.getOrderListResponse.results[index].orderId))
              .whenComplete(() async {
            var address = await UserManager.getAddress();
            PlaceOrderRequest request = PlaceOrderRequest();
            request.businessId =
                snapshot.getOrderListResponse.results[index].businessId;
            request.deliveryAddressId = address.addressId;
            request.deliveryType =
                snapshot.getOrderListResponse.results[index].deliveryType;
            request.orderItems =
                snapshot.getOrderListResponse.results[index].orderItems;
            snapshot.placeOrder(request);
          });
        } else if (orderStatus == "MERCHANT_UPDATED") {
          //accept order api
          snapshot.acceptOrder(
              snapshot.getOrderListResponse.results[index].orderId, index);
        } else if (orderStatus == "READY_FOR_PICKUP" &&
            deliveryStatus == "SELF_PICK_UP") {
          snapshot.completeOrder(
              snapshot.getOrderListResponse.results[index].orderId, index);
        } else {
          //cancel order api
          snapshot.cancelOrder(
              snapshot.getOrderListResponse.results[index].orderId, index);
        }
      },
    );
  }

  String title() {
    if (orderStatus == "CREATED") {
      return tr('screen_order.cancel_order');
    } else if (orderStatus == "MERCHANT_ACCEPTED") {
      if (deliveryStatus == "SELF_PICK_UP")
        return tr('screen_order.pickup');
      else
        return "";
    } else if (orderStatus == "CUSTOMER_CANCELLED") {
      return tr('screen_order.cancelled_customer');
    } else if (orderStatus == "MERCHANT_CANCELLED") {
      return tr('screen_order.cancelled_merchant') +
          " " +
          snapshot.getOrderListResponse.results[index].businessName;
    } else if (orderStatus == "MERCHANT_UPDATED") {
      return tr('screen_order.accept_order');
    } else if (orderStatus == "COMPLETED") {
      return tr('screen_order.re_order');
    } else if (orderStatus == "READY_FOR_PICKUP") {
      if (deliveryStatus == "SELF_PICK_UP")
        return tr('screen_order.pickup');
      else
        return tr('screen_order.on_the_way');
    } else if (orderStatus == "REQUESTING_TO_DA") {
      return tr('screen_order.on_the_way');
    } else if (orderStatus == "ASSIGNED_TO_DA") {
      return tr('screen_order.on_the_way');
    } else if (orderStatus == "PICKED_UP_BY_DA") {
      return tr('screen_order.on_the_way');
    }
  }

  Text buildText() {
    TextStyle newStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontFamily: 'Avenir',
      fontWeight: FontWeight.w800,
    );
    if (orderStatus == "CREATED") {
      return Text(
        tr('screen_order.pending'),
        style: newStyle,
      );
    } else if (orderStatus == "MERCHANT_ACCEPTED") {
      return Text(
        tr('screen_order.confirmed'),
        style: newStyle,
      );
    } else if (orderStatus == "CUSTOMER_CANCELLED") {
      return Text(
        tr('screen_order.cancelled_customer'),
        style: newStyle,
      );
    } else if (orderStatus == "MERCHANT_CANCELLED") {
      return Text(
        tr('screen_order.cancelled_merchant') +
            " " +
            snapshot.getOrderListResponse.results[index].businessName,
        style: newStyle,
      );
    } else if (orderStatus == "MERCHANT_UPDATED") {
      return Text(
        tr('screen_order.not_available'),
        style: newStyle,
      );
    } else if (orderStatus == "COMPLETED") {
      return Text(
        tr('screen_order.completed'),
        style: newStyle,
      );
    } else if (orderStatus == "READY_FOR_PICKUP") {
      if (deliveryStatus == "SELF_PICK_UP")
        return Text(
          tr('screen_order.ready_pickup'),
          style: newStyle,
        );
      else
        return Text(
          tr('screen_order.on_the_way'),
          style: newStyle,
        );
    } else if (orderStatus == "REQUESTING_TO_DA") {
      return Text(
        tr('screen_order.on_the_way'),
        style: newStyle,
      );
    } else if (orderStatus == "ASSIGNED_TO_DA") {
      return Text(
        tr('screen_order.on_the_way'),
        style: newStyle,
      );
    } else if (orderStatus == "PICKED_UP_BY_DA") {
      return Text(
        tr('screen_order.on_the_way'),
        style: newStyle,
      );
    }
  }

  Icon buildIcon() {
    if (orderStatus == "CREATED") {
      return Icon(
        Icons.autorenew,
        color: Color(0xffeb730c),
      );
    } else if (orderStatus == "MERCHANT_ACCEPTED") {
      return Icon(
        Icons.check_circle_outline,
        color: Color(0xffa4c73f),
      );
    } else if (orderStatus == "CUSTOMER_CANCELLED" ||
        orderStatus == "MERCHANT_CANCELLED") {
      return Icon(
        Icons.close,
        color: Colors.red,
      );
    } else if (orderStatus == "MERCHANT_UPDATED") {
      return Icon(
        Icons.help_outline,
        color: Colors.red,
      );
    } else if (orderStatus == "COMPLETED") {
      return Icon(
        Icons.check_circle_outline,
        color: AppColors.green,
      );
    } else if (orderStatus == "READY_FOR_PICKUP") {
      return Icon(
        Icons.check_circle_outline,
        color: AppColors.green,
      );
    } else if (orderStatus == "REQUESTING_TO_DA") {
      return Icon(Icons.account_box, color: AppColors.icColors);
    } else if (orderStatus == "ASSIGNED_TO_DA") {
      return Icon(Icons.account_box, color: AppColors.icColors);
    } else if (orderStatus == "PICKED_UP_BY_DA") {
      return Icon(Icons.account_box, color: AppColors.icColors);
    }

//    return Icon(
//      orderStatus == "CUSTOMER_CANCELLED" || orderStatus == "MERCHANT_CANCELLED"
//          ? Icons.close
//          : orderStatus == "COMPLETED"
//              ? Icons.check_circle_outline
//              : orderStatus == "CREATED" && deliveryStatus != "SELF_PICK_UP"
//                  ? Icons.autorenew
//                  : orderStatus == "MERCHANT_ACCEPTED"
//                      ? Icons.check_circle_outline
//                      : orderStatus == "MERCHANT_UPDATED"
//                          ? Icons.help_outline
//                          : Icons.autorenew,
//      color: orderStatus == "CUSTOMER_CANCELLED" ||
//              orderStatus == "MERCHANT_CANCELLED"
//          ? Colors.red
//          : orderStatus == "COMPLETED"
//              ? AppColors.green
//              : orderStatus == "CREATED"
//                  ? Color(0xffeb730c)
//                  : orderStatus == "MERCHANT_ACCEPTED"
//                      ? Color(0xffa4c73f)
//                      : orderStatus == "MERCHANT_UPDATED"
//                          ? Colors.red
//                          : AppColors.green,
//      size: 18,
//    );
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
          borderRadius: BorderRadius.circular(23),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(),
                Container(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Avenir',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
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
                              child: Icon(Icons.error),
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
                          fontFamily: "Avenir",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      textAlign: TextAlign.left),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(widget.date,
                        style: const TextStyle(
                            color: const Color(0xff7c7c7c),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Avenir",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text("Order Id : " + widget.orderId ?? "",
                        style: const TextStyle(
                            color: const Color(0xff7c7c7c),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Avenir",
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
                                        fontFamily: "Avenir",
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
                                ? tr("shop.delivery_ok")
                                : tr("shop.pickup_order"),
                            style: const TextStyle(
                                color: const Color(0xff7c7c7c),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Avenir",
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
                      fontFamily: "Avenir",
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
  Function viewStore;
  Function(PlaceOrderRequest) placeOrder;
  Function(String, int) acceptOrder;
  Function(String, int) cancelOrder;
  Function(String, int) completeOrder;
  LoadingStatus loadingStatus;
  Function(String) getOrderList;

  _ViewModel();
  _ViewModel.build(
      {this.getOrderListResponse,
      this.placeOrder,
      this.updateOrderId,
      this.cancelOrder,
      this.acceptOrder,
      this.loadingStatus,
      this.viewStore,
      this.getOrderList,
      this.completeOrder})
      : super(equals: [getOrderListResponse, loadingStatus]);
  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
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
        acceptOrder: (orderId, index) {
          dispatch(AcceptOrderAPIAction(orderId: orderId, index: index));
        });
  }
}
