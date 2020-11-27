import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/store_details/actions/store_actions.dart';
import 'package:eSamudaay/modules/store_details/views/product_catalog/widgets/product_list_view.dart';
import 'package:eSamudaay/presentations/custom_expansion_tile.dart';
import 'package:eSamudaay/presentations/loading_indicator.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubCategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        debugPrint("is Loading More => ${snapshot.isLoadingMore}");

        return snapshot.loadingStatus == LoadingStatusApp.loading
            ? LoadingIndicator()
            : snapshot.selectedCategory is CustomCategoryForAllProducts
                ?
                // If selected category is "All", then show all of the products list view irrespectve of any subcategory.
                Column(
                    children: [
                      ProductListView(
                        subCategoryIndex: snapshot.selectedCategory.categoryId,
                      ),
                      if (snapshot.isLoadingMore[
                              snapshot.selectedCategory.categoryId] ??
                          false) ...[
                        CupertinoActivityIndicator(),
                      ],
                    ],
                  )
                :
                // for dynamic categories, check if there are nonzero subcategories.
                snapshot.subCategoriesList?.isEmpty ?? true
                    ? Center(
                        child: Text("No Items Found"),
                      )
                    :
                    // otherwise show product list wrapped with respective subcategories.
                    ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.subCategoriesList.length,
                        shrinkWrap: true,
                        separatorBuilder: (context, subCategoryIndex) =>
                            SizedBox(height: 8.toHeight),
                        itemBuilder: (context, subCategoryIndex) {
                          CategoriesNew _currentSubCategory =
                              snapshot.subCategoriesList[subCategoryIndex];

                          return _SubCategoryHeaderTile(
                            subCategoryIndex: subCategoryIndex,
                            categoryName: _currentSubCategory.categoryName,
                            getProducts: () =>
                                snapshot.getProducts(_currentSubCategory),
                            isCurrentSubcategoryLodingMore:
                                snapshot.isCurrentSubcategoryLodingMore(
                                    subCategoryIndex),
                          );
                        },
                      );
      },
    );
  }
}

class _SubCategoryHeaderTile extends StatefulWidget {
  final int subCategoryIndex;
  final String categoryName;
  final Function() getProducts;
  final bool isCurrentSubcategoryLodingMore;
  _SubCategoryHeaderTile({
    @required this.subCategoryIndex,
    @required this.categoryName,
    @required this.getProducts,
    @required this.isCurrentSubcategoryLodingMore,
    Key key,
  }) : super(key: key);

  @override
  _SubCategoryTileState createState() => _SubCategoryTileState();
}

class _SubCategoryTileState extends State<_SubCategoryHeaderTile> {
  final GlobalKey<CustomExpansionTileState> expansionTileKey =
      new GlobalKey<CustomExpansionTileState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.subCategoryIndex == 0)
        expansionTileKey.currentState.handleTap();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      key: expansionTileKey,
      title: Text(
        widget.categoryName,
        style: CustomTheme.of(context).textStyles.body1,
      ),
      onExpansionChanged: (isExpanded) {
        if (isExpanded) {
          widget.getProducts();
        }
      },
      children: [
        SizedBox(height: 12.toHeight),
        ProductListView(subCategoryIndex: widget.subCategoryIndex),
        if (widget.isCurrentSubcategoryLodingMore) ...[
          CupertinoActivityIndicator(),
        ],
        SizedBox(height: 12.toHeight),
      ],
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  Map<int, bool> isLoadingMore;
  List<CategoriesNew> subCategoriesList;
  CategoriesNew selectedCategory;
  Function(CategoriesNew subCategory, {String url}) getProducts;
  LoadingStatusApp loadingStatus;

  _ViewModel();

  _ViewModel.build({
    this.isLoadingMore,
    this.selectedCategory,
    this.getProducts,
    this.loadingStatus,
    this.subCategoriesList,
  }) : super(equals: [
          isLoadingMore,
          loadingStatus,
          selectedCategory,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      selectedCategory: state.productState.selectedCategory,
      isLoadingMore: state.productState.isLoadingMore,
      loadingStatus: state.authState.loadingStatus,
      subCategoriesList: state.productState.categoryIdToSubCategoryData[
          state.productState.selectedCategory.categoryId],
      getProducts: (CategoriesNew subCategory, {String url}) {
        dispatch(
          GetProductsForSubCategory(
            urlForNextPageResponse: url,
            selectedSubCategory: subCategory,
          ),
        );
      },
    );
  }

  bool isCurrentSubcategoryLodingMore(int subCategoryIndex) {
    return isLoadingMore[subCategoriesList[subCategoryIndex].categoryId] ??
        false;
  }
}
