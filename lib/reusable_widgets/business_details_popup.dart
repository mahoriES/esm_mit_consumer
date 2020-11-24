import 'package:eSamudaay/reusable_widgets/business_title_tile.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/custom_widgets.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/mixins/merchant_components_mixin.dart';

///The [BusinessDetailsPopup] class implements the card-like widget which is shown as a modal popup
///when the [BusinessTitleTile] is tapped.

class BusinessDetailsPopup extends StatefulWidget {
  final String businessTitle;
  final String businessSubtitle;
  final String businessPrettyAddress;
  final bool isDeliveryAvailable;
  final String merchantBusinessImageUrl;
  final String merchantPhoneNumber;
  final Function onContactMerchant;
  final bool isMerchantBookmarked;
  final Function onBookmarkMerchant;

  const BusinessDetailsPopup(
      {@required this.businessTitle,
      @required this.onBookmarkMerchant,
      @required this.isMerchantBookmarked,
      @required this.onContactMerchant,
      @required this.businessPrettyAddress,
      @required this.merchantBusinessImageUrl,
      @required this.isDeliveryAvailable,
      @required this.merchantPhoneNumber,
      this.businessSubtitle = ''});

  @override
  _BusinessDetailsPopupState createState() => _BusinessDetailsPopupState();
}

class _BusinessDetailsPopupState extends State<BusinessDetailsPopup>
    with SingleTickerProviderStateMixin, MerchantWidgetElementsProviderMixin {
  AnimationController _controller;
  Animation<double> separatorPaddingAnimation;
  Animation<double> appLogoScaleAnimation;

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    separatorPaddingAnimation =
        Tween<double>(begin: 0, end: 1).animate(_controller);
    appLogoScaleAnimation = CurvedAnimation(
      parent: Tween<double>(begin: 0.0, end: 1.0).animate(_controller),
      curve: Curves.elasticOut,
    );
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.separatorPadding,
            vertical: AppSizes.widgetPadding * 2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Container(
            color: AppColors.solidWhite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  overflow: Overflow.clip,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          InteractiveViewer(
                            child: CachedNetworkImage(
                              height: 258.toHeight,
                              width: double.maxFinite,
                              fit: BoxFit.cover,
                              imageUrl: widget.merchantBusinessImageUrl,
                              placeholder: (_, __) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (_, __, ___) =>
                                  Image.asset('assets/images/shop1.png'),
                            ),
                          ),
                          SizedBox(
                            height: 0.1 * SizeConfig.screenWidth +
                                AppSizes.widgetPadding,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: AppSizes.widgetPadding,
                      bottom:
                          SizeConfig.screenWidth * 0.1 - AppSizes.widgetPadding,
                      child: eSamudaayAnimatedLogo(
                          animation: appLogoScaleAnimation,
                          scaledHeight: SizeConfig.screenWidth * 0.2),
                    ),
                  ],
                ),
                Container(
                  color: AppColors.solidWhite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildMerchantTitleRowWithActions(
                          widget.businessTitle,
                          widget.onBookmarkMerchant,
                          widget.isMerchantBookmarked),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: AppSizes.widgetPadding,
                                  top: AppSizes.separatorPadding),
                              child: Text(
                                widget.businessSubtitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                        fontSize: 16.toFont,
                                        fontWeight: FontWeight.w500),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: AppSizes.separatorPadding,
                                  right: AppSizes.widgetPadding),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: buildDeliveryStatus(
                                    context, widget.isDeliveryAvailable),
                              ),
                            ),
                          ),
                        ],
                      ),
                      AnimatedCustomDivider(
                          scalingUnitaryValue: separatorPaddingAnimation),
                      buildMerchantAddressRow(
                          context,
                          widget.businessPrettyAddress,
                          widget.merchantPhoneNumber,
                          widget.onContactMerchant),
                      const SizedBox(
                        height: AppSizes.widgetPadding,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMerchantTitleRowWithActions(
      String businessName, Function onBookmark, bool isBookmarked) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.widgetPadding),
      child: Row(
        children: [
          Expanded(
            flex: 80,
            child: Text(businessName,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: 28.toFont, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 20,
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  bookmarkActionButton(onBookmark, isBookmarked),
                  shareActionButton(null),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// [eSamudaayAnimatedLogo] class provides a animated instance of the app logo. The class requires an
/// [Animation] value as, hence can be customised as per need.

class eSamudaayAnimatedLogo extends AnimatedWidget
    with AppLogoVariationProviderMixin {
  final Animation<double> animation;
  final double scaledHeight;

  const eSamudaayAnimatedLogo(
      {@required this.animation, @required this.scaledHeight})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return buildCircularLogo(scaledHeight, currentHeight: animation.value);
  }
}

class eSamudaayLogo extends StatelessWidget with AppLogoVariationProviderMixin {
  final double scaledHeight;

  const eSamudaayLogo({@required this.scaledHeight});

  @override
  Widget build(BuildContext context) {
    return buildCircularLogo(scaledHeight);
  }
}