import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/modules/orders/views/widgets/cancel_order_prompt.dart';
import 'package:eSamudaay/presentations/custom_confirmation_dialog.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:eSamudaay/utilities/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CancelOrderButton extends StatefulWidget {
  final Function(String) onCancel;
  final VoidCallback onSupport;
  final VoidCallback onPay;
  final bool canShowPaymentOption;
  final PlaceOrderResponse orderResponse;
  const CancelOrderButton({
    @required this.onCancel,
    @required this.onSupport,
    @required this.onPay,
    @required this.canShowPaymentOption,
    @required this.orderResponse,
    Key key,
  }) : super(key: key);

  @override
  _CancelOrderButtonState createState() => _CancelOrderButtonState();
}

class _CancelOrderButtonState extends State<CancelOrderButton>
    with SingleTickerProviderStateMixin {
  bool showCancelButton;
  AnimationController _animationController;
  Animation<double> animation;

  @override
  void initState() {
    showCancelButton =
        widget.orderResponse.orderCreationTimeDiffrenceInSeconds <
            OrderConstants.CancellationAllowedForSeconds;

    if (showCancelButton) {
      final int diff = widget.orderResponse.orderCreationTimeDiffrenceInSeconds;

      debugPrint("orderCreationTimeDiffrenceInSeconds => $diff");

      _animationController = new AnimationController(
        duration: Duration(
          seconds: OrderConstants.CancellationAllowedForSeconds - diff,
        ),
        vsync: this,
      );

      animation = Tween<double>(
        begin: (diff / OrderConstants.CancellationAllowedForSeconds).toDouble(),
        end: 1,
      ).animate(_animationController)
        ..addListener(() {
          if (_animationController.isCompleted) {
            _animationController.dispose();
            showCancelButton = false;
          }
          setState(() {
            // the state that has changed here is the animation object’s value
          });
        });

      _animationController.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!showCancelButton) {
      if (widget.orderResponse.paymentInfo.canPayBeforeAccept &&
          widget.canShowPaymentOption) {
        return PayButton(
          onPay: null,
          orderResponse: null,
        );
      } else {
        return SupportButton(() {});
      }
    }

    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (context) => CancelOrderPrompt(widget.onCancel),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                value: animation.value,
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(
                  CustomTheme.of(context).colors.warningColor,
                ),
                backgroundColor:
                    CustomTheme.of(context).colors.placeHolderColor,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              tr("screen_order.Cancel"),
              style: CustomTheme.of(context).textStyles.sectionHeading2,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          orderResponse.paymentInfo.isPaymentDone ||
                  orderResponse.paymentInfo.isPaymentInitiated
              ? Icon(
                  Icons.check_circle_outline,
                  size: 30,
                  color: CustomTheme.of(context).colors.positiveColor,
                )
              : Image.asset(
                  ImagePathConstants.paymentGreenIcon,
                  width: 35,
                  fit: BoxFit.contain,
                ),
          const SizedBox(width: 4),
          Flexible(
            child: FittedBox(
              child: Text.rich(
                TextSpan(
                  text:
                      tr("payment_statuses.${orderResponse.paymentInfo.status.toLowerCase()}") +
                          "\n",
                  style: CustomTheme.of(context).textStyles.body2Faded,
                  children: [
                    TextSpan(
                      text: tr(
                        orderResponse.paymentInfo.isPaymentDone ||
                                orderResponse.paymentInfo.isPaymentInitiated
                            ? "payment_statuses.paid_amout"
                            : "payment_statuses.pay_amount",
                        args: [
                          orderResponse.orderTotalPriceInRupees.withRupeePrefix
                        ],
                      ),
                      style: CustomTheme.of(context)
                          .textStyles
                          .sectionHeading2
                          .copyWith(
                            color: orderResponse.paymentInfo.isPaymentDone ||
                                    orderResponse.paymentInfo.isPaymentInitiated
                                ? CustomTheme.of(context).colors.textColor
                                : CustomTheme.of(context).colors.positiveColor,
                          ),
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
            Flexible(
              child: Text(
                tr("screen_order.order_details"),
                style: CustomTheme.of(context)
                    .textStyles
                    .sectionHeading2
                    .copyWith(
                        color: CustomTheme.of(context).colors.primaryColor),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}

class SupportButton extends StatelessWidget {
  final VoidCallback onSupport;
  const SupportButton(this.onSupport, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSupport,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.call,
              size: 30,
              color: CustomTheme.of(context).colors.secondaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              "support",
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
