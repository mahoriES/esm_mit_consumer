import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/presentations/product_count_widget.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final Function navigateToDetails;
  const ProductTile({
    @required this.product,
    @required this.navigateToDetails,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.toWidth),
      height: 100.toHeight,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: navigateToDetails,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      height: 100.toHeight,
                      width: 100.toHeight,
                      color: CustomTheme.of(context).colors.placeHolderColor,
                      child: CachedNetworkImage(
                        imageUrl: product.firstImageUrl,
                        height: 100.toHeight,
                        width: 100.toHeight,
                        placeholder: (context, url) =>
                            CupertinoActivityIndicator(),
                        errorWidget: (context, url, error) => Icon(
                          Icons.image,
                          size: 30.toFont,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 18.toWidth,
                        top: 10.toHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productName,
                            style: CustomTheme.of(context).textStyles.cardTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5.toHeight),
                          Text(
                            product.firstSkuWeight,
                            style: CustomTheme.of(context).textStyles.body2,
                          ),
                          SizedBox(height: 4.toHeight),
                          Text(
                            product.firstSkuPrice,
                            style: CustomTheme.of(context).textStyles.body2,
                          ),
                          SizedBox(height: 4.toHeight),
                          if (product.skus.length > 1) ...[
                            Text(
                              tr("product_details.options_available"),
                              style:
                                  CustomTheme.of(context).textStyles.bottomMenu,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ProductCountWidget(
            product: product,
            isSku: false,
          )
        ],
      ),
    );
  }
}
