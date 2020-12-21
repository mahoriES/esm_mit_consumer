import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleTopBannerView extends StatelessWidget with PreferredSizeWidget {
  final String imageUrl;
  final String circleName;
  final VoidCallback onTapCircleButton;
  final bool isBannerShownOnCircleScreen;

  @override
  final Size preferredSize;

  CircleTopBannerView(
      {Key key,
      @required this.imageUrl,
      this.circleName,
      this.isBannerShownOnCircleScreen = false,
      this.onTapCircleButton})
      : preferredSize = Size.fromHeight(134 / 375 * SizeConfig.screenWidth),
        assert(isBannerShownOnCircleScreen
            ? true
            : onTapCircleButton == null
                ? false
                : true),
        assert(isBannerShownOnCircleScreen
            ? true
            : circleName != null
                ? true
                : false),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 6.0,
            color: CustomTheme.of(context).colors.shadowColor16)
      ]),
      child: SizedBox(
        width: SizeConfig.screenWidth,
        child: AspectRatio(
          aspectRatio: 375 / 134,
          child: Stack(
            children: [
              Positioned.fill(
                  child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: imageUrl ?? "",
                      placeholder: (context, url) => Image.asset(
                            ImagePathConstants.topBannerImage,
                            fit: BoxFit.cover,
                          ),
                      errorWidget: (context, url, error) => Image.asset(
                            ImagePathConstants.topBannerImage,
                            fit: BoxFit.cover,
                          ))),
              Positioned.fill(
                  child: FractionallySizedBox(
                alignment: Alignment.bottomCenter,
                widthFactor: 1,
                heightFactor: 94 / 134,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      CustomTheme.of(context).colors.textColorDarker,
                      CustomTheme.of(context)
                          .colors
                          .textColorDarker
                          .withOpacity(0.76),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.39, 1.0],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  )),
                ),
              )),
              isBannerShownOnCircleScreen
                  ? Align(
                      alignment: Alignment.center,
                      child: buildCustomOverChild(context),
                    )
                  : Positioned(
                      bottom: AppSizes.separatorPadding,
                      child: buildCustomOverChild(context),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomOverChild(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSizes.separatorPadding),
        child: Row(
          mainAxisAlignment: isBannerShownOnCircleScreen
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/splash.png',
              width: 134.5 / 375 * SizeConfig.screenWidth,
              color: CustomTheme.of(context).colors.backgroundColor,
            ),
            if (!isBannerShownOnCircleScreen)...[
              const SizedBox(width: AppSizes.widgetPadding,),
              CircleActionButton(
                  circleName: circleName, onTap: onTapCircleButton),
            ]
          ],
        ),
      ),
    );
  }
}

class CircleActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String circleName;

  const CircleActionButton(
      {Key key, @required this.onTap, @required this.circleName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                  color: CustomTheme.of(context).colors.backgroundColor)),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: CustomTheme.of(context).colors.backgroundColor,
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                circleName,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: CustomTheme.of(context)
                    .textStyles
                    .sectionHeading2
                    .copyWith(
                        color: CustomTheme.of(context).colors.backgroundColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
