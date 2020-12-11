import 'package:eSamudaay/modules/head_categories/models/main_categories_response.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:flutter/material.dart';

class LandingPageComponentsState {
  final HomePageCategoriesResponse homePageCategories;
  final HomePageCategoryResponse selectedCategory;
  final List<Business> previouslyBoughtBusinesses;
  final List<Business> previouslyBoughtBusinessUnderSelectedCategory;
  final List<Business> businessesUnderSelectedCategory;

  const LandingPageComponentsState(
      {@required this.homePageCategories,
      @required this.selectedCategory,
      @required this.businessesUnderSelectedCategory,
      @required this.previouslyBoughtBusinessUnderSelectedCategory,
      @required this.previouslyBoughtBusinesses});

  factory LandingPageComponentsState.initial() {
    return LandingPageComponentsState(
        previouslyBoughtBusinesses: [],
        previouslyBoughtBusinessUnderSelectedCategory: [],
        businessesUnderSelectedCategory: [],
        selectedCategory: null,
        homePageCategories: HomePageCategoriesResponse(catalogCategories: []));
  }

  LandingPageComponentsState copyWith(
      {HomePageCategoriesResponse homePageCategories,
      List<Business> previouslyBoughtBusinesses,
      List<Business> previouslyBoughtBusinessUnderSelectedCategory,
      List<Business> businessesUnderSelectedCategory,
      HomePageCategoryResponse selectedCategory}) {
    return LandingPageComponentsState(
        previouslyBoughtBusinessUnderSelectedCategory:
            previouslyBoughtBusinessUnderSelectedCategory ??
                this.previouslyBoughtBusinessUnderSelectedCategory,
        businessesUnderSelectedCategory: businessesUnderSelectedCategory ??
            this.businessesUnderSelectedCategory,
        previouslyBoughtBusinesses:
            previouslyBoughtBusinesses ?? this.previouslyBoughtBusinesses,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        homePageCategories: homePageCategories ?? this.homePageCategories);
  }
}
