import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/cart/views/cart_bottom_view.dart';
import 'package:eSamudaay/modules/cart/views/cart_sku_bottom_sheet.dart';
import 'package:eSamudaay/modules/catalog_search/actions/product_search_actions.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/presentations/product_count_widget.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';

///This widget displays the search screen where the user can search for products
///across the entire catalogue for a particular merchant.
class MerchantProductsSearchView extends StatefulWidget {
  @override
  _MerchantProductsSearchViewState createState() =>
      _MerchantProductsSearchViewState();
}

class _MerchantProductsSearchViewState
    extends State<MerchantProductsSearchView> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        onInit: (store) {
          //_controller.clearComposing();
          _controller.clear();
          _controller.addListener(() async {
            if (_controller.text.length < 3) return;
            store.dispatch(
              GetItemsForMerchantProductSearch(
                merchantId:
                    store.state.productState.selectedMerchant.businessId,
                queryText: _controller.text,
              ),
            );
          });
        },
        builder: (context, snapshot) {
          return WillPopScope(
            ///Widget used to clear products when back button is pressed
            onWillPop: () {
              ///To remove focus from [TextField]
              _controller.clearComposing();
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              snapshot.clearSearchResults();
              return Future.value(true);
            },
            child: Scaffold(
              body: Material(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: AppSizes.adjustableWidgetPadding,
                    ),
                    child: SafeArea(
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: AppSizes.adjustableWidgetPadding,
                                  right: AppSizes.adjustableWidgetPadding),
                              child: Hero(
                                flightShuttleBuilder:
                                    (BuildContext flightContext,
                                            Animation<double> animation,
                                            HeroFlightDirection flightDirection,
                                            BuildContext fromHeroContext,
                                            BuildContext toHeroContext) =>
                                        Material(child: toHeroContext.widget),
                                tag: 'toSearchScreen',
                                child: TextField(
                                  autofocus: true,
                                  onSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  },
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Search ${snapshot.selectedMerchant.businessName}..',
                                    prefixIcon: IconButton(
                                      icon: Icon(
                                        Icons.navigate_before,
                                        color: AppColors.icColors,
                                      ),
                                      onPressed: () {
                                        _controller.clearComposing();
                                        _controller.clear();
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        snapshot.clearSearchResults();
                                        snapshot.closeSearchWindowAction();
                                      },
                                    ),
                                    suffixIcon: snapshot.loadingStatusApp ==
                                            LoadingStatusApp.loading
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                right: AppSizes.widgetPadding),
                                            child: SizedBox(
                                              height: AppSizes
                                                  .circularIndicatorSide,
                                              width: AppSizes
                                                  .circularIndicatorSide,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: AppSizes
                                                        .circularIndicatorSide,
                                                    horizontal: AppSizes
                                                        .circularIndicatorHorizontalSide),
                                                child: Center(
                                                  child:

                                                      ///Shown when the relevant
                                                      ///product(s) are being fetched from API
                                                      CircularProgressIndicator(
                                                    strokeWidth: 3,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              color: AppColors.icColors,
                                            ),
                                            onPressed: () =>
                                                _controller.clear(),
                                          ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppSizes.productItemBorderRadius),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            ///To keep the cart total view stick to bottom
                            if ((snapshot.searchProductsForMerchant.isEmpty &&
                                    !snapshot.searchProductsQueryCompleted) ||
                                _controller.text.isEmpty)
                              Expanded(
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          child: Image.asset(
                                            'assets/images/search_icon.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        SizedBox(
                                          height: AppSizes.widgetPadding,
                                        ),
                                        Text(
                                          tr('screen_search.search_tag'),
                                          style: TextStyle(
                                            fontFamily: 'Avenir',
                                            fontSize: fit
                                                .t(AppSizes.itemTitleFontSize),
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            if (snapshot.searchProductsForMerchant.isEmpty &&
                                snapshot.searchProductsQueryCompleted &&
                                _controller.text.isNotEmpty)
                              Expanded(
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: Image.asset(
                                            'assets/images/snack.jpg',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        SizedBox(
                                          height: AppSizes.widgetPadding,
                                        ),
                                        Text(
                                          tr('screen_search.search_product_not_found') +
                                              (_controller.text.isNotEmpty
                                                  ? _controller.text.toString()
                                                  : "your query"),
                                          style: TextStyle(
                                            fontFamily: 'Avenir',
                                            fontSize: fit
                                                .t(AppSizes.itemTitleFontSize),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ///Search results for a keyword
                            if (snapshot.searchProductsForMerchant.isNotEmpty)
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: AppSizes.adjustableWidgetPadding / 2,
                                      left: AppSizes.adjustableWidgetPadding,
                                      right: AppSizes.adjustableWidgetPadding),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return SearchProductListingItemView(
                                        index: index,
                                        item: snapshot
                                            .searchProductsForMerchant[index],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height:
                                            AppSizes.adjustableWidgetPadding,
                                      );
                                    },
                                    itemCount: snapshot
                                        .searchProductsForMerchant.length,
                                  ),
                                ),
                              ),

                            ///Bottom cart total view
                            AnimatedContainer(
                              height: (snapshot.localCartListing.isEmpty &&
                                      snapshot.freeFormItemsList.isEmpty)
                                  ? 0
                                  : AppSizes.cartTotalBottomViewHeight,
                              duration: Duration(milliseconds: 300),
                              child: BottomView(
                                height: snapshot.localCartListing.isEmpty
                                    ? 0
                                    : AppSizes.cartTotalBottomViewHeight,
                                buttonTitle: tr('cart.view_cart'),
                                didPressButton: () {
                                  snapshot.navigateToCart();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class _ViewModel extends BaseModel<AppState> {
  LoadingStatusApp loadingStatusApp;
  Business selectedMerchant;
  Function(String) getSearchedProductsForMerchant;
  List<Product> localCartListing;
  List<JITProduct> freeFormItemsList;
  List<Product> searchProductsForMerchant;
  Function(Product, BuildContext) addToCart;
  Function(Product) removeFromCart;
  Function closeSearchWindowAction;
  Function clearSearchResults;
  Function navigateToCart;
  CategoriesNew selectedCategory;
  bool searchProductsQueryCompleted;

  _ViewModel();

  _ViewModel.build(
      {@required this.loadingStatusApp,
      @required this.selectedCategory,
      @required this.freeFormItemsList,
      @required this.searchProductsQueryCompleted,
      @required this.closeSearchWindowAction,
      @required this.selectedMerchant,
      @required this.getSearchedProductsForMerchant,
      @required this.localCartListing,
      @required this.addToCart,
      @required this.removeFromCart,
      @required this.clearSearchResults,
      @required this.searchProductsForMerchant,
      @required this.navigateToCart})
      : super(equals: [
          loadingStatusApp,
          selectedMerchant,
          localCartListing,
          freeFormItemsList,
          searchProductsForMerchant,
          selectedCategory,
          searchProductsQueryCompleted,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      freeFormItemsList: state.productState.localFreeFormCartItems,
      searchProductsQueryCompleted:
          state.productState.searchForProductsComplete,
      selectedCategory: state.productState.selectedCategory ??
          state.productState.categories.first,
      searchProductsForMerchant: state.productState.searchResultProducts,
      loadingStatusApp: state.authState.loadingStatus,
      selectedMerchant: state.productState.selectedMerchant,
      addToCart: (item, context) {
        dispatch(AddToCartLocalAction(product: item, context: context));
      },
      removeFromCart: (item) {
        dispatch(RemoveFromCartLocalAction(product: item));
      },
      navigateToCart: () {
        dispatch(NavigateAction.pushNamed('/CartView'));
      },
      localCartListing: state.productState.localCartItems,
      getSearchedProductsForMerchant: (queryText) {
        dispatch(GetItemsForMerchantProductSearch(
            merchantId: state.productState.selectedMerchant.businessId,
            queryText: queryText));
      },
      closeSearchWindowAction: () => dispatch(NavigateAction.pop()),
      clearSearchResults: () => dispatch(ClearSearchResultProductsAction()),
    );
  }
}

class SearchProductListingItemView extends StatefulWidget {
  final int index;
  final Product item;

  const SearchProductListingItemView({Key key, this.index, this.item})
      : super(key: key);

  @override
  _SearchProductListingItemViewState createState() =>
      _SearchProductListingItemViewState();
}

class _SearchProductListingItemViewState
    extends State<SearchProductListingItemView> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        builder: (context, snapshot) {
          bool isInStock = widget.item.inStock;
          return IgnorePointer(
            ignoring: !isInStock,
            child: Row(
              children: <Widget>[
                Container(
                  height: AppSizes.productItemImageSize / 5,
                  width: AppSizes.productItemImageSize / 5,
                  margin: EdgeInsets.only(
                    left: AppSizes.widgetPadding,
                    right: AppSizes.widgetPadding,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.offWhitish,
                        offset: Offset(0, 8),
                        blurRadius: AppSizes.productItemBlurRadius,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      ColorFiltered(
                        child: widget.item.images == null
                            ? Padding(
                                padding: const EdgeInsets.all(
                                    AppSizes.productItemBorderRadius),
                                child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        widget.item?.images?.first?.photoUrl ??
                                            "",
                                    placeholder: (context, url) =>
                                        CupertinoActivityIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                          child: Icon(
                                            Icons.image,
                                            size: AppSizes.productItemIconSize,
                                          ),
                                        )),
                              )
                            : widget.item.images.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CachedNetworkImage(
                                        height: AppSizes.productItemImageSize,
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
                                                size: AppSizes
                                                    .adjustableWidgetPadding,
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
                                                size: AppSizes
                                                    .adjustableWidgetPadding,
                                              ),
                                            )),
                                  ),
                        colorFilter: ColorFilter.mode(
                            !isInStock ? Colors.grey : Colors.transparent,
                            BlendMode.saturation),
                      ),
                      !isInStock
                          ? Positioned(
                              bottom: 5,
                              child: // Out of stock
                                  Text("Out of stock",
                                      style: const TextStyle(
                                          color: AppColors.iconColors,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Avenir-Medium",
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              AppSizes.itemSubtitle3FontSize),
                                      textAlign: TextAlign.left))
                          : Container()
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: AppSizes.productItemImageSize / 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(widget.item.productName,
                            style: const TextStyle(
                                color: AppColors.offGreyish,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Avenir-Medium",
                                fontStyle: FontStyle.normal,
                                fontSize: AppSizes.itemSubtitle2FontSize),
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
                                        color: (!isInStock
                                            ? AppColors.offWhitish
                                            : AppColors.lightBlue),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Avenir-Medium",
                                        fontStyle: FontStyle.normal,
                                        fontSize: AppSizes.productItemFontSize),
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
                                          fontSize:
                                              AppSizes.itemSubtitle3FontSize,
                                          fontWeight: FontWeight.w300,
                                          color: AppColors.darkGrey,
                                          fontFamily: 'Avenir',
                                        ),
                                      )
                                    : Text(
                                        'cart.customize'.tr(),
                                        style: TextStyle(
                                          fontSize:
                                              AppSizes.itemSubtitle3FontSize,
                                          fontWeight: FontWeight.w300,
                                          color: AppColors.darkGrey,
                                          fontFamily: 'Avenir',
                                        ),
                                      ),
                              ],
                            ),
                            ProductCountWidget(
                              product: widget.item,
                              isSku: false,
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
          borderRadius: BorderRadius.all(
              Radius.circular(AppSizes.bottomSheetBorderRadius)),
        ),
        builder: (context) => Container(
              child: SkuBottomSheet(product: product),
            ));
  }
}
