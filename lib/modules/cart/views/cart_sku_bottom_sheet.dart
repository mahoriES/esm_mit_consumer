import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/modules/store_details/views/stepper_view.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:fluttertoast/fluttertoast.dart';

///A customised bottom sheet to show the variations of an items which are
///available
///Example -
///Milk [250ml, 500ml, 1l, 2l] shall be shown in the bottom sheet and customer
///can add multiple quantities of each variation
class SkuBottomSheet extends StatefulWidget {
  final String storeName;
  final int productIndex;
  final Product product;

  const SkuBottomSheet({
    Key key,
    @required this.storeName,
    @required this.productIndex,
    @required this.product,
  })  : assert(product != null, 'The product cannot be null'),
        super(key: key);

  @override
  _SkuBottomSheetState createState() => _SkuBottomSheetState();
}

class _SkuBottomSheetState extends State<SkuBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        return Container(
          ///This constraint ensures that the bottom sheet does not expand more
          ///than half the screen's height
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height *
                AppSizes.bottomSheetHeightFraction,
          ),
          decoration: BoxDecoration(
            color: AppColors.solidWhite,
            boxShadow: [
              BoxShadow(
                  color: AppColors.blackShadowColor,
                  blurRadius: AppSizes.shadowBlurRadius)
            ],

            ///This is provided as using Clips should be avoided since, they are
            ///very expensive in Flutter!
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(AppSizes.bottomSheetBorderRadius),
              topLeft: Radius.circular(AppSizes.bottomSheetBorderRadius),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: AppSizes.widgetPadding,
                ),
                child: Row(
                  children: [
                    Expanded(
                        flex: 80,
                        child: Text(
                          widget.storeName,
                          style: TextStyle(
                            color: AppColors.solidBlack,
                            fontFamily: 'Avenir',
                            fontSize: AppSizes.itemTitleFontSize,
                            fontWeight: FontWeight.w300,
                          ),
                        )),
                    Expanded(
                        flex: 20,
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: AppColors.greyishText,
                              size: AppSizes.itemTitleFontSize,
                            ),
                            onPressed: () => snapshot.closeAction(context),
                          ),
                        )),
                  ],
                ),
              ),
              mySeparator,
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      AppSizes.bottomSheetListHeightFraction,
                ),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    if (widget.product.skus[index].inStock)
                      return buildCustomizableItem(
                        title: widget.product.productName,
           
                        specificationName:
                            widget.product.skus[index].variationOptions.weight,
                        price: (widget.product.skus[index].basePrice / 100)
                            .floor(),
                        quantity: snapshot.getSelectedVariationQuantity(
                                widget.product,
                                index,
                                widget.product.skus[index].variationOptions
                                    .weight) ??
                            0,
                        snapshot: snapshot,
                        index: index,
                      );
                    else
                      ///The [ColorFiltered] widget is being used to grey out
                      ///the [CSStepper] button when that particular item is not
                      ///in stock.
                      return ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          AppColors.solidWhite,
                          BlendMode.softLight,
                        ),
                        child: buildCustomizableItem(
                          title: widget.product.productName,
                          specificationName: widget
                              .product.skus[index].variationOptions.weight,
                          price: (widget.product.skus[index].basePrice / 100)
                              .floor(),
                          quantity: snapshot.getSelectedVariationQuantity(
                                  widget.product,
                                  index,
                                  widget.product.skus[index].variationOptions
                                      .weight) ??
                              0,
                          snapshot: snapshot,
                          index: index,
                        ),
                      );
                  },
                  itemCount: widget.product.skus.length,

                  ///To prevent the ListView from expanding infinitely
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ///This function builds the row for each variation [SKUs available]
  Widget buildCustomizableItem(
      {String title,
      int quantity,
      int price,
      String specificationName,
      _ViewModel snapshot,
      int index}) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.widgetPadding,
        right: AppSizes.widgetPadding,
        bottom: AppSizes.widgetPadding,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.solidBlack,
                    fontFamily: 'Avenir',
                    fontSize: AppSizes.itemSubtitle1FontSize,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '₹' + price.toString(),
                  style: TextStyle(
                    color: AppColors.solidBlack,
                    fontFamily: 'Avenir',
                    fontSize: AppSizes.itemSubtitle2FontSize,
                  ),
                ),
                Text(
                  'Quantity: $specificationName',
                  style: TextStyle(
                    color: AppColors.solidBlack,
                    fontFamily: 'Avenir',
                    fontSize: AppSizes.itemSubtitle3FontSize,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CSStepper(
                  value: quantity.toString(),
                  addButtonAction: () => snapshot.addToCart(
                    widget.product,
                    context,
                    index,
                  ),
                  removeButtonAction: () => snapshot.removeFromCart(
                    widget.product,
                    index,
                  ),
                ),
                SizedBox(
                  height: AppSizes.minorTopPadding,
                ),

                ///To calculate the total cost of item as -> quantity*base price
                Text(
                  '₹' + (quantity * price).toString(),
                  style: TextStyle(
                    color: AppColors.solidBlack,
                    fontFamily: 'Avenir',
                    fontSize: AppSizes.itemSubtitle2FontSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///A very thin streak which acts as a separator
  Widget get mySeparator => Padding(
        padding: EdgeInsets.only(
          left: AppSizes.separatorPadding,
          right: AppSizes.separatorPadding,
          bottom: AppSizes.separatorPadding,
        ),
        child: Container(
          color: AppColors.separatorColor,
          height: AppSizes.separatorHeight,
        ),
      );
}

class _ViewModel extends BaseModel<AppState> {
  Function(Product, BuildContext, int) addToCart;
  Function(Product, int) removeFromCart;
  int Function(Product, int, String) getSelectedVariationQuantity;
  List<Product> localCartItems;
  Function(BuildContext) closeAction;

  _ViewModel();

  ///The ViewModel shall build again whenever the [localCartItems] changes in
  ///the AppStore
  _ViewModel.build({
    this.localCartItems,
    @required this.addToCart,
    @required this.removeFromCart,
    @required this.getSelectedVariationQuantity,
    @required this.closeAction,
  }) : super(equals: [localCartItems]);

  @override
  BaseModel fromStore() => _ViewModel.build(
        ///Holds the current snapshot of the local cart from the store
        localCartItems: state.productState.localCartItems,

        closeAction: (context) => Navigator.pop(context),

        ///To set which variation is being added by customer
        addToCart: (item, context, index) {
          if (!item.skus[index].inStock) {
            Fluttertoast.showToast(msg: 'Item not in stock!');
            return;
          }
          item.selectedVariant = index;
          int count = getCountOfExistingItemInCart(item, index);
          item.count = count + 1;
          dispatch(AddToCartLocalAction(product: item, context: context));
        },

        ///To set which variation is being removed by customer
        removeFromCart: (item, index) {
          if (!item.skus[index].inStock) {
            Fluttertoast.showToast(msg: 'Item not in stock!');
            return;
          }
          item.selectedVariant = index;
          int count = getCountOfExistingItemInCart(item, index);
          if (count == 0) return;
          item.count = count - 1;
          dispatch(RemoveFromCartLocalAction(product: item));
        },

        getSelectedVariationQuantity: (product, index, variation) {
          return getCountOfExistingItemInCart(product, index);
        },
      );

  ///To get the count of items already added in the local cart for a particular
  ///variation of an item.
  ///This is useful to to keep things in sync with store and handy for adding or
  ///removing items from cart.
  int getCountOfExistingItemInCart(Product product, int index) {
    if (state.productState.localCartItems.isEmpty)
      return 0;
    else {
      Product prod;
      try {
        prod = state.productState.localCartItems.firstWhere(
          (element) =>
              element.productId == product.productId &&
              element.skus[element.selectedVariant].variationOptions.weight ==
                  product.skus[index].variationOptions.weight &&
              element.selectedVariant == index,
        );
      } catch (e) {
        return 0;
      }
      if (prod == null)
        return 0;
      else
        return prod.count;
    }
  }
}
