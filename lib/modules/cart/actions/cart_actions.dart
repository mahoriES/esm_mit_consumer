import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/cart/models/charge_details_response.dart';
import 'package:eSamudaay/modules/home/actions/home_page_actions.dart';
import 'package:eSamudaay/modules/store_details/actions/store_actions.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/presentations/custom_dialog.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GetCartFromLocal extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    List<Product> localCartList = await CartDataSource.getListOfCartWith();
    List<JITProduct> freeFormItemsList =
        await CartDataSource.getFreeFormItems() ?? [];
    List<String> customerNoteImages =
        await CartDataSource.getCustomerNoteImagesList();
    var merchant = await CartDataSource.getListOfMerchants();

    return state.copyWith(
        productState: state.productState.copyWith(
            localCartItems: localCartList,
            localFreeFormCartItems: freeFormItemsList,
            customerNoteImages: customerNoteImages,
            selectedMerchant: state.productState.selectedMerchant != null
                ? state.productState.selectedMerchant
                : merchant.isEmpty
                    ? null
                    : merchant.first));
  }
}

class UpdateCartListAction extends ReduxAction<AppState> {
  final List<Product> localCart;

  UpdateCartListAction({this.localCart});

  @override
  FutureOr<AppState> reduce() {
    // TODO: implement reduce
    return state.copyWith(
        productState: state.productState.copyWith(localCartItems: localCart));
  }
}

class AddToCartLocalAction extends ReduxAction<AppState> {
  final Product product;
  final BuildContext context;

  AddToCartLocalAction({this.product, this.context});

  @override
  FutureOr<AppState> reduce() async {
    var merchant = await CartDataSource.getListOfMerchants();
    if (merchant.isNotEmpty) {
      if (merchant.first.businessId !=
          state.productState.selectedMerchant.businessId) {
        // TODO : this logic should be written in view part
        showDialog(
          context: context,
          barrierDismissible: false,
          child: CustomDialog(
            title: tr("product_details.replace_cart_items"),
            message: tr('new_changes.clear_info'),
            positiveButtonText: tr('new_changes.continue'),
            negativeButtonText: tr("screen_account.cancel"),
            positiveAction: () async {
              await CartDataSource.deleteAllMerchants();
              await CartDataSource.deleteAll();
              await CartDataSource.insertToMerchants(
                  business: state.productState.selectedMerchant);
              bool isInCart = await CartDataSource.isAvailableInCart(
                  id: product.productId.toString(),
                  variation: product
                      .skus[product.selectedVariant].variationOptions.weight);
              if (isInCart) {
                await CartDataSource.update(
                    product,
                    product
                        .skus[product.selectedVariant].variationOptions.weight);
              } else {
                await CartDataSource.insert(
                    product: product,
                    variation: product
                        .skus[product.selectedVariant].variationOptions.weight);
              }
              List<Product> allCartNewList = [];
              List<Product> allCartItems =
                  state.productState.productListingDataSource;
              allCartItems.forEach((value) {
                if (value.productId == product.productId) {
                  value.count = product.count;
                }
                allCartNewList.add(value);
              });
              var localCartItems = await CartDataSource.getListOfCartWith();
              Navigator.pop(context);
              dispatch(
                  UpdateProductListingDataAction(listingData: allCartNewList));
              dispatch(UpdateCartListAction(localCart: localCartItems));
            },
          ),
        );
      } else {
        await CartDataSource.deleteAllMerchants();
        await CartDataSource.insertToMerchants(
            business: state.productState.selectedMerchant);
        bool isInCart = await CartDataSource.isAvailableInCart(
            id: product.productId.toString(),
            variation:
                product.skus[product.selectedVariant].variationOptions.weight);
        if (isInCart) {
          await CartDataSource.update(product,
              product.skus[product.selectedVariant].variationOptions.weight);
        } else {
          await CartDataSource.insert(
              product: product,
              variation: product
                  .skus[product.selectedVariant].variationOptions.weight);
        }
        List<Product> allCartNewList = [];
        List<Product> allCartItems =
            state.productState.productListingDataSource;
        allCartItems.forEach((value) {
          if (value.productId == product.productId) {
            value.count = product.count;
          }
          allCartNewList.add(value);
        });
        var localCartItems = await CartDataSource.getListOfCartWith();

        return state.copyWith(
            productState: state.productState.copyWith(
          productListingDataSource: allCartNewList,
          localCartItems: localCartItems,
        ));
      }
    } else {
      await CartDataSource.deleteAllMerchants();
      await CartDataSource.insertToMerchants(
          business: state.productState.selectedMerchant);
      bool isInCart = await CartDataSource.isAvailableInCart(
          id: product.productId.toString(),
          variation:
              product.skus[product.selectedVariant].variationOptions.weight);
      if (isInCart) {
        await CartDataSource.update(product,
            product.skus[product.selectedVariant].variationOptions.weight);
      } else {
        await CartDataSource.insert(
            product: product,
            variation:
                product.skus[product.selectedVariant].variationOptions.weight);
      }
      List<Product> allCartNewList = [];
      List<Product> allCartItems = state.productState.productListingDataSource;
      allCartItems.forEach((value) {
        if (value.productId == product.productId) {
          value.count = product.count;
        }
        allCartNewList.add(value);
      });
      var localCartItems = await CartDataSource.getListOfCartWith();

      return state.copyWith(
          productState: state.productState.copyWith(
        productListingDataSource: allCartNewList,
        localCartItems: localCartItems,
      ));
    }
    return null;
  }
}

class RemoveFromCartLocalAction extends ReduxAction<AppState> {
  final Product product;

  RemoveFromCartLocalAction({this.product});

  @override
  FutureOr<AppState> reduce() async {
    bool isInCart = await CartDataSource.isAvailableInCart(
        id: product.productId.toString(),
        variation:
            product.skus[product.selectedVariant].variationOptions.weight);
    if (isInCart) {
      if (product.count == 0.0) {
        await CartDataSource.delete(product.productId.toString(),
            product.skus[product.selectedVariant].variationOptions.weight);
      } else {
        await CartDataSource.update(product,
            product.skus[product.selectedVariant].variationOptions.weight);
      }
    }
    List<Product> allItemsNewList = [];
    List<Product> allItemList = state.productState.productListingDataSource;
//    Item selectedProduct = state.productState.selectedProduct;

    allItemList.forEach((value) {
      if (value.productId == product.productId) {
        value.count = product.count;
      }
//      if (state.productState?.selectedProduct != null &&
//          state.productState.selectedProduct.id == value.id) {
//        selectedProduct.inCart = product.inCart;
//      }
      allItemsNewList.add(value);
    });
    var localCartItems = await CartDataSource.getListOfCartWith();
    if (localCartItems.isEmpty) {
      await CartDataSource.deleteAllMerchants();
    }
    return state.copyWith(
        productState: state.productState.copyWith(
      productListingDataSource: allItemsNewList,
      localCartItems: localCartItems,
//            selectedProduct: state.productState?.selectedProduct
//                ?.copyWith(inCart: selectedProduct?.inCart)
    ));
  }
}

class PlaceOrderAction extends ReduxAction<AppState> {
  final PlaceOrderRequest request;

  PlaceOrderAction({this.request});

  @override
  FutureOr<AppState> reduce() async {
    print(request.toJson());
    var response = await APIManager.shared.request(
        url: ApiURL.placeOrderUrl,
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.status == ResponseStatus.success200) {
//      request.order.status = "UNCONFIRMED";
      var responseModel = PlaceOrderResponse.fromJson(response.data);
      Fluttertoast.showToast(msg: 'Order Placed');
      await CartDataSource.deleteAllMerchants();
      await CartDataSource.deleteAll();
      await CartDataSource.insertCustomerNoteImagesList([]);
      await CartDataSource.insertFreeFormItemsList([]);

      dispatch(GetCartFromLocal());
      dispatch(UpdateSelectedTabAction(1));
      dispatch(NavigateAction.pushNamedAndRemoveAll("/myHomeView"));
      return state.copyWith(
          productState:
              state.productState.copyWith(placeOrderResponse: responseModel));
    } else {
//      request.order.status = "COMPLETED";
      Fluttertoast.showToast(msg: response.data['message']);
    }
    return null;
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}

class GetOrderTaxAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var merchant = await CartDataSource.getListOfMerchants();

    var response = await APIManager.shared.request(
        url: ApiURL.getBusinessesUrl +
            "${merchant.first.businessId}" +
            "/charges",
        params: {"": ""},
        requestType: RequestType.get);
    if (response.status == ResponseStatus.success200) {
      List<Charge> charge = new List<Charge>();
      response.data.forEach((v) {
        charge.add(new Charge.fromJson(v));
      });
      return state.copyWith(
          productState: state.productState.copyWith(charges: charge));
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
      return null;
    }
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}

class GetMerchantStatusAndPlaceOrderAction extends ReduxAction<AppState> {
  final PlaceOrderRequest request;

  GetMerchantStatusAndPlaceOrderAction({this.request});

  @override
  FutureOr<AppState> reduce() async {
    var merchant = await CartDataSource.getListOfMerchants();
    var response = await APIManager.shared.request(
        url: ApiURL.getBusinessesUrl + "${merchant.first.businessId}" + "/open",
        params: {"": ""},
        requestType: RequestType.get);
    if (response.status == ResponseStatus.success200) {
      if (response.data['is_open']) {
        dispatch(PlaceOrderAction(request: request));
      } else {
        Fluttertoast.showToast(msg: tr('new_changes.shop_closed'));
      }
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
      return null;
    }
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}
