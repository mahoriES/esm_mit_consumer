import 'package:eSamudaay/modules/register/model/register_request_model.dart';

class CatalogSearchRequest {
  String merchantID;
  List<String> categoryIDs;

  CatalogSearchRequest({this.merchantID, this.categoryIDs});

  CatalogSearchRequest.fromJson(Map<String, dynamic> json) {
    merchantID = json['merchantID'];
    categoryIDs = json['categoryIDs'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.merchantID != null) {
      data['merchantID'] = this.merchantID;
    }
    if (this.categoryIDs != null) {
      data['categoryIDs'] = this.categoryIDs;
    }
    return data;
  }
}

//class CatalogSearchResponse {
//  List<Catalog> catalog;
//  int statusCode;
//  String status;
//  List<Products> products;
//
//  CatalogSearchResponse(
//      {this.catalog, this.statusCode, this.status, this.products});
//
//  CatalogSearchResponse.fromJson(Map<String, dynamic> json) {
//    if (json['catalog'] != null) {
//      catalog = new List<Catalog>();
//      json['catalog'].forEach((v) {
//        catalog.add(new Catalog.fromJson(v));
//      });
//    }
//    if (json['products'] != null) {
//      products = new List<Products>();
//      json['products'].forEach((v) {
//        products.add(new Products.fromJson(v));
//      });
//    }
//    statusCode = json['statusCode'];
//    status = json['status'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    if (this.catalog != null) {
//      data['catalog'] = this.catalog.map((v) => v.toJson()).toList();
//    }
//    data['statusCode'] = this.statusCode;
//    data['status'] = this.status;
//    return data;
//  }
//}
//
//class Catalog {
//  String type;
//  String id;
//  String name;
//  List<Products> products;
//
//  Catalog({this.type, this.id, this.name, this.products});
//
//  Catalog.fromJson(Map<String, dynamic> json) {
//    type = json['type'];
//    id = json['id'];
//    name = json['name'];
//    if (json['products'] != null) {
//      products = new List<Products>();
//      json['products'].forEach((v) {
//        products.add(new Products.fromJson(v));
//      });
//    }
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['type'] = this.type;
//    data['id'] = this.id;
//    data['name'] = this.name;
//    if (this.products != null) {
//      data['products'] = this.products.map((v) => v.toJson()).toList();
//    }
//    return data;
//  }
//}
//
//class Products {
//  String entryID;
//  List<String> parentIDs;
//  String merchantID;
//  String entryName;
//  String description;
//  String entryType;
//  Product product;
//
//  Products(
//      {this.entryID,
//      this.parentIDs,
//      this.merchantID,
//      this.entryName,
//      this.description,
//      this.entryType,
//      this.product});
//
//  Products.fromJson(Map<String, dynamic> json) {
//    entryID = json['entryID'];
//    parentIDs = json['parentIDs'].cast<String>();
//    merchantID = json['merchantID'];
//    entryName = json['entryName'];
//    description = json['description'];
//    entryType = json['entryType'];
//    product =
//        json['product'] != null ? new Product.fromJson(json['product']) : null;
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['entryID'] = this.entryID;
//    data['parentIDs'] = this.parentIDs;
//    data['merchantID'] = this.merchantID;
//    data['entryName'] = this.entryName;
//    data['description'] = this.description;
//    data['entryType'] = this.entryType;
//    if (this.product != null) {
//      data['product'] = this.product.toJson();
//    }
//    return data;
//  }
//}
//
//class Product {
//  String service;
////  Specs specs;
//  String name;
//  double price;
//  String category;
//  String id;
//  String skuSize;
//  String imageLink;
//  String restockingAt;
//  int count;
//
//  Product(
//      {this.service,
//      this.name,
//      this.price,
//      this.category,
//      this.id,
//      this.imageLink,
//      this.restockingAt,
//      this.count,
//      this.skuSize});
//
//  Product.fromJson(Map<String, dynamic> json) {
//    skuSize = json['skuSize'];
////    specs = json['specs'] != null ? new Specs.fromJson(json['specs']) : null;
//    name = json['name'];
//    price = json['price'];
////    category = json['category'];
//    id = json['id'];
//    imageLink = json['imageLink'];
//    restockingAt = json['restockingAt'];
//    count = json['count'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
////    data['service'] = this.service;
////    if (this.specs != null) {
////      data['specs'] = this.specs.toJson();
////    }
//    data['name'] = this.name;
//    data['price'] = this.price;
////    data['category'] = this.category;
//    data['id'] = this.id;
//    data['imageLink'] = this.imageLink;
//    data['restockingAt'] = this.restockingAt;
//    data['count'] = this.count;
//    return data;
//  }
//}

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
      this.selectedVariant});

  Product.fromJson(Map<String, dynamic> json) {
    selectedVariant = 0;
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_description'] = this.productDescription;
    data['is_active'] = this.isActive;
    data['in_stock'] = this.inStock;
    data['images'] = this.images.map((e) => e.toJson()).toList();
    data['long_description'] = this.longDescription;
    data['display_line_1'] = this.displayLine1;
    data['unit_name'] = this.unitName;
    if (this.possibleVariations != null) {
      data['possible_variations'] = this.possibleVariations.toJson();
    }
    if (this.skus != null) {
      data['skus'] = this.skus.map((v) => v.toJson()).toList();
    }
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
