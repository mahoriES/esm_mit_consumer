import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/reusable_widgets/bookmark_button.dart';
import 'package:eSamudaay/reusable_widgets/business_title_tile.dart';
import 'package:eSamudaay/reusable_widgets/merchant_core_widget_classes/business_delivery_status_widget.dart';
import 'package:eSamudaay/reusable_widgets/merchant_core_widget_classes/merchant_address_row.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/custom_widgets.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/mixins/merchant_components_mixin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

///The [BusinessDetailsPopup] class implements the card-like widget which is shown as a modal popup
///when the [BusinessTitleTile] is tapped.

// TODO : Wrap this widget with Store connector to avoid passing so much data as argument.

class BusinessDetailsPopup extends StatefulWidget {
  final String businessTitle;
  final String businessSubtitle;
  final String businessPrettyAddress;
  final bool isDeliveryAvailable;
  final String merchantBusinessImageUrl;
  final String merchantPhoneNumber;
  final Function onContactMerchant;
  final LocationPoint locationPoint;
  final Function onShareMerchant;
  final String businessId;

  const BusinessDetailsPopup(
      {@required this.businessTitle,
      @required this.locationPoint,
      @required this.onContactMerchant,
      @required this.businessId,
      @required this.businessPrettyAddress,
      @required this.merchantBusinessImageUrl,
      @required this.isDeliveryAvailable,
      @required this.merchantPhoneNumber,
      @required this.onShareMerchant,
      this.businessSubtitle = ''});

  @override
  _BusinessDetailsPopupState createState() => _BusinessDetailsPopupState();
}

class _BusinessDetailsPopupState extends State<BusinessDetailsPopup>
    with SingleTickerProviderStateMixin, MerchantActionsProviderMixin {
  AnimationController _controller;
  Animation<double> separatorPaddingAnimation;
  Animation<double> appLogoScaleAnimation;

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    separatorPaddingAnimation =
        Tween<double>(begin: 0, end: 1).animate(_controller);
    appLogoScaleAnimation = CurvedAnimation(
      parent: Tween<double>(begin: 0.0, end: 1.0).animate(_controller),
      curve: Curves.linear,
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
          child: Material(
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
                        bottom: SizeConfig.screenWidth * 0.1 -
                            AppSizes.widgetPadding,
                        child: eSamudaayAnimatedLogo(
                            animation: appLogoScaleAnimation,
                            scaledHeight: SizeConfig.screenWidth * 0.2),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildMerchantTitleRowWithActions(
                        widget.businessTitle,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: AppSizes.widgetPadding,
                                  top: AppSizes.separatorPadding),
                              child: Text(
                                widget.businessSubtitle,
                                style: CustomTheme.of(context)
                                    .textStyles
                                    .sectionHeading2,
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
                                child: DeliveryStatusWidget(
                                  deliveryStatus: widget.isDeliveryAvailable,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      AnimatedCustomDivider(
                          scalingUnitaryValue: separatorPaddingAnimation),
                      MerchantAddressRow(
                        onOpenMap: () {
                          openMap(widget.locationPoint?.lat,
                              widget.locationPoint?.lon);
                        },
                        onContactMerchant: widget.onContactMerchant,
                        address: widget.businessPrettyAddress,
                        phoneNumber: widget.merchantPhoneNumber,
                      ),
                      const SizedBox(
                        height: AppSizes.widgetPadding,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> openMap(double latitude, double longitude) async {
    if (latitude == null || longitude == null) {
      Fluttertoast.showToast(msg: tr('store_home.no_location'));
      return;
    }
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      Fluttertoast.showToast(msg: tr('store_home.error_map'));
    }
  }

  Widget buildMerchantTitleRowWithActions(String businessName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.widgetPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 80,
            child: Text(
              businessName,
              style: CustomTheme.of(context).textStyles.merchantCardTitle,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BookmarkButton(businessId: widget.businessId,),
                ShareBusinessActionButton(onShare: widget.onShareMerchant),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// [eSamudaayAnimatedLogo] class provides a animated instance of the app logo. The class requires an
/// [Animation] value as, hence can be customised as per need.

class eSamudaayAnimatedLogo extends AnimatedWidget {
  final Animation<double> animation;
  final double scaledHeight;

  const eSamudaayAnimatedLogo(
      {@required this.animation, @required this.scaledHeight})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return CircularAppLogo(scaledHeight: scaledHeight, currentHeight: animation.value);
  }
}

class eSamudaayLogo extends StatelessWidget {
  final double scaledHeight;

  const eSamudaayLogo({@required this.scaledHeight});

  @override
  Widget build(BuildContext context) {
    return CircularAppLogo(scaledHeight: scaledHeight);
  }
}
