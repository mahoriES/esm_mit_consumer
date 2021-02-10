part of 'order_summary_card.dart';

class _OrderSummaryAvailableItemsList extends StatelessWidget {
  final List<OrderItems> availableItemsList;
  final bool isOrderConfirmed;

  const _OrderSummaryAvailableItemsList({
    @required this.availableItemsList,
    @required this.isOrderConfirmed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isOrderConfirmed
              ? tr("screen_order.available_items")
              : tr("cart.catalogue_items"),
          style: isOrderConfirmed
              ? CustomTheme.of(context).textStyles.cardTitlePrimary
              : CustomTheme.of(context).textStyles.body1,
        ),
        const SizedBox(height: 20),
        _GenericItemsList(
          productsList: availableItemsList,
          showPrice: true,
          isFaded: false,
        ),
        Divider(
          color: CustomTheme.of(context).colors.dividerColor,
          thickness: 1,
          height: 5,
        ),
        const SizedBox(height: 15)
      ],
    );
  }
}

class _GenericItemsList extends StatelessWidget {
  final List<OrderItems> productsList;
  final bool showPrice;
  final bool isFaded;
  const _GenericItemsList({
    @required this.productsList,
    @required this.showPrice,
    @required this.isFaded,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: productsList.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final OrderItems _currentProduct = productsList[index];
        if (_currentProduct.quantity == 0) return SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentProduct.productName,
                      style:
                          CustomTheme.of(context).textStyles.cardTitle.copyWith(
                                color: isFaded
                                    ? CustomTheme.of(context)
                                        .colors
                                        .disabledAreaColor
                                    : CustomTheme.of(context).colors.textColor,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentProduct.variationOption?.size ?? "",
                      style: CustomTheme.of(context).textStyles.body2.copyWith(
                            color: isFaded
                                ? CustomTheme.of(context)
                                    .colors
                                    .disabledAreaColor
                                : CustomTheme.of(context).colors.textColor,
                          ),
                    ),
                  ],
                ),
              ),
              if (showPrice) ...{
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: FittedBox(
                    child: Text(
                      "x\t${_currentProduct.quantity}\t\t=",
                      style: CustomTheme.of(context).textStyles.cardTitleFaded,
                    ),
                  ),
                ),
              },
              const SizedBox(width: 10),
              Flexible(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: !showPrice
                      ? CustomPaint(
                          foregroundPainter: DashedLinePainter(
                            color: CustomTheme.of(context)
                                .colors
                                .disabledAreaColor,
                          ),
                          child: Container(
                            width: 10,
                            height: 2,
                          ),
                        )
                      : FittedBox(
                          child: Text(
                            _currentProduct.totalPriceOfItem.withRupeePrefix,
                            style: CustomTheme.of(context).textStyles.cardTitle,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OrderSummaryNoAvailableItemsList extends StatelessWidget {
  final List<OrderItems> unavailableItemsList;

  _OrderSummaryNoAvailableItemsList({
    @required this.unavailableItemsList,
    Key key,
  }) : super(key: key);

  final GlobalKey notAvailableIconKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: CustomTheme.of(context).colors.dividerColor,
          thickness: 1,
          height: 20,
        ),
        Row(
          children: [
            Text(
              tr("screen_order.not_available"),
              style: CustomTheme.of(context).textStyles.cardTitle,
            ),
            const SizedBox(width: 14),
            InkWell(
              key: notAvailableIconKey,
              onTap: () {
                CustomPositionedDialog.show(
                  key: notAvailableIconKey,
                  content: NotAvailableInfoCard(),
                  context: context,
                  margin: Size(0, 0),
                );
              },
              child: Icon(
                Icons.error,
                size: 22,
                color: CustomTheme.of(context).colors.placeHolderColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _GenericItemsList(
            productsList: unavailableItemsList,
            showPrice: false,
            isFaded: true,
          ),
        ),
      ],
    );
  }
}

class NotAvailableInfoCard extends StatelessWidget {
  const NotAvailableInfoCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: SizeConfig.screenWidth / 2,
        ),
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.error,
              size: 22,
              color: CustomTheme.of(context).colors.placeHolderColor,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                tr("screen_order.not_available_message"),
                style: CustomTheme.of(context).textStyles.body2Faded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChargesList extends StatelessWidget {
  final PlaceOrderResponse orderDetails;
  ChargesList(this.orderDetails, {Key key}) : super(key: key);

  final GlobalKey deliveryChargeKey = new GlobalKey();
  final GlobalKey merchantChargeKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChargesListTile(
          chargeName: tr("cart.item_total"),
          price: orderDetails.itemTotalPriceInRupees,
        ),
        const SizedBox(height: 2),
        Container(
          key: deliveryChargeKey,
          margin: const EdgeInsets.symmetric(vertical: 14),
          child: ChargesListTile(
            chargeName: tr("cart.delivery_partner_fee"),
            price: orderDetails.otherChargesDetail?.deliveryCharge?.amount ?? 0,
            style: CustomTheme.of(context)
                .textStyles
                .body1FadedWithDottedUnderline,
            onTap: () => CustomPositionedDialog.show(
              key: deliveryChargeKey,
              content: DeliveryChargeInfoCard(),
              context: context,
              margin: Size(0, 45),
            ),
          ),
        ),
        Container(
          key: merchantChargeKey,
          child: ChargesListTile(
            chargeName: tr("cart.merchant_charges"),
            price: orderDetails.otherChargesInRupees,
            style: CustomTheme.of(context)
                .textStyles
                .body1FadedWithDottedUnderline,
            onTap: () => CustomPositionedDialog.show(
              key: merchantChargeKey,
              context: context,
              content: MerchantChargesInfoCard(
                packingCharge:
                    orderDetails.otherChargesDetail?.packingCharge?.amount ?? 0,
                serviceCharge:
                    orderDetails.otherChargesDetail?.serviceCharge?.amount ?? 0,
                extraCharge:
                    orderDetails.otherChargesDetail?.extraCharge?.amount ?? 0,
              ),
              margin: Size(0, 80),
            ),
          ),
        ),
        Divider(
          color: CustomTheme.of(context).colors.dividerColor,
          thickness: 1,
          height: 40,
        ),
        ChargesListTile(
          chargeName: tr("cart.grand_total"),
          price: orderDetails.orderTotalPriceInRupees,
          style: CustomTheme.of(context).textStyles.sectionHeading2,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class CustomerListItemsView extends StatelessWidget {
  final List<Photo> customerNoteImages;
  final List<FreeFormOrderItems> freeFormItems;
  const CustomerListItemsView({
    @required this.customerNoteImages,
    @required this.freeFormItems,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        CustomPaint(
          foregroundPainter: DashedLinePainter(
            color: CustomTheme.of(context).colors.disabledAreaColor,
          ),
          child: Container(
            width: double.infinity,
            height: 2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          tr("cart.list_items"),
          style: CustomTheme.of(context).textStyles.body1,
        ),
        if (freeFormItems.isNotEmpty) ...[
          const SizedBox(height: 20),
          _OrderSummaryFreeFormItemsList(freeFormItems),
        ],
        if (customerNoteImages.isNotEmpty) ...[
          const SizedBox(height: 20),
          CustomerNoteImageView(
            customerNoteImages: customerNoteImages,
            onRemove: null,
            showRemoveButton: false,
          ),
        ],
        const SizedBox(height: 10),
      ],
    );
  }
}

class _OrderSummaryFreeFormItemsList extends StatelessWidget {
  final List<FreeFormOrderItems> freeFormItems;
  const _OrderSummaryFreeFormItemsList(this.freeFormItems, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          itemCount: freeFormItems.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final FreeFormOrderItems _currentItem = freeFormItems[index];
            final bool isAvailable =
                _currentItem.productStatus != FreeFormItemStatus.NotAdded;
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(
                      _currentItem.skuName ?? "",
                      style:
                          CustomTheme.of(context).textStyles.cardTitle.copyWith(
                                color: isAvailable
                                    ? CustomTheme.of(context).colors.textColor
                                    : CustomTheme.of(context)
                                        .colors
                                        .disabledAreaColor,
                              ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 1,
                    child: Text(
                      "x\t${_currentItem.quantity}\t\t\t",
                      style: CustomTheme.of(context).textStyles.cardTitleFaded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        isAvailable
                            ? Icons.check_circle
                            : Icons.cancel_outlined,
                        color: isAvailable
                            ? CustomTheme.of(context).colors.primaryColor
                            : CustomTheme.of(context).colors.disabledAreaColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Divider(
          color: CustomTheme.of(context).colors.dividerColor,
          thickness: 1,
          height: 5,
        ),
        const SizedBox(height: 15)
      ],
    );
  }
}
