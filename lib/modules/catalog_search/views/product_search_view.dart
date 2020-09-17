import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/cart/views/cart_sku_bottom_sheet.dart';
import 'package:eSamudaay/modules/catalog_search/actions/product_search_actions.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/modules/store_details/views/stepper_view.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/store.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MerchantProductsSearchView extends StatefulWidget {
  @override
  _MerchantProductsSearchViewState createState() =>
      _MerchantProductsSearchViewState();
}

class _MerchantProductsSearchViewState
    extends State<MerchantProductsSearchView> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        onInit: (store) {
          _controller.addListener(() async {
            if (_controller.text.length < 3) return;
          });
        },
        builder: (context, snapshot) {
          debugPrint('Found products and will rebuild');
          return WillPopScope(
            onWillPop: () {
              FocusScope.of(context).requestFocus(FocusNode());
              snapshot.clearSearchResults();
              return Future.value(true);
            },
            child: Scaffold(
              body: Material(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                    ),
                    child: SafeArea(
                      child: ListView(
                        children: [
                          Container(
                            child: TextField(
                              onEditingComplete: () {
                                if (_controller.text.length < 3) return;
                                snapshot.getSearchedProductsForMerchant(
                                    _controller.text);
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
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      snapshot.closeSearchWindowAction();
                                      snapshot.clearSearchResults();
                                    }),
                                suffixIcon: snapshot.loadingStatusApp ==
                                        LoadingStatusApp.loading
                                    ? Padding(
                                        padding: EdgeInsets.only(right: 15),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                      )
                                    : IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: AppColors.icColors,
                                        ),
                                        onPressed: () => _controller.clear(),
                                      ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          if (snapshot.searchProductsForMerchant.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(
                                top: 20,
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return SearchProductListingItemView(
                                    index: index,
                                    item: snapshot
                                        .searchProductsForMerchant[index],
                                    imageLink:
                                        "https://via.placeholder.com/150",
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 20,
                                  );
                                },
                                itemCount:
                                    snapshot.searchProductsForMerchant.length,
                              ),
                            ),
                        ],
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
  List<Product> searchProductsForMerchant;
  Function(Product, BuildContext) addToCart;
  Function(Product) removeFromCart;
  Function closeSearchWindowAction;
  Function clearSearchResults;

  _ViewModel();

  _ViewModel.build(
      {@required this.loadingStatusApp,
      @required this.closeSearchWindowAction,
      @required this.selectedMerchant,
      @required this.getSearchedProductsForMerchant,
      @required this.localCartListing,
      @required this.addToCart,
      @required this.removeFromCart,
      @required this.clearSearchResults,
      @required this.searchProductsForMerchant})
      : super(equals: [
          loadingStatusApp,
          selectedMerchant,
          localCartListing,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      searchProductsForMerchant: state.productState.searchResultProducts,
      loadingStatusApp: state.authState.loadingStatus,
      selectedMerchant: state.productState.selectedMerchand,
      addToCart: (item, context) {
        dispatch(AddToCartLocalAction(product: item, context: context));
      },
      removeFromCart: (item) {
        dispatch(RemoveFromCartLocalAction(product: item));
      },
      localCartListing: state.productState.localCartItems,
      getSearchedProductsForMerchant: (queryText) {
        dispatch(GetItemsForMerchantProductSearch(
            merchantId: state.productState.selectedMerchand.businessId,
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
  final String imageLink;

  const SearchProductListingItemView(
      {Key key, this.index, this.item, this.imageLink})
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
