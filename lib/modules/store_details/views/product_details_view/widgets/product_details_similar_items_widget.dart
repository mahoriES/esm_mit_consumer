import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// This widget is not being used for now .
// It may not be using proper data values and integration due to dependencies.
class ProductDetailsSimilarItemsWidget extends StatelessWidget {
  const ProductDetailsSimilarItemsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr("product_details.similar_products"),
          style: CustomTheme.of(context).textStyles.sectionHeading2,
        ),
        SizedBox(height: 11.toHeight),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              10,
              (index) => Container(
                margin: EdgeInsets.only(right: 16.toWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: AppColors.greyedout,
                      child: CachedNetworkImage(
                        height: 109.toWidth,
                        width: 109.toWidth,
                        imageUrl: "",
                        fit: BoxFit.fill,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.toWidth),
                            image: DecorationImage(image: imageProvider),
                          ),
                        ),
                        placeholder: (context, url) =>
                            Center(child: CupertinoActivityIndicator()),
                        errorWidget: (context, url, error) => Center(
                          child: Icon(
                            Icons.image,
                            size: 30.toFont,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 11.toHeight),
                    Text(
                      "Product Name",
                      style: CustomTheme.of(context).textStyles.cardTitle,
                    ),
                    SizedBox(height: 4.toHeight),
                    Text(
                      "500 gm",
                      style: CustomTheme.of(context).textStyles.body2,
                    ),
                    SizedBox(height: 4.toHeight),
                    Text(
                      "\u{20B9} " + "250.00",
                      style: CustomTheme.of(context).textStyles.body2,
                    ),
                    SizedBox(height: 11.toHeight),
                    // CSStepper(
                    //   fillColor: false,
                    //   addButtonAction: () {},
                    //   removeButtonAction: () {},
                    //   value: itemCount == 0
                    //       ? tr("new_changes.add")
                    //       : itemCount.toString(),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
