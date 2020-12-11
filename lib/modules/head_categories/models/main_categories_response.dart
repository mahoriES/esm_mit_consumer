class HomePageCategoryResponse {

  String categoryName;
  String categoryDescription;
  String categoryImageUrl;
  int categoryId;

  HomePageCategoryResponse({this.categoryName, this.categoryDescription,
    this.categoryImageUrl, this.categoryId});

  HomePageCategoryResponse.fromJson(Map<String, dynamic> json) {
    categoryName = json['name'] ?? '';
    categoryDescription = json['desc'] ?? '';
    categoryId = json['bcat'];
    if (json['image'] != null && json['image'] is Map<String, dynamic>)
      categoryImageUrl = json['image']['photo_url'];
  }
}

class HomePageCategoriesResponse {

  List<HomePageCategoryResponse> catalogCategories;

  HomePageCategoriesResponse({this.catalogCategories});

  HomePageCategoriesResponse.fromJson(Map<String, dynamic> json) {
    if (json['product'] != null && json['product'] is List) {
      var categoriesResponseList = List.from(json['product']);
      catalogCategories = List<HomePageCategoryResponse>();
      categoriesResponseList.forEach((element) {
        catalogCategories.add(HomePageCategoryResponse.fromJson(element));
      });
    }
  }
}

