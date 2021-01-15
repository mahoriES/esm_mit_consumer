import 'dart:io';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/catalog_search/actions/product_search_actions.dart';
import 'package:eSamudaay/modules/home/actions/video_feed_actions.dart';
import 'package:eSamudaay/modules/home/models/video_feed_response.dart';
import 'package:eSamudaay/modules/home/views/video_list_widget.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/modules/store_details/views/store_details_view/widgets/highlight_catalog_item_view.dart';
import 'package:eSamudaay/presentations/custom_confirmation_dialog.dart';
import 'package:eSamudaay/presentations/no_iems_view.dart';
import 'package:eSamudaay/reusable_widgets/business_details_popup.dart';
import 'package:eSamudaay/reusable_widgets/business_title_tile.dart';
import 'package:eSamudaay/reusable_widgets/cart_details_bottom_sheet.dart';
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
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      onInit: (store) async {
        String businessId =
            store.state.productState.selectedMerchant.businessId;
        await store.dispatchFuture(GetCategoriesDetailsAction());
        await store
            .dispatchFuture(GetBusinessVideosAction(businessId: businessId));
        store.dispatch(GetBusinessSpotlightItems(businessId: businessId));
      },
      builder: (context, snapshot) {
        return WillPopScope(
          onWillPop: (){return snapshot.onWillPopCallBack();},
          child: SafeArea(
            child: Scaffold(
              body: ModalProgressHUD(
                progressIndicator: Card(
                  child: Image.asset(
                    'assets/images/indicator.gif',
                    height: 75,
                    width: 75,
                  ),
                ),
                inAsyncCall: snapshot.loadingStatus == LoadingStatusApp.loading,
                child: Container(
                  color: CustomTheme.of(context).colors.backgroundColor,
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
                                              businessId: snapshot
                                                  .selectedMerchant.businessId,
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
                                              isOpen: snapshot
                                                  .selectedMerchant.isOpen,
                                              businessImageUrl: snapshot
                                                      .selectedMerchant
                                                      .images
                                                      .isNotEmpty
                                                  ? snapshot.selectedMerchant
                                                      .images.first.photoUrl
                                                  : "",
                                              onBackPressed: () async {
                                                // TODO : this logic to update selected merchant from cart data doesn't seem right.
                                                // Can't update now as it may cause errors in store details.
                                                Business merchants =
                                                    await CartDataSource
                                                        .getCartMerchant();
                                                if (merchants != null &&
                                                    merchants.businessId !=
                                                        store
                                                            .state
                                                            .productState
                                                            .selectedMerchant
                                                            .businessId) {
                                                  var localMerchant = merchants;
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
                                        selectedMerchant:
                                            snapshot.selectedMerchant,
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
                            CartDetailsBottomSheet(),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding: EdgeInsets.only(
                              bottom: (snapshot.localCartListing.isEmpty &&
                                      snapshot.customerNoteImagesList.isEmpty)
                                  ? AppSizes.separatorPadding
                                  : AppSizes.cartTotalBottomViewHeight +
                                      AppSizes.separatorPadding),
                          child: GestureDetector(
                            onTap: () {
                              snapshot.checkForPreviouslyAddedListItems(
                                  _showReplaceCartAlert);
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
                                  Icon(
                                    Icons.add_a_photo_outlined,
                                    color: CustomTheme.of(context)
                                        .colors
                                        .backgroundColor,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                      width: AppSizes.separatorPadding),
                                  Text(
                                    tr("cart.upload_shopping_list")
                                        .toUpperCase(),
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
              ),
            ),
          ),
        );
      },
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
            imageUrl: snapshot.categories[index].categoryImageUrl,
            tileWidth: 75.toWidth,
            categoryName: snapshot.categories[index].categoryName ?? '',
            onTap: () {
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

  void _showReplaceCartAlert(VoidCallback onReplace) {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: CustomConfirmationDialog(
        title: tr("product_details.replace_cart_items"),
        message: tr('new_changes.clear_info'),
        positiveButtonText: tr('new_changes.continue'),
        negativeButtonText: tr("screen_account.cancel"),
        positiveAction: () async {
          Navigator.pop(context);
          onReplace();
        },
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
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
  List<String> customerNoteImagesList;
  Function(Function(VoidCallback)) checkForPreviouslyAddedListItems;
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
      this.singleCategoryFewProducts,
      this.spotlightItems,
      this.onRefresh,
      this.customerNoteImagesList,
      this.checkForPreviouslyAddedListItems,
      this.categories,
      this.videoFeedResponse,
      this.selectedMerchant,
      this.updateSelectedVideo,
      this.updateSelectedCategory,
      this.navigateToProductSearch,
      this.localCartListing})
      : super(equals: [
          selectedMerchant,
          videoFeedResponse,
          spotlightItems,
          loadingStatus,
          categories,
          localCartListing,
          singleCategoryFewProducts,
          customerNoteImagesList,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      singleCategoryFewProducts: state.productState.singleCategoryFewProducts,
      spotlightItems: state.productState.spotlightItems,
      videoFeedResponse: state.productState.videosResponse,
      customerNoteImagesList: state.cartState.customerNoteImages,
      localCartListing: state.cartState.localCartItems,
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
      checkForPreviouslyAddedListItems:
          (Function(VoidCallback) showReplaceAlert) async {
        dispatch(
          CheckToReplaceCartAction(
            selectedMerchant: state.productState.selectedMerchant,
            onSuccess: () {
              dispatch(NavigateAction.pushNamed(RouteNames.CART_VIEW));
            },
            showReplaceAlert: showReplaceAlert,
          ),
        );
      },
    );
  }

  Future<bool> Function() onWillPopCallBack = () async {
    // TODO : this logic to update selected merchant from cart data doesn't seem right.
    // Can't update now as it may cause errors in store details.
    Business merchants = await CartDataSource.getCartMerchant();
    if (merchants != null &&
        merchants.businessId !=
            store.state.productState.selectedMerchant.businessId) {
      var localMerchant = merchants;
      store.dispatch(
          UpdateSelectedMerchantAction(selectedMerchant: localMerchant));
    }
    return Future.value(true);
  };

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