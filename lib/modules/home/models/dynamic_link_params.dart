import 'package:flutter/material.dart';

class DynamicLinkDataValues {
  String businessId;
  String videoId;
  String productId;

  DynamicLinkDataValues.fromJson(Map<String, dynamic> json) {
    businessId = json["businessId"];
    videoId = json['videoId'];
    productId = json['productId'];
  }

  @override
  String toString() {
    debugPrint(
        'DynamicLinkDataValues => businessId: $businessId\nvideoId: $videoId\nproductId: $productId');
    return super.toString();
  }
}
