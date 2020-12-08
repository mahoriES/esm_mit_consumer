import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/modules/home/models/business_helper_model.dart';
import 'package:eSamudaay/reusable_widgets/bookmark_button.dart';
import 'package:eSamudaay/reusable_widgets/merchant_core_widget_classes/business_delivery_status_widget.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/custom_widgets.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/extensions.dart';

class HybridBusinessTile extends StatelessWidget {
  final String businessRating;
  final String businessImageUrl;
  final bool isDeliveryAvailable;
  final String goToShopActionTitle;
  final String businessTitle;
  final String businessSubtitle;
  final String businessId;
  final List<HighlightedItemsType> highlightedItemsList;

  const HybridBusinessTile(
      {Key key,
      this.businessRating,
      @required this.businessImageUrl,
      @required this.isDeliveryAvailable,
      @required this.businessId,
      this.goToShopActionTitle,
      this.highlightedItemsList,
      @required this.businessTitle,
      @required this.businessSubtitle})
      : assert(businessTitle != null),
        assert(businessImageUrl != null),
        assert(businessId != null),
        assert(isDeliveryAvailable != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(9), boxShadow: [
            BoxShadow(
                color:
                    CustomTheme.of(context).colors.pureBlack.withOpacity(0.16),
                offset: const Offset(0, 3.0),
                blurRadius: 6.0),
          ]),
          child: Column(
            children: [
              if (highlightedItemsList.isNotEmpty) ...[
                HighlightedItemHorizontalCarouselViewer(
                  highlightedItemsList: highlightedItemsList,
                ),
                const CustomDivider(),
              ],
              Row(
                children: [
                  SizedBox(
                    height: 0.168 * SizeConfig.screenWidth,
                    width: 0.168 * SizeConfig.screenWidth,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: const ShapeDecoration(shape: CircleBorder()),
                      child: CachedNetworkImage(
                        imageUrl: businessImageUrl ?? '',
                        errorWidget: (_, __, ___) =>
                            Image.asset('assets/images/shop1.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  itemPadding,
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          businessTitle ?? ' ',
                          style: CustomTheme.of(context)
                              .textStyles
                              .cardTitle
                              .copyWith(fontSize: 16),
                        ),
                        Text(
                          businessSubtitle ?? ' ',
                          style: CustomTheme.of(context).textStyles.body1,
                        ),
                        DeliveryStatusWidget(
                            deliveryStatus: isDeliveryAvailable),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: const [BookmarkButton()],
                      ),
                      Text(
                        goToShopActionTitle,
                        style: CustomTheme.of(context).textStyles.buttonText2,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget get itemPadding => const SizedBox(
        width: 15.0,
      );
}

class HighlightedItemHorizontalCarouselViewer extends StatelessWidget {
  final List<HighlightedItemsType> highlightedItemsList;

  const HighlightedItemHorizontalCarouselViewer(
      {Key key, @required this.highlightedItemsList})
      : assert(highlightedItemsList != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (highlightedItemsList.isEmpty) return SizedBox.shrink();
    return Flexible(
        child: ListView.separated(
      itemBuilder: (context, index) => HighlightedItemTile(
        item: highlightedItemsList[index],
      ),
      separatorBuilder: (context, index) => const SizedBox(
        width: 10,
      ),
      itemCount: highlightedItemsList.length,
    ));
  }
}

class HighlightedItemTile extends StatelessWidget {
  final HighlightedItemsType item;

  const HighlightedItemTile({Key key, @required this.item})
      : assert(item != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final double imageSide = SizeConfig.screenWidth * 75 / 375;
    return Container(
        child: Column(
      children: [
        Container(
            decoration: const ShapeDecoration(shape: CircleBorder()),
            child: SizedBox(
              height: imageSide,
              width: imageSide,
              child: CachedNetworkImage(imageUrl: item.itemImageUrl),
            )),
        Text(
          item.itemName,
          style: CustomTheme.of(context).textStyles.body1,
        ),
        Text(
          item.itemQuantityOrServingSize,
          style: CustomTheme.of(context).textStyles.body2,
        ),
        Text(
          item.itemPriceWithoutCurrencyPrefix.withRupeePrefix,
          style: CustomTheme.of(context).textStyles.body2,
        ),
      ],
    ));
  }
}
