class CustomerDetailsRequest {
  String phoneNumber;
  String customerName;
  String address;
  String pincode;
  String latitude;
  String longitude;
  String fcmToken;

  CustomerDetailsRequest(
      {this.phoneNumber,
      this.customerName,
      this.address,
      this.pincode,
      this.latitude,
      this.longitude,
      this.fcmToken});

  CustomerDetailsRequest.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    customerName = json['customerName'];
    address = json['address'];
    pincode = json['pincode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['customerName'] = this.customerName;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['fcmToken'] = this.fcmToken;
    return data;
  }
}
