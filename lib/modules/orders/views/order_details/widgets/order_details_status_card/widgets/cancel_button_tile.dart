import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/views/widgets/secondary_action_button.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// This widget is shown under status card only if cancel option is available to user.
class OrderDetailsCancelButtonTile extends StatefulWidget {
  final Function(String) onCancel;
  final PlaceOrderResponse orderResponse;
  const OrderDetailsCancelButtonTile({
    @required this.onCancel,
    @required this.orderResponse,
    Key key,
  }) : super(key: key);

  @override
  _OrderDetailsCancelButtonTileState createState() =>
      _OrderDetailsCancelButtonTileState();
}

class _OrderDetailsCancelButtonTileState
    extends State<OrderDetailsCancelButtonTile> {
  bool showCancelButton;

  @override
  void initState() {
    showCancelButton = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!showCancelButton) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        Divider(
          color: CustomTheme.of(context).colors.dividerColor,
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  tr(
                    "screen_order.cancellation_message",
                    args: [
                      widget.orderResponse.cancellationAllowedForSeconds
                          .toString()
                    ],
                  ),
                  style: CustomTheme.of(context).textStyles.body2Faded,
                ),
              ),
              const SizedBox(width: 44),
              CancelOrderButton(
                onCancel: widget.onCancel,
                orderResponse: widget.orderResponse,
                onAnimationComplete: () {
                  setState(() {
                    showCancelButton = false;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
