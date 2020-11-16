import 'dart:io';

import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/modules/cart/views/cart_bottom_view.dart';
import 'package:eSamudaay/modules/catalog_search/actions/product_search_actions.dart';
import 'package:eSamudaay/modules/jit_catalog/actions/free_form_items_actions.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/reusable_widgets/business_details_popup.dart';
import 'package:eSamudaay/reusable_widgets/business_title_tile.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/actions/home_page_actions.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/actions/categories_actions.dart';
import 'package:eSamudaay/modules/store_details/actions/store_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/store.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eSamudaay/utilities/size_config.dart';

class StoreDetailsView extends StatefulWidget {
  @override
  _StoreDetailsViewState createState() => _StoreDetailsViewState();
}

class _StoreDetailsViewState extends State<StoreDetailsView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        debugPrint('Onwillpop called');
        List<Business> merchants = await CartDataSource.getListOfMerchants();
        if (merchants.isNotEmpty &&
            merchants.first.businessId !=
                store.state.productState.selectedMerchant.businessId) {
          var localMerchant = merchants.first;
          store.dispatch(
              UpdateSelectedMerchantAction(selectedMerchant: localMerchant));
        }
        return Future.value(true);
      },
      child: Scaffold(
          body: StoreConnector<AppState, _ViewModel>(
              model: _ViewModel(),
              onInit: (store) {
                store.dispatch(GetCategoriesDetailsAction());
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
                  inAsyncCall:
                      snapshot.loadingStatus == LoadingStatusApp.loading,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x29000000),
                                          offset: Offset(0, 3),
                                          blurRadius: 6,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, left: 10, top: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              BusinessTitleTile(
                                                businessName: "Marlin  Arts",
                                                businessSubtitle: snapshot.selectedMerchant.description,
                                                isDeliveryAvailable: true,
                                                isOpen: true,
                                                businessImageUrl: snapshot
                                                    .selectedMerchant
                                                    .images
                                                    .first
                                                    .photoUrl,
                                                onBookmarkMerchant: null,
                                                onBackPressed: () async {
                                                  List<Business> merchants =
                                                      await CartDataSource
                                                          .getListOfMerchants();
                                                  if (merchants.isNotEmpty &&
                                                      merchants.first
                                                              .businessId !=
                                                          store
                                                              .state
                                                              .productState
                                                              .selectedMerchant
                                                              .businessId) {
                                                    var localMerchant =
                                                        merchants.first;
                                                    store.dispatch(
                                                        UpdateSelectedMerchantAction(
                                                            selectedMerchant:
                                                                localMerchant));
                                                  }
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              SizedBox(height: AppSizes.separatorPadding,),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 20),
                                                child: Container(
                                                  child: Hero(
                                                    tag: 'herotag',
                                                    child: TextField(
                                                      onTap: () {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                FocusNode());
                                                        snapshot
                                                            .navigateToProductSearch();
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Search ${snapshot.selectedMerchant?.businessName}...',
                                                        prefixIcon: Icon(
                                                          Icons.search,
                                                          color: AppColors
                                                              .icColors,
                                                        ),
                                                        suffixIcon: Icon(
                                                          Icons.navigate_next,
                                                          color: AppColors
                                                              .icColors,
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Organic Store
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 70,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        showDetailsPopup(
                                                            snapshot);
                                                      },
                                                      child: Hero(
                                                        tag: snapshot
                                                            .selectedMerchant
                                                            ?.businessName,
                                                        child: Text(
                                                          snapshot.selectedMerchant
                                                                  ?.businessName ??
                                                              "",
                                                          style: const TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .none,
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
                                                              fontSize: 22.0),
                                                          textAlign:
                                                              TextAlign.left,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if (snapshot.selectedMerchant
                                                              .phones !=
                                                          null &&
                                                      snapshot.selectedMerchant
                                                          .phones.isNotEmpty)
                                                    Expanded(
                                                        flex: 15,
                                                        child: buildPhoneButtonForContactingMerchant(
                                                            snapshot
                                                                .selectedMerchant
                                                                .phones[0])),
                                                  if (snapshot.selectedMerchant
                                                              .phones !=
                                                          null &&
                                                      snapshot.selectedMerchant
                                                          .phones.isNotEmpty)
                                                    Expanded(
                                                        flex: 15,
                                                        child: buildWhatsappButtonForContactingMerchant(
                                                            snapshot
                                                                .selectedMerchant
                                                                .phones[0])),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              // Milk, Egg, Bread, etc..
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: Text(
                                                          snapshot.selectedMerchant
                                                                  ?.description ??
                                                              "",
                                                          style: const TextStyle(
                                                              color: const Color(
                                                                  0xff797979),
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
                                                              TextAlign.left),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 8),
                                                        child: snapshot
                                                                .selectedMerchant
                                                                .hasDelivery
                                                            ? Image.asset(
                                                                'assets/images/delivery.png')
                                                            : Image.asset(
                                                                'assets/images/no_delivery.png'),
                                                      ),
                                                      Text(
                                                          snapshot.selectedMerchant
                                                                  .hasDelivery
                                                              ? tr(
                                                                  "shop.delivery_ok")
                                                              : tr(
                                                                  "shop.delivery_no"),
                                                          style: const TextStyle(
                                                              color: const Color(
                                                                  0xff6f6f6f),
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
                                                              TextAlign.left),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 20, bottom: 10),
                                          child: MySeparator(
                                            color: AppColors.darkGrey,
                                            height: 0.5,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              right: 10,
                                              top: 15,
                                              bottom: 20),
                                          child: Row(
                                            children: <Widget>[
                                              ImageIcon(
                                                AssetImage(
                                                  'assets/images/path330.png',
                                                ),
                                                color: AppColors.darkGrey,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8, right: 8),
                                                  child: Text(
                                                      snapshot
                                                              .selectedMerchant
                                                              ?.address
                                                              ?.prettyAddress ??
                                                          "",
//                                              snapshot.selectedMerchant.address
//                                                      .addressLine1 +
//                                                  ", " +
//                                                  snapshot.selectedMerchant
//                                                      .address.addressLine2,
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff6f6f6f),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              "Avenir-Medium",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14.0),
                                                      textAlign:
                                                          TextAlign.left),
                                                ),
                                              ),
                                              ImageIcon(
                                                AssetImage(
                                                  'assets/images/location2.png',
                                                ),
                                                color: AppColors.darkGrey,
                                              ),
                                            ],
                                          ),
                                        ),

                                        ///Show the optional merchant note added by the merchant to inform
                                        ///customers regarding any current development e.g. orders will be delayed etc.
                                        if (snapshot.selectedMerchant.notice !=
                                                null &&
                                            snapshot.selectedMerchant.notice !=
                                                '')
                                          getMerchantNoteRow(
                                              snapshot.selectedMerchant.notice)
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 30, bottom: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Text(
                                              "shop.item_category",
                                              style: TextStyle(
                                                color: Color(0xff151515),
                                                fontSize: 18,
                                                fontFamily: 'Avenir-Medium',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ).tr(),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 20),
                                            child: GridView.builder(
                                              padding: EdgeInsets.zero,
                                              primary: false,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      crossAxisSpacing: 20.0,
                                                      mainAxisSpacing: 20.0,
                                                      childAspectRatio:
                                                          100 / 160),
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  child: InkWell(
                                                    onTap: () {
                                                      snapshot
                                                          .updateSelectedCategory(
                                                              snapshot.categories[
                                                                  index]);
                                                      snapshot
                                                          .navigateToProductDetails();
                                                    },
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(
                                                              color: Color(
                                                                  0xffe0e0e0),
                                                              width: 1,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
//                                              padding: EdgeInsets.all(10),
                                                              child:
//                                            Image.asset(imageList[index])

                                                                  Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        15.0),
                                                                child: CachedNetworkImage(
                                                                    height: 75,
                                                                    fit: BoxFit.cover,
//                                                  height: 80,
                                                                    imageUrl: snapshot.categories[index].images.isEmpty ? "" : snapshot.categories[index].images.first.photoUrl,
                                                                    placeholder: (context, url) => Container(
//                                                              height: 170,
                                                                        child: Icon(Icons.image)),
                                                                    errorWidget: (context, url, error) => Container(
                                                                          height:
                                                                              75,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Icon(
                                                                              Icons.image,
                                                                              size: 30,
                                                                            ),
                                                                          ),
                                                                        )),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10),
//                                      height: 30,
                                                          child: Center(
                                                            child: Wrap(
                                                              direction: Axis
                                                                  .horizontal,
                                                              children: <
                                                                  Widget>[
                                                                Hero(
                                                                  tag: snapshot
                                                                      .categories[
                                                                          index]
                                                                      .categoryName,
                                                                  child: Text(
                                                                    snapshot
                                                                        .categories[
                                                                            index]
                                                                        .categoryName,
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .none,
                                                                        color: const Color(
                                                                            0xff747474),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontFamily:
                                                                            "Avenir-Medium",
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .normal,
                                                                        fontSize:
                                                                            14.0),
                                                                    maxLines: 2,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Spacer()
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              itemCount:
                                                  snapshot.categories.length,
                                              shrinkWrap: true,
                                              physics: ClampingScrollPhysics(),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              height: (snapshot.localCartListing.isEmpty &&
                                      snapshot.freeFormItemsList.isEmpty)
                                  ? 0
                                  : AppSizes.cartTotalBottomViewHeight,
                              duration: Duration(milliseconds: 300),
                              child: BottomView(
                                storeName:
                                    snapshot.selectedMerchant?.businessName ??
                                        "",
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
                      Positioned(
                        bottom: 0,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding: EdgeInsets.only(
                              bottom: (snapshot.localCartListing.isEmpty &&
                                      snapshot.freeFormItemsList.isEmpty)
                                  ? AppSizes.separatorPadding
                                  : AppSizes.cartTotalBottomViewHeight +
                                      AppSizes.separatorPadding),
                          child: GestureDetector(
                            onTap: () {
                              snapshot
                                  .checkForPreviouslyAddedListItems(context);
                            },
                            child: Container(
                              padding:
                                  EdgeInsets.all(AppSizes.separatorPadding),
                              decoration: BoxDecoration(
                                color: AppColors.hotPink,
                                borderRadius: BorderRadius.circular(
                                    AppSizes.productItemBorderRadius),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/notepad.png',
                                    color: AppColors.solidWhite,
                                  ),
                                  SizedBox(width: AppSizes.separatorPadding),
                                  Text(
                                    'List Items',
                                    style: TextStyle(
                                        fontFamily: "Avenir-Medium",
                                        color: AppColors.solidWhite),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
  }

  Widget getMerchantNoteRow(String note) {
    ///The adjusted length would trim the merchant note to 127 characters in length only, since beyond that
    ///the UX would get affected.

    ////////////////////////////////////////////////////////////////////////////
    if (note.length > 127) {
      //Note is modified here if length is beyond 127 characters
      note = note.substring(0, 128) + '...';
    }
    ////////////////////////////////////////////////////////////////////////////
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: AppSizes.widgetPadding.toHeight),
          child: MySeparator(
            color: AppColors.darkGrey,
            height: 0.5.toHeight,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              bottom: AppSizes.widgetPadding.toHeight,
              right: AppSizes.widgetPadding.toWidth),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 18,
                child: Center(
                  child: Icon(
                    Icons.info_outline,
                    color: AppColors.lightBlue,
                  ),
                ),
              ),
              Expanded(
                flex: 82,
                child: Text(
                  note,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: AppSizes.itemSubtitle2FontSize,
                      color: AppColors.greyishText),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showDetailsPopup(_ViewModel snapshot) {
    showDialog(
        context: context,
        builder: (context) {
          return BusinessDetailsPopup(
              merchantPhoneNumber:
                  snapshot.selectedMerchant.phones?.first ?? '',
              businessTitle: snapshot.selectedMerchant.businessName ?? '',
              businessSubtitle: snapshot.selectedMerchant.description,
              businessPrettyAddress:
                  snapshot.selectedMerchant.address?.prettyAddress ?? '',
              merchantBusinessImageUrl:
                  snapshot.selectedMerchant.images.first.photoUrl,
              isDeliveryAvailable: snapshot.selectedMerchant.hasDelivery);
        });
  }

  Widget buildWhatsappButtonForContactingMerchant(String telephone) {
    return IconButton(
      icon: SizedBox(
          height: AppSizes.productItemIconSize,
          width: AppSizes.productItemIconSize,
          child: Image.asset(
            'assets/images/call.png',
            fit: BoxFit.contain,
          )),
      onPressed: () {
        launch('tel:${telephone.formatPhoneNumber}');
      },
    );
  }

  Widget buildPhoneButtonForContactingMerchant(String telephone) {
    return IconButton(
      icon: SizedBox(
        height: AppSizes.productItemIconSize,
        width: AppSizes.productItemIconSize,
        child: Image.asset(
          'assets/images/whatsapp.png',
          fit: BoxFit.contain,
        ),
      ),
      onPressed: () {
        if (Platform.isIOS) {
          launch(
              "whatsapp://wa.me/${telephone.formatPhoneNumber}/?text=${Uri.parse('Message from eSamudaay.')}");
        } else {
          launch(
              "whatsapp://send?phone=${telephone.formatPhoneNumber}&text=${Uri.parse('Message from eSamudaay.')}");
        }
      },
    );
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  Function() navigateToProductDetails;
  Function(CategoriesNew) updateSelectedCategory;
  Business selectedMerchant;
  List<CategoriesNew> categories;
  LoadingStatusApp loadingStatus;
  Function navigateToProductSearch;
  List<Product> localCartListing;
  List<JITProduct> freeFormItemsList;
  Function navigateToCart;
  Function(BuildContext) checkForPreviouslyAddedListItems;

  _ViewModel();

  _ViewModel.build(
      {this.navigateToProductDetails,
      this.loadingStatus,
      this.freeFormItemsList,
      this.checkForPreviouslyAddedListItems,
      this.categories,
      this.selectedMerchant,
      this.updateSelectedCategory,
      this.navigateToProductSearch,
      this.localCartListing,
      this.navigateToCart})
      : super(equals: [
          selectedMerchant,
          loadingStatus,
          categories,
          localCartListing,
          freeFormItemsList,
        ]);

  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        freeFormItemsList: state.productState.localFreeFormCartItems,
        localCartListing: state.productState.localCartItems,
        categories: state.productState.categories,
        updateSelectedCategory: (category) {
          dispatch(UpdateSelectedCategoryAction(selectedCategory: category));
        },
        navigateToProductDetails: () {
          store.dispatchFuture(GetSubCatalogAction()).whenComplete(() {
            dispatch(UpdateProductListingDataAction(listingData: []));
            dispatch(
              NavigateAction.pushNamed('/StoreProductListingView'),
            );
          });
        },
        navigateToCart: () {
          dispatch(NavigateAction.pushNamed('/CartView'));
        },
        loadingStatus: state.authState.loadingStatus,
        selectedMerchant: state.productState.selectedMerchant,
        navigateToProductSearch: () {
          dispatch(ClearSearchResultProductsAction());
          dispatch(
            NavigateAction.pushNamed('/productSearch'),
          );
        },
        checkForPreviouslyAddedListItems: (context) async {
          var merchant = await CartDataSource.getListOfMerchants();
          if (merchant.isNotEmpty) {
            if (merchant.first.businessId !=
                state.productState.selectedMerchant.businessId) {
              showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Text("E-samudaay"),
                    content: Text(
                      'new_changes.clear_info',
                      style: const TextStyle(
                          color: const Color(0xff6f6d6d),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Avenir-Medium",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                    ).tr(),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          'screen_account.cancel',
                          style: const TextStyle(
                              color: const Color(0xff6f6d6d),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Avenir-Medium",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                        ).tr(),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'new_changes.continue',
                          style: const TextStyle(
                              color: const Color(0xff6f6d6d),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Avenir-Medium",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                        ).tr(),
                        onPressed: () async {
                          await CartDataSource.deleteAllMerchants();
                          await CartDataSource.deleteAll();
                          await CartDataSource.insertToMerchants(
                              business: state.productState.selectedMerchant);
                          await CartDataSource.insertFreeFormItemsList([]);
                          await CartDataSource.insertCustomerNoteImagesList([]);
                          Navigator.pop(context);
                          dispatch(ClearLocalFreeFormItemsAction());
                          dispatch(NavigateAction.pushNamed('/CartView'));
                        },
                      )
                    ],
                  ));
            } else {
              await CartDataSource.deleteAllMerchants();
              await CartDataSource.insertToMerchants(
                  business: state.productState.selectedMerchant);
              dispatch(NavigateAction.pushNamed('/CartView'));
            }
          } else {
            await CartDataSource.deleteAllMerchants();
            await CartDataSource.insertToMerchants(
                business: state.productState.selectedMerchant);
            dispatch(ClearLocalFreeFormItemsAction());
            dispatch(NavigateAction.pushNamed('/CartView'));
          }
        });
  }
}

extension StringUtils on String {
  String get formatPhoneNumber {
    if (this.length > 3 && this.substring(0, 3) != "+91") return "+91" + this;
    return this;
  }
}
