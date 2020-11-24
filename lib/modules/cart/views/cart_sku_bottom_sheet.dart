import 'package:eSamudaay/modules/cart/views/cart_bottom_view.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/presentations/product_count_widget.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:eSamudaay/utilities/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/redux/states/app_state.dart';

///A customised bottom sheet to show the variations of an items which are
///available
///Example -
///Milk [250ml, 500ml, 1l, 2l] shall be shown in the bottom sheet and customer
///can add multiple quantities of each variation
///
/// TODO : This should be a global widget.
class SkuBottomSheet extends StatefulWidget {
  final Product product;

  const SkuBottomSheet({
    Key key,
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
            maxHeight: SizeConfig.screenHeight / 2,
          ),
          decoration: BoxDecoration(
            color: CustomTheme.of(context).colors.backgroundColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(AppSizes.bottomSheetBorderRadius),
              topLeft: Radius.circular(AppSizes.bottomSheetBorderRadius),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.toHeight),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 38.toWidth),
                child: Text(
                  widget.product.productName,
                  style: CustomTheme.of(context).textStyles.topTileTitle,
                ),
              ),
              SizedBox(height: 20.toHeight),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 38.toWidth),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: 2.1,
                    crossAxisSpacing: 34.toWidth,
                    mainAxisSpacing: 10.toHeight,
                    children: List.generate(
                      widget.product.skus.length,
                      (index) => buildCustomizableItem(
                        specificationName:
                            widget.product.skus[index].variationOptions.weight,
                        price: widget.product.skus[index].basePrice,
                        index: index,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.toHeight),
              BottomView(
                height: snapshot.localCartItems.isEmpty ? 0 : 65.toHeight,
                buttonTitle: tr('cart.view_cart'),
                didPressButton: snapshot.navigateToCart,
              ),
            ],
          ),
        );
      },
    );
  }

  ///This function builds the row for each variation [SKUs available]
  Widget buildCustomizableItem({
    int price,
    String specificationName,
    int index,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                child: Text(
                  specificationName,
                  style: CustomTheme.of(context).textStyles.body1,
                ),
              ),
              SizedBox(height: 6.toHeight),
              FittedBox(
                child: Text(
                  price.paisaToRupee.withRupeePrefix,
                  style: CustomTheme.of(context).textStyles.body1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.toWidth),
        ProductCountWidget(
          product: widget.product,
          isSku: true,
          skuIndex: index,
        ),
      ],
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  List<Product> localCartItems;
  Function navigateToCart;

  _ViewModel();

  _ViewModel.build({
    this.localCartItems,
    @required this.navigateToCart,
  }) : super(equals: [localCartItems]);

  @override
  BaseModel fromStore() => _ViewModel.build(
        ///Holds the current snapshot of the local cart from the store
        localCartItems: state.productState.localCartItems,
        navigateToCart: () {
          dispatch(NavigateAction.pushNamed('/CartView'));
        },
      );
}
