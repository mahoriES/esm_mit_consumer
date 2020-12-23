import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleTileWidget extends StatelessWidget {
  final String imageUrl;
  final String circleName;
  final String circleDescription;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool isSelected;

  const CircleTileWidget(
      {Key key,
      @required this.imageUrl,
      @required this.onTap,
      @required this.isSelected,
      @required this.onDelete,
      @required this.circleName,
      @required this.circleDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double tileWidth = 149.5 / 375 * SizeConfig.screenWidth;
    final double tileHeight = 163.8 / 375 * SizeConfig.screenWidth;
    return SizedBox(
      width: tileWidth,
      height: tileHeight,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: CustomTheme.of(context).colors.backgroundColor,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                    blurRadius: 6.0,
                    offset: Offset(0, 3),
                    color: CustomTheme.of(context).colors.shadowColor16)
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 65,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4),
                            topLeft: Radius.circular(4)),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: imageUrl ?? "",
                          placeholder: (context, url) =>
                              const CupertinoActivityIndicator(),
                          errorWidget: (context, url, error) => Container(
                              color: CustomTheme.of(context)
                                  .colors
                                  .placeHolderColor,
                              child: Image.asset(
                                ImagePathConstants.circleTilePlaceholder,
                                fit: BoxFit.contain,
                              )),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 12, right: 8, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isSelected
                                ? Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: ShapeDecoration(
                                        color: CustomTheme.of(context)
                                            .colors
                                            .backgroundColor,
                                        shape: CircleBorder(),
                                        shadows: [
                                          BoxShadow(
                                              blurRadius: 3.0,
                                              offset: Offset(0, 3),
                                              color: CustomTheme.of(context)
                                                  .colors
                                                  .shadowColor16)
                                        ]),
                                    child: Icon(
                                      Icons.check,
                                      size: 16,
                                      color: CustomTheme.of(context)
                                          .colors
                                          .primaryColor,
                                    ),
                                  )
                                : Spacer(),
                            onDelete == null
                                ? Spacer()
                                : InkWell(
                                    onTap: onDelete,
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: ShapeDecoration(
                                          color: CustomTheme.of(context)
                                              .colors
                                              .backgroundColor,
                                          shape: CircleBorder(),
                                          shadows: [
                                            BoxShadow(
                                                blurRadius: 3.0,
                                                offset: Offset(0, 3),
                                                color: CustomTheme.of(context)
                                                    .colors
                                                    .shadowColor16)
                                          ]),
                                      child: Icon(
                                        Icons.delete,
                                        size: 16,
                                        color: CustomTheme.of(context)
                                            .colors
                                            .disabledAreaColor,
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 35,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        circleName,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: CustomTheme.of(context).textStyles.cardTitle,
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        circleDescription,
                        maxLines: 1,
                        style: CustomTheme.of(context).textStyles.body1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
