import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/reusable_widgets/bookmark_button.dart';
import 'package:eSamudaay/reusable_widgets/business_details_popup.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/mixins/merchant_components_mixin.dart';

///The [BusinessTitleTile] is the top header shown on the business landing page.
///It contains the basic store info, alongwith options to contact, bookmark the business.
///Tapping on it will show a popup with more details viz. address, business images etc.

// TODO : Wrap this widget with Store connector to avoid passing so much data.

class BusinessTitleTile extends StatefulWidget {
  final String businessName;
  final String businessSubtitle;
  final String storeTimingsDetailsString;
  final String businessPhoneNumber;
  final bool isDeliveryAvailable;
  final String businessImageUrl;
  final bool isOpen;
  final Function onBackPressed;
  final Function onContactMerchantPressed;
  final Function onShowMerchantInfo;

  const BusinessTitleTile(
      {@required this.businessName,
      @required this.isDeliveryAvailable,
      @required this.isOpen,
      @required this.businessImageUrl,
      @required this.onBackPressed,
      @required this.onShowMerchantInfo,
      @required this.onContactMerchantPressed,
      this.businessSubtitle = '',
      this.businessPhoneNumber,
      this.storeTimingsDetailsString = ''});

  @override
  _BusinessTitleTileState createState() => _BusinessTitleTileState();
}

class _BusinessTitleTileState extends State<BusinessTitleTile>
    with MerchantWidgetElementsProviderMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: AppSizes.separatorPadding,
        bottom: AppSizes.separatorPadding,
        right: AppSizes.separatorPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.solidWhite,
        boxShadow: const [
          BoxShadow(
              color: AppColors.greyedout, blurRadius: 6.0, offset: Offset(0, 3))
        ],
        borderRadius: BorderRadius.circular(9.0),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: AppSizes.separatorPadding,
          ),
          GestureDetector(
              onTap: widget.onBackPressed,
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.blueBerry,
              )),
          GestureDetector(
              onTap: widget.onShowMerchantInfo,
              child: buildMerchantDPTitle(widget.businessImageUrl)),
          const SizedBox(
            width: AppSizes.separatorPadding / 2,
          ),
          Expanded(
            child: GestureDetector(
              onTap: widget.onShowMerchantInfo,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.businessName,
                    style: Theme.of(context).textTheme.headline6,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: AppSizes.separatorPadding / 2,
                  ),
                  Text(
                    widget.businessSubtitle,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(
                    height: AppSizes.separatorPadding / 2,
                  ),
                  Text(
                    widget.storeTimingsDetailsString,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: AppSizes.separatorPadding,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const BookmarkButton(),
                  const SizedBox(
                    width: AppSizes.separatorPadding,
                  ),
                  contactMerchantActionButton(widget.onContactMerchantPressed),
                ],
              ),
              const SizedBox(
                height: AppSizes.separatorPadding,
              ),
              buildDeliveryStatus(context, widget.isDeliveryAvailable),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMerchantDPTitle(String imageUrl) {
    return SizedBox(
      height: 0.217 * SizeConfig.screenWidth,
      width: 0.217 * SizeConfig.screenWidth,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 0.168 * SizeConfig.screenWidth,
              width: 0.168 * SizeConfig.screenWidth,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const ShapeDecoration(shape: CircleBorder()),
                child: CachedNetworkImage(
                  errorWidget: (_, __, ___) =>
                      Image.asset('assets/images/shop1.png'),
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: eSamudaayLogo(scaledHeight: 0.093 * SizeConfig.screenWidth),
          ),
        ],
      ),
    );
  }
}
