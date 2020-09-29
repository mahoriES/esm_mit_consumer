import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
//    var itemToBeRemoved = freeFormOrderItems.firstWhere(
//        (element) => (element.quantity == jitProduct.quantity &&
//            element.itemName == jitProduct.itemName), orElse: () {
//      debugPrint("Item doesn't exist");
//      return null;
//    });
    //if (itemToBeRemoved != null) freeFormOrderItems.remove(itemToBeRemoved);

    freeFormOrderItems.remove(jitProduct);

    List<JITProduct> newFreeFormItemList = [];
    freeFormOrderItems.forEach((element) {
      newFreeFormItemList.add(element);
    });
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

    return state.copyWith(
      productState: state.productState.copyWith(
        localFreeFormCartItems: newFreeFormItemList,
      ),
    );
  }
}

class CheckLocalFreeFormItemsAndAddEmptyItem extends ReduxAction<AppState> {
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
    List<JITProduct> newFreeFormItemList = [];
    freeFormOrderItems.forEach((element) {
      newFreeFormItemList.add(element);
    });
    newFreeFormItemList.add(JITProduct(quantity: 0, itemName: ""));

    return state.copyWith(
      productState: state.productState.copyWith(
        localFreeFormCartItems: newFreeFormItemList,
      ),
    );
  }
}
