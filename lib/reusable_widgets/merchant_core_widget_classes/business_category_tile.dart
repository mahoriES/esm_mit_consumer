import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';

class BusinessCategoryTile extends StatelessWidget {
  final Function onTap;
  final String categoryName;
  final String imageUrl;
  final double tileWidth;

  const BusinessCategoryTile(
      {Key key,
      @required this.onTap,
      @required this.categoryName,
      @required this.imageUrl,
      @required this.tileWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            width: tileWidth,
            height: tileWidth,
            child: Stack(
              children: [
                Positioned.fill(
                    child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  errorWidget: (_, __, ___) => placeHolderImage,
                  placeholder: (_, __) => placeHolderImage,
                  fit: BoxFit.cover,
                )),
                Positioned.fill(
                  child: FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    widthFactor: 1.0,
                    heightFactor: 0.20,
                    child: Container(
                      width: tileWidth,
                      color: CustomTheme.of(context)
                          .colors
                          .categoryTileTextUnderlay,
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Center(
                        child: Text(
                          categoryName,
                          maxLines: 1,
                          style: CustomTheme.of(context).textStyles.body2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get placeHolderImage {
    return Image.asset(
      'assets/images/category_placeholder.png',
      fit: BoxFit.cover,
    );
  }
}
