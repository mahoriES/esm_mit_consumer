import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/modules/home/models/business_helper_model.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/reusable_widgets/bookmark_button.dart';
import 'package:eSamudaay/reusable_widgets/merchant_core_widget_classes/business_delivery_status_widget.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/custom_widgets.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/extensions.dart';

///This enum is used to determine whether the tile is being used for a main screen
///business (which shows augmented categories in a horizontal carousel) or a business shown
///under a particular category (which shows augmented products belonging to that particular category)
enum BusinessShowType { categoryListing, mainPageListing }

///This is a Connector widget, for the [HybridBusinessTile]
class HybridBusinessTileConnector extends StatelessWidget {
  final Business business;
  final BusinessShowType businessShowType;

  const HybridBusinessTileConnector(
      {Key key,
      this.business,

      ///For now since this is being used only for home screen, the default value is
      ///set accordingly. Will change this when it becomes multi-purpose.
      this.businessShowType = BusinessShowType.mainPageListing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HybridBusinessTile(
        businessImageUrl: business.images == null || business.images.isEmpty
            ? null
            : business.images.first.photoUrl,
        isDeliveryAvailable: business.hasDelivery,
        highlightedItemsList: highlightedItemsList,
        businessId: business.businessId,
        businessTitle: business.businessName,
        businessSubtitle: business.description);
  }

  List<HighlightedItemsType> get highlightedItemsList {
    final List<HighlightedItemsType> highlightedItemsList = [];
    if (businessShowType == BusinessShowType.mainPageListing &&
        business.augmentedCategories != null &&
        business.augmentedCategories.isNotEmpty) {
      business.augmentedCategories.forEach((element) {
        highlightedItemsList.add(HighlightedItemsType(
            itemName: element.categoryName,
            itemImageUrl: element.images == null || element.images.isEmpty
                ? null
                : element.images.first.photoUrl));
      });
    }
    return highlightedItemsList;
  }

}

///This class should be used only via it's connector [HybridBusinessTileConnector]
class HybridBusinessTile extends StatelessWidget {
  final String businessRating;
  final String businessImageUrl;
  final bool isDeliveryAvailable;

  ///The action/CTA button title shown on the business tile. Defaults to "View Shop"
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
        assert(businessId != null),
        assert(isDeliveryAvailable != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: BoxDecoration(
              color: CustomTheme.of(context).colors.backgroundColor,
              borderRadius: BorderRadius.circular(9),
              boxShadow: [
                BoxShadow(
                    color: CustomTheme.of(context)
                        .colors
                        .shadowColor16,
                    offset: const Offset(0, 3.0),
                    blurRadius: 6.0),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (highlightedItemsList != null &&
                  highlightedItemsList.isNotEmpty) ...[
                HighlightedItemHorizontalCarouselViewer(
                  highlightedItemsList: highlightedItemsList,
                ),
                const CustomDivider(),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 0.168 * SizeConfig.screenWidth,
                    width: 0.168 * SizeConfig.screenWidth,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration:
                          ShapeDecoration(shape: CircleBorder(), shadows: [
                        BoxShadow(
                          blurRadius: 6,
                          color: CustomTheme.of(context)
                              .colors
                              .shadowColor16,
                        )
                      ]),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          businessTitle ?? ' ',
                          style: CustomTheme.of(context)
                              .textStyles
                              .cardTitle
                              .copyWith(fontSize: 16),
                        ),
                        const SizedBox(
                          height: AppSizes.separatorPadding / 2,
                        ),
                        Text(
                          businessSubtitle ?? ' ',
                          style: CustomTheme.of(context).textStyles.body1,
                        ),
                        const SizedBox(
                          height: AppSizes.separatorPadding / 2,
                        ),
                        DeliveryStatusWidget(
                            deliveryStatus: isDeliveryAvailable),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BookmarkButton(
                        businessId: businessId,
                      ),
                      const SizedBox(
                        height: AppSizes.widgetPadding,
                      ),
                      Text(
                        goToShopActionTitle ?? 'VIEW SHOP',
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
    return SingleChildScrollView(
      child: Row(
        children: generateCarouselTiles,
      ),
      scrollDirection: Axis.horizontal,
    );
  }

  List<Widget> get generateCarouselTiles {
    List<Widget> tiles = [];
    for (var index
        in Iterable<int>.generate(highlightedItemsList.length).toList()) {
      tiles.add(
        Padding(
          padding: EdgeInsets.only(
              left: index == 0 ? AppSizes.separatorPadding : 0.0,
              right: AppSizes.separatorPadding),
          child: HighlightedItemTile(
            item: highlightedItemsList[index],
          ),
        ),
      );
    }
    return tiles;
  }
}

class HighlightedItemTile extends StatelessWidget {
  final HighlightedItemsType item;

  const HighlightedItemTile({Key key, @required this.item})
      : assert(item != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    ///This is the side for the circular images of the highlighted categories / products
    ///This will be 75 sp for the standard screen, and then modified according to screen width
    final double imageSide = SizeConfig.screenWidth * 75 / 375;
    return Container(
        constraints: BoxConstraints(
          maxWidth: imageSide + AppSizes.separatorPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                decoration: ShapeDecoration(shape: CircleBorder(), shadows: [
                  BoxShadow(
                      color: CustomTheme.of(context)
                          .colors
                          .shadowColor16,
                      offset: const Offset(0, 3.0),
                      blurRadius: 3.0),
                ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(imageSide / 2),
                  child: Container(
                    color: CustomTheme.of(context).colors.backgroundColor,
                    child: SizedBox(
                      height: imageSide,
                      width: imageSide,
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: item.itemImageUrl ?? "",
                          placeholder: (context, url) =>
                              CupertinoActivityIndicator(),
                          errorWidget: (context, url, error) => Center(
                            child: Icon(
                              Icons.image,
                              size: AppSizes.productItemIconSize,
                            ),
                          )),
                    ),
                  ),
                )),
            const SizedBox(
              height: 4,
            ),
            Text(
              item.itemName ?? ' ',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: CustomTheme.of(context).textStyles.body1,
            ),
            if (item.itemQuantityOrServingSize != null ||
                item.itemQuantityOrServingSize == '')
              Text(
                item.itemQuantityOrServingSize,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomTheme.of(context).textStyles.body2,
              ),
            if (item.itemPriceWithoutCurrencyPrefix != null ||
                item.itemPriceWithoutCurrencyPrefix == '')
              Text(
                item.itemPriceWithoutCurrencyPrefix.withRupeePrefix,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomTheme.of(context).textStyles.body2,
              ),
          ],
        ));
  }
}
