import 'package:eSamudaay/modules/Profile/model/profile_update_model.dart';

class CustomerDetailsRequest {
  String role;
  String profileName;
  String clusterCode;

  CustomerDetailsRequest({this.role, this.profileName, this.clusterCode});

  CustomerDetailsRequest.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    profileName = json['profile_name'];
    clusterCode = json['cluster_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['profile_name'] = this.profileName;
    data['cluster_code'] = this.clusterCode;
    return data;
  }
}

class UserProfilesResponse {

  RegisterResponse customerProfile;
  RegisterResponse merchantProfile;
  RegisterResponse agentProfile;

  UserProfilesResponse.fromJson(Map<String, dynamic> json) {
    if (json['CUSTOMER'] != null)
      customerProfile = RegisterResponse.fromJson(json['CUSTOMER']);
    if (json['MERCHANT'] != null)
      customerProfile = RegisterResponse.fromJson(json['MERCHANT']);
    if (json['AGENT'] != null)
      customerProfile = RegisterResponse.fromJson(json['AGENT']);
  }

}

class RegisterResponse {
  Data data;
  String token;
  String role;

  RegisterResponse({this.data, this.token, this.role});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    token = json['token'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['token'] = this.token;
    data['role'] = this.role;
    return data;
  }
}

class Photo {
  String photoId;
  String photoUrl;
  String contentType;

  Photo({this.photoId, this.photoUrl, this.contentType});

  Photo.fromJson(Map<String, dynamic> json) {
    photoId = json['photo_id'];
    photoUrl = json['photo_url'];
    contentType = json['content_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo_id'] = this.photoId;
    data['photo_url'] = this.photoUrl;
    data['content_type'] = this.contentType;
    return data;
  }
}

class UserProfile {
  String phone;
  bool isActive;
  String userId;

  UserProfile({this.phone, this.isActive, this.userId});

  UserProfile.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    isActive = json['is_active'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['is_active'] = this.isActive;
    data['user_id'] = this.userId;
    return data;
  }
}

//class CustomerDetailsRequest {
//  String phoneNumber;
//  String customerName;
//  String address;
//  String pincode;
//  String latitude;
//  String longitude;
//  String fcmToken;
//
//  CustomerDetailsRequest(
//      {this.phoneNumber,
//      this.customerName,
//      this.address,
//      this.pincode,
//      this.latitude,
//      this.longitude,
//      this.fcmToken});
//
//  CustomerDetailsRequest.fromJson(Map<String, dynamic> json) {
//    phoneNumber = json['phoneNumber'];
//    customerName = json['customerName'];
//    address = json['address'];
//    pincode = json['pincode'];
//    latitude = json['latitude'];
//    longitude = json['longitude'];
//    fcmToken = json['fcmToken'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['phoneNumber'] = this.phoneNumber;
//    data['customerName'] = this.customerName;
//    data['address'] = this.address;
//    data['pincode'] = this.pincode;
//    data['latitude'] = this.latitude;
//    data['longitude'] = this.longitude;
//    data['fcmToken'] = this.fcmToken;
//    return data;
//  }
//}
class GetProfileResponse {
  CUSTOMER cUSTOMER;

  GetProfileResponse({this.cUSTOMER});

  GetProfileResponse.fromJson(Map<String, dynamic> json) {
    cUSTOMER = json['CUSTOMER'] != null
        ? new CUSTOMER.fromJson(json['CUSTOMER'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cUSTOMER != null) {
      data['CUSTOMER'] = this.cUSTOMER.toJson();
    }
    return data;
  }
}

class CUSTOMER {
  Data data;
  String token;
  String role;

  CUSTOMER({this.data, this.token, this.role});

  CUSTOMER.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    token = json['token'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['token'] = this.token;
    data['role'] = this.role;
    return data;
  }
}
