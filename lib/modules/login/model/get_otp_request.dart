class GenerateOTPRequest {
  String phoneNumber;
  bool isSignUp;

  GenerateOTPRequest({this.isSignUp, this.phoneNumber});

  GenerateOTPRequest.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
