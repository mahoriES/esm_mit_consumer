import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:eSamudaay/utilities/extensions.dart';

class CatalogSearchResponse {
  int count;
  String next;
  String previous;
  List<Product> results;

  CatalogSearchResponse({this.count, this.results});

  CatalogSearchResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = new List<Product>();
      json['results'].forEach((v) {
        results.add(new Product.fromJson(v));
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

class JITProduct {
  int quantity;
  String itemName;

  JITProduct({
    this.quantity,
    this.itemName,
  });

  JITProduct.fromJson(Map<String, dynamic> json)
      : quantity = json['quantity'],
        itemName = json['itemName'];

  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        'itemName': itemName,
      };
}

class Product {
  int productId;
  int selectedVariant;
  String productName;
  String productDescription;
  bool isActive;
  bool inStock;
  List<Photo> images;
  String longDescription;
  String displayLine1;
  String unitName;
  int count;
  PossibleVariations possibleVariations;
  List<Skus> skus;
  int ratingVal;
  int ratingNum;
  bool spotlight;

  Product(
      {this.productId,
      this.productName,
      this.productDescription,
      this.isActive,
      this.inStock,
      this.count,
      this.images,
      this.longDescription,
      this.displayLine1,
      this.unitName,
      this.possibleVariations,
      this.skus,
      this.ratingVal,
      this.ratingNum,
      this.spotlight});

  Product.fromJson(Map<String, dynamic> json) {
    selectedVariant = json['selectedVariant'];
    count = json['count'];
    productId = json['product_id'];
    productName = json['product_name'];
    productDescription = json['product_description'];
    isActive = json['is_active'];
    inStock = json['in_stock'];
    if (json['images'] != null) {
      images = new List<Photo>();
      json['images'].forEach((e) {
        images.add(Photo.fromJson(e));
      });
//      images = json['images'].cast<String>();
    }
    longDescription = json['long_description'];
    displayLine1 = json['display_line_1'];
    unitName = json['unit_name'];
    possibleVariations = json['possible_variations'] != null
        ? new PossibleVariations.fromJson(json['possible_variations'])
        : null;
    if (json['skus'] != null) {
      skus = new List<Skus>();
      json['skus'].forEach((v) {
        skus.add(new Skus.fromJson(v));
      });
    }
    ratingVal = json['rating_val'] ?? 0;
    ratingNum = json['rating_num'] ?? 0;
    spotlight = json['spotlight'];
  }

  bool get hasRating => this.ratingNum != 0 && this.ratingVal != 0;

  String get getRatingValue =>
      (this.ratingVal / this.ratingNum).toStringAsFixed(1);

  Skus get _firstSku =>
      this.skus == null || this.skus.isEmpty ? null : this.skus.first;

  String get firstSkuWeight => _firstSku?.variationOptions?.weight ?? "";

  String get firstSkuPrice =>
      _firstSku?.basePrice?.paisaToRupee?.withRupeePrefix;

  String get firstImageUrl => this.images == null || this.images.isEmpty
      ? ""
      : (this.images.first?.photoUrl ?? "");

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['selectedVariant'] = this.selectedVariant;
    data['count'] = this.count;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_description'] = this.productDescription;
    data['is_active'] = this.isActive;
    data['in_stock'] = this.inStock;
    if (this.images != null) {
      data['images'] = this.images.map((e) => e.toJson()).toList();
    }
    data['long_description'] = this.longDescription;
    data['display_line_1'] = this.displayLine1;
    data['unit_name'] = this.unitName;
    if (this.possibleVariations != null) {
      data['possible_variations'] = this.possibleVariations.toJson();
    }
    if (this.skus != null) {
      data['skus'] = this.skus.map((v) => v.toJson()).toList();
    }
    data['rating_val'] = this.ratingVal;
    data['rating_num'] = this.ratingNum;
    data['spotlight'] = this.spotlight;
    return data;
  }
}

class PossibleVariations {
  List<String> size;

  PossibleVariations({this.size});

  PossibleVariations.fromJson(Map<String, dynamic> json) {
    size = json['Size'] != null ? json['Size'].cast<String>() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Size'] = this.size;
    return data;
  }
}

class Charges {
  int packing;
  int service;

  Charges({this.packing, this.service});

  Charges.fromJson(Map<String, dynamic> json) {
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

class Skus {
  int skuId;
  String skuCode;
  bool isActive;
  bool inStock;
  Charges charges;
  int basePrice;
  VariationOptions variationOptions;

  Skus(
      {this.skuId,
      this.skuCode,
      this.isActive,
      this.inStock,
      this.charges,
      this.basePrice,
      this.variationOptions});

  Skus.fromJson(Map<String, dynamic> json) {
    skuId = json['sku_id'];
    skuCode = json['sku_code'];
    isActive = json['is_active'];
    inStock = json['in_stock'];
    charges =
        json['charges'] != null ? new Charges.fromJson(json['charges']) : null;
    basePrice = json['base_price'];
    variationOptions = json['variation_options'] != null
        ? new VariationOptions.fromJson(json['variation_options'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sku_id'] = this.skuId;
    data['sku_code'] = this.skuCode;
    data['is_active'] = this.isActive;
    data['in_stock'] = this.inStock;
    if (this.charges != null) {
      data['charges'] = this.charges.toJson();
    }
    data['base_price'] = this.basePrice;
    if (this.variationOptions != null) {
      data['variation_options'] = this.variationOptions.toJson();
    }
    return data;
  }
}

class VariationOptions {
  String weight;

  VariationOptions({this.weight});

  VariationOptions.fromJson(Map<String, dynamic> json) {
    weight = json['Weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Weight'] = this.weight;
    return data;
  }
}
