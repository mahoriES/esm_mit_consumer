import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviouslyBoughtItemTile extends StatelessWidget {
  final String itemImageUrl;
  final String itemTitle;
  final String itemQuantityOrServingSizeString;
  final String itemPriceWithoutCurrencyPrefix;
  final String businessName;
  final VoidCallback onTappingTile;

  const PreviouslyBoughtItemTile(
      {Key key,
      @required this.itemImageUrl,
      @required this.itemTitle,
      @required this.itemQuantityOrServingSizeString,
      @required this.itemPriceWithoutCurrencyPrefix,
      @required this.businessName,
      @required this.onTappingTile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardWidth = SizeConfig.screenWidth * 0.408;
    return GestureDetector(
      onTap: onTappingTile,
      child: SizedBox(
        width: cardWidth,
        child: AspectRatio(
          aspectRatio: 153 / 195,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(offset: Offset(0, 3), blurRadius: 6.0)
              ],
            ),
            child: Column(
              children: [
                Flexible(
                  flex: 55,
                  child: CachedNetworkImage(
                    imageUrl: itemImageUrl,
                    errorWidget: (_, __, ___) => CupertinoActivityIndicator(),
                  ),
                ),
                Flexible(
                    flex: 45,
                    child: Column(
                      children: [
                        Text(
                          itemTitle ?? '',
                          style: CustomTheme.of(context).textStyles.bottomMenu,
                        ),
                        Text(
                          itemQuantityOrServingSizeString ?? '',
                          style: CustomTheme.of(context).textStyles.bottomMenu,
                        ),
                        Text(
                          itemPriceWithoutCurrencyPrefix ?? '',
                          style: CustomTheme.of(context).textStyles.bottomMenu,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 90,
                              child: Text(
                                businessName ?? '',
                                style: CustomTheme.of(context)
                                    .textStyles
                                    .bottomMenu,
                              ),
                            ),
                            InkWell(
                                onTap: onTappingTile,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: CustomTheme.of(context)
                                      .colors
                                      .primaryColor,
                                )),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
