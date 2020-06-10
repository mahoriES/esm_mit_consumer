import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/home/models/merchant_response.dart';
import 'package:meta/meta.dart';

class HomePageState {
  final LoadingStatus loadingStatus;
  final List<Merchants> merchants;
  final String homePageLoadedDate;
  final int currentIndex;
  final List<String> banners;

  HomePageState(
      {@required this.currentIndex,
      @required this.loadingStatus,
      @required this.merchants,
      @required this.homePageLoadedDate,
      @required this.banners});

//  static HomePageState fromJson(dynamic json) =>
//      HomePageState(homePageLoadedDate: json["homePageLoadedDate"]);
//
//  dynamic toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['homePageLoadedDate'] = this.homePageLoadedDate;
//    return data;
//  }

  factory HomePageState.initial() {
    return new HomePageState(
      loadingStatus: LoadingStatus.success,
      merchants: [],
      homePageLoadedDate: "0",
      currentIndex: 0,
      banners: <String>[],
    );
  }

  HomePageState copyWith(
      {LoadingStatus loadingStatus,
      List<Merchants> merchants,
      List<String> banners,
      int currentIndex,
      String homePageLoadedDate}) {
    return new HomePageState(
        currentIndex: currentIndex ?? this.currentIndex,
        loadingStatus: loadingStatus ?? this.loadingStatus,
        merchants: merchants ?? this.merchants,
        homePageLoadedDate: homePageLoadedDate ?? this.homePageLoadedDate,
        banners: banners ?? this.banners);
  }
}
