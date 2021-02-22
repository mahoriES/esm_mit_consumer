part of '../orders_card.dart';

class _OrderCardMessage extends StatelessWidget {
  final PlaceOrderResponse orderResponse;
  final Function(int) rateOrder;
  const _OrderCardMessage(
    this.orderResponse, {
    this.rateOrder,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String orderStatus = orderResponse.orderStatus;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: orderStatus == OrderState.CREATED
          ? Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 14),
              child: Text(
                tr("screen_order.pending_order_message"),
                style: CustomTheme.of(context).textStyles.cardTitleFaded,
                textAlign: TextAlign.center,
              ),
            )
          : orderStatus == OrderState.MERCHANT_ACCEPTED ||
                  orderStatus == OrderState.REQUESTING_TO_DA ||
                  orderStatus == OrderState.ASSIGNED_TO_DA ||
                  orderResponse.isReadyToPickupByDA
              ? Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    orderStatus == OrderState.MERCHANT_ACCEPTED
                        ? tr("screen_order.processing_order_message")
                        : tr("screen_order.processing_order_message_DA"),
                    style: CustomTheme.of(context).textStyles.cardTitleFaded,
                    textAlign: TextAlign.center,
                  ),
                )
              : orderStatus == OrderState.MERCHANT_UPDATED ||
                      orderStatus == OrderState.CUSTOMER_CANCELLED
                  ? SizedBox(height: 20)
                  : orderStatus == OrderState.MERCHANT_CANCELLED
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            tr("screen_order.declined_order_message",
                                args: [orderResponse.cancellationNote]),
                            style: CustomTheme.of(context)
                                .textStyles
                                .cardTitleFaded,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : orderStatus == OrderState.PICKED_UP_BY_DA
                          ? Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  Text(
                                    tr("screen_order.out_for_delivery_order_message"),
                                    style: CustomTheme.of(context)
                                        .textStyles
                                        .cardTitleFaded,
                                    textAlign: TextAlign.center,
                                  ),
                                  // SizedBox(height: 10),
                                  // InkWell(
                                  //   onTap: () => ContactOptionsWidget(
                                  //     name: orderResponse.d,
                                  //     phoneNumber: null,
                                  //   ),
                                  //   child: Text(
                                  //     "Contact Delivery Person".toUpperCase(),
                                  //     style: CustomTheme.of(context)
                                  //         .textStyles
                                  //         .body2BoldPrimary,
                                  //   ),
                                  // ),
                                ],
                              ),
                            )
                          : orderStatus == OrderState.READY_FOR_PICKUP
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Column(
                                    children: [
                                      // Text(
                                      //   "Store timings: Mon- Fri 10:00am - 8:00 pm",
                                      //   style: CustomTheme.of(context)
                                      //       .textStyles
                                      //       .cardTitleFaded,
                                      //   textAlign: TextAlign.center,
                                      // ),
                                      // SizedBox(height: 10),
                                      InkWell(
                                        onTap: () {
                                          GenericMethods.openMap(
                                            orderResponse.pickupAddress
                                                .locationPoint?.lat,
                                            orderResponse.pickupAddress
                                                .locationPoint?.lon,
                                          );
                                        },
                                        child: Text(
                                          tr("screen_order.store_location")
                                              .toUpperCase(),
                                          style: CustomTheme.of(context)
                                              .textStyles
                                              .body2BoldPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : orderStatus == OrderState.COMPLETED
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Column(
                                        children: [
                                          RatingIndicator(
                                            rating: orderResponse
                                                    .rating?.ratingValue ??
                                                0,
                                            onRate: orderResponse
                                                    .isOrderAlreadyRated
                                                ? null
                                                : rateOrder,
                                          ),
                                        ],
                                      ),
                                    )
                                  : orderStatus == OrderState.CUSTOMER_PENDING
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, bottom: 14),
                                          child: Text(
                                            "Pay and complete your order!",
                                            style: CustomTheme.of(context)
                                                .textStyles
                                                .cardTitleFaded,
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : SizedBox.shrink(),
    );
  }
}
