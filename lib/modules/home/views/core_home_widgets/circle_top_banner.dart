import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleTopBannerView extends StatelessWidget {
  final String imageUrl;
  final String circleName;
  final VoidCallback onTapCircleButton;

  CircleTopBannerView(
      {Key key,
      @required this.imageUrl,
      @required this.circleName,
      @required this.onTapCircleButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 6.0,
            color: CustomTheme.of(context).colors.pureBlack.withOpacity(0.16))
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
                      placeholder: (context, url) =>
                          Image.asset(
                            'assets/images/top_banner_placeholder.jpg',
                            fit: BoxFit.cover,
                          ),
                      errorWidget: (context, url, error) => Image.asset(
                            'assets/images/top_banner_placeholder.jpg',
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
                      CustomTheme.of(context).colors.pureBlack,
                      CustomTheme.of(context)
                          .colors
                          .pureBlack
                          .withOpacity(0.76),
                      CustomTheme.of(context).colors.pureBlack.withOpacity(0.0),
                    ],
                    stops: [0.0, 0.39, 1.0],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  )),
                ),
              )),
              Positioned(
                bottom: AppSizes.separatorPadding,
                child: SizedBox(
                  width: SizeConfig.screenWidth,
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
                        InkWell(
                          onTap: onTapCircleButton,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(
                                    color: CustomTheme.of(context)
                                        .colors
                                        .pureWhite)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color:
                                      CustomTheme.of(context).colors.pureWhite,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  circleName,
                                  style: CustomTheme.of(context)
                                      .textStyles
                                      .sectionHeading2
                                      .copyWith(
                                          color: CustomTheme.of(context)
                                              .colors
                                              .pureWhite),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
