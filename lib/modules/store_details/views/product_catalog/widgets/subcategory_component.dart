import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/store_details/actions/store_actions.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/modules/store_details/views/product_catalog/widgets/product_tile.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';

class SubCategoryComponent extends StatelessWidget {
  // final GlobalKey<CustomExpansionTileState> expansionTileKey =
  //     GlobalKey<CustomExpansionTileState>();
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      // onInit: (store) {
      //   store.dispatch(GetSubCategoryDetailsAction(
      //       subCategory: store.state.productState.subCategories[0]));
      // },
      builder: (context, snapshot) {
        // if (snapshot.loadingStatus == LoadingStatusApp.loading) {
        //   return CircularProgressIndicator();
        // }
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.subCategories.length,
          shrinkWrap: true,
          itemBuilder: (context, subCategoryIndex) {
            return ExpansionTile(
                title: Text(
                  snapshot.subCategories[subCategoryIndex].categoryName,
                  style: CustomTheme.of(context).textStyles.body1,
                ),
                onExpansionChanged: (isExpanded) {
                  if (isExpanded) {
                    snapshot.updateSelectedCategory(
                        snapshot.subCategories[subCategoryIndex]);
                    snapshot.getProducts();
                  }
                },
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, productIndex) => ProductTile(
                      snapshot.products.length,
                      productIndex,
                      () {
                        snapshot.getProducts(
                            url: snapshot.productResponse.next);
                      },
                    ),
                  ),
                ]);
          },
        );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  LoadingStatusApp loadingStatus;
  List<CategoriesNew> subCategories;
  List<Product> products;
  Function({String url}) getProducts;
  Function(CategoriesNew) updateSelectedCategory;
  CatalogSearchResponse productResponse;

  _ViewModel();

  _ViewModel.build({
    this.loadingStatus,
    this.subCategories,
    this.products,
    this.getProducts,
    this.updateSelectedCategory,
    this.productResponse,
  }) : super(equals: [
          products,
          subCategories,
          // loadingStatus,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      loadingStatus: state.authState.loadingStatus,
      subCategories: state.productState.subCategories ?? [],
      products: state.productState.productListingDataSource ?? [],
      productResponse: state.productState.productResponse,
      getProducts: ({String url}) {
        dispatch(GetCatalogDetailsAction(url: url));
      },
      updateSelectedCategory: (category) {
        dispatch(
            UpdateSelectedSubCategoryAction(selectedSubCategory: category));
      },
    );
  }
}
