import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';

// String constants for all possible state of any order.
class OrderState {
  static const CUSTOMER_PENDING = 'CUSTOMER_PENDING';
  static const CREATED = 'CREATED';
  static const MERCHANT_ACCEPTED = 'MERCHANT_ACCEPTED';
  static const MERCHANT_UPDATED = 'MERCHANT_UPDATED';
  static const MERCHANT_CANCELLED = 'MERCHANT_CANCELLED';
  static const CUSTOMER_CANCELLED = 'CUSTOMER_CANCELLED';
  // In case CP cancels the order on request of customer or merchant.
  static const PROVIDER_CANCELLED = 'PROVIDER_CANCELLED';
  static const READY_FOR_PICKUP = 'READY_FOR_PICKUP';
  static const REQUESTING_TO_DA = 'REQUESTING_TO_DA';
  static const ASSIGNED_TO_DA = 'ASSIGNED_TO_DA';
  static const PICKED_UP_BY_DA = 'PICKED_UP_BY_DA';
  static const COMPLETED = 'COMPLETED';
}

// Secondary Action varies according to order status.
//
// e.g. for cancelled/completed orders, it should be REORDER
// for pending orders, it should be CANCEL
// for processing orders, it should be PAY
enum SecondaryAction { CANCEL, REORDER, PAY, REJECT, NONE }

enum PaymentOptions { Razorpay, COD }

// String constants for all possible payment state of any order.
class PaymentStatus {
  static const PENDING = 'PENDING';
  static const SUCCESS = 'SUCCESS';
  static const FAIL = 'FAIL';
  static const REFUND_SUCCESS = 'REFUND_SUCCESS';
  static const REFUND_FAILED = 'REFUND_FAILED';

  //  Old Statuses:
  static const INITIATED = 'INITIATED';
  static const APPROVED = 'APPROVED';
  static const REJECTED = 'REJECTED';
}

class OrderConstants {
  static const CancellationAllowedForSeconds = 20;
}

enum OrderTapActions { GO_TO_ORDER_DETAILS, PAY, PAY_AND_CONFIRM }

class OrderStateData {
  final IconData icon;
  final Color actionButtonColor;
  final Color actionButtonTextColor;
  final String actionButtonText;
  final bool isActionButtonFilled;
  final SecondaryAction secondaryAction;
  // what all tags should be shown under progress bar.
  final List<String> stateProgressTagsList;
  // index of current/selected Tag from 'stateProgressTagsList'. the indicator above this tag would be highlighted.
  final int stateProgressBreakPoint;
  final Color stateProgressBreakPointColor;
  final Color stateProgressTagColor;
  final bool isOrderCompleted;
  final bool isOrderConfirmed;
  final bool isOrderCancelled;
  // in case when animation should stop before the actual breakPoint.
  // define animationBreakPoint as index where animation stops.
  final int animationBreakPoint;
  final bool showPaymentOption;
  final OrderTapActions orderTapAction;

  OrderStateData({
    @required this.icon,
    @required this.actionButtonColor,
    @required this.actionButtonTextColor,
    @required this.actionButtonText,
    @required this.isActionButtonFilled,
    @required this.secondaryAction,
    @required this.stateProgressTagsList,
    @required this.stateProgressBreakPoint,
    @required this.stateProgressBreakPointColor,
    @required this.stateProgressTagColor,
    this.isOrderCompleted = false,
    this.isOrderConfirmed = false,
    this.isOrderCancelled = false,
    this.animationBreakPoint,
    @required this.showPaymentOption,
    @required this.orderTapAction,
  });

  static OrderStateData getStateData({
    @required PlaceOrderResponse orderDetails,
    @required BuildContext context,
  }) {
    final bool canCancelOrder =
        orderDetails.orderCreationTimeDiffrenceInSeconds <
            OrderConstants.CancellationAllowedForSeconds;

    switch (orderDetails.orderStatus) {
      case OrderState.CUSTOMER_PENDING:
        return _pendingPaymentState(context);
      case OrderState.CREATED:
        // If payment is already done, then pending merchant confirmation state should not be visible to customer.
        // instead it should show processing order state.
        if (orderDetails.paymentInfo.isPaymentDone) {
          return _processingOrderState(
            context,
            canCancelOrder: canCancelOrder,
          );
        } else {
          return _pendigConfirmationState(
            context,
            canCancelOrder: canCancelOrder,
            // show payment option if 'canPayBeforeAccept' is true and the order does not contain list items.
            // or if payment is already done, show payment details.
            showPaymentOption: (orderDetails.paymentInfo.canPayBeforeAccept &&
                    orderDetails.customerNoteImages.isEmpty) ||
                orderDetails.paymentInfo.isPaymentDone,
          );
        }
        break;

      case OrderState.MERCHANT_ACCEPTED:
      case OrderState.REQUESTING_TO_DA:
      case OrderState.ASSIGNED_TO_DA:
        // If merchant started processing the order, cancel option should not be shown.
        return _processingOrderState(
          context,
          canCancelOrder: false,
        );

      case OrderState.MERCHANT_UPDATED:
        return _confirmAndPayState(
          context,
          payBeforeOrder: orderDetails.paymentInfo.payBeforeOrder,
        );

      case OrderState.MERCHANT_CANCELLED:
      case OrderState.PROVIDER_CANCELLED:
        return _orderDeclinedState(
          context,
          showPaymentInfo:
              orderDetails.paymentInfo.status == PaymentStatus.REFUND_SUCCESS,
        );

      case OrderState.CUSTOMER_CANCELLED:
        return _orderCancelledState(
          context,
          showPaymentInfo:
              orderDetails.paymentInfo.status == PaymentStatus.REFUND_SUCCESS,
        );

      case OrderState.READY_FOR_PICKUP:
        return _readyForPickupState(
          context,
          deliveryType: orderDetails.deliveryType,
        );

      case OrderState.PICKED_UP_BY_DA:
        return _outForDeliveryState(context);

      case OrderState.COMPLETED:
        return _completedState(context);

      default:
        return null;
    }
  }

  static OrderStateData _pendigConfirmationState(
    BuildContext context, {
    @required bool canCancelOrder,
    @required bool showPaymentOption,
  }) {
    return OrderStateData(
      actionButtonColor:
          CustomTheme.of(context).colors.warningColor.withOpacity(0.2),
      actionButtonTextColor: CustomTheme.of(context).colors.warningColor,
      icon: Icons.watch_later_outlined,
      actionButtonText: "screen_order_status.pending",
      isActionButtonFilled: true,
      secondaryAction: canCancelOrder
          ? SecondaryAction.CANCEL
          : showPaymentOption
              ? SecondaryAction.PAY
              : SecondaryAction.NONE,
      stateProgressTagsList: [
        "screen_order_status.request_sent",
        "screen_order_status.pending",
        "screen_order_status.processing",
        "screen_order_status.completed",
      ],
      stateProgressBreakPoint: 1,
      stateProgressBreakPointColor: CustomTheme.of(context).colors.warningColor,
      stateProgressTagColor: CustomTheme.of(context).colors.textColor,
      showPaymentOption: showPaymentOption,
      orderTapAction: OrderTapActions.GO_TO_ORDER_DETAILS,
    );
  }

  static OrderStateData _confirmAndPayState(
    BuildContext context, {
    @required bool payBeforeOrder,
  }) {
    return OrderStateData(
      actionButtonColor: CustomTheme.of(context).colors.positiveColor,
      actionButtonTextColor: CustomTheme.of(context).colors.backgroundColor,
      icon: Icons.check_circle_outline,
      actionButtonText: payBeforeOrder
          ? "screen_order_status.pay_and_confirm_order"
          : "screen_order_status.confirm_order",
      isActionButtonFilled: true,
      secondaryAction: SecondaryAction.REJECT,
      stateProgressTagsList: [
        "screen_order_status.request_sent",
        "screen_order_status.merchant_updated",
        "screen_order_status.confirm_order",
        "screen_order_status.completed",
      ],
      stateProgressBreakPoint: 2,
      stateProgressBreakPointColor:
          CustomTheme.of(context).colors.backgroundColor,
      stateProgressTagColor: CustomTheme.of(context).colors.textColor,
      showPaymentOption: false,
      orderTapAction: OrderTapActions.PAY_AND_CONFIRM,
    );
  }

  static OrderStateData _processingOrderState(
    BuildContext context, {
    @required bool canCancelOrder,
  }) {
    return OrderStateData(
      actionButtonColor:
          CustomTheme.of(context).colors.warningColor.withOpacity(0.2),
      actionButtonTextColor: CustomTheme.of(context).colors.warningColor,
      icon: Icons.watch_later_outlined,
      actionButtonText: "screen_order_status.processing",
      isActionButtonFilled: false,
      secondaryAction:
          canCancelOrder ? SecondaryAction.CANCEL : SecondaryAction.PAY,
      isOrderConfirmed: true,
      stateProgressTagsList: [
        "screen_order_status.request_sent",
        // "screen_order_status.pending",
        "screen_order_status.order_confirmed",
        "screen_order_status.processing",
      ],
      stateProgressBreakPoint: 2,
      animationBreakPoint: 1,
      showPaymentOption: true,
      stateProgressBreakPointColor: CustomTheme.of(context).colors.warningColor,
      stateProgressTagColor: CustomTheme.of(context).colors.warningColor,
      orderTapAction: OrderTapActions.GO_TO_ORDER_DETAILS,
    );
  }

  static OrderStateData _orderDeclinedState(
    BuildContext context, {
    @required bool showPaymentInfo,
  }) {
    return OrderStateData(
      actionButtonColor:
          CustomTheme.of(context).colors.secondaryColor.withOpacity(0.2),
      actionButtonTextColor: CustomTheme.of(context).colors.secondaryColor,
      icon: Icons.cancel_outlined,
      actionButtonText: "screen_order_status.declined",
      isActionButtonFilled: false,
      secondaryAction: SecondaryAction.REORDER,
      stateProgressTagsList: [
        "screen_order_status.request_sent",
        "screen_order_status.declined",
      ],
      stateProgressBreakPoint: 1,
      stateProgressBreakPointColor:
          CustomTheme.of(context).colors.secondaryColor,
      stateProgressTagColor: CustomTheme.of(context).colors.secondaryColor,
      isOrderCancelled: true,
      orderTapAction: OrderTapActions.GO_TO_ORDER_DETAILS,
      showPaymentOption: showPaymentInfo,
    );
  }

  static OrderStateData _orderCancelledState(
    BuildContext context, {
    @required bool showPaymentInfo,
  }) {
    return OrderStateData(
      actionButtonColor:
          CustomTheme.of(context).colors.secondaryColor.withOpacity(0.2),
      actionButtonTextColor: CustomTheme.of(context).colors.secondaryColor,
      icon: Icons.cancel_outlined,
      actionButtonText: "screen_order_status.cancelled",
      isActionButtonFilled: false,
      secondaryAction: SecondaryAction.REORDER,
      stateProgressTagsList: [
        "screen_order_status.request_sent",
        "screen_order_status.pending",
        "screen_order_status.cancelled",
      ],
      stateProgressBreakPoint: 2,
      stateProgressBreakPointColor:
          CustomTheme.of(context).colors.secondaryColor,
      stateProgressTagColor: CustomTheme.of(context).colors.secondaryColor,
      isOrderCancelled: true,
      orderTapAction: OrderTapActions.GO_TO_ORDER_DETAILS,
      showPaymentOption: showPaymentInfo,
    );
  }

  static OrderStateData _readyForPickupState(
    BuildContext context, {
    @required String deliveryType,
  }) {
    return OrderStateData(
      actionButtonColor:
          CustomTheme.of(context).colors.warningColor.withOpacity(0.2),
      actionButtonTextColor: CustomTheme.of(context).colors.warningColor,
      icon: Icons.store_sharp,
      actionButtonText: deliveryType == DeliveryType.DeliveryToHome
          ? "screen_order_status.processing"
          : "screen_order_status.pickup",
      isActionButtonFilled: false,
      secondaryAction: SecondaryAction.PAY,
      stateProgressTagsList: [
        "screen_order_status.request_sent",
        "screen_order_status.pending",
        "screen_order_status.order_confirmed",
        "screen_order_status.pickup",
      ],
      stateProgressBreakPoint: 3,
      stateProgressBreakPointColor: CustomTheme.of(context).colors.warningColor,
      stateProgressTagColor: CustomTheme.of(context).colors.warningColor,
      isOrderConfirmed: true,
      orderTapAction: OrderTapActions.GO_TO_ORDER_DETAILS,
      showPaymentOption: true,
    );
  }

  static OrderStateData _outForDeliveryState(BuildContext context) {
    return OrderStateData(
      actionButtonColor:
          CustomTheme.of(context).colors.positiveColor.withOpacity(0.2),
      actionButtonTextColor: CustomTheme.of(context).colors.positiveColor,
      icon: Icons.directions_bike,
      actionButtonText: "screen_order_status.delivery",
      isActionButtonFilled: false,
      secondaryAction: SecondaryAction.PAY,
      stateProgressTagsList: [
        "screen_order_status.request_sent",
        "screen_order_status.pending",
        "screen_order_status.order_confirmed",
        "screen_order_status.delivery",
      ],
      stateProgressBreakPoint: 3,
      stateProgressBreakPointColor:
          CustomTheme.of(context).colors.backgroundColor,
      stateProgressTagColor: CustomTheme.of(context).colors.positiveColor,
      isOrderConfirmed: true,
      orderTapAction: OrderTapActions.GO_TO_ORDER_DETAILS,
      showPaymentOption: true,
    );
  }

  static OrderStateData _completedState(BuildContext context) {
    return OrderStateData(
      actionButtonColor:
          CustomTheme.of(context).colors.positiveColor.withOpacity(0.2),
      actionButtonTextColor: CustomTheme.of(context).colors.positiveColor,
      icon: Icons.check_circle,
      actionButtonText: "screen_order_status.completed",
      isActionButtonFilled: false,
      secondaryAction: SecondaryAction.REORDER,
      stateProgressTagsList: [
        "screen_order_status.request_sent",
        "screen_order_status.pending",
        "screen_order_status.order_confirmed",
        "screen_order_status.completed",
      ],
      stateProgressBreakPoint: 3,
      stateProgressBreakPointColor:
          CustomTheme.of(context).colors.positiveColor,
      stateProgressTagColor: CustomTheme.of(context).colors.textColor,
      isOrderCompleted: true,
      isOrderConfirmed: true,
      orderTapAction: OrderTapActions.GO_TO_ORDER_DETAILS,
      showPaymentOption: true,
    );
  }

  static OrderStateData _pendingPaymentState(BuildContext context) {
    return OrderStateData(
      actionButtonColor: CustomTheme.of(context).colors.positiveColor,
      actionButtonTextColor: CustomTheme.of(context).colors.backgroundColor,
      icon: Icons.check_circle_outline,
      actionButtonText: "Pay  {amount}",
      isActionButtonFilled: true,
      secondaryAction: SecondaryAction.NONE,
      stateProgressTagsList: [""],
      stateProgressBreakPoint: 0,
      stateProgressBreakPointColor:
          CustomTheme.of(context).colors.secondaryColor,
      stateProgressTagColor: CustomTheme.of(context).colors.secondaryColor,
      showPaymentOption: false,
      orderTapAction: OrderTapActions.PAY,
    );
  }
}
