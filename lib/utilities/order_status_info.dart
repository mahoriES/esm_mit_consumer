import 'package:easy_localization/easy_localization.dart';

///This class is used to generate better user-facing messages for the different order statuses.
///Depending on the current Order Status, Payment Status, as well as Order Type, required data is supplied
///from this class.

class OrderStatusInfoGenerator {
  ///Singleton instance of [OrderStatusInfoGenerator]
  static OrderStatusInfoGenerator _instance;

  OrderStatusInfoGenerator._internal() {
    _instance = this;
  }

  factory OrderStatusInfoGenerator() =>
      _instance ?? OrderStatusInfoGenerator._internal();

  ///[_deferPaymentActionStatuses] holds the Order states for which payment button (Pay via UPI) is not
  ///to be shown.
  static List<String> _deferPaymentActionStatuses = const [
    'CREATED',
    'MERCHANT_CANCELLED',
    'CUSTOMER_CANCELLED',
    'MERCHANT_UPDATED'
  ];

  ///[_orderActionStatuses] holds the Order states for which the Order actions
  ///i) Re-order
  ///ii) Cancel order
  ///iii) Accept Order
  ///are to shown accordingly.
  static List<String> _orderActionStatuses = const [
    'COMPLETED',
    'CREATED',
    'MERCHANT_UPDATED'
  ];

  static shouldShowPaymentButton(String orderStatus) {
    if (_deferPaymentActionStatuses.contains(orderStatus)) return false;
    return true;
  }

  static shouldShowOrderActionButton(String orderStatus) {
    if (_orderActionStatuses.contains(orderStatus)) return true;
    return false;
  }

  ///[paymentStatusMessageFromKey] provides the customer facing status string of the payment for
  ///the order depending upon the status received from backend.
  static String paymentStatusMessageFromKey(String paymentStatus, {String amount, String via}) {
    switch(paymentStatus) {
      case 'INITIATED':
        return tr('payment_statuses.initiated');
        break;
      case 'PENDING':
        return tr('payment_statuses.pending');
        break;
      case 'APPROVED':
        return tr('payment_statuses.approved');
        break;
      case 'REJECTED':
        return tr('payment_statuses.rejected');
        break;
      case 'SUCCESS':
        return tr('payment_statuses.success', args: [amount,via]);
        break;
      case 'FAIL':
        return tr('payment_statuses.fail');
        break;
      case 'REFUNDED':
        return tr('payment_statuses.refunded', args: [amount, via]);
        break;
      default:
        return '';
    }
  }

  ///[orderStatusTitleFromKey] provides a user-friendly title for the current order status
  ///viz. Order Confirmed, Out for Delivery etc.
  static String orderStatusTitleFromKey(String status, bool deliveryStatus) {
    switch (status) {
      case 'CREATED':
        return tr('order_statuses_title.created');
        break;
      case 'MERCHANT_UPDATED':
        return tr('order_statuses_title.order_updated');
        break;
      case 'READY_FOR_PICKUP':
        return tr('order_statuses_title.order_ready_pickup');
        break;
      case 'MERCHANT_CANCELLED':
        return tr('order_statuses_title.order_cancelled_merchant');
        break;
      case 'CUSTOMER_CANCELLED':
        return tr('order_statuses_title.order_cancelled_customer');
        break;
      case 'ASSIGNED_TO_DA':
        return tr('order_statuses_title.order_assigned_DA');
        break;
      case 'PICKED_UP_BY_DA':
        return tr('order_statuses_title.order_picked_DA');
        break;
      case 'COMPLETED':
        if (deliveryStatus)
          return tr('order_statuses_title.order_delivered');
        else
          return tr('order_statuses_title.order_picked_customer');
        break;
      case 'REQUESTING_TO_DA':
        return tr('order_statuses_title.order_requesting_DA');
        break;
      case 'PICKED_UP_BY_DA':
        return tr('order_statuses_title.order_picked_DA');
        break;
      case 'MERCHANT_ACCEPTED':
        return tr('order_statuses_title.order_confirmed');
        break;
      default:
        return '';
    }
  }

  ///[orderStatusSubtitleFromKey] provides a user-friendly subtitle for the current order status
  ///viz. Ready to be delivered, Is under process by store etc.
  static String orderStatusSubtitleFromKey(String status, bool deliveryStatus) {
    switch (status) {
      case 'CREATED':
        return tr('order_statuses_subtitle.created');
        break;
      case 'MERCHANT_UPDATED':
        return tr('order_statuses_subtitle.order_updated');
        break;
      case 'READY_FOR_PICKUP':
        return tr('order_statuses_subtitle.order_ready_pickup');
        break;
      case 'MERCHANT_CANCELLED':
        return tr('order_statuses_subtitle.order_cancelled_merchant');
        break;
      case 'CUSTOMER_CANCELLED':
        return tr('order_statuses_subtitle.order_cancelled_customer');
        break;
      case 'ASSIGNED_TO_DA':
        return tr('order_statuses_subtitle.order_assigned_DA');
        break;
      case 'PICKED_UP_BY_DA':
        return tr('order_statuses_subtitle.order_picked_DA');
        break;
      case 'COMPLETED':
        if (deliveryStatus)
          return tr('order_statuses_subtitle.order_delivered');
        else
          return tr('order_statuses_subtitle.order_picked_customer');
        break;
      case 'REQUESTING_TO_DA':
        return tr('order_statuses_subtitle.order_requesting_DA');
        break;
      case 'PICKED_UP_BY_DA':
        return tr('order_statuses_subtitle.order_picked_DA');
        break;
      case 'MERCHANT_ACCEPTED':
        if (deliveryStatus)
          return tr('order_statuses_subtitle.order_confirmed');
        else
          return tr('order_statuses_subtitle.order_confirmed_pickup');
        break;
      default:
        return '';
    }
  }
}
