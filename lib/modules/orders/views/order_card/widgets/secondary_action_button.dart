import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/modules/orders/views/order_card/widgets/cancel_order_prompt.dart';
import 'package:eSamudaay/presentations/custom_confirmation_dialog.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:eSamudaay/utilities/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CancelOrderButton extends StatelessWidget {
  final Function(String) onCancel;
  const CancelOrderButton(this.onCancel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (context) => CancelOrderPrompt(onCancel),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.clear,
              color: CustomTheme.of(context).colors.secondaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              tr("screen_order.Cancel"),
              style:
                  CustomTheme.of(context).textStyles.sectionHeading2.copyWith(
                        color: CustomTheme.of(context).colors.secondaryColor,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReorderButton extends StatelessWidget {
  final VoidCallback onReorder;

  const ReorderButton(this.onReorder, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (context) => CustomConfirmationDialog(
          title: tr("screen_order.repeat_order"),
          // message:
          //     "The order will be added to your cart. You can modify it or proceed with the same order.",
          positiveAction: () {
            Navigator.pop(context);
            onReorder();
          },
          positiveButtonText: tr("common.continue"),
          negativeButtonText: tr("common.cancel"),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.refresh,
              color: CustomTheme.of(context).colors.textColor,
            ),
            const SizedBox(width: 8),
            Text(
              tr("screen_order.reorder"),
              style: CustomTheme.of(context).textStyles.sectionHeading2,
            ),
          ],
        ),
      ),
    );
  }
}

class PayButton extends StatelessWidget {
  final VoidCallback onPay;
  final PlaceOrderResponse orderResponse;

  const PayButton({
    @required this.onPay,
    @required this.orderResponse,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: orderResponse.paymentInfo.isPaymentDone ||
              orderResponse.paymentInfo.isPaymentInitiated
          ? null
          : onPay,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            orderResponse.paymentInfo.isPaymentDone ||
                    orderResponse.paymentInfo.isPaymentInitiated
                ? ImagePathConstants.paymentDoneIcon
                : ImagePathConstants.paymentPendingIcon,
            width: 50,
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: FittedBox(
              child: Text.rich(
                TextSpan(
                  text: "Payment " +
                      (orderResponse.paymentInfo.status == PaymentStatus.SUCCESS
                          ? "Done"
                          : "${orderResponse.paymentInfo.status.capitalize()}") +
                      "\n",
                  style: CustomTheme.of(context).textStyles.body2,
                  children: [
                    TextSpan(
                      text: "Pay " +
                          orderResponse.orderTotalPriceInRupees.withRupeePrefix,
                      style: CustomTheme.of(context).textStyles.sectionHeading2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailsButton extends StatelessWidget {
  final VoidCallback goToOrderDetails;
  const OrderDetailsButton(this.goToOrderDetails, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: goToOrderDetails,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tr("screen_order.order_details"),
              style: CustomTheme.of(context)
                  .textStyles
                  .sectionHeading2
                  .copyWith(color: CustomTheme.of(context).colors.primaryColor),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: CustomTheme.of(context).colors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chevron_right_outlined,
                size: 16,
                color: CustomTheme.of(context).colors.backgroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
