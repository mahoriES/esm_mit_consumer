import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DeliveryStatusWidget extends StatelessWidget {
  final bool deliveryStatus;

  ///If the shop is closed we don't show the delivery status rather just let the
  ///know user know about the same.
  ///This is an optional field and if it is true.. It ignores the [deliveryStatus]
  ///and the closed status is shown instead
  final bool isClosed;

  const DeliveryStatusWidget(
      {Key key, @required this.deliveryStatus, this.isClosed=false})
      : assert(deliveryStatus != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color orange = CustomTheme.of(context).colors.storeCoreColor;
    final Color green = CustomTheme.of(context).colors.positiveColor;
    final Color closedColor = CustomTheme.of(context).colors.storeInfoColor;
    return Material(
      type: MaterialType.transparency,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isClosed
              ? ImageIcon(
                  AssetImage(ImagePathConstants.closedStoreIcon),
                  color: closedColor,
                )
              : deliveryStatus
                  ? ImageIcon(
                      AssetImage(ImagePathConstants.deliveryAvailableIcon),
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
          Text(
                  isClosed
                      ? "common.closed"
                      : deliveryStatus
                          ? "shop.delivery_ok"
                          : "shop.delivery_no",
                  style: CustomTheme.of(context).textStyles.body1.copyWith(
                      color: isClosed
                          ? closedColor
                          : deliveryStatus
                              ? green
                              : orange),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left)
              .tr(),
        ],
      ),
    );
  }
}
