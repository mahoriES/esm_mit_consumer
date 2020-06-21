class UpdateProfile {
  String role;
  String profileName;
  ProfilePic profilePic;

  UpdateProfile({this.profileName, this.profilePic, this.role});

  UpdateProfile.fromJson(Map<String, dynamic> json) {
    profileName = json['profile_name'];
    role = json['role'];
    profilePic = json['profile_pic'] != null
        ? new ProfilePic.fromJson(json['profile_pic'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['profile_name'] = this.profileName;
    data['role'] = "CUSTOMER";
    if (this.profilePic != null) {
      data['profile_pic'] = this.profilePic.toJson();
    }
    return data;
  }
}

class ImageResponse {
  String photoId;
  String photoUrl;
  String contentType;

  ImageResponse({this.photoId, this.photoUrl, this.contentType});

  ImageResponse.fromJson(Map<String, dynamic> json) {
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

class UpdatedProfile {
  Data data;
  String token;
  String role;

  UpdatedProfile({this.data, this.token, this.role});

  UpdatedProfile.fromJson(Map<String, dynamic> json) {
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

class GetProfile {
  Data data;
  String token;
  String role;

  GetProfile({this.data, this.token, this.role});

  GetProfile.fromJson(Map<String, dynamic> json) {
    data =
        json['CUSTOMER'] != null ? new Data.fromJson(json['CUSTOMER']) : null;
    token = json['token'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['CUSTOMER'] = this.data.toJson();
    }
    data['token'] = this.token;
    data['role'] = this.role;
    return data;
  }
}

class Data {
  UserProfile userProfile;
  ImageResponse profilePic;
  String profileName;
  String created;
  String modified;
  bool isSuspended;

  Data(
      {this.userProfile,
      this.profilePic,
      this.profileName,
      this.created,
      this.modified,
      this.isSuspended});

  Data.fromJson(Map<String, dynamic> json) {
    userProfile = json['user_profile'] != null
        ? new UserProfile.fromJson(json['user_profile'])
        : null;
    profilePic = json['profile_pic'] != null
        ? new ImageResponse.fromJson(json['profile_pic'])
        : null;
    profileName = json['profile_name'];
    created = json['created'];
    modified = json['modified'];
    isSuspended = json['is_suspended'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userProfile != null) {
      data['user_profile'] = this.userProfile.toJson();
    }
    if (this.profilePic != null) {
      data['profile_pic'] = this.profilePic.toJson();
    }
    data['profile_name'] = this.profileName;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['is_suspended'] = this.isSuspended;
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

class ProfilePicModel {
  String photoId;
  String photoUrl;
  String contentType;

  ProfilePicModel({this.photoId, this.photoUrl, this.contentType});

  ProfilePicModel.fromJson(Map<String, dynamic> json) {
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

class AddAddress {
  String addressName;
  String prettyAddress;
  double lat;
  double lon;
  GeoAddr geoAddr;

  AddAddress(
      {this.addressName, this.prettyAddress, this.lat, this.lon, this.geoAddr});

  AddAddress.fromJson(Map<String, dynamic> json) {
    addressName = json['address_name'];
    prettyAddress = json['pretty_address'];
    lat = json['lat'];
    lon = json['lon'];
    geoAddr = json['geo_addr'] != null
        ? new GeoAddr.fromJson(json['geo_addr'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_name'] = this.addressName;
    data['pretty_address'] = this.prettyAddress;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    if (this.geoAddr != null) {
      data['geo_addr'] = this.geoAddr.toJson();
    }
    return data;
  }
}

class GeoAddr {
  String pincode;
  String city;

  GeoAddr({this.pincode, this.city});

  GeoAddr.fromJson(Map<String, dynamic> json) {
    pincode = json['pincode'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pincode'] = this.pincode;
    data['city'] = this.city;
    return data;
  }
}

class ProfilePic {
  String photoId;

  ProfilePic({this.photoId});

  ProfilePic.fromJson(Map<String, dynamic> json) {
    photoId = json['photo_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo_id'] = this.photoId;
    return data;
  }
}
