import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/home/actions/home_page_actions.dart';
import 'package:eSamudaay/modules/home/models/cluster.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/login/actions/login_actions.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:eSamudaay/modules/store_details/actions/categories_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/custom_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePageMainView extends StatefulWidget {
  @override
  _HomePageMainViewState createState() => _HomePageMainViewState();
}

class _HomePageMainViewState extends State<HomePageMainView> {
  String address = "";
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh(_ViewModel snapshot) async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    if (snapshot.response.previous != null) {
//      snapshot.getMerchantList(snapshot.response.previous);
    } else {
      snapshot.getMerchantList(ApiURL.getBusinessesUrl);
    }

    _refreshController.refreshCompleted();
  }

  void _onLoading(_ViewModel snapshot) async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
//    items.add((items.length + 1).toString());
    if (snapshot.response.next != null) {
      snapshot.getMerchantList(snapshot.response.next);
    }
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return UserExceptionDialog<AppState>(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0), // here the desired height
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            brightness: Brightness.light,
            automaticallyImplyLeading: false,
            titleSpacing: 0.0,
            centerTitle: false,
            bottom: PreferredSize(
                child: Container(), preferredSize: Size.fromHeight(0.0)),
            flexibleSpace: // Rect
            // angle 2102
                Container(
              height: 160,
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/HeaderImage.png"),
                      fit: BoxFit.fill)),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/splash.png',
                            width: 200,
                            color: Colors.white,
                          ),
                          StoreConnector<AppState, _ViewModel>(
                              model: _ViewModel(),
                              onInit: (store) {
                                store.dispatch(GetCartFromLocal());
                                store.dispatch(GetUserFromLocalStorageAction());
                              },
                              builder: (context, snapshot) {
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: 45,
                                    ),
                                    ImageIcon(
                                      AssetImage('assets/images/location2.png'),
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(snapshot?.cluster?.clusterName ?? "",
                                        style: TextStyle(
                                          fontFamily: 'JTLeonor',
                                          color: Colors.white,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                        )),
                                  ],
                                );
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        body: StoreConnector<AppState, _ViewModel>(
            model: _ViewModel(),
            builder: (context, snapshot) {
              List<Business> firstList = List<Business>();
              List<Business> secondList = List<Business>();
              snapshot.merchants.asMap().forEach((index, element) {
                if (index <= 2) {
                  firstList.add(element);
                } else {
                  secondList.add(element);
                }
              });

              return ModalProgressHUD(
                progressIndicator: Card(
                  child: Image.asset(
                    'assets/images/indicator.gif',
                    height: 75,
                    width: 75,
                  ),
                ),
                inAsyncCall:
                    snapshot.loadingStatus == LoadingStatusApp.loading &&
                        snapshot.merchants.isEmpty,
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropHeader(
                    waterDropColor: AppColors.icColors,
                    complete: Image.asset(
                      'assets/images/indicator.gif',
                      height: 75,
                      width: 75,
                    ),
                    refresh: Image.asset(
                      'assets/images/indicator.gif',
                      height: 75,
                      width: 75,
                    ),
                  ),
                  footer: CustomFooter(
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
                  child: (snapshot.merchants != null &&
                              snapshot.merchants.isEmpty) &&
                          snapshot.loadingStatus != LoadingStatusApp.loading
                      ? buildEmptyView(context, snapshot)
                      : ListView(
                          padding: EdgeInsets.only(top: 2, bottom: 15),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 20, bottom: 10),
                              child: Text('screen_home.store_near_you',
                                      style: const TextStyle(
                                          color: const Color(0xff2c2c2c),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Avenir-Medium",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16.0),
                                      textAlign: TextAlign.left)
                                  .tr(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: AnimationLimiter(
                                child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    var business = firstList[index];
                                    return InkWell(
                                        onTap: () {
                                          snapshot
                                              .updateSelectedMerchant(business);
                                          snapshot.navigateToStoreDetailsPage();
                                        },
                                        child: AnimationConfiguration
                                            .staggeredList(
                                          position: index,
                                          duration:
                                              const Duration(milliseconds: 375),
                                          child: SlideAnimation(
                                            horizontalOffset: 5.0,
                                            child: FadeInAnimation(
                                              child: StoresListView(
                                                items:
                                                    business?.description ?? "",
                                                shopImage: business.images ==
                                                            null ||
                                                        business.images.isEmpty
                                                    ? null
                                                    : business
                                                        .images.first.photoUrl,
                                                name: business.businessName,
                                                deliveryStatus:
                                                    business.hasDelivery,
                                                shopClosed: !business.isOpen,
                                                itemsCount: business.itemsCount,
                                              ),
                                            ),
                                          ),
                                        ));
                                  },
                                  itemCount: firstList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      height: 10,
                                    );
                                  },
                                ),
                              ),
                            ),

                            snapshot.banners.isEmpty
                                ? Container()
                                : CarouselSlider(
                                    enlargeCenterPage: true,
                                    items: snapshot.banners.isEmpty
                                        ? [Container()]
                                        : snapshot.banners
                                            .map((banner) => InkWell(
                                                  onTap: () {},
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15.0)),
                                                    child: CachedNetworkImage(
                                                        height: 400.0,
                                                        fit: BoxFit.contain,
                                                        imageUrl:
                                                            banner.photoUrl,
                                                        placeholder: (context,
                                                                url) =>
                                                            CupertinoActivityIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Center(
                                                              child: Icon(
                                                                  Icons.error),
                                                            )),
                                                  ),
                                                ))
                                            .toList(),
                                    height: 200,
                                    aspectRatio: 16 / 9,
                                    viewportFraction: 1.0,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: true,
                                    autoPlayInterval: Duration(seconds: 3),
                                    autoPlayAnimationDuration:
                                        Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    pauseAutoPlayOnTouch: Duration(seconds: 10),
//                  enlargeCenterPage: true,
                                    scrollDirection: Axis.horizontal,
                                  ),
                            // Stores near you

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AnimationLimiter(
                                child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    var business = secondList[index];
                                    return InkWell(
                                        onTap: () {
                                          snapshot
                                              .updateSelectedMerchant(business);
                                          snapshot.navigateToStoreDetailsPage();
                                        },
                                        child: AnimationConfiguration
                                            .staggeredList(
                                          position: index,
                                          duration:
                                              const Duration(milliseconds: 375),
                                          child: SlideAnimation(
                                            horizontalOffset: 5.0,
                                            child: FadeInAnimation(
                                              child: StoresListView(
                                                items:
                                                    business?.description ?? "",
                                                shopImage: business.images ==
                                                            null ||
                                                        business.images.isEmpty
                                                    ? null
                                                    : business
                                                        .images.first.photoUrl,
                                                name: business.businessName,
                                                deliveryStatus:
                                                    business.hasDelivery,
                                                shopClosed: !business.isOpen,
                                                itemsCount: business.itemsCount,
                                              ),
                                            ),
                                          ),
                                        ));
                                  },
                                  itemCount: secondList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      height: 10,
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                ),
              );
            }),
      ),
    );
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
          Text('',
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
            child: Text('No Shops Found',
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
        ],
      ),
    );
  }
}

class StoresListView extends StatelessWidget {
  final String shopImage;
  final String name;
  final String items;
  final String itemsCount;
  final bool deliveryStatus;
  final bool shopClosed;

  const StoresListView(
      {Key key,
      this.shopImage,
      this.name,
      this.itemsCount,
      this.deliveryStatus,
      this.items,
      this.shopClosed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return true
        ? // Rectangle 2104
        Container(
            width: 334,
            height: 162,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(9)),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0x29000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                      spreadRadius: 0)
                ],
                color: const Color(0xffffffff)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // logo
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                shopClosed ? Colors.grey : Colors.white,
                                BlendMode.modulate),
                            child: shopImage == null
                                ? Image.asset(
                                    'assets/images/shop1.png',
                                    fit: BoxFit.cover,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: CachedNetworkImage(
                                        height: 46,
                                        width: 46,
                                        fit: BoxFit.cover,
                                        imageUrl: shopImage,
                                        placeholder: (context, url) => Icon(
                                              Icons.image,
                                              size: 30,
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                              child: Icon(
                                                Icons.image,
                                                size: 30,
                                              ),
                                            )),
                                  ),
                          ),
                        ],
                      ),
                    ), // Astore Groceries
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Hero(
                        tag: name,
                        child: Text(name,
                            style: const TextStyle(
                                decoration: TextDecoration.none,
                                color: const Color(0xffd5133a),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Avenir-Medium",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                            textAlign: TextAlign.left),
                      ),
                    ),
                    Spacer(),
                    shopClosed
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.iconColors,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.white30, spreadRadius: 3),
                              ],
                            ),
                            child: // Out of stock
                                Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: Text('common.closed',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Avenir-Medium",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.0),
                                      textAlign: TextAlign.left)
                                  .tr(),
                            ))
                        : Container()
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        color: const Color(0xfffafafa)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(items,
                              style: const TextStyle(
                                  color: Color(0xff939393),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Helvetica",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                              textAlign: TextAlign.left),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(flex: 60,
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: deliveryStatus
                                          ? ImageIcon(
                                              AssetImage(
                                                  'assets/images/delivery.png'),
                                              color: shopClosed
                                                  ? Colors.grey.shade400
                                                  : Colors.black,
                                            )
                                          : shopClosed
                                              ? Image.asset(
                                                  'assets/images/group236.png')
                                              : Image.asset(
                                                  'assets/images/no_delivery.png'),
                                    ),
                                    Expanded(flex: 80,
                                      child: Text(
                                          deliveryStatus
                                              ? tr("shop.delivery_ok")
                                              : tr("shop.delivery_no"),
                                          style: const TextStyle(
                                              color: const Color(0xff141414),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Avenir-Medium",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 11.0),
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left),
                                    ),
                                  ],
                                ),
                              ),
                              // 1000+ Products available
                              Expanded(flex: 40,
                                child: Text(itemsCount ?? "",
                                    style: const TextStyle(
                                        color: const Color(0xff141414),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Avenir-Medium",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12.0),
                                    textAlign: TextAlign.left),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        : Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 79,
                  height: 79,
                  margin: new EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            shopClosed ? Colors.grey : Colors.transparent,
                            BlendMode.saturation),
                        child: shopImage == null
                            ? Image.asset(
                                'assets/images/shop1.png',
                                fit: BoxFit.cover,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                    height: 100.0,
                                    fit: BoxFit.cover,
                                    imageUrl: shopImage,
                                    placeholder: (context, url) => Icon(
                                          Icons.image,
                                          size: 30,
                                        ),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                          child: Icon(
                                            Icons.image,
                                            size: 30,
                                          ),
                                        )),
                              ),
                      ),
                      shopClosed
                          ? Positioned(
                              bottom: 5,
                              child: // Out of stock
                                  Text('common.closed',
                                          style: const TextStyle(
                                              color: const Color(0xfff51818),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Avenir-Medium",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.0),
                                          textAlign: TextAlign.left)
                                      .tr())
                          : Container()
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(name,
                            style: const TextStyle(
                                color: const Color(0xff2c2c2c),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Avenir-Medium",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                            textAlign: TextAlign.left),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(items,
                              style: const TextStyle(
                                  color: const Color(0xff7c7c7c),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Avenir-Medium",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0),
                              textAlign: TextAlign.left),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: deliveryStatus
                                  ? ImageIcon(
                                      AssetImage('assets/images/delivery.png'),
                                      color: shopClosed
                                          ? Colors.grey.shade400
                                          : Colors.black,
                                    )
                                  : shopClosed
                                      ? Image.asset(
                                          'assets/images/group236.png')
                                      : Image.asset(
                                          'assets/images/no_delivery.png'),
                            ),
                            Text(
                                deliveryStatus
                                    ? tr("shop.delivery_ok")
                                    : tr("shop.delivery_no"),
                                style: const TextStyle(
                                    color: const Color(0xff7c7c7c),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Avenir-Medium",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();
  Function(String) getMerchantList;
  String userAddress;
  Function navigateToAddAddressPage;
  Function navigateToProductSearch;
  Function navigateToStoreDetailsPage;
  Function updateCurrentIndex;
  VoidCallback navigateToCart;
  Function(Business) updateSelectedMerchant;
  int currentIndex;
  List<Business> merchants;
  List<Photo> banners;
  LoadingStatusApp loadingStatus;
  Cluster cluster;
  GetBusinessesResponse response;
  _ViewModel.build(
      {this.navigateToAddAddressPage,
      this.navigateToCart,
      this.cluster,
      this.banners,
      this.navigateToProductSearch,
      this.navigateToStoreDetailsPage,
      this.updateCurrentIndex,
      this.currentIndex,
      this.loadingStatus,
      this.merchants,
      this.userAddress,
      this.updateSelectedMerchant,
      this.getMerchantList,
      this.response})
      : super(equals: [
          currentIndex,
          merchants,
          banners,
          loadingStatus,
          userAddress,
          cluster,
          response
        ]);

  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        response: state.homePageState.response,
        cluster: state.authState.cluster,
        userAddress: "",
        loadingStatus: state.authState.loadingStatus,
        merchants: state.homePageState.merchants,
        banners: state.homePageState.banners,
        navigateToCart: () {
          dispatch(NavigateAction.pushNamed('/CartView'));
        },
        updateSelectedMerchant: (merchant) {
          dispatch(UpdateSelectedMerchantAction(selectedMerchant: merchant));
        },
        navigateToStoreDetailsPage: () {
          dispatch(RemoveCategoryAction());
          dispatch(NavigateAction.pushNamed('/StoreDetailsView'));
        },
        navigateToAddAddressPage: () {
          dispatch(NavigateAction.pushNamed('/AddAddressView'));
        },
        navigateToProductSearch: () {
          dispatch(UpdateSelectedTabAction(1));
        },
        getMerchantList: (url) {
          dispatch(GetMerchantDetails(getUrl: url));
        },
        currentIndex: state.homePageState.currentIndex);
  }
}
