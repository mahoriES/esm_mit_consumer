import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/models/order_models.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GetOrderListAPIAction extends ReduxAction<AppState> {
  final String urlForNextPageResponse;
  GetOrderListAPIAction({this.urlForNextPageResponse});
  LoadingStatusApp finalState = LoadingStatusApp.success;

  @override
  Future<AppState> reduce() async {
    try {
      final ResponseModel response = await APIManager.shared.request(
        url: urlForNextPageResponse ?? ApiURL.placeOrderUrl,
        params: null,
        requestType: RequestType.get,
      );

      if (response.status == ResponseStatus.success200) {
        final GetOrderListResponse responseModel =
            GetOrderListResponse.fromJson(response.data);
        if (urlForNextPageResponse != null) {
          final List<PlaceOrderResponse> data =
              state.ordersState.getOrderListResponse.results;
          responseModel.results = data + responseModel.results;
        }

        return state.copyWith(
          ordersState: state.ordersState.copyWith(
            getOrderListResponse: responseModel,
          ),
        );
      } else {
        Fluttertoast.showToast(
            msg: response.data['message'] ?? tr("common.some_error_occured"));
        finalState = LoadingStatusApp.error;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
      finalState = LoadingStatusApp.error;
    }
    return null;
  }

  void before() => dispatch(
        urlForNextPageResponse == null
            ? ToggleLoadingOrderListState(LoadingStatusApp.loading)
            : ToggleLoadingNextPageState(LoadingStatusApp.loading),
      );

  void after() => dispatch(
        urlForNextPageResponse == null
            ? ToggleLoadingOrderListState(finalState)
            : ToggleLoadingNextPageState(finalState),
      );
}

class ToggleLoadingOrderListState extends ReduxAction<AppState> {
  final LoadingStatusApp loadingState;
  ToggleLoadingOrderListState(this.loadingState);

  @override
  AppState reduce() {
    return state.copyWith(
      ordersState:
          state.ordersState.copyWith(isLoadingOrdersList: loadingState),
    );
  }
}

class ToggleLoadingNextPageState extends ReduxAction<AppState> {
  final LoadingStatusApp loadingState;
  ToggleLoadingNextPageState(this.loadingState);

  @override
  AppState reduce() {
    return state.copyWith(
      ordersState: state.ordersState.copyWith(isLoadingNextPage: loadingState),
    );
  }
}

class GetOrderDetailsAPIAction extends ReduxAction<AppState> {
  final String orderId;
  GetOrderDetailsAPIAction(this.orderId);
  LoadingStatusApp finalState = LoadingStatusApp.success;

  @override
  Future<AppState> reduce() async {
    try {
      final response = await APIManager.shared.request(
        url: ApiURL.placeOrderUrl + orderId,
        params: null,
        requestType: RequestType.get,
      );

      if (response.status == ResponseStatus.success200) {
        final PlaceOrderResponse responseModel =
            PlaceOrderResponse.fromJson(response.data);

        return state.copyWith(
          ordersState: state.ordersState.copyWith(
            selectedOrderDetailsResponse: responseModel,
          ),
        );
      } else {
        Fluttertoast.showToast(
            msg: response.data['message'] ?? tr("common.some_error_occured"));
        finalState = LoadingStatusApp.error;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
      finalState = LoadingStatusApp.error;
    }
    return null;
  }

  void before() =>
      dispatch(ToggleLoadingOrderDetailsState(LoadingStatusApp.loading));

  void after() => dispatch(ToggleLoadingOrderDetailsState(finalState));
}

class ToggleLoadingOrderDetailsState extends ReduxAction<AppState> {
  final LoadingStatusApp loadingState;
  ToggleLoadingOrderDetailsState(this.loadingState);

  @override
  AppState reduce() {
    return state.copyWith(
      ordersState:
          state.ordersState.copyWith(isLoadingOrderDetails: loadingState),
    );
  }
}

class AddRatingAPIAction extends ReduxAction<AppState> {
  final AddReviewRequest request;
  final String orderId;
  AddRatingAPIAction({
    @required this.request,
    @required this.orderId,
  });
  LoadingStatusApp finalState = LoadingStatusApp.success;

  @override
  Future<AppState> reduce() async {
    try {
      final response = await APIManager.shared.request(
        url: ApiURL.rateOrderUrl(orderId),
        params: request.toJson(),
        requestType: RequestType.post,
      );

      if (response.status == ResponseStatus.success200) {
        final GetOrderListResponse updatedResponse =
            state.ordersState.getOrderListResponse;

        updatedResponse.results.forEach((order) {
          if (order.orderId == orderId) {
            order.rating.ratingValue = request.ratingValue;
            order.rating.ratingComment = request.ratingComment;
          }
        });

        return state.copyWith(
          ordersState: state.ordersState.copyWith(
            getOrderListResponse: updatedResponse,
          ),
        );
      } else {
        Fluttertoast.showToast(
            msg: response.data['message'] ?? tr("common.some_error_occured"));
        finalState = LoadingStatusApp.error;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
      finalState = LoadingStatusApp.error;
    }
    return null;
  }

  void before() =>
      dispatch(ToggleLoadingOrderListState(LoadingStatusApp.loading));

  void after() => dispatch(ToggleLoadingOrderListState(finalState));
}

class CancelOrderAPIAction extends ReduxAction<AppState> {
  final String orderId;
  final String cancellationNote;
  CancelOrderAPIAction({
    @required this.orderId,
    @required this.cancellationNote,
  });

  LoadingStatusApp finalState = LoadingStatusApp.success;

  @override
  Future<AppState> reduce() async {
    try {
      final response = await APIManager.shared.request(
        url: ApiURL.cancelOrderUrl(orderId),
        params: {"cancellation_note": cancellationNote},
        requestType: RequestType.post,
      );

      if (response.status == ResponseStatus.success200) {
        final GetOrderListResponse updatedResponse =
            state.ordersState.getOrderListResponse;

        updatedResponse.results.forEach((order) {
          if (order.orderId == orderId) {
            order.orderStatus = OrderState.CUSTOMER_CANCELLED;
          }
        });

        return state.copyWith(
          ordersState: state.ordersState.copyWith(
            getOrderListResponse: updatedResponse,
          ),
        );
      } else {
        Fluttertoast.showToast(
            msg: response.data['message'] ?? tr("common.some_error_occured"));
        finalState = LoadingStatusApp.error;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
      finalState = LoadingStatusApp.error;
    }
    return null;
  }

  void before() =>
      dispatch(ToggleLoadingOrderListState(LoadingStatusApp.loading));

  void after() => dispatch(ToggleLoadingOrderListState(finalState));
}

class AcceptOrderAPIAction extends ReduxAction<AppState> {
  final String orderId;
  AcceptOrderAPIAction(this.orderId);

  LoadingStatusApp finalState = LoadingStatusApp.success;

  @override
  Future<AppState> reduce() async {
    try {
      final response = await APIManager.shared.request(
        url: ApiURL.acceptOrderUrl(orderId),
        params: null,
        requestType: RequestType.post,
      );

      if (response.status == ResponseStatus.success200) {
        final GetOrderListResponse updatedResponse =
            state.ordersState.getOrderListResponse;

        updatedResponse.results.forEach((order) {
          if (order.orderId == orderId) {
            order.orderStatus = OrderState.MERCHANT_ACCEPTED;
          }
        });

        return state.copyWith(
          ordersState: state.ordersState.copyWith(
            getOrderListResponse: updatedResponse,
          ),
        );
      } else {
        Fluttertoast.showToast(
            msg: response.data['message'] ?? tr("common.some_error_occured"));
        finalState = LoadingStatusApp.error;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
      finalState = LoadingStatusApp.error;
    }
    return null;
  }

  void before() =>
      dispatch(ToggleLoadingOrderListState(LoadingStatusApp.loading));

  void after() => dispatch(ToggleLoadingOrderListState(finalState));
}

class SetSelectedOrderForDetails extends ReduxAction<AppState> {
  final PlaceOrderResponse order;
  SetSelectedOrderForDetails(this.order);
  @override
  AppState reduce() {
    return state.copyWith(
      ordersState: state.ordersState.copyWith(
        selectedOrderForDetails: order,
        selectedOrderDetailsResponse: null,
      ),
    );
  }
}

class ReorderAction extends ReduxAction<AppState> {
  final PlaceOrderResponse orderResponse;
  final bool shouldFetchOrderDetails;
  ReorderAction({
    @required this.orderResponse,
    @required this.shouldFetchOrderDetails,
  });

  LoadingStatusApp finalState = LoadingStatusApp.success;

  @override
  Future<AppState> reduce() async {
    PlaceOrderResponse _orderDetails;
    if (shouldFetchOrderDetails) {
      await dispatchFuture(SetSelectedOrderForDetails(orderResponse));
      await dispatchFuture(GetOrderDetailsAPIAction(orderResponse.orderId));
      _orderDetails = state.ordersState.selectedOrderDetailsResponse;
    } else {
      _orderDetails = orderResponse;
    }

    final PlaceOrderRequest request = PlaceOrderRequest();
    request.businessId = _orderDetails.businessId;
    request.deliveryAddressId = _orderDetails.deliveryAdress?.addressId;
    request.deliveryType = _orderDetails.deliveryType;
    request.orderItems = _orderDetails.orderItems;
    request.customerNoteImages = _orderDetails.customerNoteImages;

    await dispatchFuture(PlaceOrderAction(request: request));
    dispatch(GetOrderListAPIAction());

    return null;
  }

  void before() =>
      dispatch(ToggleLoadingOrderListState(LoadingStatusApp.loading));

  void after() => dispatch(ToggleLoadingOrderListState(finalState));
}
