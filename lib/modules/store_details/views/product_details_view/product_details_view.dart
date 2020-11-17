import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/modules/store_details/views/product_details_view/widgets/product_details_appbar.dart';
import 'package:eSamudaay/modules/store_details/views/product_details_view/widgets/product_details_image_carausel.dart';
import 'package:eSamudaay/modules/store_details/views/widgets/product_count_widget.dart';
import 'package:eSamudaay/store.dart';
import 'package:eSamudaay/themes/theme_constants/theme_globals.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Product selectedProduct =
        store.state.productState.selectedProductForDetails;
    Business selectedMerchant = store.state.productState.selectedMerchant;
    return Scaffold(
      appBar: ProductDetailsAppBar(
        title: selectedProduct.productName,
        subTitle: selectedMerchant.businessName,
        productId: selectedProduct.productId.toString(),
        businessId: selectedMerchant.businessId.toString(),
      ),
      body: ListView(
        children: [
          Hero(
            tag: selectedProduct.productName,
            child: ProductDetailsImageCarousel(
              selectedProduct.productName,
              selectedProduct.images,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 22.toWidth,
              vertical: 20.toHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedProduct.productName,
                            style: ThemeGlobals.customTextStyles.headline6,
                          ),
                          SizedBox(height: 5.toHeight),
                          Text(
                            selectedProduct.skus.first.variationOptions.weight,
                            style: ThemeGlobals.customTextStyles.caption,
                          ),
                          SizedBox(height: 4.toHeight),
                          Text(
                            "\u{20B9} " +
                                (selectedProduct.skus.first.basePrice / 100)
                                    .toString(),
                            style: ThemeGlobals.customTextStyles.caption,
                          ),
                          SizedBox(height: 4.toHeight),
                          if (selectedProduct.skus.length > 1) ...[
                            Text(
                              tr("product_details.options_available"),
                              style: ThemeGlobals.customTextStyles.menuActive,
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: 8.toWidth),
                    Flexible(
                      flex: 1,
                      child: Center(child: ProductCountWidget()),
                    ),
                  ],
                ),
                if (selectedProduct.productDescription != null &&
                    selectedProduct.productDescription.trim() != "") ...[
                  SizedBox(height: 20.toHeight),
                  Text(
                    tr("product_details.product_information"),
                    style: ThemeGlobals.customTextStyles.subtitle2,
                  ),
                  SizedBox(height: 11.toHeight),
                  Text(
                    selectedProduct.productDescription,
                    style: ThemeGlobals.customTextStyles.caption,
                    textAlign: TextAlign.justify,
                  ),
                ],
                // SizedBox(height: 20.toHeight),
                // ProductDetailsSimilarItemsWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
