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

class _StoreDetailsViewState extends State<StoreDetailsView>
    with MerchantWidgetElementsProviderMixin {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
                  child: Container(
                    color: AppColors.solidWhite,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  children: <Widget>[
                                    Column(
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
                                                businessName: snapshot
                                                        .selectedMerchant
                                                        .businessName ??
                                                    '',
                                                businessSubtitle: snapshot
                                                        .selectedMerchant
                                                        .description ??
                                                    '',
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
                                                onShowMerchantInfo: () =>
                                                    showDetailsPopup(snapshot),
                                                onContactMerchantPressed: () {
                                                  contactMerchantAction(
                                                      snapshot);
                                                },
                                              ),
                                              SizedBox(
                                                height:
                                                    AppSizes.separatorPadding,
                                              ),
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
                                                          Icons.search_rounded,
                                                          color: AppColors
                                                              .blueBerry,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: AppColors
                                                                  .greyedout),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 10, bottom: 20),
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
                                                        crossAxisSpacing: 12.0,
                                                        mainAxisSpacing: 10.0,
                                                        childAspectRatio: 1),
                                                itemBuilder: (context, index) {
                                                  return buildBusinessCategoryTile(
                                                      onTap: () {
                                                        snapshot.updateSelectedCategory(
                                                            snapshot.categories[
                                                                index]);
                                                        snapshot
                                                            .navigateToProductDetails();
                                                      },
                                                      imageUrl: snapshot
                                                              .categories[index]
                                                              .images
                                                              .isEmpty
                                                          ? ""
                                                          : snapshot
                                                              .categories[index]
                                                              .images
                                                              .first
                                                              .photoUrl,
                                                      tileWidth: 75,
                                                      categoryName: snapshot
                                                              .categories[index]
                                                              .categoryName ??
                                                          '');
                                                },
                                                itemCount:
                                                    snapshot.categories.length,
                                                shrinkWrap: true,
                                                physics:
                                                    ClampingScrollPhysics(),
                                              ),
                                            ),
                                            SizedBox(
                                              height: AppSizes.widgetPadding,
                                            ),
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
                                  buttonTitle: tr('cart.view_cart').toString(),
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
                  ),
                );
              })),
    );
  }

  Widget getMerchantNoteRow(String note) {
    ///The adjusted length would trim the merchant note to 127 characters in length only, since beyond that
    ///the UX would get affected.
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: AppSizes.separatorPadding,
                horizontal: AppSizes.widgetPadding),
            decoration: const BoxDecoration(color: AppColors.darkishPink),
            child: Center(
              child: Text(
                note.formatCustomerNote,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: AppSizes.itemSubtitle3FontSize,
                    fontWeight: FontWeight.w500,
                    color: AppColors.solidWhite),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void contactMerchantAction(_ViewModel snapshot) {
    showContactMerchantDialog(context, onCallAction: () {
      String phone = snapshot.selectedMerchant.phones?.first?.formatPhoneNumber;
      if (phone == null) return;
      launch('tel:$phone');
    }, onWhatsappAction: () {
      String phone = snapshot.selectedMerchant.phones?.first?.formatPhoneNumber;
      if (phone == null) return;
      if (Platform.isIOS) {
        launch(
            "whatsapp://wa.me/$phone/?text=${Uri.parse('Message from eSamudaay.')}");
      } else {
        launch(
            "whatsapp://send?phone=$phone&text=${Uri.parse('Message from eSamudaay.')}");
      }
    });
  }

  void showDetailsPopup(_ViewModel snapshot) {
    showDialog(
        context: context,
        builder: (context) {
          return BusinessDetailsPopup(
              onContactMerchant: () {
                contactMerchantAction(snapshot);
              },
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

  String get formatCustomerNote {
    if (this.length > 127) {
      //Note is modified here if length is beyond 127 characters
      return this.substring(0, 128) + '..';
    } else
      return this;
  }
}
