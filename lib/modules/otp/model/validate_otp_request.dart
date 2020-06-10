class ValidateOTPRequest {
  String phoneNumber;
  String otp;
  String fcmToken;

  ValidateOTPRequest({this.phoneNumber, this.otp, this.fcmToken});

  ValidateOTPRequest.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    otp = json['otp'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['otp'] = this.otp;
    data['fcmToken'] = this.fcmToken;
    return data;
  }
}
