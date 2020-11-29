import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/store_details/actions/store_actions.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/presentations/no_iems_view.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'product_tile.dart';

class ProductListView extends StatelessWidget {
  final int subCategoryIndex;
  final bool showFewProductsOnly;
  final bool isScrollable;
  const ProductListView({
    @required this.subCategoryIndex,
    @required this.isScrollable,
    this.showFewProductsOnly = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "ProductListView => index : $subCategoryIndex bool : $showFewProductsOnly");

    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        // If data is loaded and the list is still empty then show no items found.
        // TODO : This should be handeled on backend in future.

        if (snapshot.noItemsFound(subCategoryIndex, showFewProductsOnly)) {
          return NoItemsFoundView();
        }
        return ListView.separated(
            physics: isScrollable
                ? AlwaysScrollableScrollPhysics()
                : NeverScrollableScrollPhysics(),
            itemCount: snapshot
                .productsList(subCategoryIndex, showFewProductsOnly)
                .length,
            shrinkWrap: true,
            separatorBuilder: (context, productIndex) =>
                SizedBox(height: 16.toHeight),
            itemBuilder: (context, productIndex) {
              // If the 3rd last element of list is in view then load more data is triggered.
              if (!showFewProductsOnly &&
                  productIndex ==
                      snapshot
                              .productsList(
                                  subCategoryIndex, showFewProductsOnly)
                              .length -
                          3) {
                return VisibilityDetector(
                  key: new UniqueKey(),
                  onVisibilityChanged: (info) {
                    if (snapshot.hasNext(subCategoryIndex) &&
                        !snapshot.isAlreadyLoadingMore(subCategoryIndex)) {
                      snapshot.fetchProducts(subCategoryIndex);
                    }
                  },
                  child: ProductTile(
                    product: snapshot.productsList(
                        subCategoryIndex, showFewProductsOnly)[productIndex],
                    navigateToDetails: () => snapshot.navigateToProductDetails(
                      snapshot.productsList(
                          subCategoryIndex, showFewProductsOnly)[productIndex],
                    ),
                  ),
                );
              }
              return ProductTile(
                product: snapshot.productsList(
                    subCategoryIndex, showFewProductsOnly)[productIndex],
                navigateToDetails: () => snapshot.navigateToProductDetails(
                  snapshot.productsList(
                      subCategoryIndex, showFewProductsOnly)[productIndex],
                ),
              );
            });
      },
    );
  }
}

// TODO : try to pass subcategoryIndex as an argument in viewModel to avoid passing it in every getter/functioon individually.
class _ViewModel extends BaseModel<AppState> {
  Function(int) fetchProducts;
  List<CategoriesNew> subCategoryList;
  CatalogSearchResponse allProducts;
  Map<int, bool> isLoadingMore;
  Map<int, CatalogSearchResponse> productListMap;
  Function(Product) navigateToProductDetails;
  List<Product> singleCategoryFewProducts;
  LoadingStatusApp loadingStatus;

  _ViewModel();

  _ViewModel.build({
    this.fetchProducts,
    this.subCategoryList,
    this.allProducts,
    this.isLoadingMore,
    this.productListMap,
    this.navigateToProductDetails,
    this.singleCategoryFewProducts,
    this.loadingStatus,
  }) : super(equals: [
          isLoadingMore,
          subCategoryList,
          allProducts,
          loadingStatus,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      subCategoryList: state.productState.categoryIdToSubCategoryData[
              state.productState.selectedCategory?.categoryId] ??
          [],
      allProducts: state.productState.allProductsForMerchant,
      loadingStatus: state.authState.loadingStatus,
      singleCategoryFewProducts: state.productState.singleCategoryFewProducts,
      isLoadingMore: state.productState.isLoadingMore,
      productListMap: state.productState.subCategoryIdToProductData,
      fetchProducts: (int subCategoryIndex) {
        if (subCategoryIndex == CustomCategoryForAllProducts().categoryId) {
          dispatch(
            GetAllProducts(
                urlForNextPageResponse:
                    state.productState.allProductsForMerchant.next),
          );
        } else {
          CategoriesNew _currentSubCategory = state
                  .productState.categoryIdToSubCategoryData[
              state.productState.selectedCategory.categoryId][subCategoryIndex];

          String nextUrl = state.productState
              .subCategoryIdToProductData[_currentSubCategory.categoryId].next;
          dispatch(
            GetProductsForSubCategory(
              urlForNextPageResponse: nextUrl,
              selectedSubCategory: _currentSubCategory,
            ),
          );
        }
      },
      navigateToProductDetails: (Product product) {
        dispatch(UpdateSelectedProductAction(product));
        dispatch(NavigateAction.pushNamed(RouteNames.PRODUCT_DETAILS));
      },
    );
  }

  bool get isLoading => loadingStatus == LoadingStatusApp.loading;

  bool noItemsFound(int subCategoryIndex, bool showFewProductsOnly) {
    return !isLoading &&
        !isAlreadyLoadingMore(subCategoryIndex) &&
        productsList(subCategoryIndex, showFewProductsOnly).isEmpty;
  }

  List<Product> productsList(int subCategoryIndex, bool showFewProductsOnly) {
    if (showFewProductsOnly) return singleCategoryFewProducts;

    if (subCategoryIndex == CustomCategoryForAllProducts().categoryId)
      return allProducts?.results ?? [];

    int _currentSubcategoryId = subCategoryList[subCategoryIndex].categoryId;
    return productListMap[_currentSubcategoryId]?.results ?? [];
  }

  bool hasNext(int subCategoryIndex) {
    if (subCategoryIndex == CustomCategoryForAllProducts().categoryId)
      return allProducts?.next != null;

    int _currentSubcategoryId = subCategoryList[subCategoryIndex].categoryId;
    return productListMap[_currentSubcategoryId]?.next != null;
  }

  bool isAlreadyLoadingMore(subCategoryIndex) {
    if (subCategoryIndex == CustomCategoryForAllProducts().categoryId)
      return isLoadingMore[subCategoryIndex] ?? false;

    int _currentSubcategoryId = subCategoryList[subCategoryIndex].categoryId;
    return isLoadingMore[_currentSubcategoryId] ?? false;
  }
}
