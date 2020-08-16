class CategoryResponse {
  List<CategoriesNew> categories;

  CategoryResponse({this.categories});

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = new List<CategoriesNew>();
      json['categories'].forEach((v) {
        categories.add(new CategoriesNew.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoriesNew {
  int categoryId;
  String categoryName;
  String categoryDescription;
  int parentCategoryId;
  bool isActive;
  List<Images> images;

  CategoriesNew(
      {this.categoryId,
      this.categoryName,
      this.categoryDescription,
      this.parentCategoryId,
      this.isActive,
      this.images});

  CategoriesNew.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    isActive = json['is_active'];
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    categoryDescription = json['category_description'];
    parentCategoryId = json['parent_category_id'];
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
