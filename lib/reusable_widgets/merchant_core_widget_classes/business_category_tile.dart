import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/modules/head_categories/actions/categories_action.dart';
import 'package:eSamudaay/modules/head_categories/models/main_categories_response.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/size_config.dart';

class BusinessCategoryTile extends StatelessWidget {
  final Function onTap;
  final String categoryName;
  final String imageUrl;
  final double tileWidth;

  const BusinessCategoryTile(
      {Key key,
      @required this.onTap,
      @required this.categoryName,
      @required this.imageUrl,
      @required this.tileWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            width: tileWidth,
            height: tileWidth,
            child: Stack(
              children: [
                Positioned.fill(
                    child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  errorWidget: (_, __, ___) => placeHolderImage,
                  placeholder: (_, __) => placeHolderImage,
                  fit: BoxFit.cover,
                )),
                Positioned.fill(
                  child: FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    widthFactor: 1.0,
                    heightFactor: 0.20,
                    child: Container(
                      width: tileWidth,
                      color: CustomTheme.of(context)
                          .colors
                          .categoryTileTextUnderlay,
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Center(
                        child: Text(
                          categoryName,
                          maxLines: 1,
                          style: CustomTheme.of(context).textStyles.body2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
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
    );
  }

  Widget get placeHolderImage {
    return Image.asset(
      'assets/images/category_placeholder.png',
      fit: BoxFit.cover,
    );
  }
}

class HomeCategoriesGridView extends StatelessWidget {
  const HomeCategoriesGridView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        debugPrint(
            'Building the CategoryGridView ${snapshot.homePageCategoriesResponse.catalogCategories.length}');

        if (snapshot.homePageCategoriesResponse == null ||
            snapshot.homePageCategoriesResponse.catalogCategories == null ||
            snapshot.homePageCategoriesResponse.catalogCategories.isEmpty)
          return SizedBox.shrink();
        return Container(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.separatorPadding,
                vertical: AppSizes.separatorPadding),
            primary: false,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1),
            itemBuilder: (context, index) {
              HomePageCategoryResponse category =
                  snapshot.homePageCategoriesResponse.catalogCategories[index];
              return BusinessCategoryTile(
                imageUrl: category.categoryImageUrl ?? "",
                tileWidth: 75.toWidth,
                categoryName: category.categoryName ?? ' ',
                onTap: () {
                  snapshot.navigateToCategoryScreen(category);
                },
              );
            },
            itemCount:
                snapshot.homePageCategoriesResponse.catalogCategories.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
          ),
        );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  HomePageCategoriesResponse homePageCategoriesResponse;
  Function(HomePageCategoryResponse) navigateToCategoryScreen;

  _ViewModel.build({
    this.homePageCategoriesResponse,
    this.navigateToCategoryScreen,
  }) : super(equals: [
          homePageCategoriesResponse,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      homePageCategoriesResponse: state.homeCategoriesState.homePageCategories,
      navigateToCategoryScreen: (HomePageCategoryResponse selectedCategory) {
        dispatch(
            SelectHomePageCategoryAction(selectedCategory: selectedCategory));
        dispatch(NavigateAction.pushNamed(RouteNames.CATEGORY_BUSINESSES));
        debugPrint('Category selected');
      },
    );
  }
}
