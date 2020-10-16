import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';

class AddFreeFormItemAction extends ReduxAction<AppState> {
  final JITProduct jitProduct;

  AddFreeFormItemAction({@required this.jitProduct});

  @override
  FutureOr<AppState> reduce() {
    List<JITProduct> freeFormOrderItems =
        state.productState.localFreeFormCartItems ?? [];

    if (!doesThisJitProductExistInLocalCart(jitProduct))
      freeFormOrderItems.add(jitProduct);

    List<JITProduct> newFreeFormItemList = [];
    freeFormOrderItems.forEach((element) {
      newFreeFormItemList.add(element);
    });
    CartDataSource.insertFreeFormItemsList(newFreeFormItemList);
    return state.copyWith(
        productState: state.productState
            .copyWith(localFreeFormCartItems: newFreeFormItemList));
  }

  bool doesThisJitProductExistInLocalCart(JITProduct jitProduct) {
    List<JITProduct> freeFormOrderItems =
        state.productState.localFreeFormCartItems ?? [];
    if (freeFormOrderItems.isEmpty) return false;
    var itemToBeRemoved = freeFormOrderItems.firstWhere(
        (element) => (element.quantity == jitProduct.quantity &&
            element.itemName == jitProduct.itemName), orElse: () {
      debugPrint("Item doesn't exist");
      return null;
    });
    if (itemToBeRemoved == null) return false;
    return true;
  }
}

class RemoveFreeFormItemAction extends ReduxAction<AppState> {
  final JITProduct jitProduct;

  RemoveFreeFormItemAction({@required this.jitProduct});

  @override
  FutureOr<AppState> reduce() {
    List<JITProduct> freeFormOrderItems =
        state.productState.localFreeFormCartItems ?? [];

    freeFormOrderItems.remove(jitProduct);

    List<JITProduct> newFreeFormItemList = [];
    freeFormOrderItems.forEach((element) {
      newFreeFormItemList.add(element);
    });
    CartDataSource.insertFreeFormItemsList(newFreeFormItemList);
    return state.copyWith(
      productState: state.productState.copyWith(
        localFreeFormCartItems: newFreeFormItemList,
      ),
    );
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}

class RemoveFreeFormItemByIndexAction extends ReduxAction<AppState> {
  final int index;

  RemoveFreeFormItemByIndexAction({@required this.index});

  @override
  FutureOr<AppState> reduce() {
    List<JITProduct> freeFormOrderItems =
        state.productState.localFreeFormCartItems ?? [];
    if (freeFormOrderItems == null || freeFormOrderItems.length <= index)
      return null;
    dispatch(RemoveFreeFormItemAction(jitProduct: freeFormOrderItems[index]));
    return null;
  }
}

class UpdateFreeFormItemSkuName extends ReduxAction<AppState> {
  final String skuName;
  final int updatedIndex;

  UpdateFreeFormItemSkuName(
      {@required this.updatedIndex, @required this.skuName});

  @override
  FutureOr<AppState> reduce() {
    List<JITProduct> freeFormOrderItems =
        state.productState.localFreeFormCartItems ?? [];
    if (updatedIndex >= freeFormOrderItems.length) {
      debugPrint("Creating new product");
      JITProduct updatedProduct = JITProduct(quantity: 0, itemName: skuName);
      freeFormOrderItems.add(updatedProduct);
    } else {
      debugPrint("Altering existing product");
      JITProduct product = freeFormOrderItems.removeAt(updatedIndex);
      JITProduct updatedProduct =
          JITProduct(quantity: product.quantity ?? 0, itemName: skuName);
      freeFormOrderItems.insert(updatedIndex, updatedProduct);
    }

    List<JITProduct> newFreeFormItemList = [];
    freeFormOrderItems.forEach((element) {
      newFreeFormItemList.add(element);
    });
    CartDataSource.insertFreeFormItemsList(newFreeFormItemList);
    return state.copyWith(
      productState: state.productState.copyWith(
        localFreeFormCartItems: newFreeFormItemList,
      ),
    );
  }
}

class UpdateFreeFormItemQuantity extends ReduxAction<AppState> {
  final int updatedIndex;
  final int quantity;

  UpdateFreeFormItemQuantity(
      {@required this.quantity, @required this.updatedIndex});

  @override
  FutureOr<AppState> reduce() {
    List<JITProduct> freeFormOrderItems =
        state.productState.localFreeFormCartItems ?? [];
    if (updatedIndex >= freeFormOrderItems.length) {
      debugPrint("Creating new product");
      JITProduct updatedProduct = JITProduct(quantity: quantity, itemName: "");
      freeFormOrderItems.add(updatedProduct);
    } else {
      debugPrint("Altering existing product");
      JITProduct product = freeFormOrderItems.removeAt(updatedIndex);
      JITProduct updatedProduct =
          JITProduct(quantity: quantity, itemName: product.itemName ?? "");
      freeFormOrderItems.insert(updatedIndex, updatedProduct);
    }

    List<JITProduct> newFreeFormItemList = [];
    freeFormOrderItems.forEach((element) {
      newFreeFormItemList.add(element);
    });
    CartDataSource.insertFreeFormItemsList(newFreeFormItemList);
    return state.copyWith(
      productState: state.productState.copyWith(
        localFreeFormCartItems: newFreeFormItemList,
      ),
    );
  }
}

class ClearLocalFreeFormItemsAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
      productState: state.productState.copyWith(
        localFreeFormCartItems: [],
        customerNoteImages: [],
      ),
    );
  }
}

class CheckLocalFreeFormItemsAndAddEmptyItem extends ReduxAction<AppState> {
  final BuildContext context;

  CheckLocalFreeFormItemsAndAddEmptyItem({@required this.context});

  @override
  FutureOr<AppState> reduce() {
    List<JITProduct> freeFormOrderItems =
        state.productState.localFreeFormCartItems ?? [];

    if (freeFormOrderItems.isNotEmpty) {
      for (final element in freeFormOrderItems) {
        if (element.quantity < 1 || element.itemName == "") {
          Fluttertoast.showToast(msg: "Please add missing free form items");
          return null;
        }
      }
    }
    setMerchantForFreeFormItem(context);
    List<JITProduct> newFreeFormItemList = [];
    freeFormOrderItems.forEach((element) {
      newFreeFormItemList.add(element);
    });
    newFreeFormItemList.add(JITProduct(quantity: 0, itemName: ""));
    CartDataSource.insertFreeFormItemsList(newFreeFormItemList);
    return state.copyWith(
      productState: state.productState.copyWith(
        localFreeFormCartItems: newFreeFormItemList,
      ),
    );
  }

  ///This function checks if the user has already added free form items previously from another merchant.
  ///If yes, then those are cleared before adding list items for new merchant.
  void setMerchantForFreeFormItem(BuildContext context) async {
    var merchant = await CartDataSource.getListOfMerchants();
    if (merchant.isNotEmpty) {
      if (merchant.first.businessId !=
          state.productState.selectedMerchant.businessId) {
        showDialog(
            context: context,
            child: AlertDialog(
              title: Text("E-samudaay"),
              content: Text(
                'new_changes.clear_info',
                style: const TextStyle(
                    color: const Color(0xff6f6d6d),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Avenir-Medium",
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0),
              ).tr(),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'screen_account.cancel',
                    style: const TextStyle(
                        color: const Color(0xff6f6d6d),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Avenir-Medium",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                  ).tr(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text(
                    'new_changes.continue',
                    style: const TextStyle(
                        color: const Color(0xff6f6d6d),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Avenir-Medium",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                  ).tr(),
                  onPressed: () async {
                    await CartDataSource.deleteAllMerchants();
                    await CartDataSource.deleteAll();
                    await CartDataSource.insertToMerchants(
                        business: state.productState.selectedMerchant);
                    Navigator.pop(context);
                  },
                )
              ],
            ));
      } else {
        await CartDataSource.deleteAllMerchants();
        await CartDataSource.insertToMerchants(
            business: state.productState.selectedMerchant);
      }
    } else {
      await CartDataSource.deleteAllMerchants();
      await CartDataSource.insertToMerchants(
          business: state.productState.selectedMerchant);
    }
  }
}
