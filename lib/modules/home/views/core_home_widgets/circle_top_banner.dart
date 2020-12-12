import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';

class CircleTopBannerView extends StatelessWidget {
  final String imageUrl;
  final String circleName;
  final VoidCallback onTapCircleButton;

  const CircleTopBannerView(
      {Key key,
      @required this.imageUrl,
      @required this.circleName,
      @required this.onTapCircleButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: AspectRatio(
        aspectRatio: 375 / 134,
        child: Stack(
          children: [
            Positioned.fill(
                child: CachedNetworkImage(
              imageUrl: imageUrl,
            )),
            Positioned(
              bottom: AppSizes.separatorPadding,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.separatorPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/splash.png',
                      width: 134.5 / 375 * SizeConfig.screenWidth,
                      color: CustomTheme.of(context).colors.pureWhite,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                              color: CustomTheme.of(context).colors.pureWhite)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: CustomTheme.of(context).colors.pureWhite,
                          ),
                          const SizedBox(width: 3,),
                          Text(
                            circleName,
                            style: CustomTheme.of(context)
                                .textStyles
                                .body2
                                .copyWith(
                                    color: CustomTheme.of(context)
                                        .colors
                                        .pureWhite),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
