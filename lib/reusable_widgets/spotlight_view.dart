import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/modules/store_details/views/stepper_view.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SpotlightTile extends StatelessWidget {
  final String imageUrl;
  final String itemName;
  final String quantityDescription;
  final String price;
  final String itemQuantity;
  final Function decrementQuantityAction;
  final Function incrementQuantityAction;
  final Product product;

  const SpotlightTile(
      {@required this.itemName,
      @required this.product,
      @required this.imageUrl,
      @required this.price,
      @required this.quantityDescription,
      @required this.decrementQuantityAction,
      @required this.incrementQuantityAction,
      @required this.itemQuantity});

  @override
  Widget build(BuildContext context) {
    double imageSide = SizeConfig.screenWidth * 0.277;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
                height: imageSide,
                width: imageSide,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (_, __) => CircularProgressIndicator(),
                )),
          ),
          SizedBox(
            height: AppSizes.separatorPadding,
          ),
          Text(
            itemName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: AppSizes.separatorPadding / 2,
          ),
          Text(
            quantityDescription,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: AppSizes.separatorPadding,
          ),
          CSStepper(
            value: itemQuantity,
            addButtonAction: () {
              incrementQuantityAction(product, context, 0);
            },
            removeButtonAction: () {
              decrementQuantityAction(product, 0);
            },
          ),
        ],
      ),
    );
  }
}

//
class SpotlightItemsScroller extends StatelessWidget {
  final List<Product> spotlightProducts;
  final Function onAddProduct;
  final Function onRemoveProduct;

  const SpotlightItemsScroller(
      {@required this.spotlightProducts,
      @required this.onAddProduct,
      @required this.onRemoveProduct});

  @override
  Widget build(BuildContext context) {
    debugPrint('Rebuilding the spotlight section');
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenWidth * 0.56,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.widgetPadding,
          vertical: AppSizes.separatorPadding),
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            Product product = spotlightProducts[index];
            return SpotlightTile(
                product: product,
                itemName: product.productName,
                imageUrl: product.images.first.photoUrl,
                price: (product.skus.first.basePrice / 100).toStringAsFixed(2),
                quantityDescription: product.skus.first.variationOptions.weight,
                decrementQuantityAction: onRemoveProduct,
                incrementQuantityAction: onAddProduct,
                itemQuantity: product.count == 0
                    ? tr("new_changes.add")
                    : product.count.toString());
          },
          separatorBuilder: (_, __) => SizedBox(
                width: AppSizes.widgetPadding,
              ),
          itemCount: spotlightProducts.length),
    );
  }
}
