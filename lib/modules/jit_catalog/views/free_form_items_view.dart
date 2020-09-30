import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/jit_catalog/actions/free_form_items_actions.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';

class FreeFormItemsView extends StatefulWidget {
  @override
  _FreeFormItemsViewState createState() => _FreeFormItemsViewState();
}

class _FreeFormItemsViewState extends State<FreeFormItemsView> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        debugPrint("Free form area was rebuilt");
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.sliverPadding,
            horizontal: AppSizes.sliverPadding,
          ),
          child: Container(
              padding: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius:
                    BorderRadius.circular(AppSizes.productItemBorderRadius),
                boxShadow: [
                  BoxShadow(
                      blurRadius: AppSizes.shadowBlurRadius,
                      color: AppColors.blackShadowColor),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: AppSizes.widgetPadding),
                    child: Text(
                      'List Items',
                      style: TextStyle(
                        fontSize: AppSizes.productItemFontSize,
                        fontFamily: 'Avenir-Medium',
                        color: AppColors.icColors,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.widgetPadding,
                  ),
                  buildFreeFormItems(snapshot),
                ],
              )),
        );
      },
    );
  }

  Widget buildEmptyItemsWidget(_ViewModel snapshot) {
    return Container(
      child: Column(
        children: [
          IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: AppColors.icColors,
              ),
              onPressed: () {}),
          Text(
            'Add an item',
            style: TextStyle(
              fontSize: AppSizes.itemTitleFontSize,
              fontFamily: 'Avenir',
              color: AppColors.blackTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFreeFormItemRow(int index, _ViewModel snapshot,
      {String skuName = "", int quantity = 0}) {
    debugPrint("Build free form item row called $skuName");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(flex: 5, child: Container()),
        Expanded(
          flex: 50,
          child: TextFormField(
            key: Key(snapshot.localFreeFormCartItems.length.toString()),
            initialValue: skuName,
            decoration: InputDecoration(hintText: "e.g. Atta 5 kg"),
            onChanged: (value) {
              debugPrint('On changed called for item name');
              snapshot.updateFreeFormItemSkuName(value, index);
            },
          ),
        ),
        Expanded(flex: 10, child: Container()),
        Expanded(
            flex: 20,
            child: TextFormField(
              key: Key(snapshot.localFreeFormCartItems.length.toString()),
              keyboardType: TextInputType.numberWithOptions(),
              initialValue: quantity == 0 ? "" : quantity.toString(),
              decoration: InputDecoration(hintText: "e.g. 2"),
              onChanged: (value) {
                debugPrint('On changed called for quantity $value');
                snapshot.updateFreeFormItemQuantity(
                    value != "" ? int.parse(value) : 0, index);
              },
            )),
        Expanded(
          flex: 15,
          child: IconButton(
              icon: Icon(
                Icons.clear,
                color: AppColors.iconColors,
                size: AppSizes.productItemIconSize / 1.2,
              ),
              onPressed: () {
                snapshot.removeJitProductFromLocalCartByIndex(index);
              }),
        ),
      ],
    );
  }

  Widget buildAddNewItemButton(_ViewModel snapshot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: AppColors.icColors,
            ),
            onPressed: () {
              snapshot.addNewEmptyFreeFormItem(context);
            }),
        Text(
          'Add Item',
          style: TextStyle(
            fontSize: AppSizes.itemSubtitle2FontSize,
            fontFamily: 'Avenir',
            color: AppColors.blackTextColor,
          ),
        ),
      ],
    );
  }

  Widget buildFreeFormItems(_ViewModel snapshot) {
    return Container(
      child: ListView.separated(
        itemBuilder: (context, index) {
          if (index == snapshot.localFreeFormCartItems.length) {
            return buildAddNewItemButton(snapshot);
          }
          return buildFreeFormItemRow(
            index,
            snapshot,
            skuName: snapshot.localFreeFormCartItems[index].itemName,
            quantity: snapshot.localFreeFormCartItems[index].quantity,
          );
        },
        separatorBuilder: (_, __) =>
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        itemCount: snapshot.localFreeFormCartItems.length + 1,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  List<JITProduct> localFreeFormCartItems;
  Function(JITProduct) addJitProductToLocalCart;
  Function(JITProduct) removeJitProductFromLocalCart;
  Function(int) removeJitProductFromLocalCartByIndex;
  Function(String, int) updateFreeFormItemSkuName;
  Function(int, int) updateFreeFormItemQuantity;
  Function(BuildContext) addNewEmptyFreeFormItem;
  LoadingStatusApp loadingStatusApp;

  _ViewModel();

  _ViewModel.build({
    @required this.localFreeFormCartItems,
    @required this.removeJitProductFromLocalCart,
    @required this.updateFreeFormItemSkuName,
    @required this.updateFreeFormItemQuantity,
    @required this.addJitProductToLocalCart,
    @required this.removeJitProductFromLocalCartByIndex,
    @required this.loadingStatusApp,
    @required this.addNewEmptyFreeFormItem,
  }) : super(equals: [
          localFreeFormCartItems,
          loadingStatusApp,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
        loadingStatusApp: state.authState.loadingStatus,
        localFreeFormCartItems: state.productState.localFreeFormCartItems,
        addJitProductToLocalCart: (jitProduct) {
          dispatch(AddFreeFormItemAction(jitProduct: jitProduct));
          displayTheFreeFormItemList();
        },
        removeJitProductFromLocalCart: (jitProduct) {
          dispatch(RemoveFreeFormItemAction(jitProduct: jitProduct));
          displayTheFreeFormItemList();
        },
        updateFreeFormItemQuantity: (quantity, index) {
          dispatch(UpdateFreeFormItemQuantity(
              quantity: quantity, updatedIndex: index));
          displayTheFreeFormItemList();
        },
        updateFreeFormItemSkuName: (skuName, index) {
          dispatch(
              UpdateFreeFormItemSkuName(updatedIndex: index, skuName: skuName));
          displayTheFreeFormItemList();
        },
        addNewEmptyFreeFormItem: (context) {
          dispatch(CheckLocalFreeFormItemsAndAddEmptyItem(context: context));
          displayTheFreeFormItemList();
        },
        removeJitProductFromLocalCartByIndex: (index) {
          debugPrint("The index to be removed is $index");
          dispatch(RemoveFreeFormItemByIndexAction(index: index));
          displayTheFreeFormItemList();
        });
  }

  void displayTheFreeFormItemList() {
    debugPrint(
        "Free form items: ${state.productState.localFreeFormCartItems.length}");
    state.productState.localFreeFormCartItems.forEach((element) {
      debugPrint("${element.itemName}-\t${element.quantity}");
    });
  }
}
