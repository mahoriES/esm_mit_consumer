import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
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
                text: "Payment Details\n",
                style: CustomTheme.of(context).textStyles.body2,
                children: [
                  TextSpan(
                    text: (orderResponse.paymentInfo.status ==
                                    PaymentStatus.SUCCESS ||
                                orderResponse.paymentInfo.status ==
                                    PaymentStatus.APPROVED
                            ? "Paid"
                            : "${orderResponse.paymentInfo.status.toCamelCase()}") +
                        "\t" +
                        "${orderResponse.orderTotalPriceInRupees.withRupeePrefix}",
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
                          text: "Payment Method\n",
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
                      orderResponse.paymentInfo.isPaymentPending
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
                                    ? "Retry"
                                    : "Pay",
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
