import 'package:eSamudaay/modules/head_categories/models/main_categories_response.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';

class BannersWithPointerResponse {
  // List of promotion banners.
  List<Main> main;
  // cluster specific banner.
  Top top;

  BannersWithPointerResponse({this.main, this.top});

  BannersWithPointerResponse.fromJson(Map<String, dynamic> json) {
    if (json['main'] != null) {
      main = new List<Main>();
      json['main'].forEach((v) {
        main.add(new Main.fromJson(v));
      });
    }
    top = json['top'] != null ? new Top.fromJson(json['top']) : null;
  }
}

class Main {
  // banner format can ne image or video.
  // For now only image is supported.
  String bannerFormat;
  // banner image object containing id, url and content-type
  Photo media;
  // banner pointer consists data to redirect user to specific screen when tapped.
  BannerPointer bannerPointer;

  Main({this.bannerFormat, this.media, this.bannerPointer});

  Main.fromJson(Map<String, dynamic> json) {
    bannerFormat = json['banner_format'];
    media = json['media'] != null ? new Photo.fromJson(json['media']) : null;
    bannerPointer = json['banner_pointer'] != null
        ? new BannerPointer.fromJson(json['banner_pointer'])
        : null;
  }
}

class BannerPointer {
  // For now, only supported type is bCat. This can vary for future usecases.
  String type;
  // contains data for bCat.
  Meta meta;

  BannerPointer({this.type, this.meta});

  BannerPointer.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }
}

class Meta {
  List<HomePageCategoryResponse> bcats;

  Meta({this.bcats});

  Meta.fromJson(Map<String, dynamic> json) {
    if (json['bcats'] != null) {
      bcats = new List<HomePageCategoryResponse>();
      json['bcats'].forEach((v) {
        bcats.add(new HomePageCategoryResponse.fromJson(v));
      });
    }
  }
}

class Top {
  String bannerFormat;
  Photo media;

  Top({this.bannerFormat, this.media});

  Top.fromJson(Map<String, dynamic> json) {
    bannerFormat = json['banner_format'];
    media = json['media'] != null ? new Photo.fromJson(json['media']) : null;
  }
}
