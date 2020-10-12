import 'package:flutter/material.dart';

class DynamicLinkDataValues {
  String businessId;
  String clusterId;
  String productId;
  String videoId;

  DynamicLinkDataValues.fromJson(Map<String, dynamic> json) {
    businessId = json["businessId"];
    clusterId = json['clusterId'];
    productId = json['productId'];
    videoId = json['videoId'];
  }

  @override
  String toString() {
    debugPrint(
        'DynamicLinkDataValues => businessId: $businessId\nclusterId: $clusterId\nproductId: $productId\nvideoId: $videoId');
    return super.toString();
  }
}
