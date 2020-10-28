import 'package:easy_localization/easy_localization.dart';

class OrderStatusInfoGenerator {
  static OrderStatusInfoGenerator _instance;

  OrderStatusInfoGenerator._internal() {
    _instance = this;
  }

  factory OrderStatusInfoGenerator() =>
      _instance ?? OrderStatusInfoGenerator._internal();

  static List<String> _deferPaymentActionStatuses = const [
    'CREATED',
    'MERCHANT_CANCELLED',
    'CUSTOMER_CANCELLED',
    'COMPLETED',
    'MERCHANT_UPDATED'
  ];

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

  static String orderStatusTitleFromKey(String status) {
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
        return tr('order_statuses_title.order_delivered');
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
        return 'Processing Order';
    }
  }

  static String orderStatusSubtitleFromKey(String status) {
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
        return tr('order_statuses_subtitle.order_delivered');
        break;
      case 'REQUESTING_TO_DA':
        return tr('order_statuses_subtitle.order_requesting_DA');
        break;
      case 'PICKED_UP_BY_DA':
        return tr('order_statuses_subtitle.order_picked_DA');
        break;
      case 'MERCHANT_ACCEPTED':
        return tr('order_statuses_subtitle.order_confirmed');
        break;
      default:
        return 'Processing Order';
    }
  }
}
