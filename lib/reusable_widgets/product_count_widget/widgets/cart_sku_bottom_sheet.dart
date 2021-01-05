import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/reusable_widgets/cart_details_bottom_sheet.dart';
import 'package:eSamudaay/reusable_widgets/product_count_widget/product_count_widget.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:eSamudaay/utilities/extensions.dart';
import 'package:flutter/material.dart';

///A customised bottom sheet to show the variations of an items which are
///available
///Example -
///Milk [250ml, 500ml, 1l, 2l] shall be shown in the bottom sheet and customer
///can add multiple quantities of each variation
///

// merchant data should be passed as argument in such global widgets
// to avoid coupling with selectedMerchant.
class SkuBottomSheet extends StatefulWidget {
  final Product product;
  final Business selectedMerchant;

  const SkuBottomSheet({
    Key key,
    @required this.product,
    @required this.selectedMerchant,
  })  : assert(product != null, 'The product cannot be null'),
        super(key: key);

  @override
  _SkuBottomSheetState createState() => _SkuBottomSheetState();
}

class _SkuBottomSheetState extends State<SkuBottomSheet> {
  @override
  Widget build(BuildContext context) {
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
                    selectedMerchant: widget.selectedMerchant,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 24.toHeight),
          CartDetailsBottomSheet(),
        ],
      ),
    );
  }

  ///This function builds the row for each variation [SKUs available]
  Widget buildCustomizableItem({
    int price,
    String specificationName,
    int index,
    Business selectedMerchant,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                child: Text(
                  specificationName ?? ' ',
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
          product: widget.product.copy(index),
          selectedMerchant: selectedMerchant,
          isSku: true,
        ),
      ],
    );
  }
}
