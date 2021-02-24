import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/modules/orders/views/widgets/secondary_action_button.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';

class OrderDetailsCancelButtonTile extends StatefulWidget {
  final Function(String) onCancel;
  final int orderCreationTimeDiffrenceInSeconds;
  const OrderDetailsCancelButtonTile({
    @required this.onCancel,
    @required this.orderCreationTimeDiffrenceInSeconds,
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
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  "You can only cancel within ${OrderConstants.CancellationAllowedForSeconds}sec of placing the order",
                  style: CustomTheme.of(context).textStyles.body2Faded,
                ),
              ),
              const SizedBox(width: 44),
              CancelOrderButton(
                onCancel: widget.onCancel,
                orderCreationTimeDiffrenceInSeconds:
                    widget.orderCreationTimeDiffrenceInSeconds,
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
