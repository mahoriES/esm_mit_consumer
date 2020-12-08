class AddressTags {
  static const List<String> tagList = ["Home", "Work", "Other"];
}

class AddressRequest {
  String addressName;
  String prettyAddress;
  double lat;
  double lon;
  GeoAddr geoAddr;

  AddressRequest(
      {this.addressName, this.prettyAddress, this.lat, this.lon, this.geoAddr});

  AddressRequest.fromJson(Map<String, dynamic> json) {
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

  copyWith({
    String addressName,
    String prettyAddress,
    double lat,
    double lon,
    GeoAddr geoAddr,
  }) {
    return AddressRequest(
      addressName: addressName ?? this.addressName,
      prettyAddress: prettyAddress ?? this.prettyAddress,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      geoAddr: geoAddr ?? this.geoAddr,
    );
  }
}

class GeoAddr {
  String pincode;
  String city;
  String landmark;
  String house;

  GeoAddr({this.pincode, this.city, this.house, this.landmark});

  GeoAddr.fromJson(Map<String, dynamic> json) {
    pincode = json['pincode'];
    city = json['city'];
    landmark = json['landmark'];
    house = json['house'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pincode'] = this.pincode;
    data['city'] = this.city;
    data['landmark'] = this.landmark;
    data['house'] = this.house;
    return data;
  }

  copyWith({
    String pincode,
    String city,
    String landmark,
    String house,
  }) {
    return GeoAddr(
      pincode: pincode ?? this.pincode,
      city: city ?? this.city,
      landmark: landmark ?? this.landmark,
      house: house ?? this.house,
    );
  }
}

class AddressResponse {
  String addressId;
  String addressName;
  String prettyAddress;
  LocationPoint locationPoint;
  GeoAddr geoAddr;

  AddressResponse(
      {this.addressId,
      this.addressName,
      this.prettyAddress,
      this.locationPoint,
      this.geoAddr});

  AddressResponse.fromJson(Map<String, dynamic> json) {
    addressId = json['address_id'];
    addressName = json['address_name'];
    prettyAddress = json['pretty_address'];
    locationPoint = json['location_point'] != null
        ? new LocationPoint.fromJson(json['location_point'])
        : null;
    geoAddr = json['geo_addr'] != null
        ? new GeoAddr.fromJson(json['geo_addr'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_id'] = this.addressId;
    data['address_name'] = this.addressName;
    data['pretty_address'] = this.prettyAddress;
    if (this.locationPoint != null) {
      data['location_point'] = this.locationPoint.toJson();
    }
    if (this.geoAddr != null) {
      data['geo_addr'] = this.geoAddr.toJson();
    }
    return data;
  }
}

class LocationPoint {
  double lon;
  double lat;

  LocationPoint({this.lon, this.lat});

  LocationPoint.fromJson(Map<String, dynamic> json) {
    lon = json['lon'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    return data;
  }
}
