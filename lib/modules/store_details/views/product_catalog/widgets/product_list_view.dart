import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/store_details/actions/store_actions.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'product_tile.dart';

class ProductListView extends StatelessWidget {
  final int subCategoryIndex;
  const ProductListView({
    @required this.subCategoryIndex,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        // If data is loaded and the list is still empty then show no items found.
        // TODO : This should be handeled on backend in future.
        if (!snapshot.isAlreadyLoadingMore(subCategoryIndex) &&
            snapshot.productsList(subCategoryIndex).isEmpty) {
          return Center(
            child: Text("No Items Found"),
          );
        }
        return ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.productsList(subCategoryIndex).length,
            shrinkWrap: true,
            separatorBuilder: (context, productIndex) =>
                SizedBox(height: 16.toHeight),
            itemBuilder: (context, productIndex) {
              // If the 3rd last element of list is in view then load more data is available.
              if (productIndex ==
                  snapshot.productsList(subCategoryIndex).length - 3) {
                return VisibilityDetector(
                  key: new UniqueKey(),
                  onVisibilityChanged: (info) {
                    if (snapshot.hasNext(subCategoryIndex) &&
                        !snapshot.isAlreadyLoadingMore(subCategoryIndex)) {
                      snapshot.fetchProducts(subCategoryIndex);
                    }
                  },
                  child: ProductTile(
                    product:
                        snapshot.productsList(subCategoryIndex)[productIndex],
                    navigateToDetails: () => snapshot.navigateToProductDetails(
                      snapshot.productsList(subCategoryIndex)[productIndex],
                    ),
                  ),
                );
              }
              return ProductTile(
                product: snapshot.productsList(subCategoryIndex)[productIndex],
                navigateToDetails: () => snapshot.navigateToProductDetails(
                  snapshot.productsList(subCategoryIndex)[productIndex],
                ),
              );
            });
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  Function(int) fetchProducts;
  List<CategoriesNew> subCategoryList;
  CatalogSearchResponse allProducts;
  Map<int, bool> isLoadingMore;
  Map<int, CatalogSearchResponse> productListMap;
  Function(Product) navigateToProductDetails;

  _ViewModel();

  _ViewModel.build({
    this.fetchProducts,
    this.subCategoryList,
    this.allProducts,
    this.isLoadingMore,
    this.productListMap,
    this.navigateToProductDetails,
  }) : super(equals: [
          isLoadingMore,
          subCategoryList,
          allProducts,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      subCategoryList: state.productState.categoryIdToSubCategoryData[
              state.productState.selectedCategory.categoryId] ??
          [],
      allProducts: state.productState.allProductsForMerchant,
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

  List<Product> productsList(int subCategoryIndex) {
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
