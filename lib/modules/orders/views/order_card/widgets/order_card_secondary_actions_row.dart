import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/modules/orders/views/widgets/secondary_action_button.dart';
import 'package:eSamudaay/reusable_widgets/payment_options_widget.dart';
import 'package:flutter/material.dart';

class OrderCardSecondaryButtonsRow extends StatefulWidget {
  final PlaceOrderResponse orderResponse;
  final Function(String) onCancel;
  final Function() onReorder;
  final Function() goToOrderDetails;
  OrderCardSecondaryButtonsRow({
    this.orderResponse,
    this.onCancel,
    this.onReorder,
    this.goToOrderDetails,
    Key key,
  }) : super(key: key);

  @override
  _OrderCardSecondaryButtonsRowState createState() =>
      _OrderCardSecondaryButtonsRowState();
}

class _OrderCardSecondaryButtonsRowState
    extends State<OrderCardSecondaryButtonsRow> {
  @override
  Widget build(BuildContext context) {
    final OrderStateData stateData = OrderStateData.getStateData(
      orderDetails: widget.orderResponse,
      context: context,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (stateData.secondaryAction != SecondaryAction.NONE) ...[
          Flexible(
            child: stateData.secondaryAction == SecondaryAction.CANCEL
                ? CancelOrderButton(
                    onCancel: widget.onCancel,
                    orderResponse: widget.orderResponse,
                    onAnimationComplete: () => setState(() {}),
                  )
                : stateData.secondaryAction == SecondaryAction.REJECT
                    ? RejectOrderButton(widget.onCancel)
                    : stateData.secondaryAction == SecondaryAction.REORDER
                        ? ReorderButton(widget.onReorder)
                        : stateData.secondaryAction == SecondaryAction.PAY
                            ? PayButton(
                                onPay: () => showModalBottomSheet(
                                  context: context,
                                  isDismissible: false,
                                  enableDrag: false,
                                  builder: (context) => PaymentOptionsWidget(
                                    showBackOption: true,
                                    orderDetails: widget.orderResponse,
                                    onPaymentSuccess: () {},
                                  ),
                                ),
                                orderResponse: widget.orderResponse,
                              )
                            : SizedBox.shrink(),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: OrderDetailsButton(
            widget.goToOrderDetails,
            // If no Secondary Action is available , then order details button should be aligned in center.
            isCenterAligned: stateData.secondaryAction == SecondaryAction.NONE,
          ),
        ),
      ],
    );
  }
}
