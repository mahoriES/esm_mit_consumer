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
enum SecondaryAction { CANCEL, REORDER, PAY, NONE }

enum PaymentOptions { Razorpay, COD }

// String constants for all possible payment state of any order.
class PaymentStatus {
  static const PENDING = 'PENDING';
  static const SUCCESS = 'SUCCESS';
  static const FAIL = 'FAIL';
  static const REFUNDED = 'REFUNDED';

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
    this.showPaymentOption = true,
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
        return _pendigPaymentState(canCancelOrder, context);
      case OrderState.CREATED:
        return _pendigConfirmationState(
          context,
          orderDetails.paymentInfo.canPayBeforeAccept,
          canCancelOrder,
          orderDetails.paymentInfo.isPaymentDone,
        );

      case OrderState.MERCHANT_ACCEPTED:
      case OrderState.REQUESTING_TO_DA:
      case OrderState.ASSIGNED_TO_DA:
        return _processingOrderState(context);

      case OrderState.MERCHANT_UPDATED:
        return _confirmAndPayState(context);

      case OrderState.MERCHANT_CANCELLED:
        return _orderDeclinedState(context);

      case OrderState.CUSTOMER_CANCELLED:
        return _orderCancelledState(context);

      case OrderState.READY_FOR_PICKUP:
        return _readyForPickupState(context, orderDetails.deliveryType);

      case OrderState.PICKED_UP_BY_DA:
        return _outForDeliveryState(context);

      case OrderState.COMPLETED:
        return _completedState(context);

      default:
        return null;
    }
  }

  static OrderStateData _pendigPaymentState(
    bool canCancelOrder,
    BuildContext context,
  ) {
    return OrderStateData(
      actionButtonColor: CustomTheme.of(context).colors.positiveColor,
      actionButtonTextColor: CustomTheme.of(context).colors.backgroundColor,
      icon: Icons.check_circle_outline,
      actionButtonText: "Pay  {amount}",
      isActionButtonFilled: true,
      secondaryAction:
          canCancelOrder ? SecondaryAction.CANCEL : SecondaryAction.NONE,
      stateProgressTagsList: [
        "screen_order_status.payment_pending",
        "screen_order_status.pending",
        "screen_order_status.confirm",
        "screen_order_status.completed",
      ],
      stateProgressBreakPoint: 0,
      stateProgressBreakPointColor: CustomTheme.of(context).colors.warningColor,
      stateProgressTagColor: CustomTheme.of(context).colors.textColor,
      showPaymentOption: false,
      orderTapAction: OrderTapActions.PAY,
    );
  }

  static OrderStateData _pendigConfirmationState(
    BuildContext context,
    bool canPayBeforeAccept,
    bool canCancelOrder,
    bool isPaymentDone,
  ) {
    return OrderStateData(
      actionButtonColor:
          CustomTheme.of(context).colors.warningColor.withOpacity(0.2),
      actionButtonTextColor: CustomTheme.of(context).colors.warningColor,
      icon: Icons.watch_later_outlined,
      actionButtonText: "screen_order_status.pending",
      isActionButtonFilled: true,
      secondaryAction: canCancelOrder
          ? SecondaryAction.CANCEL
          : canPayBeforeAccept || isPaymentDone
              ? SecondaryAction.PAY
              : SecondaryAction.NONE,
      stateProgressTagsList: [
        "screen_order_status.request_sent",
        "screen_order_status.pending",
        "screen_order_status.confirm",
        "screen_order_status.completed",
      ],
      stateProgressBreakPoint: 1,
      stateProgressBreakPointColor: CustomTheme.of(context).colors.warningColor,
      stateProgressTagColor: CustomTheme.of(context).colors.textColor,
      showPaymentOption: canPayBeforeAccept,
      orderTapAction: OrderTapActions.GO_TO_ORDER_DETAILS,
    );
  }

  static OrderStateData _confirmAndPayState(BuildContext context) {
    return OrderStateData(
      actionButtonColor: CustomTheme.of(context).colors.positiveColor,
      actionButtonTextColor: CustomTheme.of(context).colors.backgroundColor,
      icon: Icons.check_circle_outline,
      actionButtonText: "screen_order_status.confirm_order",
      isActionButtonFilled: true,
      secondaryAction: SecondaryAction.NONE,
      stateProgressTagsList: [
        "screen_order_status.request_sent",
        "screen_order_status.pending",
        "screen_order_status.confirm",
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

  static OrderStateData _processingOrderState(BuildContext context) {
    return OrderStateData(
      actionButtonColor:
          CustomTheme.of(context).colors.warningColor.withOpacity(0.2),
      actionButtonTextColor: CustomTheme.of(context).colors.warningColor,
      icon: Icons.watch_later_outlined,
      actionButtonText: "screen_order_status.processing",
      isActionButtonFilled: false,
      secondaryAction: SecondaryAction.PAY,
      isOrderConfirmed: true,
      stateProgressTagsList: [
        "screen_order_status.request_sent",
        "screen_order_status.pending",
        "screen_order_status.confirm",
        "screen_order_status.processing",
      ],
      stateProgressBreakPoint: 3,
      animationBreakPoint: 2,
      stateProgressBreakPointColor: CustomTheme.of(context).colors.warningColor,
      stateProgressTagColor: CustomTheme.of(context).colors.warningColor,
      orderTapAction: OrderTapActions.GO_TO_ORDER_DETAILS,
    );
  }

  static OrderStateData _orderDeclinedState(BuildContext context) {
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
    );
  }

  static OrderStateData _orderCancelledState(BuildContext context) {
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
    );
  }

  static OrderStateData _readyForPickupState(
      BuildContext context, String deliveryType) {
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
        "screen_order_status.confirm",
        "screen_order_status.pickup",
      ],
      stateProgressBreakPoint: 3,
      stateProgressBreakPointColor: CustomTheme.of(context).colors.warningColor,
      stateProgressTagColor: CustomTheme.of(context).colors.warningColor,
      isOrderConfirmed: true,
      orderTapAction: OrderTapActions.GO_TO_ORDER_DETAILS,
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
        "screen_order_status.confirm",
        "screen_order_status.delivery",
      ],
      stateProgressBreakPoint: 3,
      stateProgressBreakPointColor:
          CustomTheme.of(context).colors.backgroundColor,
      stateProgressTagColor: CustomTheme.of(context).colors.positiveColor,
      isOrderConfirmed: true,
      orderTapAction: OrderTapActions.GO_TO_ORDER_DETAILS,
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
        "screen_order_status.confirm",
        "screen_order_status.completed",
      ],
      stateProgressBreakPoint: 3,
      stateProgressBreakPointColor:
          CustomTheme.of(context).colors.positiveColor,
      stateProgressTagColor: CustomTheme.of(context).colors.textColor,
      isOrderCompleted: true,
      isOrderConfirmed: true,
      orderTapAction: OrderTapActions.GO_TO_ORDER_DETAILS,
    );
  }
}
