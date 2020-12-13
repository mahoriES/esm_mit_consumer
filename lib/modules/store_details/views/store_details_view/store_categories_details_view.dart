import 'dart:io';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/cart/views/cart_bottom_view.dart';
import 'package:eSamudaay/modules/catalog_search/actions/product_search_actions.dart';
import 'package:eSamudaay/modules/home/actions/video_feed_actions.dart';
import 'package:eSamudaay/modules/home/models/video_feed_response.dart';
import 'package:eSamudaay/modules/home/views/video_list_widget.dart';
import 'package:eSamudaay/modules/jit_catalog/actions/free_form_items_actions.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/modules/store_details/views/store_details_view/widgets/highlight_catalog_item_view.dart';
import 'package:eSamudaay/presentations/no_iems_view.dart';
import 'package:eSamudaay/reusable_widgets/business_details_popup.dart';
import 'package:eSamudaay/reusable_widgets/business_title_tile.dart';
import 'package:eSamudaay/reusable_widgets/merchant_core_widget_classes/business_category_tile.dart';
import 'package:eSamudaay/reusable_widgets/spotlight_view.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/link_sharing_service.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/mixins/merchant_components_mixin.dart';
import 'package:eSamudaay/utilities/extensions.dart';

class StoreDetailsView extends StatefulWidget {
  @override
  _StoreDetailsViewState createState() => _StoreDetailsViewState();
}

//TODO: Reduce the size of this classes by moving around widget components

class _StoreDetailsViewState extends State<StoreDetailsView>
    with MerchantActionsProviderMixin {
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
      child: SafeArea(
        child: Scaffold(
          body: StoreConnector<AppState, _ViewModel>(
            model: _ViewModel(),
            onInit: (store) async {
              String businessId =
                  store.state.productState.selectedMerchant.businessId;
              await store.dispatchFuture(GetCategoriesDetailsAction());
              await store.dispatchFuture(
                  GetBusinessVideosAction(businessId: businessId));
              store.dispatch(GetBusinessSpotlightItems(businessId: businessId));
            },
            onDidChange: (snapshot){

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
                  color: CustomTheme.of(context).colors.pureWhite,
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
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, left: 10, top: 15),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            BusinessTitleTile(
                                              businessId: snapshot.selectedMerchant.businessId,
                                              businessName: snapshot
                                                      .selectedMerchant
                                                      .businessName ??
                                                  '',
                                              businessSubtitle: snapshot
                                                      .selectedMerchant
                                                      .description ??
                                                  '',
                                              isDeliveryAvailable: snapshot
                                                  .selectedMerchant.hasDelivery,
                                              // TODO : is Open value should be dynamic.
                                              isOpen: true,
                                              businessImageUrl: snapshot
                                                      .selectedMerchant
                                                      .images
                                                      .isNotEmpty
                                                  ? snapshot.selectedMerchant
                                                      .images.first.photoUrl
                                                  : "",
                                              onBackPressed: () async {
                                                List<Business> merchants =
                                                    await CartDataSource
                                                        .getListOfMerchants();
                                                if (merchants.isNotEmpty &&
                                                    merchants
                                                            .first.businessId !=
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
                                                contactMerchantAction(snapshot);
                                              },
                                            ),
                                            VideosListWidget(
                                              videoFeedResponse:
                                                  snapshot.videoFeedResponse,
                                              onRefresh: () => snapshot
                                                  .dispatch(LoadVideoFeed()),
                                              onTapOnVideo: (videoItem) {
                                                snapshot.updateSelectedVideo(
                                                    videoItem);
                                                snapshot.navigateToVideoView();
                                              },
                                            ),
                                            const SizedBox(
                                              height: AppSizes.widgetPadding,
                                            ),
                                            Container(
                                              child: Hero(
                                                tag: 'toSearchScreen',
                                                child: TextField(
                                                  onTap: () {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            FocusNode());
                                                    snapshot
                                                        .navigateToProductSearch();
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: tr(
                                                        'store_home.search_hint'),
                                                    hintStyle: CustomTheme.of(
                                                            context)
                                                        .themeData
                                                        .textTheme
                                                        .subtitle1
                                                        .copyWith(
                                                            color: CustomTheme
                                                                    .of(context)
                                                                .colors
                                                                .disabledAreaColor),
                                                    prefixIcon: Icon(
                                                      Icons.search_rounded,
                                                      color:
                                                          CustomTheme.of(context).colors.brandViolet,
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color: AppColors
                                                                  .greyedout),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: AppSizes.widgetPadding,
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
                                            snapshot.selectedMerchant.notice),
                                      SpotlightItemsScroller(
                                        onImageTap: (Product item) {
                                          snapshot.updateSelectedProduct(item);
                                          snapshot
                                              .navigateToProductDetailsPage();
                                        },
                                        spotlightProducts:
                                            snapshot.spotlightItems,
                                        onAddProduct: snapshot.addToCart,
                                        onRemoveProduct:
                                            snapshot.removeFromCart,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppSizes.widgetPadding),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const SizedBox(
                                          height: AppSizes.separatorPadding,
                                        ),
                                        Text(
                                          "shop.item_category",
                                          style: CustomTheme.of(context)
                                              .textStyles
                                              .sectionHeading2
                                              .copyWith(
                                                  fontSize: 18,
                                                  color: CustomTheme.of(context)
                                                      .colors
                                                      .primaryColor),
                                        ).tr(),
                                        const SizedBox(
                                          height: AppSizes.widgetPadding,
                                        ),
                                        buildCategoriesGrid(snapshot),
                                        const SizedBox(
                                          height: AppSizes.widgetPadding * 4,
                                        ),
                                      ],
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
                              padding: const EdgeInsets.all(
                                  AppSizes.separatorPadding),
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
                                  const SizedBox(
                                      width: AppSizes.separatorPadding),
                                  Text(
                                    'List Items',
                                    style: CustomTheme.of(context)
                                        .textStyles
                                        .body1
                                        .copyWith(
                                            height: 1,
                                            color: CustomTheme.of(context)
                                                .colors
                                                .backgroundColor),
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
            },
          ),
        ),
      ),
    );
  }

  // TODO : move these methods to view model.

  Widget buildProductsListView(_ViewModel snapshot) {
    return HighlightCatalogItems(
        productList: snapshot.singleCategoryFewProducts,
        actionButtonTitle: tr('store_home.see_more'),
        onTapActionButton: () {
          if (snapshot.categories.isNotEmpty) {
            snapshot.updateSelectedCategory(snapshot.categories.first);
          } else {
            snapshot.updateSelectedCategory(CustomCategoryForAllProducts());
          }
          snapshot.navigateToProductCatalog();
        });
  }

  Widget buildCategoriesGrid(_ViewModel snapshot) {
    if (snapshot.showNoProductsWidget) return const NoItemsFoundView();
    if (snapshot.showFirstFewProducts) return buildProductsListView(snapshot);
    return Container(
      child: GridView.builder(
        padding: EdgeInsets.zero,
        primary: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1),
        itemBuilder: (context, index) {
          return BusinessCategoryTile(
            imageUrl: snapshot.categories[index].images.isEmpty ? ""
                  : snapshot.categories[index].images?.first?.photoUrl ?? "",
            tileWidth: 75.toWidth,
            categoryName: snapshot.categories[index].categoryName ?? '',
            onTap: (){
              snapshot.updateSelectedCategory(snapshot.categories[index]);
              snapshot.navigateToProductCatalog();
            },
          );
        },
        itemCount: snapshot.categories.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      ),
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
                style: CustomTheme.of(context).textStyles.buttonText2.copyWith(
                    color: CustomTheme.of(context).colors.backgroundColor),
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
      Navigator.pop(context);
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
      Navigator.pop(context);
    }, merchantName: snapshot.selectedMerchant.businessName);
  }

  void showDetailsPopup(_ViewModel snapshot) {
    showDialog(
        context: context,
        builder: (context) {
          return BusinessDetailsPopup(
              businessId: snapshot.selectedMerchant.businessId,
              locationPoint:
                  snapshot.selectedMerchant.address?.locationPoint ?? null,
              onShareMerchant: () async {
                LinkSharingService().shareBusinessLink(
                    businessId: snapshot.selectedMerchant.businessId,
                    storeName: snapshot.selectedMerchant.businessName);
              },
              onContactMerchant: () {
                contactMerchantAction(snapshot);
              },
              merchantPhoneNumber: snapshot.selectedMerchant.phones.isNotEmpty
                  ? snapshot.selectedMerchant?.phones?.first
                  : 'Not Available',
              businessTitle: snapshot.selectedMerchant.businessName ?? '',
              businessSubtitle: snapshot.selectedMerchant.description,
              businessPrettyAddress:
                  snapshot.selectedMerchant.address?.prettyAddress ?? '',
              merchantBusinessImageUrl:
                  snapshot.selectedMerchant.images.isNotEmpty
                      ? snapshot.selectedMerchant.images.first.photoUrl
                      : '',
              isDeliveryAvailable: snapshot.selectedMerchant.hasDelivery);
        });
  }
}

class _ViewModel extends BaseModel<AppState> {
  Function(Product, BuildContext, int) addToCart;
  Function(Product, int) removeFromCart;
  Function() navigateToProductCatalog;
  Function(VideoItem) updateSelectedVideo;
  Function(CategoriesNew) updateSelectedCategory;
  Business selectedMerchant;
  List<CategoriesNew> categories;
  LoadingStatusApp loadingStatus;
  Function navigateToProductSearch;
  List<Product> localCartListing;
  List<Product> spotlightItems;
  List<Product> singleCategoryFewProducts;
  List<JITProduct> freeFormItemsList;
  Function navigateToCart;
  Function(BuildContext) checkForPreviouslyAddedListItems;
  VideoFeedResponse videoFeedResponse;
  Function onVideoTap;
  Function loadVideoFeedForMerchant;
  Function onRefresh;
  Function navigateToVideoView;
  Function(Product) updateSelectedProduct;
  Function navigateToProductDetailsPage;

  _ViewModel();

  _ViewModel.build(
      {this.navigateToProductCatalog,
      this.loadVideoFeedForMerchant,
      this.updateSelectedProduct,
      this.navigateToVideoView,
      this.loadingStatus,
      this.onVideoTap,
      this.navigateToProductDetailsPage,
      this.addToCart,
      this.singleCategoryFewProducts,
      this.removeFromCart,
      this.spotlightItems,
      this.onRefresh,
      this.freeFormItemsList,
      this.checkForPreviouslyAddedListItems,
      this.categories,
      this.videoFeedResponse,
      this.selectedMerchant,
      this.updateSelectedVideo,
      this.updateSelectedCategory,
      this.navigateToProductSearch,
      this.localCartListing,
      this.navigateToCart})
      : super(equals: [
          selectedMerchant,
          videoFeedResponse,
          spotlightItems,
          loadingStatus,
          categories,
          localCartListing,
          singleCategoryFewProducts,
          freeFormItemsList,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
        singleCategoryFewProducts: state.productState.singleCategoryFewProducts,
        spotlightItems: state.productState.spotlightItems,
        videoFeedResponse: state.productState.videosResponse,
        freeFormItemsList: state.productState.localFreeFormCartItems,
        localCartListing: state.productState.localCartItems,
        categories: state.productState?.categories ?? [],
        updateSelectedCategory: (category) {
          dispatch(UpdateSelectedCategoryAction(selectedCategory: category));
          category is CustomCategoryForAllProducts
              ? dispatch(GetAllProducts())
              : dispatch(GetSubCategoriesAction());
        },
        updateSelectedVideo: (video) async {
          dispatch(UpdateSelectedVideoAction(selectedVideo: video));
        },
        loadVideoFeedForMerchant: () {
          dispatch(GetBusinessVideosAction(
              businessId: state.productState.selectedMerchant.businessId));
        },
        navigateToProductCatalog: () {
          dispatch(NavigateAction.pushNamed(RouteNames.PRODUCT_CATALOGUE));
        },
        navigateToCart: () {
          dispatch(NavigateAction.pushNamed('/CartView'));
        },
        addToCart: (item, context, index) {
          if (!item.skus[index].inStock) {
            Fluttertoast.showToast(msg: 'Item not in stock!');
            return;
          }
          item.selectedVariant = index;
          int count = getCountOfExistingSpotlightItemInCart(item, index);
          item.count = count + 1;
          dispatch(AddToCartLocalAction(product: item, context: context));
        },
        removeFromCart: (item, index) {
          if (!item.skus[index].inStock) {
            Fluttertoast.showToast(msg: 'Item not in stock!');
            return;
          }
          item.selectedVariant = index;
          int count = getCountOfExistingSpotlightItemInCart(item, index);
          if (count == 0) return;
          item.count = count - 1;
          dispatch(RemoveFromCartLocalAction(product: item));
        },
        loadingStatus: state.authState.loadingStatus,
        selectedMerchant: state.productState.selectedMerchant,
        navigateToProductSearch: () {
          dispatch(ClearSearchResultProductsAction());
          dispatch(
            NavigateAction.pushNamed(RouteNames.PRODUCT_SEARCH),
          );
        },
        updateSelectedProduct: (selectedProduct) {
          dispatch(UpdateSelectedProductAction(selectedProduct));
        },
        navigateToProductDetailsPage: () {
          dispatch(NavigateAction.pushNamed(RouteNames.PRODUCT_DETAILS));
        },
        navigateToVideoView: () {
          dispatch(NavigateAction.pushNamed("/videoPlayer"));
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

  int getCountOfExistingSpotlightItemInCart(Product product, int index) {
    if (localCartListing.isEmpty)
      return 0;
    else {
      Product prod;
      try {
        prod = localCartListing.firstWhere(
          (element) =>
              element.productId == product.productId &&
              element.skus[element.selectedVariant].variationOptions.weight ==
                  product.skus[index].variationOptions.weight &&
              element.selectedVariant == index,
        );
      } catch (e) {
        return 0;
      }
      if (prod == null)
        return 0;
      else
        return prod.count;
    }
  }

  bool get showNoProductsWidget {
    return loadingStatus == LoadingStatusApp.success &&
        singleCategoryFewProducts.isEmpty &&
        (categories.isEmpty || categories.length == 1);
  }

  bool get showFirstFewProducts {
    return (categories.isEmpty || categories.length == 1) &&
        singleCategoryFewProducts.isNotEmpty;
  }
}
