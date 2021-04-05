import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/extensions.dart';

class PaymentStatusTile extends StatelessWidget {
  final PlaceOrderResponse orderResponse;
  final VoidCallback onPay;
  const PaymentStatusTile({
    @required this.orderResponse,
    @required this.onPay,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: FittedBox(
            child: Text.rich(
              TextSpan(
                text: tr("screen_order.payment_details") + "\n",
                style: CustomTheme.of(context).textStyles.body2,
                children: [
                  TextSpan(
                    text: tr(
                      // If paylater is selected already then check the delivery type
                      // and show relevant message to user.
                      orderResponse.paymentInfo.isPayLaterSelected
                          ? orderResponse.deliveryType ==
                                  DeliveryType.DeliveryToHome
                              ? "payment_statuses.on_delivery_amount"
                              : "payment_statuses.on_pickup_amount"
                          : orderResponse.paymentInfo.dStatusWithAmount,
                      args: [
                        orderResponse.orderTotalPriceInRupees.withRupeePrefix
                      ],
                    ),
                    style: CustomTheme.of(context)
                        .textStyles
                        .cardTitle
                        .copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ),
        Flexible(
          child: orderResponse.paymentInfo.isPaymentDone ||
                  orderResponse.paymentInfo.isPaymentInitiated
              ? Row(
                  children: [
                    Icon(
                      orderResponse.paymentInfo.isPaymentInitiated
                          ? Icons.watch_later_outlined
                          : Icons.check_circle_outline,
                      color: CustomTheme.of(context).colors.positiveColor,
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Text.rich(
                        TextSpan(
                          text: tr("screen_order.payment_method") + "\n",
                          style: CustomTheme.of(context).textStyles.body2,
                          children: [
                            TextSpan(
                              text: orderResponse.paymentInfo?.paymentMadeVia
                                      ?.toCamelCase() ??
                                  "",
                              style: CustomTheme.of(context)
                                  .textStyles
                                  .cardTitle
                                  .copyWith(height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : orderResponse.paymentInfo.isPaymentFailed ||
                      orderResponse.paymentInfo.isPaymentPending ||
                      orderResponse.paymentInfo.isPayLaterSelected
                  ? InkWell(
                      onTap: onPay,
                      child: Container(
                        width: 102,
                        height: 46,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: CustomTheme.of(context).colors.positiveColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              orderResponse.paymentInfo.isPaymentFailed
                                  ? Icons.refresh
                                  : Icons.check_circle_outline,
                              color:
                                  CustomTheme.of(context).colors.positiveColor,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                orderResponse.paymentInfo.isPaymentFailed
                                    ? tr("screen_order.retry")
                                    : tr("screen_order.pay"),
                                style: CustomTheme.of(context)
                                    .textStyles
                                    .sectionHeading2
                                    .copyWith(
                                      color: CustomTheme.of(context)
                                          .colors
                                          .positiveColor,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
        ),
      ],
    );
  }
}
