import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/reusable_widgets/payment_options_widget.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/extensions.dart';

class OrderActionButton extends StatelessWidget {
  final PlaceOrderResponse orderResponse;
  final VoidCallback confirmOrder;
  final VoidCallback goToOrderDetails;
  final bool isOrderDetailsView;

  const OrderActionButton({
    @required this.orderResponse,
    @required this.confirmOrder,
    @required this.goToOrderDetails,
    @required this.isOrderDetailsView,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderStateData stateData = OrderStateData.getStateData(
      orderDetails: orderResponse,
      context: context,
    );

    return ActionButton(
      text: tr(
        stateData.actionButtonText,
        args: [" "],
        namedArgs: {
          "amount": orderResponse.itemTotalPriceInRupees.withRupeePrefix
        },
      ),
      onTap: () {
        switch (stateData.orderTapAction) {
          case OrderTapActions.PAY:
            showPaymentBottomSheet(
              context,
              onSuccess: null,
            );
            break;

          case OrderTapActions.PAY_AND_CONFIRM:
            if (orderResponse.paymentInfo.payBeforeOrder &&
                !orderResponse.paymentInfo.isPaymentDone) {
              showPaymentBottomSheet(
                context,
                onSuccess: confirmOrder,
              );
            } else {
              confirmOrder();
            }
            break;

          case OrderTapActions.GO_TO_ORDER_DETAILS:
            if (!isOrderDetailsView) goToOrderDetails();
            break;
        }
      },
      icon: stateData.icon,
      isFilled: isOrderDetailsView ? true : stateData.isActionButtonFilled,
      textColor: stateData.actionButtonTextColor,
      buttonColor: stateData.actionButtonColor,
      showBorder: false,
      textStyle: CustomTheme.of(context).textStyles.sectionHeading3,
    );
  }

  showPaymentBottomSheet(BuildContext context, {VoidCallback onSuccess}) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => PaymentOptionsWidget(
        showBackOption: true,
        orderDetails: orderResponse,
        onPaymentSuccess: onSuccess,
      ),
    );
  }
}
