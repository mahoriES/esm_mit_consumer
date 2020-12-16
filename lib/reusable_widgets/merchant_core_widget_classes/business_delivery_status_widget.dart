import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DeliveryStatusWidget extends StatelessWidget {
  final bool deliveryStatus;

  const DeliveryStatusWidget({Key key, @required this.deliveryStatus})
      : assert(deliveryStatus != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color orange = CustomTheme.of(context).colors.storeCoreColor;
    final Color green = CustomTheme.of(context).colors.positiveColor;
    return Material(
      type: MaterialType.transparency,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          deliveryStatus
              ? ImageIcon(
                  AssetImage('assets/images/delivery.png'),
                  color: green,
                )
              : Icon(
                  Icons.store_rounded,
                  color: orange,
                  size: 20,
                ),
          const SizedBox(
            width: 3,
          ),
          Text(deliveryStatus ? "shop.delivery_ok" : "shop.delivery_no",
                  style: CustomTheme.of(context)
                      .textStyles
                      .body1
                      .copyWith(color: deliveryStatus ? green : orange),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left)
              .tr(),
        ],
      ),
    );
  }
}
