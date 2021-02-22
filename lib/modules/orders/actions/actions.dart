import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/models/order_models.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/payments/razorpay/utility.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Get List of all orders placed by the user.
class GetOrderListAPIAction extends ReduxAction<AppState> {
  final String urlForNextPageResponse;
  GetOrderListAPIAction({this.urlForNextPageResponse});

  // change to failure state in case of any error/exception.
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

        // if action is triggered to get the next response of orders list
        // then append the current response in existing list.
        if (urlForNextPageResponse != null) {
          final List<PlaceOrderResponse> data =
              state.ordersState.ordersList.results;
          responseModel.results = data + responseModel.results;
        }

        return state.copyWith(
          ordersState: state.ordersState.copyWith(
            ordersList: responseModel,
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

class GetOrderDetailsAPIAction extends ReduxAction<AppState> {
  final String orderId;
  GetOrderDetailsAPIAction(this.orderId);

  // change to failure state in case of any error/exception.
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
            selectedOrderDetails: responseModel,
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

/// Use this action to reset the feedback screen data.
// Feedback screen should have fresh state each time user navigates to it.
// if initialRating is not available, pass 0 as initialRating.
class ResetReviewRequest extends ReduxAction<AppState> {
  final int initialRating;
  ResetReviewRequest(this.initialRating);
  @override
  AppState reduce() {
    return state.copyWith(
      ordersState: state.ordersState.copyWith(
        reviewRequest: new AddReviewRequest(ratingValue: initialRating),
      ),
    );
  }
}

/// update the rating of specific products for the order.
class UpdateProductReviewRequest extends ReduxAction<AppState> {
  final int productId;
  final int rating;

  UpdateProductReviewRequest({@required this.productId, @required this.rating});

  @override
  AppState reduce() {
    try {
      List<ProductRating> updatedProductRatings =
          state.ordersState.reviewRequest.productRatings;

      // used to check whether the product is already rated and present in the list.
      bool isProductAlreadyPresentInList = false;

      if (updatedProductRatings == null) {
        updatedProductRatings = [];
      }

      for (int i = 0; i < updatedProductRatings.length; i++) {
        if (updatedProductRatings[i].productId == productId) {
          // set isProductAlreadyPresentInList to true , as poduct is already presnt in the list.
          isProductAlreadyPresentInList = true;

          // update the rating for this productRating object.
          updatedProductRatings[i] = updatedProductRatings[i].copyWith(
            ratingValue: rating,
          );
        }
      }

      // if product is not added yet in the list, add a new productRating for the same.
      if (!isProductAlreadyPresentInList) {
        updatedProductRatings.add(
          new ProductRating(productId: productId, ratingValue: rating),
        );
      }

      return state.copyWith(
        ordersState: state.ordersState.copyWith(
          reviewRequest: state.ordersState.reviewRequest.copyWith(
            productRatings: updatedProductRatings,
          ),
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: tr("common.some_error_occured"));
      return null;
    }
  }
}

/// update the rating and comment for overall order.
class UpdateOrderReviewRequest extends ReduxAction<AppState> {
  final int rating;
  final String comment;

  UpdateOrderReviewRequest({@required this.rating, @required this.comment});

  @override
  AppState reduce() {
    return state.copyWith(
      ordersState: state.ordersState.copyWith(
        reviewRequest: state.ordersState.reviewRequest.copyWith(
          ratingValue: rating,
          ratingComment: comment,
        ),
      ),
    );
  }
}

// action to send user's final feedback to server.
class AddRatingAPIAction extends ReduxAction<AppState> {
  final AddReviewRequest request;
  final String orderId;
  AddRatingAPIAction({
    @required this.request,
    @required this.orderId,
  });

  // change to failure state in case of any error/exception.
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
            state.ordersState.ordersList;

        // If feedback is updated succesfully, then update this specific order's rating info.
        updatedResponse.results.forEach((order) {
          if (order.orderId == orderId) {
            order.rating.ratingValue = request.ratingValue;
            order.rating.ratingComment = request.ratingComment;
          }
        });

        // fetch order details to update the view.
        dispatch(GetOrderDetailsAPIAction(orderId));

        return state.copyWith(
          ordersState: state.ordersState.copyWith(
            ordersList: updatedResponse,
            // showFeedbackSubmitDialog triggers a modal on top of view to thank user for submitting the feedback.
            showFeedbackSubmitDialog: true,
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

  // change to failure state in case of any error/exception.
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
            state.ordersState.ordersList;

        // If feedback is updated succesfully, then update this specific order's status to CUSTOMER_CANCELLED.
        updatedResponse.results.forEach((order) {
          if (order.orderId == orderId) {
            order.orderStatus = OrderState.CUSTOMER_CANCELLED;
          }
        });

        // fetch order details to update the view.
        dispatch(GetOrderDetailsAPIAction(orderId));

        return state.copyWith(
          ordersState: state.ordersState.copyWith(ordersList: updatedResponse),
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

/// if merchant updates the order, consumer is again asked to confirm whether they want to proceed with the updated products/charges.
// use this action to to send confirmation from consumer's side.
class AcceptOrderAPIAction extends ReduxAction<AppState> {
  final String orderId;
  AcceptOrderAPIAction(this.orderId);

  // change to failure state in case of any error/exception.
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
            state.ordersState.ordersList;

        // If confirmation is sent succesfully, then update this specific order's status to MERCHANT_ACCEPTED.
        updatedResponse.results.forEach((order) {
          if (order.orderId == orderId) {
            order.orderStatus = OrderState.MERCHANT_ACCEPTED;
          }
        });

        // fetch order details to update the view.
        dispatch(GetOrderDetailsAPIAction(orderId));

        return state.copyWith(
          ordersState: state.ordersState.copyWith(
            ordersList: updatedResponse,
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

/// reset selected order as required
// selectedOrder is udsed to fetch order_details onInit in orderDeatis view.
class ResetSelectedOrder extends ReduxAction<AppState> {
  final PlaceOrderResponse order;
  ResetSelectedOrder(this.order);
  @override
  AppState reduce() {
    return state.copyWith(
      ordersState: state.ordersState.copyWith(
        selectedOrder: order,
        selectedOrderDetails: null,
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

  @override
  Future<AppState> reduce() async {
    PlaceOrderResponse _orderDetails;

    if (shouldFetchOrderDetails) {
      // if triggered from orders_list view , then we need to fetch the order details to get more data about that order.
      await dispatchFuture(ResetSelectedOrder(orderResponse));
      await dispatchFuture(GetOrderDetailsAPIAction(orderResponse.orderId));
      _orderDetails = state.ordersState.selectedOrderDetails;
    } else {
      // if triggered from orders_details view , then required data must have already been fetched.
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

  void after() =>
      dispatch(ToggleLoadingOrderListState(LoadingStatusApp.success));
}

// Reset the checkoutOtions data to avoid conflict.
class ClearPreviousRazorpayCheckoutOptionsAction extends ReduxAction<AppState> {
  ClearPreviousRazorpayCheckoutOptionsAction();

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(orderPaymentCheckoutOptions: null);
  }
}

class GetRazorpayCheckoutOptionsAction extends ReduxAction<AppState> {
  final String orderId;

  GetRazorpayCheckoutOptionsAction({@required this.orderId});

  @override
  Future<AppState> reduce() async {
    final response = await APIManager.shared.request(
      url: ApiURL.getRazorpayOrderIdUrl(orderId),
      params: null,
      requestType: RequestType.get,
    );
    if (response.status == ResponseStatus.success200 &&
        response.data != null &&
        response.data is Map) {
      final RazorpayCheckoutOptions checkoutOptions =
          RazorpayCheckoutOptions.fromJson(response.data);
      if (checkoutOptions != null) {
        final Map<String, dynamic> standardisedRazorpayCheckoutOptions =
            checkoutOptions.toJson();
        return state.copyWith(
            orderPaymentCheckoutOptions: standardisedRazorpayCheckoutOptions);
      } else
        _handleErrorInCheckoutOptionsResponse(
            message:
                'Checkout options for orderId is not as per required format');
    } else
      _handleErrorInCheckoutOptionsResponse(
          message:
              'Error getting the checkout options for orderId. Either the response is not in proper format or it indicates a bug in getting response.');
    return null;
  }

  void _handleErrorInCheckoutOptionsResponse({@required String message}) {
    Fluttertoast.showToast(msg: tr('payment_info.checkout_error'));
    FirebaseCrashlytics.instance
        .recordError(Exception([message]), StackTrace.current);
  }
}

class PaymentAction extends ReduxAction<AppState> {
  final String orderId;
  final VoidCallback onSuccess;
  PaymentAction({
    @required this.orderId,
    @required this.onSuccess,
  });

  @override
  Future<AppState> reduce() async {
    await dispatchFuture(ClearPreviousRazorpayCheckoutOptionsAction());
    await dispatchFuture(GetRazorpayCheckoutOptionsAction(orderId: orderId));

    RazorpayUtility().checkout(
      state.orderPaymentCheckoutOptions,
      onSuccess: onSuccess,
      onFailure: () {},
    );

    return state.copyWith(orderPaymentCheckoutOptions: null);
  }

  void before() =>
      dispatch(ToggleLoadingOrderListState(LoadingStatusApp.loading));

  void after() =>
      dispatch(ToggleLoadingOrderListState(LoadingStatusApp.success));
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

// reset showFeedbackSubmitDialog to false after triggering the dialog once.
class ResetShowFeedbackDialog extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    return state.copyWith(
      ordersState: state.ordersState.copyWith(showFeedbackSubmitDialog: false),
    );
  }
}

class ChangeSelctedPaymentOption extends ReduxAction<AppState> {
  PaymentOptions paymentOption;
  ChangeSelctedPaymentOption(this.paymentOption);

  @override
  AppState reduce() {
    return state.copyWith(
      ordersState: state.ordersState.copyWith(
        selectedPaymentOption: paymentOption,
      ),
    );
  }
}
