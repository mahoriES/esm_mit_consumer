import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/modules/store_details/views/widgets/product_list_view.dart';
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
      padding: const EdgeInsets.symmetric(vertical: AppSizes.separatorPadding),
      child: Container(
        child: Column(
          children: [
            ProductListView(
              subCategoryIndex: CustomCategoryForAllProducts().categoryId,
              showFewProductsOnly: true,
              isScrollable: false,
            ),
            SizedBox(
              height: AppSizes.widgetPadding,
            ),
            GestureDetector(
                onTap: onTapActionButton,
                child: Text(
                  actionButtonTitle,
                  style: CustomTheme.of(context)
                      .textStyles
                      .buttonText2
                      .copyWith(fontSize: 14),
                )),
          ],
        ),
      ),
    );
  }
}
