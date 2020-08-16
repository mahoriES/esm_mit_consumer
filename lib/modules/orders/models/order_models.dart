import 'package:eSamudaay/modules/cart/models/cart_model.dart';

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
  String status;
  String dt;

  PaymentInfo({this.upi, this.status, this.dt});

  PaymentInfo.fromJson(Map<String, dynamic> json) {
    upi = json['upi'];
    status = json['status'];
    dt = json['dt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['upi'] = this.upi;
    data['status'] = this.status;
    data['dt'] = this.dt;
    return data;
  }
}
