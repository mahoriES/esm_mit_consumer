import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:meta/meta.dart';

class HomePageState {
  final GetBusinessesResponse response;
  final LoadingStatusApp loadingStatus;
  final List<Business> merchants;
  final String homePageLoadedDate;
  final int currentIndex;
  final List<Photo> banners;
  final Photo topBanner;

  HomePageState(
      {@required this.currentIndex,
      @required this.loadingStatus,
      @required this.merchants,
      @required this.topBanner,
      @required this.homePageLoadedDate,
      @required this.banners,
      this.response});


  factory HomePageState.initial() {
    return new HomePageState(
        loadingStatus: LoadingStatusApp.success,
        merchants: [],
        homePageLoadedDate: "0",
        currentIndex: 0,
        topBanner: Photo(),
        banners: <Photo>[],
        response: GetBusinessesResponse());
  }

  HomePageState copyWith(
      {LoadingStatusApp loadingStatus,
      List<Business> merchants,
      List<Photo> banners,
      int currentIndex,
      Photo topBanner,
      String homePageLoadedDate,
      GetBusinessesResponse response}) {
    return new HomePageState(
        topBanner: topBanner ?? this.topBanner,
        currentIndex: currentIndex ?? this.currentIndex,
        loadingStatus: loadingStatus ?? this.loadingStatus,
        merchants: merchants ?? this.merchants,
        homePageLoadedDate: homePageLoadedDate ?? this.homePageLoadedDate,
        response: response ?? this.response,
        banners: banners ?? this.banners);
  }
}
