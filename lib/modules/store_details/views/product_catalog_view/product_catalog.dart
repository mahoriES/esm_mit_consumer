import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/cart/views/cart_bottom_view.dart';
import 'package:eSamudaay/modules/catalog_search/actions/product_search_actions.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/store_details/actions/store_actions.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/modules/store_details/views/product_catalog_view/widgets/catalogue_menu.dart';
import 'package:eSamudaay/modules/store_details/views/widgets/business_header_view.dart';
import 'package:eSamudaay/modules/store_details/views/widgets/product_list_view.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widgets/search_component.dart';
import 'widgets/subcategory_view.dart';

class ProductCatalogView extends StatefulWidget {
  const ProductCatalogView({Key key}) : super(key: key);

  @override
  _ProductCatalogViewState createState() => _ProductCatalogViewState();
}

class _ProductCatalogViewState extends State<ProductCatalogView>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  onInit(store) {
    // when view is created for first time,
    // the _tabController needs to be initialized with initial_index as index of the selected category.
    CategoriesNew _selectedCategory = store.state.productState.selectedCategory;
    List<CategoriesNew> _categoriesList = store.state.productState.categories;

    int indexOfSelectedCategory = _categoriesList.indexWhere(
      (category) => category.categoryId == _selectedCategory.categoryId,
    );

    _tabController = new TabController(
      // The tabbar consists an extra tab called "All" at 0th index so length should be incremented by 1.
      length: _categoriesList.length + 1,
      vsync: this,
      // increment the indexOfSelectedCategory by 1 to jump to the right tab.
      initialIndex: indexOfSelectedCategory + 1,
    );

    // add listener to update the category on scroll.
    _tabController.addListener(() {
      if (_tabController.index != _tabController.previousIndex) {
        store.dispatch(
          UpdateSelectedCategoryAction(
            selectedCategory: _tabController.index > 0
                ? store.state.productState.categories[_tabController.index - 1]
                : CustomCategoryForAllProducts(),
          ),
        );
        _tabController.index > 0
            ? store.dispatch(GetSubCategoriesAction())
            : store.dispatch(GetAllProducts());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      onInit: onInit,
      builder: (context, snapshot) {
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                BusinessHeaderView(
                  resetMerchantOnBack: false,
                ),
                SizedBox(height: 22.toHeight),
                SearchComponent(
                  placeHolder: tr('product_list.search_placeholder'),
                  isEnabled: false,
                  onTapIfDisabled: snapshot.navigateToSearchView,
                ),
                SizedBox(height: 22.toHeight),
                // If there is atleast one category available.
                // then show top catalague menu and subcategory view.
                if (snapshot.categories.isNotEmpty) ...[
                  CatalogueMenuComponent(
                    categories: snapshot.categories,
                    tabController: _tabController,
                    updateCategory: (i) =>
                        snapshot.updateSelectedCategory(i - 1),
                  ),
                  SizedBox(height: 22.toHeight),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: List.generate(
                        snapshot.categories.length + 1,
                        (index) => SubCategoryView(
                          categoryId: index > 0
                              ? snapshot.categories[index - 1].categoryId
                              : CustomCategoryForAllProducts().categoryId,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 22.toHeight),
                ]
                // If there are zero categpries the show all product list directly.
                else ...[
                  Expanded(
                    child: ProductListView(
                      subCategoryIndex:
                          CustomCategoryForAllProducts().categoryId,
                      isScrollable: true,
                    ),
                  ),
                  if (snapshot.isLoadingMore[
                          CustomCategoryForAllProducts().categoryId] ??
                      false) ...[
                    CupertinoActivityIndicator(),
                  ]
                ],
              ],
            ),
            bottomSheet: AnimatedContainer(
              height: (snapshot.localCartListing.isEmpty &&
                      snapshot.freeFormItemsList.isEmpty)
                  ? 0
                  : 65.toHeight,
              duration: Duration(milliseconds: 300),
              child: BottomView(
                height: (snapshot.localCartListing.isEmpty &&
                        snapshot.freeFormItemsList.isEmpty)
                    ? 0
                    : 65.toHeight,
                buttonTitle: tr('cart.view_cart'),
                didPressButton: snapshot.navigateToCart,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  Function navigateToSearchView;
  List<CategoriesNew> categories;
  LoadingStatusApp loadingStatus;
  Map<int, bool> isLoadingMore;
  Function(int) updateSelectedCategory;
  Function navigateToCart;
  List<Product> localCartListing;
  List<JITProduct> freeFormItemsList;

  _ViewModel();

  _ViewModel.build({
    this.navigateToSearchView,
    this.categories,
    this.loadingStatus,
    this.updateSelectedCategory,
    this.isLoadingMore,
    this.navigateToCart,
    this.freeFormItemsList,
    this.localCartListing,
  }) : super(equals: [
          loadingStatus,
          isLoadingMore,
          freeFormItemsList,
          localCartListing,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      navigateToSearchView: () {
        dispatch(ClearSearchResultProductsAction());
        dispatch(
          NavigateAction.pushNamed(RouteNames.PRODUCT_SEARCH),
        );
      },
      categories: state.productState.categories ?? [],
      loadingStatus: state.authState.loadingStatus,
      isLoadingMore: state.productState.isLoadingMore,
      updateSelectedCategory: (index) {
        dispatch(
          UpdateSelectedCategoryAction(
            selectedCategory: index >= 0
                ? state.productState.categories[index]
                : CustomCategoryForAllProducts(),
          ),
        );
        index >= 0
            ? dispatch(GetSubCategoriesAction())
            : dispatch(GetAllProducts());
      },
      freeFormItemsList: state.productState.localFreeFormCartItems,
      navigateToCart: () {
        dispatch(NavigateAction.pushNamed('/CartView'));
      },
      localCartListing: state.productState.localCartItems,
    );
  }
}
