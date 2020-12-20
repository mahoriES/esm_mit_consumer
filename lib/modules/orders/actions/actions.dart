import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/models/order_models.dart';
import 'package:eSamudaay/modules/orders/models/support_request_model.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upi_pay/upi_pay.dart';

class GetOrderListAPIAction extends ReduxAction<AppState> {
  final String orderRequestApi;

  GetOrderListAPIAction({this.orderRequestApi});
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: orderRequestApi == null ? ApiURL.placeOrderUrl : orderRequestApi,
        params: {"": ""},
        requestType: RequestType.get);

    if (response.status == ResponseStatus.success200) {
      GetOrderListResponse responseModel =
          GetOrderListResponse.fromJson(response.data);
      if (orderRequestApi == ApiURL.placeOrderUrl) {
      } else {
        var data = state.productState.getOrderListResponse.results;
        var data_new = data + responseModel.results;

        responseModel.results = data_new;
      }

      return state.copyWith(
          productState:
              state.productState.copyWith(getOrderListResponse: responseModel));
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
    }
    return null;
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}

class GetOrderDetailsAPIAction extends ReduxAction<AppState> {
  final String orderId;

  GetOrderDetailsAPIAction({this.orderId});
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.placeOrderUrl + orderId,
        params: {"": ""},
        requestType: RequestType.get);

    if (response.status == ResponseStatus.success200) {
      PlaceOrderResponse responseModel =
          PlaceOrderResponse.fromJson(response.data);
      GetOrderListResponse orderResponse = new GetOrderListResponse();
      orderResponse.results = state.productState.getOrderListResponse.results;
      orderResponse.results.forEach((e) {
        if (e.orderId == orderId) {
          print("equal");
          e.otherChargesDetail = responseModel.otherChargesDetail;
          e.businessPhones = responseModel.businessPhones;
          e.businessId = responseModel.businessId;
          if (responseModel.orderItems != null)
            e.orderItems = responseModel.orderItems;
          if (responseModel.freeFormOrderItems != null)
            e.freeFormOrderItems = responseModel.freeFormOrderItems;
          if (responseModel.customerNoteImages != null)
            e.customerNoteImages = responseModel.customerNoteImages;
        }
      });
      return state.copyWith(
          productState:
              state.productState.copyWith(getOrderListResponse: orderResponse));
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
    }
    return null;
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}

class PaymentAPIAction extends ReduxAction<AppState> {
  final String orderId;

  PaymentAPIAction({this.orderId});
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.placeOrderUrl + orderId + '/payment',
        params: {"": ""},
        requestType: RequestType.post);

    if (response.status == ResponseStatus.success200) {
      GetOrderListResponse orderResponse = new GetOrderListResponse();
      orderResponse.results = state.productState.getOrderListResponse.results;
      orderResponse.results.forEach((e) {
        if (e.orderId == orderId) {
          e.paymentInfo = PaymentInfo(
              dt: e.paymentInfo.dt,
              status: "INITIATED",
              upi: e.paymentInfo.upi);
        }
      });
      return state.copyWith(
          productState:
              state.productState.copyWith(getOrderListResponse: orderResponse));
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
    }
    return null;
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}

class AddRatingAPIAction extends ReduxAction<AppState> {
  final AddReviewRequest request;
  final String orderId;
  AddRatingAPIAction({
    this.request,
    this.orderId,
  });
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.placeOrderUrl + "$orderId" + "/rating",
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.status == ResponseStatus.success200) {
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.submitted));
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
    }
    return null;
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.submitted));
}

class CancelOrderAPIAction extends ReduxAction<AppState> {
  final String orderId;
  final int index;

  CancelOrderAPIAction({this.orderId, this.index});
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.placeOrderUrl + orderId + "/cancel",
        params: {"cancellation_note": ""},
        requestType: RequestType.post);

    if (response.status == ResponseStatus.success200) {
      // dispatch(GetOrderListAPIAction(orderRequestApi: ApiURL.placeOrderUrl));
      state.productState.getOrderListResponse.results[index].orderStatus =
          "CUSTOMER_CANCELLED";

      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.submitted));
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
    }
    return state.copyWith(productState: state.productState.copyWith());
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.submitted));
}

class AcceptOrderAPIAction extends ReduxAction<AppState> {
  final String orderId;
  final int index;

  AcceptOrderAPIAction({
    this.orderId,
    this.index,
  });
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.placeOrderUrl + orderId + "/accept",
        params: {"": ""},
        requestType: RequestType.post);

    if (response.status == ResponseStatus.success200) {
//      dispatch(GetOrderListAPIAction());
      state.productState.getOrderListResponse.results[index].orderStatus =
          "MERCHANT_ACCEPTED";
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.submitted));
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
    }
    return state.copyWith(productState: state.productState.copyWith());
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.submitted));
}

class CompleteOrderAPIAction extends ReduxAction<AppState> {
  final String orderId;
  final int index;
  CompleteOrderAPIAction({this.orderId, this.index});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.placeOrderUrl + orderId + "/complete",
        params: {"": ""},
        requestType: RequestType.post);

    if (response.status == ResponseStatus.success200) {
      // dispatch(GetOrderListAPIAction(orderRequestApi: ApiURL.placeOrderUrl));
      state.productState.getOrderListResponse.results[index].orderStatus =
          "COMPLETED";

      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.submitted));
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
    }
    return state.copyWith(productState: state.productState.copyWith());
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.submitted));
}

class SupportAPIAction extends ReduxAction<AppState> {
  final SupportRequest request;

  SupportAPIAction({this.request});
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.supportURL,
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.data['statusCode'] == 200) {
      Fluttertoast.showToast(
          msg:
              'Successfully raised an issue. Our support team will contact you shortly.');

      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.submitted));
      dispatch(NavigateAction.pop());
    } else {
      Fluttertoast.showToast(msg: response.data['status']);
    }
    return null;
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.submitted));
}

class UpdateOrderAction extends ReduxAction<AppState> {
  final UpdateOrderRequest request;

  UpdateOrderAction({this.request});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.updateOrderUrl,
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.data['statusCode'] == 200) {
      Fluttertoast.showToast(msg: response.data['status']);
      await CartDataSource.deleteCartMerchant();
      await CartDataSource.deleteAllProducts();
      dispatch(GetCartFromLocal());
      dispatch(GetOrderListAPIAction());
    } else {
      request.orders[0].status = request.oldStatus;
      Fluttertoast.showToast(msg: response.data['status']);
    }
    return null;
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}

class OrderSupportAction extends ReduxAction<AppState> {
  final String orderId;

  OrderSupportAction({this.orderId});

  @override
  FutureOr<AppState> reduce() {
    // TODO: implement reduce
    return state.copyWith(
        productState: state.productState.copyWith(supportOrder: orderId));
  }
}

class GetUPIAppsAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    List<ApplicationMeta> apps = await UpiPay.getInstalledUpiApplications();
    return state.copyWith(
        productState: state.productState.copyWith(upiApps: apps));
  }
}
