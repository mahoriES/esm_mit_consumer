part of '../orders_card.dart';

class _SecondaryActionsRow extends StatelessWidget {
  final OrderStateData stateData;
  final Function(String) onCancel;
  final VoidCallback onReOrder;
  final VoidCallback goToOrderDetails;
  const _SecondaryActionsRow({
    @required this.stateData,
    @required this.onCancel,
    @required this.onReOrder,
    @required this.goToOrderDetails,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (stateData.isCancelOptionAvailable ||
            stateData.isReorderOptionAvailable) ...{
          Flexible(
            child: _SecondaryActionButton(
              prefixIcon: stateData.isCancelOptionAvailable
                  ? Icon(
                      Icons.clear,
                      color: CustomTheme.of(context).colors.secondaryColor,
                    )
                  : Icon(Icons.refresh),
              text: stateData.isCancelOptionAvailable
                  ? tr("screen_order.Cancel")
                  : tr("screen_order.reorder"),
              color: stateData.isCancelOptionAvailable
                  ? CustomTheme.of(context).colors.secondaryColor
                  : CustomTheme.of(context).colors.textColor,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => stateData.isCancelOptionAvailable
                      ? CancelOrderPrompt(onCancel)
                      : CustomConfirmationDialog(
                          title: tr("screen_order.repeat_order"),
                          // message:
                          //     "The order will be added to your cart. You can modify it or proceed with the same order.",
                          positiveAction: () {
                            Navigator.pop(context);
                            onReOrder();
                          },
                          positiveButtonText: tr("common.continue"),
                          negativeButtonText: tr("common.cancel"),
                        ),
                );
              },
            ),
          ),
        },
        Flexible(
          child: _SecondaryActionButton(
            alignment: (stateData.isCancelOptionAvailable ||
                    stateData.isReorderOptionAvailable)
                ? MainAxisAlignment.end
                : MainAxisAlignment.center,
            suffixIcon: Container(
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
            text: tr("screen_order.order_details"),
            color: CustomTheme.of(context).colors.primaryColor,
            onTap: goToOrderDetails,
          ),
        ),
      ],
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final String text;
  final Color color;
  final MainAxisAlignment alignment;
  const _SecondaryActionButton({
    @required this.onTap,
    @required this.text,
    this.prefixIcon,
    this.suffixIcon,
    this.color,
    this.alignment,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: alignment ?? MainAxisAlignment.start,
          children: [
            if (prefixIcon != null) ...[
              prefixIcon,
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: CustomTheme.of(context)
                  .textStyles
                  .sectionHeading2
                  .copyWith(
                    color: color ?? CustomTheme.of(context).colors.textColor,
                  ),
            ),
            if (suffixIcon != null) ...[
              const SizedBox(width: 8),
              suffixIcon,
            ],
          ],
        ),
      ),
    );
  }
}
