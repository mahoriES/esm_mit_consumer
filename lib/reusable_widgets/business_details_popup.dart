import 'package:eSamudaay/themes/eSamudaay_theme_data.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/custom_widgets.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eSamudaay/modules/store_details/views/store_categories_details_view.dart';

class BusinessDetailsPopup extends StatefulWidget {
  final String businessTitle;
  final String businessSubtitle;
  final String businessPrettyAddress;
  final bool isDeliveryAvailable;
  final String merchantBusinessImageUrl;
  final String merchantPhoneNumber;
  final Function onContactMerchant;

  const BusinessDetailsPopup(
      {@required this.businessTitle,
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
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSizes.separatorPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Container(
            color: AppColors.solidWhite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  overflow: Overflow.visible,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.merchantBusinessImageUrl,
                            placeholder: (_, __) =>
                                const CircularProgressIndicator(),
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
                      buildMerchantTitleRowWithActions(widget.businessTitle),
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
                          )
                        ],
                      ),
                      AnimatedCustomDivider(
                          scalingUnitaryValue: separatorPaddingAnimation),
                      buildMerchantAddressRow(
                          context,
                          widget.businessPrettyAddress,
                          widget.merchantPhoneNumber, widget.onContactMerchant),
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

  Widget buildMerchantTitleRowWithActions(String businessName) {
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
                  bookmarkActionButton(null),
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

mixin AppLogoVariationProviderMixin {
  Widget buildCircularLogo(double scaledHeight, {double currentHeight}) {
    return SizedBox.fromSize(
      size: Size(scaledHeight, scaledHeight),
      child: Center(
        child: Transform.scale(
          scale: currentHeight != null ? currentHeight : 1.0,
          child: Container(
            decoration: const ShapeDecoration(
              color: AppColors.solidWhite,
              shadows: [
                BoxShadow(
                    color: Color(0xff6ea597be),
                    blurRadius: 20.0,
                    spreadRadius: 0.0,
                    offset: Offset(0, 6))
              ],
              shape: const CircleBorder(),
            ),
            padding: EdgeInsets.all(scaledHeight / 6),
            child: Image.asset(
              'assets/images/app_main_icon.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

mixin MerchantWidgetElementsProviderMixin {
  Widget buildDeliveryStatus(BuildContext context, bool deliveryStatus) {
    return Material(
      type: MaterialType.transparency,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          deliveryStatus
              ? const ImageIcon(
                  AssetImage('assets/images/delivery.png'),
                  color: Colors.green,
                )
              : const AssetImage('assets/images/no_delivery.png'),
          Text(deliveryStatus ? tr("shop.delivery_ok") : tr("shop.delivery_no"),
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: AppColors.green),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left),
        ],
      ),
    );
  }

  Widget buildBusinessCategoryTile(
      {Function onTap,
      String categoryName,
      String imageUrl,
      double tileWidth}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          width: tileWidth,
          height: tileWidth,
          child: Stack(
            children: [
              Positioned.fill(
                  child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              )),
              Positioned.fill(
                  child: FractionallySizedBox(
                alignment: Alignment.bottomCenter,
                widthFactor: 1.0,
                heightFactor: 0.16,
                child: Container(
                  width: tileWidth,
                  color: Color(0xffe6ffffff),
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Center(child: Text(categoryName)),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget contactMerchantActionButton(Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        Icons.phone_outlined,
        color: AppColors.blueBerry,
        size: 22,
      ),
    );
  }

  Widget shareActionButton(Function onShare) {
    return GestureDetector(
      onTap: onShare,
      child: const Icon(
        Icons.share,
        color: AppColors.blueBerry,
      ),
    );
  }

  Widget bookmarkActionButton(Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.bookmark,
        color: AppColors.blueBerry.withOpacity(0.3),
      ),
    );
  }

  void showContactMerchantDialog(BuildContext context, {Function onCallAction, Function onWhatsappAction, String merchantName}) {
    showModalBottomSheet(
        context: context,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        builder: (context) => Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  title: new Text('Call $merchantName'),
                  onTap: onCallAction),
              new ListTile(
                title: new Text('Whatsapp $merchantName'),
                onTap: onWhatsappAction,
              ),
            ],
          ),
        ));
  }

  Widget buildMerchantAddressRow(
      BuildContext context, String address, String phoneNumber, Function onContactMerchant) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.widgetPadding),
      child: Material(
        type: MaterialType.transparency,
        child: Row(
          children: <Widget>[
            const ImageIcon(
              AssetImage(
                'assets/images/location2.png',
              ),
              color: AppColors.blueBerry,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(address,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: AppColors.blueBerry),
                    textAlign: TextAlign.left),
              ),
            ),
            contactMerchantActionButton(onContactMerchant),
            const SizedBox(
              width: AppSizes.separatorPadding,
            ),
            Text(phoneNumber.formatPhoneNumber,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(color: AppColors.blueBerry),
                textAlign: TextAlign.left),
          ],
        ),
      ),
    );
  }
}
