import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/main.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/cart/views/cart_bottom_view.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/actions/store_actions.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/modules/store_details/views/stepper_view.dart';
import 'package:eSamudaay/modules/cart/views/cart_sku_bottom_sheet.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/store.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/custom_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StoreProductListingView extends StatefulWidget {
  @override
  _StoreProductListingViewState createState() =>
      _StoreProductListingViewState();
}

class _StoreProductListingViewState extends State<StoreProductListingView>
    with TickerProviderStateMixin, RouteAware {
  TextEditingController _controller = TextEditingController();

  TabController controller;
  int _currentPosition = 0;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    controller = null;
    _controller = null;
    super.dispose();
  }

  @override
  void didPop() {
    super.didPop();
  }

  @override
  void didPush() {
    super.didPush();
  }

  @override
  void didPopNext() {
    store.dispatch(UpdateProductListingDataAction(
        listingData: store.state.productState.productListingDataSource));
    super.didPopNext();
  }

  void _onRefresh(_ViewModel snapshot) async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    if (snapshot.productResponse.previous != null) {
//      snapshot.getOrderList(snapshot.getOrderListResponse.previous);
    } else {
      snapshot.getProducts(null, null, null);
    }
    if (mounted) _refreshController.refreshCompleted();
  }

  void _onLoading(_ViewModel snapshot) async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
//    items.add((items.length + 1).toString());

    if (snapshot.productResponse.next != null) {
      snapshot.getProducts(null, null, snapshot.productResponse.next);
    }

    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
  }

  initController(Store<AppState> stores) {
    controller = TabController(
      length: stores.state.productState.subCategories.length,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(() {
      if (!controller.indexIsChanging) {
        if (controller.index != 0) {
          store.dispatch(UpdateProductListingDataAction(listingData: []));
          stores.dispatch(UpdateSelectedSubCategoryAction(
              selectedSubCategory:
                  stores.state.productState.subCategories[controller.index]));

          stores.dispatch(GetCatalogDetailsAction());
        } else {
          store.dispatch(UpdateProductListingDataAction(listingData: []));
          stores.dispatch(UpdateSelectedSubCategoryAction(
              selectedSubCategory: stores.state.productState.subCategories[0]));
          stores.dispatch(GetCatalogDetailsAction());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        titleSpacing: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.icColors,
          ),
        ),
        title: StoreConnector<AppState, _ViewModel>(
            model: _ViewModel(),
            builder: (context, snapshot) {
              return Hero(
                tag: snapshot.selectedCategory.categoryName,
                child: Text(
                  snapshot.selectedCategory.categoryName,
                  style: const TextStyle(
                      decoration: TextDecoration.none,
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Avenir-Medium",
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                ),
              );
            }),
      ),
      body: StoreConnector<AppState, _ViewModel>(
          model: _ViewModel(),
          onInit: (store) {
            initController(store);
            store.dispatch(GetCatalogDetailsAction());
          },
          builder: (context, snapshot) {
            var count = snapshot.subCategories.length;
            return Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 20),
                    child: new TextField(
                      onTap: () {
                        FocusScope.of(context)
                            .requestFocus(FocusNode());
                        snapshot.navigateToProductSearch();
                      },
                      controller: _controller,
                      decoration: new InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.icColors,
                          ),
                          suffixIcon: Icon(
                            Icons.navigate_next,
                            color: AppColors.icColors,
                          ),
                          hintText: tr('product_list.search_placeholder'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: new BorderSide(
                                color: AppColors.icColors,
                              ),),),
                    ),
                  ),
                  Container(
                    height: 50,
                    child: TabBar(
                      isScrollable: true,
                      controller: controller,
                      labelStyle: TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Avenir-Medium",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      unselectedLabelStyle: TextStyle(
                          color: const Color(0xff9f9f9f),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Avenir-Medium",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      labelColor: Color(0xff000000),
                      unselectedLabelColor: Color(0xff9f9f9f),
                      indicator: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.icColors,
                            width: 3,
                          ),
                        ),
                      ),
                      onTap: (index) {},
                      tabs: List.generate(
                        count,
                        (index) => // All
                            Container(
                          height: 50,
                          child: Center(
                            child: Text(
                                snapshot.subCategories[index].categoryName,
                                textAlign: TextAlign.left),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ModalProgressHUD(
                      progressIndicator: Card(
                        child: Image.asset(
                          'assets/images/indicator.gif',
                          height: 75,
                          width: 75,
                        ),
                      ),
                      inAsyncCall:
                          snapshot.loadingStatus == LoadingStatusApp.loading,
                      opacity: 0,
                      child: TabBarView(
                        controller: controller,
                        children: List.generate(
                          count,
                          (index) => snapshot.products.isEmpty
                              ? snapshot.loadingStatus ==
                                      LoadingStatusApp.loading
                                  ? Container()
                                  : EmptyViewProduct()
                              : SmartRefresher(
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
                                    builder: (BuildContext context,
                                        LoadStatus mode) {
                                      Widget body;
                                      if (mode == LoadStatus.idle) {
                                        body = Text("");
                                      } else if (mode == LoadStatus.loading) {
                                        body = CupertinoActivityIndicator();
                                      } else if (mode == LoadStatus.failed) {
                                        body = Text("Load Failed!Click retry!");
                                      } else if (mode ==
                                          LoadStatus.canLoading) {
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
                                    padding: EdgeInsets.all(15),
                                    itemCount: snapshot.products.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        height: 15,
                                      );
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ProductListingItemView(
                                        index: index,
                                        imageLink:
                                            snapshot.selectedCategory.images !=
                                                    null
                                                ? snapshot.selectedCategory
                                                            .images.length >
                                                        0
                                                    ? snapshot.selectedCategory
                                                        .images.first.photoUrl
                                                    : ""
                                                : "",
                                        item: snapshot.products[index],
                                      );
                                    },
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    height: snapshot.localCartListing.isEmpty ? 0 : 86,
                    duration: Duration(milliseconds: 300),
                    child: BottomView(
                      storeName: snapshot.selectedMerchant?.businessName ?? "",
                      height: snapshot.localCartListing.isEmpty ? 0 : 86,
                      buttonTitle: tr('cart.view_cart'),
                      didPressButton: () {
                        snapshot.navigateToCart();
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class EmptyViewProduct extends StatelessWidget {
  const EmptyViewProduct({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
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
            Text('screen_order.empty_pro',
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
              child: Text('screen_order.empty_pro_hint',
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
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  Function navigateToCart;
  CatalogSearchResponse productResponse;
  List<Product> products;
  LoadingStatusApp loadingStatus;
  List<Product> localCartListing;
  List<Product> productTempListing;
  Business selectedMerchant;
  List<CategoriesNew> subCategories;
  CategoriesNew selectedCategory;
  CategoriesNew selectedSubCategory;
  Function(Product, BuildContext) addToCart;
  Function(Product) removeFromCart;
  Function(String, String, String) getProducts;
  Function(CategoriesNew) updateSelectedCategory;
  Function(List<Product>) updateTempProductList;
  Function(List<Product>) updateProductList;
  Function navigateToProductSearch;

  _ViewModel();

  _ViewModel.build(
      {this.productResponse,
      this.navigateToCart,
      this.updateSelectedCategory,
      this.loadingStatus,
      this.selectedCategory,
      this.products,
      this.addToCart,
      this.removeFromCart,
      this.subCategories,
      this.localCartListing,
      this.getProducts,
      this.productTempListing,
      this.updateTempProductList,
      this.updateProductList,
      this.selectedMerchant,
      this.selectedSubCategory,
      this.navigateToProductSearch
      })
      : super(equals: [
          products,
          localCartListing,
          selectedMerchant,
          loadingStatus,
          productTempListing,
          selectedCategory,
          subCategories,
          productResponse,
          selectedSubCategory
        ]);

  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        addToCart: (item, context) {
          dispatch(AddToCartLocalAction(product: item, context: context));
        },
        removeFromCart: (item) {
          dispatch(RemoveFromCartLocalAction(product: item));
        },
        navigateToCart: () {
          dispatch(NavigateAction.pushNamed('/CartView'));
        },
        getProducts: (categoryId, merchantId, url) {
          dispatch(GetCatalogDetailsAction(url: url));
        },
        updateSelectedCategory: (category) {
          dispatch(
              UpdateSelectedSubCategoryAction(selectedSubCategory: category));
        },
        updateTempProductList: (list) {
          dispatch(UpdateProductListingTempDataAction(listingData: list));
        },
        updateProductList: (list) {
          dispatch(UpdateProductListingDataAction(listingData: list));
        },
        navigateToProductSearch: () {
          dispatch(
            NavigateAction.pushNamed('/productSearch'),
          );
        },
        subCategories: state.productState.subCategories,
        productTempListing: state.productState.productListingTempDataSource,
        loadingStatus: state.authState.loadingStatus,
        selectedCategory: state.productState.selectedCategory,
        selectedSubCategory: state.productState.selectedSubCategory,
        products: state.productState.productListingDataSource,
        localCartListing: state.productState.localCartItems,
        selectedMerchant: state.productState.selectedMerchand,
        productResponse: state.productState.productResponse);
  }
}

class ProductListingItemView extends StatefulWidget {
  final int index;
  final Product item;
  final String imageLink;

  const ProductListingItemView({Key key, this.index, this.item, this.imageLink})
      : super(key: key);

  @override
  _ProductListingItemViewState createState() => _ProductListingItemViewState();
}

class _ProductListingItemViewState extends State<ProductListingItemView> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        builder: (context, snapshot) {
          bool isOutOfStock = widget.item.inStock;
          return IgnorePointer(
            ignoring: !isOutOfStock,
            child: Row(
              children: <Widget>[
                Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.only(
                    left: 13,
                    right: 13,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffe7eaf0),
                        offset: Offset(0, 8),
                        blurRadius: 15,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      ColorFiltered(
                        child: widget.item.images == null
                            ? Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: "",
                                    placeholder: (context, url) =>
                                        CupertinoActivityIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                          child: Icon(
                                            Icons.image,
                                            size: 30,
                                          ),
                                        )),
                              )
                            : widget.item.images.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CachedNetworkImage(
                                        height: 500.0,
                                        fit: BoxFit.cover,
                                        imageUrl: widget.item?.images?.first
                                                ?.photoUrl ??
                                            "",
                                        placeholder: (context, url) =>
                                            CupertinoActivityIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                              child: Icon(
                                                Icons.image,
                                                size: 30,
                                              ),
                                            )),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: "",
                                        placeholder: (context, url) =>
                                            CupertinoActivityIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                              child: Icon(
                                                Icons.image,
                                                size: 30,
                                              ),
                                            )),
                                  ),
                        colorFilter: ColorFilter.mode(
                            !isOutOfStock ? Colors.grey : Colors.transparent,
                            BlendMode.saturation),
                      ),
                      !isOutOfStock
                          ? Positioned(
                              bottom: 5,
                              child: // Out of stock
                                  Text("Out of stock",
                                      style: const TextStyle(
                                          color: const Color(0xfff51818),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Avenir-Medium",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.0),
                                      textAlign: TextAlign.left))
                          : Container()
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(widget.item.productName,
                            style: const TextStyle(
                                color: const Color(0xff515c6f),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Avenir-Medium",
                                fontStyle: FontStyle.normal,
                                fontSize: 15.0),
                            textAlign: TextAlign.left),
                        // ₹ 55.00
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                    "₹ ${widget.item.skus.isEmpty ? 0 : widget.item.skus.first.basePrice / 100}",
                                    style: TextStyle(
                                        color: (!isOutOfStock
                                            ? Color(0xffc1c1c1)
                                            : Color(0xff5091cd)),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Avenir-Medium",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18.0),
                                    textAlign: TextAlign.left),
                                SizedBox(
                                  height: 3,
                                ),

                                ///To display the appropriate label depending on
                                ///whether there is only one variation or multiple
                                ///available
                                widget.item.skus.length == 1
                                    ? Text(
                                        widget.item.skus.first.variationOptions
                                            .weight,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                          color: AppColors.darkGrey,
                                          fontFamily: 'Avenir',
                                        ),
                                      )
                                    : Text(
                                        'cart.customize'.tr(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                          color: AppColors.darkGrey,
                                          fontFamily: 'Avenir',
                                        ),
                                      ),
                              ],
                            ),
                            CSStepper(
                              backgroundColor: !isOutOfStock
                                  ? Color(0xffb1b1b1)
                                  : AppColors.icColors,
                              addButtonAction: () {
                                if (widget.item.skus.isNotEmpty &&
                                    widget.item.skus.length > 1) {
                                  handleActionForMultipleSkus(
                                      product: widget.item,
                                      storeName: store.state.productState
                                          .selectedMerchand.businessName,
                                      productIndex: widget.index);
                                  return;
                                }

                                widget.item.count =
                                    ((widget.item?.count ?? 0) + 1)
                                        .clamp(0, double.nan);
                                snapshot.addToCart(widget.item, context);
                              },
                              removeButtonAction: () {
                                if (widget.item.skus.isNotEmpty &&
                                    widget.item.skus.length > 1) {
                                  handleActionForMultipleSkus(
                                      product: widget.item,
                                      storeName: store.state.productState
                                          .selectedMerchand.businessName,
                                      productIndex: widget.index);
                                  return;
                                }
                                widget.item.count =
                                    ((widget.item?.count ?? 0) - 1)
                                        .clamp(0, double.nan);
                                snapshot.removeFromCart(widget.item);
                              },
                              value: getTotalItemCount(
                                          widget.item.productId, snapshot) ==
                                      0
                                  ? tr("new_changes.add")
                                  : getTotalItemCount(
                                          widget.item.productId, snapshot)
                                      .toString(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  ///This method fetches the total quantity(s) of any particular item available
  ///in cart across all its variations.
  int getTotalItemCount(int productId, _ViewModel snapshot) {
    int count = 0;
    snapshot.localCartListing.forEach((element) {
      if (element.productId == productId) count += element.count;
    });
    debugPrint('Total count is $count');
    return count;
  }

  ///A convenience method to wrap the necessary information to the
  ///[SkuBottomSheet] class and present it modally in a bottom sheet.
  void handleActionForMultipleSkus(
      {Product product, String storeName, int productIndex}) {
    showModalBottomSheet(
        context: context,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        builder: (context) => Container(
              child: SkuBottomSheet(
                product: product,
                storeName: storeName,
                productIndex: productIndex,
              ),
            ));
  }
}
