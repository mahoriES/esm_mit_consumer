import 'dart:async';
import 'dart:io';
import 'package:async_redux/async_redux.dart';
import 'package:dio/dio.dart';
import 'package:eSamudaay/modules/address/models/addess_models.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/cart/models/charge_details_response.dart';
import 'package:eSamudaay/modules/home/actions/home_page_actions.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/presentations/custom_confirmation_dialog.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class GetCartFromLocal extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    try {
      final List<Product> localCartList =
          await CartDataSource.getListOfProducts();
      final List<String> customerNoteImages =
          await CartDataSource.getCustomerNoteImagesList();
      final Business merchant = await CartDataSource.getCartMerchant();

      if (merchant == null) {
        CartDataSource.resetCart();
      } else {
        // fetch order charges if the cart data is not null.
        dispatch(GetOrderTaxAction(merchant));
      }

      return state.copyWith(
        cartState: state.cartState.copyWith(
          isMerchantAllowedToBeNull: true,
          localCartItems: localCartList,
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
        await CartDataSource.resetCart();
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
      if (localCartItems.isEmpty &&
          state.cartState.customerNoteImages.isEmpty) {
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

class PlaceOrderAction extends ReduxAction<AppState> {
  final PlaceOrderRequest request;

  PlaceOrderAction({@required this.request});

  @override
  FutureOr<AppState> reduce() async {
    try {
      final response = await APIManager.shared.request(
        url: ApiURL.placeOrderUrl,
        params: request.toJson(),
        requestType: RequestType.post,
      );

      if (response.status == ResponseStatus.success200) {
        final responseModel = PlaceOrderResponse.fromJson(response.data);
        Fluttertoast.showToast(msg: tr("cart.order_placed"));
        await CartDataSource.resetCart();
        dispatch(GetCartFromLocal());
        dispatch(UpdateSelectedTabAction(1));
        dispatch(NavigateAction.pushNamedAndRemoveAll(RouteNames.HOME_PAGE));
        return state.copyWith(
          productState: state.productState.copyWith(
            placeOrderResponse: responseModel,
          ),
        );
      } else {
        Fluttertoast.showToast(
            msg: response.data['message'] ?? tr("common.some_error_occured"));
      }
    } catch (_) {
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
    }
    return null;
  }

  void before() => dispatch(ToggleCartLoadingState(true));

  void after() => dispatch(ToggleCartLoadingState(false));
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

class GetMerchantStatusAndPlaceOrderAction extends ReduxAction<AppState> {
  final PlaceOrderRequest request;

  GetMerchantStatusAndPlaceOrderAction({this.request});

  @override
  FutureOr<AppState> reduce() async {
    try {
      final response = await APIManager.shared.request(
        url: ApiURL.getStoreStatusUrl(request?.businessId),
        params: null,
        requestType: RequestType.get,
      );
      if (response.status == ResponseStatus.success200) {
        if (response.data['is_open']) {
          dispatch(PlaceOrderAction(request: request));
        } else {
          Fluttertoast.showToast(msg: tr('new_changes.shop_closed'));
        }
      } else {
        Fluttertoast.showToast(
            msg: response.data['message'] ?? tr("common.some_error_occured"));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
    }
    return null;
  }

  void before() => dispatch(ToggleCartLoadingState(true));

  void after() => dispatch(ToggleCartLoadingState(false));
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

class ToggleImageUploadingState extends ReduxAction<AppState> {
  bool isLoading;
  ToggleImageUploadingState(this.isLoading);

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      cartState: state.cartState.copyWith(
        isImageUploading: isLoading,
      ),
    );
  }
}

class UpdateDeliveryType extends ReduxAction<AppState> {
  String type;
  UpdateDeliveryType(this.type);

  @override
  FutureOr<AppState> reduce() async {
    return state.copyWith(
      cartState: state.cartState.copyWith(
        selectedDeliveryType: type,
      ),
    );
  }
}

class GetInitialDeliveryType extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    if (store.state.cartState.selectedDeliveryType == null) {
      final bool isDeliveryAvailable =
          store.state.cartState.cartMerchant?.hasDelivery ?? false;
      final String type = isDeliveryAvailable
          ? DeliveryType.DeliveryToHome
          : DeliveryType.StorePickup;
      return state.copyWith(
        cartState: state.cartState.copyWith(
          selectedDeliveryType: type,
        ),
      );
    }
    return null;
  }
}

class GetInitialSelectedAddress extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    final AddressResponse selectedAddress =
        store.state.addressState.selectedAddressForDelivery;
    if (selectedAddress == null) {
      if (store.state.addressState.savedAddressList != null &&
          store.state.addressState.savedAddressList.isNotEmpty) {
        return state.copyWith(
          addressState: state.addressState.copyWith(
            selectedAddressForDelivery:
                store.state.addressState.savedAddressList.first,
          ),
        );
      }
    }
    return null;
  }
}

class AddCustomerNoteImageAction extends ReduxAction<AppState> {
  final ImageSource imageSource;
  AddCustomerNoteImageAction({@required this.imageSource});

  Future<dynamic> getImage() async {
    final PickedFile imageFile = await ImagePicker().getImage(
      source: imageSource,
      imageQuality: 25,
    );
    if (imageFile == null) {
      return false;
    }
    return File(imageFile.path);
  }

  @override
  FutureOr<AppState> reduce() async {
    try {
      final imageFile = await getImage();
      if (imageFile == false) return null;

      final response = await APIManager.shared.request(
        requestType: RequestType.post,
        url: ApiURL.imageUpload,
        params: FormData.fromMap(
          {
            "file": await MultipartFile.fromFile(
              imageFile.path,
              filename: 'customerImage.jpg',
            )
          },
        ),
      );
      if (response.status == ResponseStatus.success200) {
        final Photo photo = Photo.fromJson(response.data);
        if (photo.photoUrl == null) {
          throw Exception();
        }
        final List<String> updatedImageList = state.cartState.customerNoteImages
          ..add(photo.photoUrl);
        CartDataSource.insertCustomerNoteImagesList(updatedImageList);
        return state.copyWith(
          cartState: state.cartState.copyWith(
            customerNoteImages: updatedImageList,
          ),
        );
      } else {
        throw Exception();
      }
    } catch (_) {
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
      return null;
    }
  }

  void before() => dispatch(ToggleImageUploadingState(true));

  void after() => dispatch(ToggleImageUploadingState(false));
}

class RemoveCustomerNoteImageAction extends ReduxAction<AppState> {
  final int imageIndex;
  RemoveCustomerNoteImageAction({@required this.imageIndex});

  @override
  FutureOr<AppState> reduce() async {
    try {
      final List<String> updatedImageList = state.cartState.customerNoteImages
        ..removeAt(imageIndex);

      await CartDataSource.insertCustomerNoteImagesList(updatedImageList);

      final List<String> updatedList =
          await CartDataSource.getCustomerNoteImagesList();

      if (state.cartState.localCartItems.isEmpty && updatedList.isEmpty) {
        await CartDataSource.deleteCartMerchant();
      }

      final Business merchant = await CartDataSource.getCartMerchant();

      return state.copyWith(
        cartState: state.cartState.copyWith(
          isMerchantAllowedToBeNull: true,
          customerNoteImages: updatedImageList,
          cartMerchant: merchant,
        ),
      );
    } catch (_) {
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
      return null;
    }
  }

  void before() => dispatch(ToggleImageUploadingState(true));

  void after() => dispatch(ToggleImageUploadingState(false));
}

class CheckToReplaceCartAction extends ReduxAction<AppState> {
  Business selectedMerchant;
  VoidCallback onSuccess;
  BuildContext context;
  CheckToReplaceCartAction({
    @required this.selectedMerchant,
    @required this.onSuccess,
    @required this.context,
  });
  @override
  FutureOr<AppState> reduce() async {
    final Business cartMerchant = state.cartState.cartMerchant;

    final bool isSameMerchantAddedInCart =
        state.cartState.cartMerchant?.businessId == selectedMerchant.businessId;

    // if no merchant is selected
    if (cartMerchant == null) {
      await CartDataSource.resetCart();
      await CartDataSource.insertCartMerchant(
        state.productState.selectedMerchant,
      );
      await dispatchFuture(GetCartFromLocal());
      final Business updatedMerchant = await CartDataSource.getCartMerchant();
      if (updatedMerchant.businessId ==
          state.productState.selectedMerchant.businessId) {
        onSuccess();
      }
      return null;
    }
    // if same merchant is selected.
    else if (isSameMerchantAddedInCart) {
      onSuccess();
      return null;
    }

    // if diffrent merchant is selected but no items are added.
    else if (state.cartState.localCartItems.isEmpty &&
        state.cartState.customerNoteImages.isEmpty) {
      await CartDataSource.resetCart();
      await CartDataSource.insertCartMerchant(selectedMerchant);
      await dispatchFuture(GetCartFromLocal());
      final Business updatedMerchant = await CartDataSource.getCartMerchant();

      if (updatedMerchant.businessId == selectedMerchant.businessId) {
        onSuccess();
        return null;
      }
    }
    // if diffrent merchant is selected and items are added.
    else {
      showDialog(
        context: context,
        barrierDismissible: false,
        child: CustomConfirmationDialog(
          title: tr("product_details.replace_cart_items"),
          message: tr('new_changes.clear_info'),
          positiveButtonText: tr('new_changes.continue'),
          negativeButtonText: tr("screen_account.cancel"),
          positiveAction: () async {
            Navigator.pop(context);
            await CartDataSource.resetCart();
            await CartDataSource.insertCartMerchant(
                state.productState.selectedMerchant);
            await dispatchFuture(GetCartFromLocal());
            final Business updatedMerchant =
                await CartDataSource.getCartMerchant();

            if (updatedMerchant.businessId ==
                state.productState.selectedMerchant.businessId) {
              onSuccess();
              return null;
            }
          },
        ),
      );
    }
    return null;
  }
}
