import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:meta/meta.dart';

class HomePageState {
  final GetBusinessesResponse response;
  final LoadingStatusApp loadingStatus;
  final List<Business> merchants;
  ///This Map is a data structure which holds the master business lists
  ///All the businesses under Certain Category, Main Page Businesses, Previously bought
  ///under category etc. would be put in this structure, and used from here.
  ///For now, the bookmark button checks and updates the bookmark status for the
  ///businesses in this structure itself.
  ///
  /// Moving forward, merchnats would be segregated in list of Business IDs lists,
  /// and the actual [Business] would be grabbed from here.
  final Map<String, Business> businessDS;
  final String homePageLoadedDate;
  final int currentIndex;
  final List<Photo> banners;
  final Photo topBanner;

  HomePageState(
      {@required this.currentIndex,
      @required this.loadingStatus,
      @required this.merchants,
      @required this.businessDS,
      @required this.topBanner,
      @required this.homePageLoadedDate,
      @required this.banners,
      this.response});


  factory HomePageState.initial() {
    return new HomePageState(
        loadingStatus: LoadingStatusApp.success,
        merchants: [],
        homePageLoadedDate: "0",
        businessDS: Map<String, Business>(),
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
      Map<String, Business> businessDS,
      String homePageLoadedDate,
      GetBusinessesResponse response}) {
    return new HomePageState(
        topBanner: topBanner ?? this.topBanner,
        businessDS: businessDS ?? this.businessDS,
        currentIndex: currentIndex ?? this.currentIndex,
        loadingStatus: loadingStatus ?? this.loadingStatus,
        merchants: merchants ?? this.merchants,
        homePageLoadedDate: homePageLoadedDate ?? this.homePageLoadedDate,
        response: response ?? this.response,
        banners: banners ?? this.banners);
  }
}
