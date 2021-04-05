import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/models/order_models.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OrdersState {
  final GetOrderListResponse ordersList;
  final LoadingStatusApp isLoadingOrderDetails;
  final LoadingStatusApp isLoadingOrdersList;
  final LoadingStatusApp isLoadingNextPage;
  final PlaceOrderResponse selectedOrder;
  final PlaceOrderResponse selectedOrderDetails;
  final AddReviewRequest reviewRequest;
  final bool showFeedbackSubmitDialog;
  final PaymentOptions selectedPaymentOption;

  OrdersState({
    @required this.ordersList,
    @required this.isLoadingOrderDetails,
    @required this.isLoadingOrdersList,
    @required this.isLoadingNextPage,
    @required this.selectedOrder,
    @required this.selectedOrderDetails,
    @required this.reviewRequest,
    @required this.showFeedbackSubmitDialog,
    @required this.selectedPaymentOption,
  });

  factory OrdersState.initial() {
    return new OrdersState(
      ordersList: GetOrderListResponse(results: []),
      isLoadingOrderDetails: LoadingStatusApp.idle,
      isLoadingOrdersList: LoadingStatusApp.idle,
      isLoadingNextPage: LoadingStatusApp.idle,
      selectedOrder: null,
      selectedOrderDetails: null,
      reviewRequest: new AddReviewRequest(),
      showFeedbackSubmitDialog: false,
      selectedPaymentOption: PaymentOptions.Razorpay,
    );
  }

  OrdersState copyWith({
    GetOrderListResponse ordersList,
    String supportOrder,
    LoadingStatusApp isLoadingOrderDetails,
    LoadingStatusApp isLoadingOrdersList,
    LoadingStatusApp isLoadingNextPage,
    PlaceOrderResponse selectedOrder,
    PlaceOrderResponse selectedOrderDetails,
    bool isSelectedOrderDetailsNull = false,
    AddReviewRequest reviewRequest,
    bool showFeedbackSubmitDialog,
    PaymentOptions selectedPaymentOption,
  }) {
    return OrdersState(
      ordersList: ordersList ?? this.ordersList,
      isLoadingOrderDetails:
          isLoadingOrderDetails ?? this.isLoadingOrderDetails,
      isLoadingOrdersList: isLoadingOrdersList ?? this.isLoadingOrdersList,
      isLoadingNextPage: isLoadingNextPage ?? this.isLoadingNextPage,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      selectedOrderDetails: selectedOrderDetails ??
          (isSelectedOrderDetailsNull ? null : this.selectedOrderDetails),
      reviewRequest: reviewRequest ?? this.reviewRequest,
      showFeedbackSubmitDialog:
          showFeedbackSubmitDialog ?? this.showFeedbackSubmitDialog,
      selectedPaymentOption:
          selectedPaymentOption ?? this.selectedPaymentOption,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdersState &&
          runtimeType == other.runtimeType &&
          ordersList == other.ordersList &&
          isLoadingOrderDetails == other.isLoadingOrderDetails &&
          isLoadingOrdersList == other.isLoadingOrdersList &&
          isLoadingNextPage == other.isLoadingNextPage &&
          selectedOrder == other.selectedOrder &&
          selectedOrderDetails == other.selectedOrderDetails &&
          reviewRequest == other.reviewRequest &&
          showFeedbackSubmitDialog == other.showFeedbackSubmitDialog;

  @override
  int get hashCode =>
      ordersList.hashCode ^
      isLoadingOrderDetails.hashCode ^
      isLoadingOrdersList.hashCode ^
      isLoadingNextPage.hashCode ^
      selectedOrder.hashCode ^
      selectedOrderDetails.hashCode ^
      reviewRequest.hashCode ^
      showFeedbackSubmitDialog.hashCode;
}
