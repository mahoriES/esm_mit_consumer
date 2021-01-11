import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';

class OrderState {
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

class OrderStateData {
  final IconData icon;
  final Color actionButtonColor;
  final Color actionButtonTextColor;
  final String actionButtonText;
  final bool isActionButtonFilled;
  final bool isCancelOptionAvailable;
  final bool isReorderOptionAvailable;
  final List<String> stateProgressTagsList;
  final int stateProgressBreakPoint;
  final Color stateProgressBreakPointColor;
  final Color stateProgressTagColor;
  final bool isOrderCompleted;
  final bool isOrderConfirmed;
  final bool isOrderCancelled;
  final int animationBreakPoint;

  OrderStateData({
    @required this.icon,
    @required this.actionButtonColor,
    @required this.actionButtonTextColor,
    @required this.actionButtonText,
    @required this.isActionButtonFilled,
    @required this.isCancelOptionAvailable,
    @required this.isReorderOptionAvailable,
    @required this.stateProgressTagsList,
    @required this.stateProgressBreakPoint,
    @required this.stateProgressBreakPointColor,
    @required this.stateProgressTagColor,
    this.isOrderCompleted = false,
    this.isOrderConfirmed = false,
    this.isOrderCancelled = false,
    this.animationBreakPoint,
  });

  static OrderStateData getStateData(String state, BuildContext context) {
    OrderStateData _stateData;
    switch (state) {
      case OrderState.CREATED:
        _stateData = _pendigConfirmationState(context);
        break;
      case OrderState.MERCHANT_ACCEPTED:
      case OrderState.REQUESTING_TO_DA:
      case OrderState.ASSIGNED_TO_DA:
        _stateData = _processingOrderState(context);

        break;
      case OrderState.MERCHANT_UPDATED:
        _stateData = _confirmAndPayState(context);
        break;
      case OrderState.MERCHANT_CANCELLED:
        _stateData = _orderDeclinedState(context);
        break;
      case OrderState.CUSTOMER_CANCELLED:
        _stateData = _orderCancelledState(context);
        break;
      case OrderState.READY_FOR_PICKUP:
        _stateData = _readyForPickupState(context);
        break;
      case OrderState.PICKED_UP_BY_DA:
        _stateData = _outForDeliveryState(context);
        break;
      case OrderState.COMPLETED:
        _stateData = _completedState(context);
        break;
      default:
    }

    return _stateData;
  }

  static OrderStateData _pendigConfirmationState(BuildContext context) {
    return OrderStateData(
      actionButtonColor:
          CustomTheme.of(context).colors.warningColor.withOpacity(0.2),
      actionButtonTextColor: CustomTheme.of(context).colors.warningColor,
      icon: Icons.watch_later_outlined,
      actionButtonText: "Pending Confirmation",
      isActionButtonFilled: true,
      isCancelOptionAvailable: true,
      isReorderOptionAvailable: false,
      stateProgressTagsList: [
        "Request\nsent",
        "Pending\nConfirmation",
        "Confirm\nand Pay",
        "Order\nFulfilled",
      ],
      stateProgressBreakPoint: 1,
      stateProgressBreakPointColor: CustomTheme.of(context).colors.warningColor,
      stateProgressTagColor: CustomTheme.of(context).colors.textColor,
    );
  }

  static OrderStateData _confirmAndPayState(BuildContext context) {
    return OrderStateData(
      actionButtonColor: CustomTheme.of(context).colors.positiveColor,
      actionButtonTextColor: CustomTheme.of(context).colors.backgroundColor,
      icon: Icons.check_outlined,
      actionButtonText: "Confirm and Pay",
      isActionButtonFilled: true,
      isCancelOptionAvailable: true,
      isReorderOptionAvailable: false,
      stateProgressTagsList: [
        "Request\nsent",
        "Pending\nConfirmation",
        "Confirm\nand Pay",
        "Order\nFulfilled",
      ],
      stateProgressBreakPoint: 2,
      stateProgressBreakPointColor:
          CustomTheme.of(context).colors.backgroundColor,
      stateProgressTagColor: CustomTheme.of(context).colors.textColor,
    );
  }

  static OrderStateData _processingOrderState(BuildContext context) {
    return OrderStateData(
      actionButtonColor:
          CustomTheme.of(context).colors.warningColor.withOpacity(0.2),
      actionButtonTextColor: CustomTheme.of(context).colors.warningColor,
      icon: Icons.watch_later_outlined,
      actionButtonText: "Processing Order",
      isActionButtonFilled: false,
      isCancelOptionAvailable: false,
      isReorderOptionAvailable: false,
      isOrderConfirmed: true,
      stateProgressTagsList: [
        "Request\nsent",
        "Pending\nConfirmation",
        "Confirm\nand Pay",
        "Processing\nOrder",
      ],
      stateProgressBreakPoint: 3,
      animationBreakPoint: 2,
      stateProgressBreakPointColor: CustomTheme.of(context).colors.warningColor,
      stateProgressTagColor: CustomTheme.of(context).colors.warningColor,
    );
  }

  static OrderStateData _orderDeclinedState(BuildContext context) {
    return OrderStateData(
      actionButtonColor:
          CustomTheme.of(context).colors.secondaryColor.withOpacity(0.2),
      actionButtonTextColor: CustomTheme.of(context).colors.secondaryColor,
      icon: Icons.cancel_outlined,
      actionButtonText: "Order Declined",
      isActionButtonFilled: false,
      isCancelOptionAvailable: false,
      isReorderOptionAvailable: true,
      stateProgressTagsList: [
        "Request\nsent",
        "Order\nDeclined",
      ],
      stateProgressBreakPoint: 1,
      stateProgressBreakPointColor:
          CustomTheme.of(context).colors.secondaryColor,
      stateProgressTagColor: CustomTheme.of(context).colors.secondaryColor,
      isOrderCancelled: true,
    );
  }

  static OrderStateData _orderCancelledState(BuildContext context) {
    return OrderStateData(
      actionButtonColor:
          CustomTheme.of(context).colors.secondaryColor.withOpacity(0.2),
      actionButtonTextColor: CustomTheme.of(context).colors.secondaryColor,
      icon: Icons.cancel_outlined,
      actionButtonText: "Order Cancelled",
      isActionButtonFilled: false,
      isCancelOptionAvailable: false,
      isReorderOptionAvailable: true,
      stateProgressTagsList: [
        "Request\nsent",
        "Pending\nConfirmation",
        "Order\nCancelled",
      ],
      stateProgressBreakPoint: 2,
      stateProgressBreakPointColor:
          CustomTheme.of(context).colors.secondaryColor,
      stateProgressTagColor: CustomTheme.of(context).colors.secondaryColor,
      isOrderCancelled: true,
    );
  }

  static OrderStateData _readyForPickupState(BuildContext context) {
    return OrderStateData(
      actionButtonColor:
          CustomTheme.of(context).colors.warningColor.withOpacity(0.2),
      actionButtonTextColor: CustomTheme.of(context).colors.warningColor,
      icon: Icons.store_sharp,
      actionButtonText: "Pick-up at store",
      isActionButtonFilled: false,
      isCancelOptionAvailable: false,
      isReorderOptionAvailable: false,
      stateProgressTagsList: [
        "Request\nsent",
        "Pending\nConfirmation",
        "Confirm\nand Pay",
        "Pickup\nat store",
      ],
      stateProgressBreakPoint: 3,
      stateProgressBreakPointColor: CustomTheme.of(context).colors.warningColor,
      stateProgressTagColor: CustomTheme.of(context).colors.warningColor,
      isOrderConfirmed: true,
    );
  }

  static OrderStateData _outForDeliveryState(BuildContext context) {
    return OrderStateData(
      actionButtonColor:
          CustomTheme.of(context).colors.positiveColor.withOpacity(0.2),
      actionButtonTextColor: CustomTheme.of(context).colors.positiveColor,
      icon: Icons.directions_bike,
      actionButtonText: "Out For Delivery",
      isActionButtonFilled: false,
      isCancelOptionAvailable: false,
      isReorderOptionAvailable: false,
      stateProgressTagsList: [
        "Request\nsent",
        "Pending\nConfirmation",
        "Confirm\nand Pay",
        "Out for\nDelivery",
      ],
      stateProgressBreakPoint: 3,
      stateProgressBreakPointColor:
          CustomTheme.of(context).colors.backgroundColor,
      stateProgressTagColor: CustomTheme.of(context).colors.positiveColor,
      isOrderConfirmed: true,
    );
  }

  static OrderStateData _completedState(BuildContext context) {
    return OrderStateData(
      actionButtonColor:
          CustomTheme.of(context).colors.positiveColor.withOpacity(0.2),
      actionButtonTextColor: CustomTheme.of(context).colors.positiveColor,
      icon: Icons.check_circle,
      actionButtonText: "Order Fulfilled",
      isActionButtonFilled: false,
      isCancelOptionAvailable: false,
      isReorderOptionAvailable: true,
      stateProgressTagsList: [
        "Request\nsent",
        "Pending\nConfirmation",
        "Confirm\nand Pay",
        "Order\nFulfilled",
      ],
      stateProgressBreakPoint: 3,
      stateProgressBreakPointColor:
          CustomTheme.of(context).colors.positiveColor,
      stateProgressTagColor: CustomTheme.of(context).colors.textColor,
      isOrderCompleted: true,
      isOrderConfirmed: true,
    );
  }
}
