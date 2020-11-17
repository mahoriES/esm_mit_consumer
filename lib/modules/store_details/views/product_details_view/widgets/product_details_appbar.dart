import 'package:eSamudaay/themes/theme_constants/theme_globals.dart';
import 'package:eSamudaay/utilities/link_sharing_service.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class ProductDetailsAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final String subTitle;
  final String productId;
  final String businessId;
  const ProductDetailsAppBar({
    @required this.title,
    @required this.subTitle,
    @required this.productId,
    @required this.businessId,
  }) : assert(title != null && subTitle != null,
            "Title and Subtitle can not be null in product details appBar");

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.chevron_left),
        iconSize: 36.toFont,
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: ThemeGlobals.customTextStyles.headline6,
            maxLines: 1,
          ),
          Text(
            subTitle,
            style: ThemeGlobals.customTextStyles.caption,
            maxLines: 1,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.share),
          iconSize: 30.toFont,
          onPressed: () async {
            DynamicLinkParameters linkParameters =
                LinkSharingService().createProductLink(
              productId: productId,
              businessId: businessId,
              storeName: subTitle,
            );
            await LinkSharingService().shareLink(parameters: linkParameters);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size(double.infinity, AppBar().preferredSize.height);
}
