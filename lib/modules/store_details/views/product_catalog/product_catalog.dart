import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/store_details/views/product_catalog/widgets/product_list_component.dart';
import 'package:eSamudaay/modules/store_details/views/product_catalog/widgets/search_component.dart';
import 'package:eSamudaay/modules/store_details/views/product_catalog/widgets/subcategories_tabbar.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProductCatalogView extends StatelessWidget {
  const ProductCatalogView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) => Scaffold(
        // TODO : app bar should be used from maerchant main view.
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.toWidth),
          child: Column(
            children: [
              SizedBox(height: 22.toHeight),
              SearchComponent(
                placeHolder: tr('product_list.search_placeholder'),
                isEnabled: false,
                onTapIfDisabled: snapshot.navigateToSearchView,
                controller: null,
              ),
              SizedBox(height: 22.toHeight),
              DefaultTabController(
                length: snapshot.subCategories.length + 1,
                child: Column(
                  children: [
                    SubCatergoriesTabbar(subCategories: snapshot.subCategories),
                    SizedBox(height: 22.toHeight),
                    // ProductListComponent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  Function navigateToSearchView;
  List<CategoriesNew> subCategories;

  _ViewModel();

  _ViewModel.build({
    this.navigateToSearchView,
    this.subCategories,
  });

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      navigateToSearchView: () =>
          dispatch(NavigateAction.pushNamed(RouteNames.PRODUCT_SEARCH)),
      subCategories: state.productState.subCategories ?? [],
    );
  }
}
