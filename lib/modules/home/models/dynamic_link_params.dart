import 'package:flutter/material.dart';

class DynamicLinkDataValues {
  String businessId;
  String videoId;

  DynamicLinkDataValues.fromJson(Map<String, dynamic> json) {
    businessId = json["businessId"];
    videoId = json['videoId'];
  }

  @override
  String toString() {
    debugPrint(
        'DynamicLinkDataValues => businessId: $businessId\nvideoId: $videoId');
    return super.toString();
  }
}
