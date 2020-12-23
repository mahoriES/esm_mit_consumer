import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/cart/models/charge_details_response.dart';
import 'package:eSamudaay/modules/home/actions/home_page_actions.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
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
    try {
      final List<Product> localCartList =
          await CartDataSource.getListOfProducts();
      final List<JITProduct> freeFormItemsList =
          await CartDataSource.getFreeFormItems() ?? [];
      final List<String> customerNoteImages =
          await CartDataSource.getCustomerNoteImagesList();
      final Business merchant = await CartDataSource.getCartMerchant();

      if (merchant == null) {
        // as we changed the merchant table to merchant key_value in sharedPref , merchant will be null even if cart had some products in older version.
        // this condition will make sure that older version data is deleted.

        CartDataSource.deleteAllProducts();
        CartDataSource.deleteCartMerchant();
      } else {
        // fetch order charges if the cart data is not null.
        dispatch(GetOrderTaxAction(merchant));
      }

      return state.copyWith(
        cartState: state.cartState.copyWith(
          localCartItems: localCartList,
          localFreeFormCartItems: freeFormItemsList,
          customerNoteImages: customerNoteImages,
          cartMerchant: merchant,
        ),
      );
    } catch (_) {
      Fluttertoast.showToast(msg: "cart.cart_fetch_error");
      return null;
    }
  }

  @override
  void before() => dispatch(ToggleCartLoadingState(true));

  @override
  void after() => dispatch(ToggleCartLoadingState(false));
}

class AddToCartLocalAction extends ReduxAction<AppState> {
  final Product product;
  final Business selectedMerchant;

  AddToCartLocalAction({
    @required this.product,
    @required this.selectedMerchant,
  });

  @override
  FutureOr<AppState> reduce() async {
    try {
      // get store details for local cart.
      final Business cartMerchant = state.cartState.cartMerchant;

      if (cartMerchant != null) {
        // check if the product is already present in the cart
        final bool isInCart = state.cartState.isAvailableInCart(product);

        if (isInCart) {
          await CartDataSource.updateCartProduct(product);
        } else {
          await CartDataSource.insertProduct(product);
        }
        final List<Product> localCartItems =
            await CartDataSource.getListOfProducts();

        return state.copyWith(
          cartState: state.cartState.copyWith(
            localCartItems: localCartItems,
          ),
        );
      }
      // if cart is empty yet
      else {
        await CartDataSource.insertCartMerchant(selectedMerchant);
        await CartDataSource.insertProduct(product);

        final List<Product> localCartItems =
            await CartDataSource.getListOfProducts();
        // fetch order charges for selected merchant.
        dispatch(GetOrderTaxAction(selectedMerchant));

        return state.copyWith(
          cartState: state.cartState.copyWith(
            localCartItems: localCartItems,
            cartMerchant: selectedMerchant,
          ),
        );
      }
    } catch (_) {
      Fluttertoast.showToast(msg: tr("cart.generic_error"));
      return null;
    }
  }
}

class RemoveFromCartAction extends ReduxAction<AppState> {
  final Product product;
  RemoveFromCartAction({@required this.product});

  @override
  FutureOr<AppState> reduce() async {
    try {
      // if product count is decreamented to zero then remove the product from cart.
      if (product.count == 0) {
        await CartDataSource.deleteCartProduct(product);
      } else {
        await CartDataSource.updateCartProduct(product);
      }

      final List<Product> localCartItems =
          await CartDataSource.getListOfProducts();

      // if all products are removed clear the cart data.
      if (localCartItems.isEmpty) {
        await CartDataSource.deleteCartMerchant();
      }

      final Business merchant = await CartDataSource.getCartMerchant();

      return state.copyWith(
        cartState: state.cartState.copyWith(
          isMerchantAllowedToBeNull: true,
          localCartItems: localCartItems,
          cartMerchant: merchant,
        ),
      );
    } catch (_) {
      Fluttertoast.showToast(msg: tr("cart.generic_error"));
      return null;
    }
  }
}

// Delete existing data in cart and add new merchant as cart store along with the selected product.
class UpdateCartMerchantAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    try {
      Business merchant = await CartDataSource.getCartMerchant();
      // fetch order charges for selected merchant.
      dispatch(GetOrderTaxAction(merchant));

      return state.copyWith(
        cartState: state.cartState.copyWith(
          cartMerchant: merchant,
        ),
      );
    } catch (_) {
      Fluttertoast.showToast(msg: tr("cart.generic_error"));
      return null;
    }
  }
}

// TODO : Refactor this action.
class PlaceOrderAction extends ReduxAction<AppState> {
  final PlaceOrderRequest request;

  PlaceOrderAction({@required this.request});

  @override
  FutureOr<AppState> reduce() async {
    final response = await APIManager.shared.request(
        url: ApiURL.placeOrderUrl,
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.status == ResponseStatus.success200) {
//      request.order.status = "UNCONFIRMED";
      final responseModel = PlaceOrderResponse.fromJson(response.data);
      Fluttertoast.showToast(msg: 'Order Placed');
      await CartDataSource.deleteCartMerchant();
      await CartDataSource.deleteAllProducts();
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
  Business merchant;
  GetOrderTaxAction(this.merchant);
  @override
  FutureOr<AppState> reduce() async {
    if (merchant?.businessId == null) return null;

    final response = await APIManager.shared.request(
      url: ApiURL.getChargesUrl(merchant.businessId),
      params: null,
      requestType: RequestType.get,
    );

    if (response.status == ResponseStatus.success200) {
      final CartCharges cartCharges = CartCharges.fromJson(response.data);
      return state.copyWith(
        cartState: state.cartState.copyWith(charges: cartCharges),
      );
    } else {
      Fluttertoast.showToast(
          msg: response.data['message'] ?? tr("common.some_error_occured"));
      return null;
    }
  }

  @override
  void before() => dispatch(ToggleCartLoadingState(true));

  @override
  void after() => dispatch(ToggleCartLoadingState(false));
}

// TODO : Refactor this action.
class GetMerchantStatusAndPlaceOrderAction extends ReduxAction<AppState> {
  final PlaceOrderRequest request;

  GetMerchantStatusAndPlaceOrderAction({this.request});

  @override
  FutureOr<AppState> reduce() async {
    var merchant = await CartDataSource.getCartMerchant();
    var response = await APIManager.shared.request(
        url: ApiURL.getBusinessesUrl + "${merchant?.businessId}" + "/open",
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

class ToggleCartLoadingState extends ReduxAction<AppState> {
  bool isLoading;
  ToggleCartLoadingState(this.isLoading);

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      cartState: state.cartState.copyWith(
        isCartLoading: isLoading,
      ),
    );
  }
}
