import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/models/order_models.dart';
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

  OrdersState({
    @required this.ordersList,
    @required this.isLoadingOrderDetails,
    @required this.isLoadingOrdersList,
    @required this.isLoadingNextPage,
    @required this.selectedOrder,
    @required this.selectedOrderDetails,
    @required this.reviewRequest,
    this.showFeedbackSubmitDialog,
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
    AddReviewRequest reviewRequest,
    bool showFeedbackSubmitDialog,
  }) {
    return OrdersState(
      ordersList: ordersList ?? this.ordersList,
      isLoadingOrderDetails:
          isLoadingOrderDetails ?? this.isLoadingOrderDetails,
      isLoadingOrdersList: isLoadingOrdersList ?? this.isLoadingOrdersList,
      isLoadingNextPage: isLoadingNextPage ?? this.isLoadingNextPage,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      selectedOrderDetails: selectedOrderDetails ?? this.selectedOrderDetails,
      reviewRequest: reviewRequest ?? this.reviewRequest,
      showFeedbackSubmitDialog:
          showFeedbackSubmitDialog ?? this.showFeedbackSubmitDialog,
    );
  }
}
