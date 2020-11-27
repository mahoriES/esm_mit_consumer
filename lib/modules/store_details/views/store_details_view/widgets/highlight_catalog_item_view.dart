import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/modules/store_details/views/store_product_listing_view.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';


class HighlightCatalogItems extends StatelessWidget {
  final List<Product> productList;
  final Function onTapActionButton;
  final String actionButtonTitle;

  const HighlightCatalogItems(
      {@required this.productList,
      @required this.actionButtonTitle,
      @required this.onTapActionButton});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppSizes.separatorPadding),
      child: Container(
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return ProductListingItemView(
                  imageLink: productList[index].images.isNotEmpty
                      ? productList[index].images?.first?.photoUrl ?? ""
                      : "",
                  item: productList[index],
                  index: 0,
                );
              },
              itemCount: productList.length,
              separatorBuilder: (context, index) => SizedBox(
                height: AppSizes.separatorPadding,
              ),
            ),
            SizedBox(height: AppSizes.widgetPadding,),
            GestureDetector(
                onTap: onTapActionButton,
                child: Text(
                  actionButtonTitle,
                  style: CustomTheme.of(context).textStyles.buttonText2.copyWith(fontSize: 14),
                )),
          ],
        ),
      ),
    );
  }
}
