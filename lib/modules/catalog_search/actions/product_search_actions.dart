import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:flutter/cupertino.dart';

class GetItemsForMerchantProductSearch extends ReduxAction<AppState> {

   final String queryText;

   final String merchantId;

  GetItemsForMerchantProductSearch(
      {@required this.merchantId, @required this.queryText});

  @override
  FutureOr<void> before() {
    dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));
    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
    super.after();
  }

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.getBusinessesUrl + merchantId + "/catalog/products",
        requestType: RequestType.get,
        params: {
          "filter": queryText
        }
    );
    if (response.status == ResponseStatus.success200) {
      var responseModel = CatalogSearchResponse.fromJson(response.data);
      var items = responseModel.results;

      var products = items.map((f) {
        f.count = 0;
        return f;
      }).toList();

      List<Product> allCartItems = await CartDataSource.getListOfCartWith();

      products.forEach((item) {
        item.selectedVariant = 0;
        allCartItems.forEach((localCartItem) {
          if (item.productId == localCartItem.productId) {
            item.count = localCartItem.count;
          }
        });
      });

//      if (url != null) {
//        var totalProduct =
//            state.productState.productResponse.results + products;
//        products = totalProduct;
//        responseModel.results = products;
//      } else {}

      return state.copyWith(
          productState: state.productState.copyWith(
              //productListingDataSource: products,
              //productResponse: responseModel,
              searchResultProducts: products,
          ));
    }
    else {
      return null;
    }
  }

}

class ClearSearchResultProductsAction extends ReduxAction<AppState> {

  @override
  AppState reduce() {
    return state.copyWith(
      productState: state.productState.copyWith(
        searchResultProducts: [],
      ),
    );
  }

}