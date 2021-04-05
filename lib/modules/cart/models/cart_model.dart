import 'dart:math';
import 'package:eSamudaay/modules/cart/models/charge_details_response.dart';
import 'package:eSamudaay/modules/orders/models/order_models.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeliveryType {
  static const String DeliveryToHome = "DA_DELIVERY";
  static const String StorePickup = "SELF_PICK_UP";
}

class ProductStatus {
  static const String Available = "IS_AVAILABLE";
  static const String NotAvailable = "NOT_IN_STOCK";
}

class FreeFormItemStatus {
  static const String Added = "FREE_FORM_ADDED";
  static const String NotAdded = "FREE_FORM_NOT_ADDED";
}

class ItemsEnhanced {
  Product item;
  int number;

  ItemsEnhanced({this.item, this.number});

  ItemsEnhanced.fromJson(Map<String, dynamic> json) {
    item = json['item'] != null ? new Product.fromJson(json['item']) : null;
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.item != null) {
      data['item'] = this.item.toJson();
    }
    data['number'] = this.number;
    return data;
  }
}

class PlaceOrderRequest {
  String businessId;
  String deliveryType;
  List<OrderItems> orderItems;
  List<FreeFormOrderItems> freeFormOrderItems;
  String deliveryAddressId;
  String customerNote;
  List<Photo> customerNoteImages;

  PlaceOrderRequest(
      {this.businessId,
      this.deliveryType,
      this.orderItems,
      this.customerNoteImages,
      this.freeFormOrderItems,
      this.deliveryAddressId,
      this.customerNote});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['delivery_type'] = this.deliveryType;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems.map((v) => v.toJson()).toList();
    }
    if (this.freeFormOrderItems != null) {
      data['free_form_items'] =
          this.freeFormOrderItems.map((e) => e.toJson()).toList();
    }
    data['delivery_address_id'] = this.deliveryAddressId;
    data['customer_note'] = this.customerNote;
    if (this.customerNoteImages != null)
      data['customer_note_images'] =
          this.customerNoteImages.map((v) => v.toJson()).toList();

    return data;
  }
}

class PlaceOrderResponse {
  String orderId;
  String orderShortNumber;
  String businessId;
  String deliveryType;
  String orderStatus;
  double itemTotal;
  double otherCharges;
  double deliveryCharges;
  double orderTotal;
  List<BusinessImages> businessImages;
  String businessName;
  String clusterName;
  String customerName;
  PickupAddress pickupAddress;
  PickupAddress deliveryAdress;
  List<String> businessPhones;
  List<String> customerPhones;
  List<OrderItems> orderItems;
  List<FreeFormOrderItems> freeFormOrderItems;
  CartCharges otherChargesDetail;
  List<OrderTrail> orderTrail;
  List<Photo> customerNoteImages;
  String created;
  String modified;
  Rating rating;
  PaymentInfo paymentInfo;
  String cancellationNote;
  int itemsCount;
  List<CpInfo> cpInfo;
  String customerCancelBefore;

  PlaceOrderResponse({
    this.deliveryCharges,
    this.orderId,
    this.customerNoteImages,
    this.freeFormOrderItems,
    this.paymentInfo,
    this.orderShortNumber,
    this.deliveryType,
    this.orderStatus,
    this.itemTotal,
    this.otherCharges,
    this.orderTotal,
    this.businessImages,
    this.businessName,
    this.clusterName,
    this.customerName,
    this.pickupAddress,
    this.deliveryAdress,
    this.businessPhones,
    this.customerPhones,
    this.orderItems,
    this.otherChargesDetail,
    this.orderTrail,
    this.created,
    this.modified,
    this.rating,
    this.businessId,
    this.cancellationNote,
    this.itemsCount,
    this.cpInfo,
    this.customerCancelBefore,
  });

  PlaceOrderResponse.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    businessId = json['business_id'];
    orderShortNumber = json['order_short_number'];
    deliveryType = json['delivery_type'];
    orderStatus = json['order_status'];
    itemTotal = json['item_total'] != null
        ? double.parse(json['item_total'].toString())
        : json['item_total'];
    otherCharges = json['other_charges'] != null
        ? double.parse(json['other_charges'].toString())
        : json['other_charges'];
    deliveryCharges = json['delivery_charges'] != null
        ? double.parse(json['delivery_charges'].toString())
        : json['delivery_charges'];
    orderTotal = json['order_total'] != null
        ? double.parse(json['order_total'].toString())
        : json['order_total'];
    if (json['business_images'] != null) {
      businessImages = new List<BusinessImages>();
      json['business_images'].forEach((v) {
        businessImages.add(BusinessImages.fromJson(v));
      });
    }
    businessName = json['business_name'];
    clusterName = json['cluster_name'];
    customerName = json['customer_name'];
    paymentInfo = json['payment_info'] != null
        ? new PaymentInfo.fromJson(json['payment_info'])
        : null;
    pickupAddress = json['pickup_address'] != null
        ? new PickupAddress.fromJson(json['pickup_address'])
        : null;
    deliveryAdress = json['delivery_address'] != null
        ? new PickupAddress.fromJson(json['delivery_address'])
        : null;
    if (json['business_phones'] != null) {
      businessPhones = json['business_phones'].cast<String>();
    }

    if (json['customer_phones'] != null) {
      customerPhones = json['customer_phones'].cast<String>();
    }
    if (json['order_items'] != null) {
      orderItems = new List<OrderItems>();
      json['order_items'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
    if (json['free_form_items'] != null) {
      freeFormOrderItems = new List<FreeFormOrderItems>();
      json['free_form_items'].forEach((v) {
        freeFormOrderItems.add(new FreeFormOrderItems.fromJson(v));
      });
    }
    if (json['other_charges_detail'] != null) {
      otherChargesDetail = CartCharges.fromJson(json['other_charges_detail']);
    }
    if (json['order_trail'] != null) {
      orderTrail = new List<OrderTrail>();
      json['order_trail'].forEach((v) {
        orderTrail.add(new OrderTrail.fromJson(v));
      });
    }
    if (json['customer_note_images'] != null) {
      customerNoteImages = [];
      List list = json['customer_note_images'];
      list.forEach((image) {
        debugPrint("image runtime type => ${image.runtimeType}");
        if (image is Map) {
          customerNoteImages.add(Photo.fromJson(image));
        } else if (image is String) {
          customerNoteImages.add(Photo(photoUrl: image));
        }
      });
    }
    created = json['created'];
    modified = json['modified'];
    rating =
        json['rating'] != null ? new Rating.fromJson(json['rating']) : null;
    cancellationNote = json["cancellation_note"] ?? "";
    itemsCount = json['items_count'];
    if (json['cp_info'] != null) {
      cpInfo = List<CpInfo>();
      json['cp_info'].forEach((v) {
        cpInfo.add(CpInfo.fromJson(v));
      });
    }
    customerCancelBefore = json["customer_cancel_before"];
  }

  String get createdTime => DateFormat('hh:mm a').format(
        DateTime.parse(this.created).toLocal(),
      );

  int get secondsLeftToCancel {
    if (this.customerCancelBefore == null) return 0;
    DateTime cancelBefore = DateTime.parse(this.customerCancelBefore).toLocal();
    return max(cancelBefore.difference(DateTime.now()).inSeconds, 0);
  }

  int get cancellationAllowedForSeconds {
    if (this.customerCancelBefore == null) return 0;
    DateTime cancelBefore = DateTime.parse(this.customerCancelBefore).toLocal();
    return max(
      cancelBefore
          .difference(DateTime.parse(this.modified).toLocal())
          .inSeconds,
      0,
    );
  }

  String get createdDate => DateFormat('d MMM yyyy').format(
        DateTime.parse(this.created).toLocal(),
      );

  String get businessContactNumber => this.businessPhones == null
      ? null
      : this.businessPhones.isEmpty
          ? null
          : this.businessPhones.first;

  String get businessImageUrl => this.businessImages == null
      ? null
      : this.businessImages.isEmpty
          ? null
          : this.businessImages.first.photoUrl;

  bool get isOrderAlreadyRated => this.rating.ratingValue != null;

  double get orderTotalPriceInRupees => (this.orderTotal ?? 0) / 100;
  double get itemTotalPriceInRupees => (this.itemTotal ?? 0) / 100;
  double get otherChargesInRupees => (this.otherCharges ?? 0) / 100;

  bool get isReadyToPickupByDA {
    return this.orderStatus == OrderState.READY_FOR_PICKUP &&
        this.deliveryType == DeliveryType.DeliveryToHome;
  }

  /// returns a string in form of "x Items , Y Lists" referring to number of products and lists in that order.
  String get totalCountString {
    int _productsCount = this.orderItems?.length ?? this.itemsCount ?? 0;
    int _customerNoteImagesCount = this.customerNoteImages?.length ?? 0;
    int _totalCount = _productsCount + _customerNoteImagesCount;
    if (_totalCount == 0) return "";
    return (_productsCount > 0
            ? ("$_productsCount " +
                tr("cart.${_productsCount > 1 ? 'items' : 'item'}"))
            : "") +
        ((_productsCount > 0 && _customerNoteImagesCount > 0) ? " , " : "") +
        (_customerNoteImagesCount > 0
            ? ("$_customerNoteImagesCount " +
                tr("cart.${_customerNoteImagesCount > 1 ? 'lists' : 'list'}"))
            : "") +
        " ";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['business_id'] = this.businessId;
    data['order_short_number'] = this.orderShortNumber;
    data['delivery_type'] = this.deliveryType;
    data['order_status'] = this.orderStatus;
    data['item_total'] = this.itemTotal;
    data['other_charges'] = this.otherCharges;
    data['delivery_charges'] = this.deliveryCharges;
    data['order_total'] = this.orderTotal;
    if (this.businessImages != null) {
      data['business_images'] =
          this.businessImages.map((v) => v.toJson()).toList();
    }
    data['business_name'] = this.businessName;
    data['cluster_name'] = this.clusterName;
    data['customer_name'] = this.customerName;
    if (this.pickupAddress != null) {
      data['pickup_address'] = this.pickupAddress.toJson();
    }
    if (this.deliveryAdress != null) {
      data['delivery_address'] = this.deliveryAdress.toJson();
    }
    data['business_phones'] = this.businessPhones;
    data['customer_phones'] = this.customerPhones;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems.map((v) => v.toJson()).toList();
    }
    if (this.freeFormOrderItems != null) {
      data['free_form_items'] =
          this.freeFormOrderItems.map((e) => e.toJson()).toList();
    }
    if (this.otherChargesDetail != null) {
      data['other_charges_detail'] = this.otherChargesDetail.toJson();
    }
    if (this.orderTrail != null) {
      data['order_trail'] = this.orderTrail.map((v) => v.toJson()).toList();
    }
    data['created'] = this.created;
    data['modified'] = this.modified;
    if (this.rating != null) {
      data['rating'] = this.rating.toJson();
    }
    if (this.paymentInfo != null) {
      data['payment_info'] = this.paymentInfo.toJson();
    }
    data["cancellation_note"] = this.cancellationNote;
    if (this.cpInfo != null) {
      data['cp_info'] = this.cpInfo.map((v) => v.toJson()).toList();
    }
    data['customer_cancel_before'] = this.customerCancelBefore;
    return data;
  }
}

class Rating {
  int ratingValue;
  String ratingComment;

  Rating({this.ratingValue, this.ratingComment});

  Rating.fromJson(Map<String, dynamic> json) {
    ratingValue = json['rating_value'];
    ratingComment = json['rating_comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating_value'] = this.ratingValue;
    data['rating_comment'] = this.ratingComment;
    return data;
  }
}

class BusinessImages {
  String photoId;
  String photoUrl;
  String contentType;

  BusinessImages({this.photoId, this.photoUrl, this.contentType});

  BusinessImages.fromJson(Map<String, dynamic> json) {
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

class PickupAddress {
  String addressId;
  String addressName;
  String prettyAddress;
  LocationPoint locationPoint;
  GeoAddr geoAddr;

  PickupAddress(
      {this.addressId,
      this.addressName,
      this.prettyAddress,
      this.locationPoint,
      this.geoAddr});

  PickupAddress.fromJson(Map<String, dynamic> json) {
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

  /// Returns a formatted string including houseNumer (if available) and landmark (if available) along with the actual address string.
  String get addressString {
    String _house = this.geoAddr?.house;
    String _landmark = this.geoAddr?.landmark;
    String _address = this.prettyAddress;

    return (_house == null ? "" : "$_house, ") +
        (_address ?? "") +
        (_landmark == null
            ? ""
            : ("\n" + "${tr('cart.landmark')} : $_landmark"));
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
}

class FreeFormOrderItems {
  String skuName;
  int quantity;
  String productStatus;

  FreeFormOrderItems({
    @required this.skuName,
    @required this.quantity,
    this.productStatus,
  });

  FreeFormOrderItems.fromJson(Map<String, dynamic> json) {
    skuName = json['sku_name'];
    quantity = json['quantity'];
    if (json['product_status'] != null) {
      productStatus = json['product_status'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sku_name'] = skuName;
    data['quantity'] = quantity;
    if (this.productStatus != null) {
      data['product_status'] = productStatus;
    }
    return data;
  }
}

class OrderItems {
  int skuId;
  int quantity;
  int unitPrice;
  String productName;
  String skuCode;
  List<Photo> images;
  String unitName;
  VariationOption variationOption;
  String productStatus;
  SkuCharges skuCharges;

  OrderItems(
      {this.skuId,
      this.quantity,
      this.unitPrice,
      this.productName,
      this.skuCode,
      this.images,
      this.productStatus,
      this.unitName,
      this.variationOption,
      this.skuCharges});

  OrderItems.fromJson(Map<String, dynamic> json) {
    skuId = json['sku_id'];
    quantity = json['quantity'];
    unitPrice = json['unit_price'];
    productName = json['product_name'];
    skuCode = json['sku_code'];
    if (json['images'] != null) {
      images = new List<Photo>();
      json['images'].forEach((v) {
        images.add(Photo.fromJson(v));
      });
    }
    productStatus = json['product_status'];
    unitName = json['unit_name'];
    variationOption = json['variation_option'] != null
        ? new VariationOption.fromJson(json['variation_option'])
        : null;
    skuCharges = json['sku_charges'] != null
        ? new SkuCharges.fromJson(json['sku_charges'])
        : null;
  }

  bool get hasImages => this.images != null && this.images.isNotEmpty;

  String get firstImageUrl => this.images == null || this.images.isEmpty
      ? ""
      : (this.images.first?.photoUrl ?? "");

  double get totalPriceOfItem {
    double _unitPriceInRupees = this.unitPrice / 100;
    return this.quantity * _unitPriceInRupees;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sku_id'] = this.skuId;
    data['quantity'] = this.quantity;
    data['unit_price'] = this.unitPrice;
    data['product_status'] = this.productStatus;
    data['product_name'] = this.productName;
    data['sku_code'] = this.skuCode;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    data['unit_name'] = this.unitName;
    if (this.variationOption != null) {
      data['variation_option'] = this.variationOption.toJson();
    }
    if (this.skuCharges != null) {
      data['sku_charges'] = this.skuCharges.toJson();
    }
    return data;
  }

  OrderItems.fromProductModel(Product data) {
    skuId = data.skus[data.selectedSkuIndex].skuId;
    quantity = data.count;
    unitPrice = (data.selectedSkuPrice * 100).toInt();
    productName = data.productName;
    skuCode = data.skus[data.selectedSkuIndex].skuCode;
    if (data.images != null) {
      images = new List<Photo>();
      data.images.forEach((v) {
        images.add(v);
      });
    }
    // productStatus = data.s;
    // unitName = json['unit_name'];
    // variationOption = json['variation_option'] != null
    //     ? new VariationOption.fromJson(json['variation_option'])
    //     : null;
    // skuCharges = json['sku_charges'] != null
    //     ? new SkuCharges.fromJson(json['sku_charges'])
    //     : null;
  }
}

class VariationOption {
  String size;

  VariationOption({this.size});

  VariationOption.fromJson(Map<String, dynamic> json) {
    size = json['Weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Weight'] = this.size;
    return data;
  }
}

class SkuCharges {
  int packing;
  int service;

  SkuCharges({this.packing, this.service});

  SkuCharges.fromJson(Map<String, dynamic> json) {
    packing = json['Packing'];
    service = json['Service'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Packing'] = this.packing;
    data['Service'] = this.service;
    return data;
  }
}

class OrderTrail {
  String eventName;
  EventInfo eventInfo;
  String created;

  OrderTrail({this.eventName, this.eventInfo, this.created});

  OrderTrail.fromJson(Map<String, dynamic> json) {
    eventName = json['event_name'];
    eventInfo = json['event_info'] != null
        ? new EventInfo.fromJson(json['event_info'])
        : null;
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_name'] = this.eventName;
    if (this.eventInfo != null) {
      data['event_info'] = this.eventInfo.toJson();
    }
    data['created'] = this.created;
    return data;
  }
}

class EventInfo {
  EventInfo.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class Cart {
  List<ItemsEnhanced> itemsEnhanced;
  String service;
  double total;

  Cart({this.itemsEnhanced, this.service, this.total});

  Cart.fromJson(Map<String, dynamic> json) {
    if (json['itemsEnhanced'] != null) {
      itemsEnhanced = new List<ItemsEnhanced>();
      json['itemsEnhanced'].forEach((v) {
        itemsEnhanced.add(new ItemsEnhanced.fromJson(v));
      });
    }
    service = json['service'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.itemsEnhanced != null) {
      data['itemsEnhanced'] =
          this.itemsEnhanced.map((v) => v.toJson()).toList();
    }
    data['service'] = this.service;
    data['total'] = this.total;
    return data;
  }
}

class CpInfo {
  String phone;
  String profileName;
  bool isSuspended;

  CpInfo({this.phone, this.profileName, this.isSuspended});

  CpInfo.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    profileName = json['profile_name'];
    isSuspended = json['is_suspended'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['profile_name'] = this.profileName;
    data['is_suspended'] = this.isSuspended;
    return data;
  }
}
