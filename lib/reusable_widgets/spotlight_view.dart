import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/modules/store_details/views/stepper_view.dart';
import 'package:eSamudaay/presentations/product_count_widget.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

///The [SpotlightTile] class implements the item to shown in the horizontal carousel for the
///spotlight items.

class SpotlightTile extends StatelessWidget {
  final String imageUrl;
  final String itemName;
  final String quantityDescription;
  final String price;
  final String itemQuantity;
  final Function decrementQuantityAction;
  final Function incrementQuantityAction;
  final Product product;
  final Function onTapItemImage;

  const SpotlightTile(
      {@required this.itemName,
      @required this.product,
      @required this.imageUrl,
      @required this.price,
      @required this.onTapItemImage,
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
          GestureDetector(
            onTap: () {
              onTapItemImage(product);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                  height: imageSide,
                  width: imageSide,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    errorWidget: (_, __, ___) =>
                        Image.asset('assets/images/shop1.png'),
                  )),
            ),
          ),
          const SizedBox(
            height: AppSizes.separatorPadding,
          ),
          Text(
            itemName,
            maxLines: 1,
            style: CustomTheme.of(context).textStyles.cardTitle,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: AppSizes.separatorPadding / 2,
          ),
          Text(
            quantityDescription,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: CustomTheme.of(context).textStyles.body2,
          ),
          const SizedBox(
            height: AppSizes.separatorPadding / 2,
          ),
          Text(
            "₹ " + price,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: CustomTheme.of(context).textStyles.body2,
          ),
          const SizedBox(
            height: AppSizes.separatorPadding,
          ),
          ProductCountWidget(
            product: product,
            isSku: false,
          ),
        ],
      ),
    );
  }
}

class SpotlightItemsScroller extends StatelessWidget {
  final List<Product> spotlightProducts;
  final Function onAddProduct;
  final Function onRemoveProduct;
  final Function onImageTap;

  const SpotlightItemsScroller(
      {@required this.spotlightProducts,
      @required this.onAddProduct,
      @required this.onImageTap,
      @required this.onRemoveProduct});

  @override
  Widget build(BuildContext context) {
    if (spotlightProducts.isEmpty) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: AppSizes.widgetPadding,
        ),
        Padding(
          padding: const EdgeInsets.only(left: AppSizes.widgetPadding),
          child: Text(
            tr('store_home.spotlight'),
            style: CustomTheme.of(context)
                .textStyles
                .sectionHeading2
                .copyWith(fontSize: 18),
          ),
        ),
        Container(
          height: SizeConfig.screenWidth * 0.64,
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
                    onTapItemImage: onImageTap,
                    itemName: product.productName,
                    imageUrl: product.images.first.photoUrl,
                    price:
                        (product.skus.first.basePrice / 100).toStringAsFixed(2),
                    quantityDescription:
                        product.skus.first.variationOptions.weight,
                    decrementQuantityAction: onRemoveProduct,
                    incrementQuantityAction: onAddProduct,
                    itemQuantity: product.count == 0
                        ? tr("new_changes.add")
                        : product.count.toString());
              },
              separatorBuilder: (_, __) => const SizedBox(
                    width: AppSizes.widgetPadding,
                  ),
              itemCount: spotlightProducts.length),
        ),
      ],
    );
  }
}
