class MerchantSearchResponse {
  List<Merchants> merchants;
  int statusCode;
  String status;

  MerchantSearchResponse({this.merchants, this.statusCode, this.status});

  MerchantSearchResponse.fromJson(Map<String, dynamic> json) {
    if (json['merchants'] != null) {
      merchants = new List<Merchants>();
      json['merchants'].forEach((v) {
        merchants.add(new Merchants.fromJson(v));
      });
    } else {
      merchants = [];
    }
    statusCode = json['statusCode'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.merchants != null) {
      data['merchants'] = this.merchants.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    return data;
  }
}

class MerchantLocal {
  String shopName;
  String displayPicture;
  String cardViewLine2;
  String flag;
  String merchantID;
  String address1;
  String address2;
  MerchantLocal(
      {this.shopName,
      this.displayPicture,
      this.cardViewLine2,
      this.address1,
      this.address2,
      this.flag,
      this.merchantID});

  MerchantLocal.fromJson(Map<String, dynamic> json) {
    shopName = json['shopName'];
    displayPicture = json['displayPicture'];
    cardViewLine2 = json['cardViewLine2'];
    flag = json['flag'];
    merchantID = json['merchantID'];
    address1 = json['address1'];
    address2 = json['address2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shopName'] = this.shopName;
    data['displayPicture'] = this.displayPicture;
    data['cardViewLine2'] = this.cardViewLine2;
    data['flag'] = this.flag;
    data['merchantID'] = this.merchantID;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    return data;
  }
}

class Merchants {
  Address address;
  String merchantID;
  List<String> secondaryPhoneNumbers;
  String openTime;
  String closeTime;
  String displayPicture;
  String shopName;
  String cardViewLine2;
  String ownerName;
  List<String> flags;
  String noticeToCustomers;
  List<String> servicesOffered;
  List<String> serviceSpecificData;
  List<Categories> categories;

  Merchants({
    this.address,
    this.merchantID,
    this.secondaryPhoneNumbers,
    this.openTime,
    this.closeTime,
    this.displayPicture,
    this.shopName,
    this.cardViewLine2,
    this.ownerName,
    this.flags,
    this.noticeToCustomers,
    this.servicesOffered,
    this.serviceSpecificData,
    this.categories,
  });

  Merchants.fromJson(Map<String, dynamic> json) {
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    merchantID = json['merchantID'];
    if (json['secondaryPhoneNumbers'] != null) {
      secondaryPhoneNumbers = json['secondaryPhoneNumbers'].cast<String>();
    }
    openTime = json['openTime'];
    closeTime = json['closeTime'];
    displayPicture = json['displayPicture'];
    shopName = json['shopName'];
    cardViewLine2 = json['cardViewLine2'];
    ownerName = json['ownerName'];
    if (json['flags'] != null) {
      flags = json['flags'].cast<String>();
    }
    noticeToCustomers = json['noticeToCustomers'];
    if (json['servicesOffered'] != null) {
      servicesOffered = json['servicesOffered'].cast<String>();
    } else {
      servicesOffered = [];
    }
    serviceSpecificData = json['serviceSpecificData'];
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['merchantID'] = this.merchantID;
    data['secondaryPhoneNumbers'] = this.secondaryPhoneNumbers;
    data['openTime'] = this.openTime;
    data['closeTime'] = this.closeTime;
    data['displayPicture'] = this.displayPicture;
    data['shopName'] = this.shopName;
    data['cardViewLine2'] = this.cardViewLine2;
    data['ownerName'] = this.ownerName;
    data['flags'] = this.flags;
    data['noticeToCustomers'] = this.noticeToCustomers;
    data['servicesOffered'] = this.servicesOffered;
    data['serviceSpecificData'] = this.serviceSpecificData;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Address {
  String addressLine1;
  String addressLine2;
  String latitude;
  String longitude;
  String name;
  String area;
  String formattedAddress;

  Address(
      {this.addressLine1,
      this.addressLine2,
      this.latitude,
      this.longitude,
      this.name,
      this.area,
      this.formattedAddress});

  Address.fromJson(Map<String, dynamic> json) {
    if (json['tags'] != null) {
      addressLine1 = json['addressLine1'];
      addressLine2 = json['addressLine2'];
      latitude = json['latitude'];
      longitude = json['longitude'];

      name = json['name'];
      area = json['area'];
      formattedAddress = json['formattedAddress'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;

    data['name'] = this.name;
    data['area'] = this.area;
    data['formattedAddress'] = this.formattedAddress;
    return data;
  }
}

class Categories {
  String id;
  String name;
  String description;
  String imageLink;

  Categories({this.id, this.name, this.description, this.imageLink});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageLink = json['imageLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['imageLink'] = this.imageLink;
    return data;
  }
}
