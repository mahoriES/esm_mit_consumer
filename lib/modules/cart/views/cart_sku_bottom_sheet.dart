import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/modules/store_details/views/stepper_view.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/redux/states/app_state.dart';

class SkuBottomSheet extends StatefulWidget {

  final String storeName;
  final String buttonTitle;
  final VoidCallback didPressDone;
  final int productIndex;
  final Product product;

  const SkuBottomSheet({
    Key key,
    @required this.buttonTitle,
    @required this.didPressDone,
    @required this.storeName,
    @required this.productIndex,
    @required this.product,
  }) : super(key:key);

  @override
  _SkuBottomSheetState createState() => _SkuBottomSheetState();
}

class _SkuBottomSheetState extends State<SkuBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        debugPrint('This was built');
        if (snapshot.localCartItems.isNotEmpty) {
          debugPrint(snapshot.localCartItems[0]?.count?.toString() ?? 0);
        }
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
            ),
            //boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 5)],
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height*0.45,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 5)],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(
                  left: 20
                ),
                  child: Row(
                    children: [
                      Expanded(flex: 80,child: Text(
                        widget.storeName,
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: 'Avenir',
                          fontSize: 23,
                          fontWeight: FontWeight.w300,
                        ),
                      )),
                      Expanded(flex: 20,child: Center(
                        child: IconButton(
                            icon: Icon(Icons.close,color: Colors.grey,size: 22,),
                            onPressed: () => Navigator.pop(context),
                        ),
                      )),
                    ],
                  ),
                ),
                mySeparator,
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height*0.3,
                  ),
                  child: ListView.builder(itemBuilder: (context, index) =>
                      buildCustomizableItem(
                    title: widget.product.productName,
                    specificationName: widget.product.skus[index].variationOptions.weight,
                    price: (widget.product.skus[index].basePrice/100).floor(),
                    quantity: snapshot.getSelectedVariationQuantity(
                      widget.product,
                      index,
                      widget.product.skus[index].variationOptions.weight
                    ) ?? 0,
                    snapshot: snapshot,
                    index: index,
                  ),
                    itemCount: widget.product.skus.length,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                  ),
                ),
              ],
            ),
          ),
        );

      },
    );
  }

  Widget buildCustomizableItem({String title,int quantity,int price,
    String specificationName, _ViewModel snapshot, int index}) {

    return Padding(
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
        top: 3,
        bottom: 10,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,style: TextStyle(
                  color: Colors.black87,
                  fontFamily: 'Avenir',
                  fontSize: 19,
                ),textAlign: TextAlign.left,),
                Text(
                  '₹'+price.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Avenir',
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Quantity: $specificationName',
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'Avenir',
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 40,
            child: Column(crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CSStepper(
                  value: quantity.toString(),
                  didPressAdd: () => snapshot.addToCart(
                    widget.product,
                    context,
                    index,
                  ),
                  didPressRemove: () => snapshot.removeFromCart(
                    widget.product,
                    index,
                  ),
                ),
                SizedBox(height: 3,),
                Text(
                    '₹'+(quantity*price).toString(),
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'Avenir',
                      fontSize: 18,
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }

  Widget get mySeparator => Padding(
    padding: EdgeInsets.only(
      left: 15,
      right: 15,
      bottom: 10,
    ),
    child: Container(
      color: Colors.black26,
      height: 0.4,
    ),
  );
}

class _ViewModel extends BaseModel<AppState> {

  Function(Product, BuildContext, int) addToCart;
  Function(Product, int) removeFromCart;
  int Function(Product, int, String) getSelectedVariationQuantity;
  List<Product> localCartItems;

  _ViewModel();

  _ViewModel.build({
    this.localCartItems,
    @required this.addToCart,
    @required this.removeFromCart,
    @required this.getSelectedVariationQuantity
  }) : super(equals: [localCartItems]);

  @override
  BaseModel fromStore() => _ViewModel.build(

    localCartItems: state.productState.localCartItems,

    addToCart: (item, context, index) {
      //if (item.selectedVariant != index) item.count = 0;
      item.selectedVariant = index;
      int count = getCountOfExistingItemInCart(item, index);
      item.count = count + 1;
      dispatch(AddToCartLocalAction(product: item,context: context));
    },

    removeFromCart: (item, index) {
      //if (item.count == 0) return;
      item.selectedVariant = index;
      int count = getCountOfExistingItemInCart(item, index);
      if (count == 0)return;
      item.count = count - 1;
      //item.count--;
      dispatch(RemoveFromCartLocalAction(product: item));
    },

    getSelectedVariationQuantity: (product, index, variation) {

      if (state.productState.localCartItems.isEmpty)
        return 0;
      else {
        Product prod;
        try {
          prod = state.productState.localCartItems.firstWhere(
                (element) => element.productId==product.productId &&
                element.skus[element.selectedVariant].variationOptions.weight ==
                    product.skus[index].variationOptions.weight &&
                element.selectedVariant == index,
          );
        } catch(e){
          return 0;
        }
        if (prod == null) return 0;
        else return prod.count;
      }

    },
  );

  int getCountOfExistingItemInCart(Product product, int index) {
    if (state.productState.localCartItems.isEmpty)
      return 0;
    else {
      Product prod;
      try {
        prod = state.productState.localCartItems.firstWhere(
              (element) => element.productId==product.productId &&
              element.skus[element.selectedVariant].variationOptions.weight ==
                  product.skus[index].variationOptions.weight &&
              element.selectedVariant == index,
        );
      } catch(e) {
        return 0;
      }
      if (prod == null) return 0;
      else return prod.count;
    }
  }

}


