import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetOrderListRequest {
  String phoneNumber;

  GetOrderListRequest({this.phoneNumber});

  GetOrderListRequest.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}

class GetOrderListResponse {
  int count;
  String next;
  String previous;
  List<PlaceOrderResponse> results;

  GetOrderListResponse({this.count, this.results});

  GetOrderListResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = new List<PlaceOrderResponse>();
      json['results'].forEach((v) {
        results.add(new PlaceOrderResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddReviewRequest {
  int ratingValue;
  String ratingComment;

  AddReviewRequest({this.ratingValue, this.ratingComment});

  AddReviewRequest.fromJson(Map<String, dynamic> json) {
    ratingValue = json['rating_value'];
    ratingComment = json['rating_comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating_value'] = this.ratingValue;
    data['rating_comment'] = this.ratingComment;
    return data;
  }
}

class UpdateOrderRequest {
  String phoneNumber;
  List orders;
  String comments;
  String oldStatus;

  UpdateOrderRequest(
      {this.phoneNumber, this.orders, this.comments, this.oldStatus});

  UpdateOrderRequest.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    if (json['orders'] != null) {
      orders = new List();
      json['orders'].forEach((v) {
        orders.add(v);
      });
    }
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    if (this.orders != null) {
      data['orders'] = this.orders.map((v) => v.toJson()).toList();
    }
    data['comments'] = this.comments;
    print(data);
    return data;
  }
}

class PaymentInfo {

  String upi;

  /// The payment status of the order. Can have following possible values
  ///   I) PENDING : Payment not done
  ///   II) SUCCESS : Payment succeded. Could be online or COD.
  ///   III) FAIL : Online payment failed
  ///   IV) REFUNDED : Money refunded
  ///
  ///  Old Statuses:
  ///   I) INITIATED : Customer marked paid
  ///   II) APPROVED : Merchant approved payment
  ///   III) REJECTED : Merchant rejected the payment claim
  ///
  String status;

  String dt;

  /// A string containing info regarding the source of the payment
  /// e.g. Direct UPI, Deutsche bank, PayTM, OlaMoney etc.
  ///
  String paymentMadeVia;

  /// Amount paid via the [paymentMadeVia] channel in paise. This may be different
  /// than the order total billed amount
  ///
  int amount;

  PaymentInfo({this.upi, this.status, this.dt, this.paymentMadeVia, this.amount});

  PaymentInfo.fromJson(Map<String, dynamic> json) {
    upi = json['upi'];
    status = json['status'];
    dt = json['dt'];
    amount = json['amount'];
    paymentMadeVia = json['via'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['upi'] = this.upi;
    data['status'] = this.status;
    data['dt'] = this.dt;
    data['via'] = paymentMadeVia;
    data['amount'] = amount;
    return data;
  }
}

class RazorpayCheckoutOptions extends Equatable {
  final String key;
  final int amount;
  final String name;
  final String orderId;
  final String description;
  final int timeout;
  final String email;
  final String phone;
  final String currency;

  RazorpayCheckoutOptions(this.key, this.amount, this.name, this.orderId,
      this.description, this.timeout, this.email, this.phone, this.currency);

  factory RazorpayCheckoutOptions.fromJson(Map<String, dynamic> json) {
    final String key = json['key'];
    final int amount = json['amount'] ?? 0;
    final String name = json['name'] ?? 'eSamudaay';
    final String orderId = json['order_id'];
    final int timeout = json['timeout'] ?? 60;
    final String currency = json['currency'] ?? "INR";
    final String description = json['description'] ?? '';
    final String phone = (json['prefill'] ?? const {})['contact'] ?? '';
    final String email = (json['prefill'] ?? const {})['email'] ?? '';
    if (key != null && orderId != null) return null;
    return RazorpayCheckoutOptions(
        key, amount, name, orderId, description, timeout, email, phone, currency);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> checkoutOptions = Map<String, dynamic>();
    checkoutOptions['key'] = key;
    checkoutOptions['amount'] = amount;
    checkoutOptions['name'] = name;
    checkoutOptions['order_id'] = orderId;
    checkoutOptions['currency'] = currency;
    checkoutOptions['timeout'] = timeout;
    checkoutOptions['description'] = description;
    checkoutOptions['prefill'] = {
      'contact': phone,
      'email': email
    };
    return checkoutOptions;
  }

  @override
  List<Object> get props =>
      [key, amount, name, orderId, description, timeout, email, phone, currency];
}
