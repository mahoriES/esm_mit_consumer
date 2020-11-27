import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/store_details/actions/store_actions.dart';
import 'package:eSamudaay/modules/store_details/views/product_catalog/widgets/catalogue_menu.dart';
import 'package:eSamudaay/modules/store_details/views/product_catalog/widgets/product_list_view.dart';
import 'package:eSamudaay/modules/store_details/views/product_catalog/widgets/search_component.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      onInit: onInit,
      builder: (context, snapshot) {
        return Scaffold(
          // TODO : app bar should be used from merchant main view.
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 22.toHeight),
                SearchComponent(
                  placeHolder: tr('product_list.search_placeholder'),
                  isEnabled: false,
                  onTapIfDisabled: snapshot.navigateToSearchView,
                ),
                SizedBox(height: 22.toHeight),
                // If there is atleast one category available.
                // then show top catalague menu and subcatehory view.
                if (snapshot.categories.isNotEmpty) ...[
                  CatalogueMenuComponent(
                    categories: snapshot.categories,
                    tabController: _tabController,
                    updateCategory: (i) =>
                        snapshot.updateSelectedCategory(i - 1),
                  ),
                  SizedBox(height: 22.toHeight),
                  SubCategoryView(),
                  SizedBox(height: 22.toHeight),
                ]
                // If there are zero categpries the show all product list directly.
                else ...[
                  Column(
                    children: [
                      ProductListView(
                        subCategoryIndex:
                            CustomCategoryForAllProducts().categoryId,
                      ),
                      if (snapshot.isLoadingMore[
                              CustomCategoryForAllProducts().categoryId] ??
                          false) ...[
                        CupertinoActivityIndicator(),
                      ],
                    ],
                  )
                ],
              ],
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

  _ViewModel();

  _ViewModel.build({
    this.navigateToSearchView,
    this.categories,
    this.loadingStatus,
    this.updateSelectedCategory,
    this.isLoadingMore,
  }) : super(equals: [loadingStatus, isLoadingMore]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      navigateToSearchView: () =>
          dispatch(NavigateAction.pushNamed(RouteNames.PRODUCT_SEARCH)),
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
    );
  }
}
