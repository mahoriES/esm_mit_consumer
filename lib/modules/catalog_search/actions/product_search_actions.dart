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
import 'package:fluttertoast/fluttertoast.dart';

///An action to search products for a particular merchant for a given query text
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
      ///Preparing a list of products from the fetched items and initialising
      ///the selected quantity for each [product] to zero.
      var products = items.map((item) {
        item.count = 0;
        return item;
      }).toList();
      ///Getting the list of all items currently persisted in the local cart
      ///data source
      List<Product> allCartItems = await CartDataSource.getListOfCartWith();
      ///Initialising the selected SKU for each product (in the fetched product
      ///list) and if the item has already been added to the local cart, then
      ///updating it's quantity to that in the local cart.
      products.forEach((item) {
        item.selectedVariant = 0;
        allCartItems.forEach((localCartItem) {
          if (item.productId == localCartItem.productId) {
            item.count = localCartItem.count;
          }
        });
      });

      return state.copyWith(
          productState: state.productState.copyWith(
              searchResultProducts: products,
              searchForProductsComplete: true
          ));
    }
    else {
      Fluttertoast.showToast(msg: "Error fetching items!");
      return state.copyWith(
          productState: state.productState.copyWith(
              searchForProductsComplete: true
          ));
    }
  }

}

///This action is used to clear the items which were searched and stored in the
///local store.
class ClearSearchResultProductsAction extends ReduxAction<AppState> {

  @override
  AppState reduce() {
    return state.copyWith(
      productState: state.productState.copyWith(
        searchResultProducts: [],
        searchForProductsComplete: false,
      ),
    );
  }

}