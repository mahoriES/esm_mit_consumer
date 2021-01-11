part of "../order_details.dart";

class _StatusCard extends StatelessWidget {
  final PlaceOrderResponse orderDetails;
  final Function(int) rateOrder;

  const _StatusCard(this.orderDetails, {this.rateOrder, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Card(
        elevation: 4,
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  BusinessImageWithLogo(
                    imageUrl: orderDetails?.businessImageUrl ?? "",
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderDetails?.businessName ?? "",
                          style: CustomTheme.of(context)
                              .textStyles
                              .sectionHeading1Regular,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          orderDetails?.totalCountString ?? "",
                          style: CustomTheme.of(context).textStyles.body1,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(9),
                            topRight: Radius.circular(9),
                          ),
                        ),
                        builder: (context) => ContactOptionsWidget(
                          name: orderDetails.businessName ?? "",
                          phoneNumber: orderDetails.businessContactNumber,
                        ),
                      );
                    },
                    child: Icon(
                      Icons.call_outlined,
                      color: CustomTheme.of(context).colors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 29),
                ],
              ),
              const SizedBox(height: 30),
              OrderProgressIndicator(
                OrderStateData.getStateData(orderDetails.orderStatus, context),
              ),
              const SizedBox(height: 28),
              if (orderDetails.orderStatus == OrderState.COMPLETED) ...{
                RatingComponent(
                  isAlreadyRated: orderDetails.isOrderAlreadyRated,
                  rating: orderDetails.rating.ratingValue,
                  onRate: rateOrder,
                ),
                const SizedBox(height: 20),
              },
              if (orderDetails.orderStatus ==
                  OrderState.MERCHANT_CANCELLED) ...{
                ActionButton(
                  text: tr(
                    "screen_order.decline_reason",
                    args: [orderDetails.cancellationNote],
                  ),
                  onTap: null,
                  isFilled: true,
                  textColor: CustomTheme.of(context).colors.secondaryColor,
                  buttonColor: CustomTheme.of(context)
                      .colors
                      .secondaryColor
                      .withOpacity(0.2),
                  showBorder: false,
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
