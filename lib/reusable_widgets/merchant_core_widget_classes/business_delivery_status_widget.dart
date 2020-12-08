import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DeliveryStatusWidget extends StatefulWidget {
  final bool deliveryStatus;

  const DeliveryStatusWidget({Key key, @required this.deliveryStatus})
      : assert(deliveryStatus != null),
        super(key: key);

  @override
  _DeliveryStatusWidgetState createState() => _DeliveryStatusWidgetState();
}

class _DeliveryStatusWidgetState extends State<DeliveryStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.deliveryStatus
              ? ImageIcon(
                  AssetImage('assets/images/delivery.png'),
                  color: green,
                )
              : Icon(
                  Icons.store,
                  color: orange,
                ),
          const SizedBox(
            width: 3,
          ),
          Text(widget.deliveryStatus ? "shop.delivery_ok" : "shop.delivery_no",
                  style: CustomTheme.of(context)
                      .textStyles
                      .body1
                      .copyWith(color: widget.deliveryStatus ? green : orange),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left)
              .tr(),
        ],
      ),
    );
  }

  Color get green => CustomTheme.of(context).colors.positiveGreen;

  Color get orange => CustomTheme.of(context).colors.brandOrange;
}
