import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/reusable_widgets/bookmark_button.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eSamudaay/modules/store_details/views/store_categories_details_view.dart';

///The [MerchantWidgetElementsProviderMixin] provides the common widgets shared among components dealing
///with the business pages.

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
              : const Icon(Icons.store,color: AppColors.orange,),
          SizedBox(width: 3.toWidth,),
          Text(deliveryStatus ? tr("shop.delivery_ok") : tr("shop.delivery_no"),
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: deliveryStatus ? AppColors.green : AppColors.orange, fontSize: 10),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left),
        ],
      ),
    );
  }

  Widget get placeHolderImage {
    return Image.asset(
      'assets/images/category_placeholder.png',
      fit: BoxFit.cover,
    );
  }

  Widget buildBusinessCategoryTile(BuildContext context,
      {Function onTap,
        String categoryName,
        String imageUrl,
        double tileWidth}) {
    return GestureDetector(
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
                    color: const Color(0xffe6ffffff),
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Center(
                      child: Text(
                        categoryName,
                        style: CustomTheme.of(context).textStyles.caption,
                      ),
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

  Widget bookmarkActionButton(Function onTap, bool isBookmarked) {
    return BookmarkButton(
      isBookmarked: isBookmarked,
      onTap: onTap,
    );
  }

  void showContactMerchantDialog(BuildContext context,
      {Function onCallAction, Function onWhatsappAction, String merchantName}) {
    showModalBottomSheet(
        context: context,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(9), topRight: Radius.circular(9)),
        ),
        builder: (context) => Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  title: new Text(
                    'Call $merchantName',
                    style: CustomTheme.of(context).textStyles.subtitle2,
                  ),
                  leading: const Icon(
                    Icons.call,
                    size: 25,
                    color: AppColors.green,
                  ),
                  onTap: onCallAction),
              new ListTile(
                title: new Text('Whatsapp $merchantName',
                    style: CustomTheme.of(context).textStyles.subtitle2),
                leading: SizedBox(height: 25.toHeight,width: 25.toWidth,child: Image.asset('assets/images/whatsapp.png')),
                onTap: onWhatsappAction,
              ),
            ],
          ),
        ));
  }

  Widget buildMerchantAddressRow(BuildContext context, String address,
      String phoneNumber, Function onContactMerchant) {
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
            GestureDetector(onTap: onContactMerchant,
              child: Text(phoneNumber.formatPhoneNumber,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: AppColors.blueBerry),
                  textAlign: TextAlign.left),
            ),
          ],
        ),
      ),
    );
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
                    color: const Color(0xff6ea597be),
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