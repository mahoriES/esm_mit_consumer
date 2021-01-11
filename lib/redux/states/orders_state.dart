import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/models/order_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OrdersState {
  final GetOrderListResponse getOrderListResponse;
  final String supportOrder;
  final LoadingStatusApp isLoadingOrderDetails;
  final LoadingStatusApp isLoadingOrdersList;
  final LoadingStatusApp isLoadingNextPage;
  final PlaceOrderResponse selectedOrderForDetails;
  final PlaceOrderResponse selectedOrderDetailsResponse;

  OrdersState({
    @required this.getOrderListResponse,
    @required this.supportOrder,
    @required this.isLoadingOrderDetails,
    @required this.isLoadingOrdersList,
    @required this.isLoadingNextPage,
    @required this.selectedOrderForDetails,
    @required this.selectedOrderDetailsResponse,
  });

  factory OrdersState.initial() {
    return new OrdersState(
      supportOrder: "",
      getOrderListResponse: GetOrderListResponse(results: []),
      isLoadingOrderDetails: LoadingStatusApp.idle,
      isLoadingOrdersList: LoadingStatusApp.idle,
      isLoadingNextPage: LoadingStatusApp.idle,
      selectedOrderForDetails: null,
      selectedOrderDetailsResponse: null,
    );
  }

  OrdersState copyWith({
    GetOrderListResponse getOrderListResponse,
    String supportOrder,
    LoadingStatusApp isLoadingOrderDetails,
    LoadingStatusApp isLoadingOrdersList,
    LoadingStatusApp isLoadingNextPage,
    PlaceOrderResponse selectedOrderForDetails,
    PlaceOrderResponse selectedOrderDetailsResponse,
  }) {
    return OrdersState(
      getOrderListResponse: getOrderListResponse ?? this.getOrderListResponse,
      supportOrder: supportOrder ?? this.supportOrder,
      isLoadingOrderDetails:
          isLoadingOrderDetails ?? this.isLoadingOrderDetails,
      isLoadingOrdersList: isLoadingOrdersList ?? this.isLoadingOrdersList,
      isLoadingNextPage: isLoadingNextPage ?? this.isLoadingNextPage,
      selectedOrderForDetails:
          selectedOrderForDetails ?? this.selectedOrderForDetails,
      selectedOrderDetailsResponse:
          selectedOrderDetailsResponse ?? this.selectedOrderDetailsResponse,
    );
  }
}
