import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';

class GetBusinessesResponse {
  int count;
  String next;
  String previous;
  List<Business> results;

  GetBusinessesResponse({this.count, this.results});

  GetBusinessesResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = new List<Business>();
      json['results'].forEach((v) {
        results.add(new Business.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Business {
  String businessId;
  String businessName;
  String itemsCount;
  bool isOpen;
  bool isBookmarked;
  AddressNew address;
  String description;
  List<Photo> images;
  List<String> phones;

  ///A custom notice (merchant note) added optionally by merchant to convey important information
  ///e.g. Raining heavily, orders will be delayed etc. This value be null
  String notice;

  bool hasDelivery;
  List<OrderItems> previouslyOrderedItems;
  List<CategoriesNew> augmentedCategories;

  Business(
      {this.businessId,
      this.businessName,
      this.isOpen,
      this.isBookmarked,
      this.itemsCount,
      this.address,
      this.description,
      this.notice,
      this.augmentedCategories,
      this.images,
      this.phones,
      this.previouslyOrderedItems,
      this.hasDelivery});

  Business.fromJson(Map<String, dynamic> json) {
    itemsCount = json['items_count'];
    businessId = json['business_id'];
    isBookmarked = json['bookmark'];
    businessName = json['business_name'];
    description = json['description'];
    isOpen = json['is_open'];
    address = json['address'] != null
        ? new AddressNew.fromJson(json['address'])
        : null;
    if (json['images'] != null) {
      images = new List<Photo>();
      json['images'].forEach((v) {
        images.add(new Photo.fromJson(v));
      });
    }
    if (json['notice'] != null)
      notice = json['notice'].toString();
    phones = json['phones'] != null ? json['phones'].cast<String>() : [];
    hasDelivery = json['has_delivery'];
    if (json['ag_orderitems'] != null && json['ag_orderitems'] is List) {
      previouslyOrderedItems = List<OrderItems>();
      json['ag_orderitems'].forEach((v) {
        previouslyOrderedItems.add(OrderItems.fromJson(v));
      });
    }
    if (json['ag_cat'] != null && json['ag_cat'] is List) {
      augmentedCategories = List<CategoriesNew>();
      json['ag_cat'].forEach((v){
        augmentedCategories.add(CategoriesNew.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['business_name'] = this.businessName;
    data['description'] = this.description;
    data['bookmark'] = this.isBookmarked;
    data['is_open'] = this.isOpen;
    data['items_count'] = this.itemsCount;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.notice != null)
      data['notice'] = this.notice;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    data['phones'] = this.phones;
    data['has_delivery'] = this.hasDelivery;
    return data;
  }

  Business.clone(Business business) : this(
      businessId: business.businessId,
      isBookmarked: business.isBookmarked,
      businessName: business.businessName,
      itemsCount: business.itemsCount,
      isOpen: business.isOpen,
      address: business.address,
      description: business.description,
      images: business.images,
      notice: business.notice,
      hasDelivery: business.hasDelivery,
      phones: business.phones,
      augmentedCategories: business.augmentedCategories,
      previouslyOrderedItems: business.previouslyOrderedItems
  );

}

class AddressNew {
  String prettyAddress;
  LocationPoint locationPoint;

  AddressNew({this.prettyAddress, this.locationPoint});

  AddressNew.fromJson(Map<String, dynamic> json) {
    prettyAddress = json['pretty_address'];
    locationPoint = json['location_point'] != null
        ? new LocationPoint.fromJson(json['location_point'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pretty_address'] = this.prettyAddress;
    if (this.locationPoint != null) {
      data['location_point'] = this.locationPoint.toJson();
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
  AddressNew address;
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
    address = json['address'] != null
        ? new AddressNew.fromJson(json['address'])
        : null;
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

class Categories {
  int categoryId;
  String categoryName;
  String categoryDescription;
  Null parentCategoryId;
  bool isActive;
  List<Images> images;

  Categories(
      {this.categoryId,
      this.categoryName,
      this.categoryDescription,
      this.parentCategoryId,
      this.isActive,
      this.images});

  Categories.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryDescription = json['category_description'];
    parentCategoryId = json['parent_category_id'];
    isActive = json['is_active'];
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['category_description'] = this.categoryDescription;
    data['parent_category_id'] = this.parentCategoryId;
    data['is_active'] = this.isActive;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String photoId;
  String photoUrl;
  String contentType;

  Images({this.photoId, this.photoUrl, this.contentType});

  Images.fromJson(Map<String, dynamic> json) {
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
