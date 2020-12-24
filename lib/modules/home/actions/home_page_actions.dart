import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/address/actions/address_actions.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/circles/actions/circle_picker_actions.dart';
import 'package:eSamudaay/modules/head_categories/actions/categories_action.dart';
import 'package:eSamudaay/modules/home/actions/video_feed_actions.dart';
import 'package:eSamudaay/modules/home/models/cluster.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/home/models/video_feed_response.dart';
import 'package:eSamudaay/modules/home/views/my_clusters_view.dart';
import 'package:eSamudaay/modules/login/actions/login_actions.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:eSamudaay/utilities/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dynamic_link_actions.dart';

class GetMerchantDetails extends ReduxAction<AppState> {
  final String getUrl;

  GetMerchantDetails({this.getUrl});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: getUrl,
        params: {
          "cluster_id": state.authState.cluster?.clusterId ?? '',
          "ag_cat": true
        },
        requestType: RequestType.get);
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      var responseModel = GetBusinessesResponse.fromJson(response.data);

      var merchants = await CartDataSource.getListOfMerchants();

      if (getUrl == ApiURL.getBusinessesUrl) {
      } else {
        var businessList = state.homePageState.merchants;
        responseModel.results = businessList + responseModel.results;
      }
      dispatch(UpdateBusinessesDataStructureAction(responseModel.results));
      if (merchants.isNotEmpty) {
        return state.copyWith(
            homePageState: state.homePageState.copyWith(
                merchants: responseModel.results, response: responseModel),
            productState:
                state.productState.copyWith(selectedMerchant: merchants.first));
      }
      return state.copyWith(
          homePageState: state.homePageState.copyWith(
              merchants: responseModel.results, response: responseModel));
    }
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeBusinessListLoadingAction(true));
    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeBusinessListLoadingAction(false));
    super.after();
  }
}

class ChangeSelectedCircleUsingCircleCodeAction extends ReduxAction<AppState> {
  final String circleCode;
  bool _didCircleGotChanged = false;

  ChangeSelectedCircleUsingCircleCodeAction({@required this.circleCode});

  @override
  FutureOr<AppState> reduce() async {
    if (state.authState.cluster != null &&
        state.authState.cluster.clusterCode == circleCode) return null;
    final Cluster toBeSelectedCluster = [
      ...state.authState.myClusters ?? <Cluster>[],
      ...state.authState.nearbyClusters ?? <Cluster>[],
    ].toSet().toList().firstWhere(
        (element) => element.clusterCode == circleCode,
        orElse: () => null);
    if (toBeSelectedCluster == null) return null;
    _didCircleGotChanged = true;
    return state.copyWith(
      authState: state.authState.copyWith(
        cluster: toBeSelectedCluster,
      ),
    );
  }

  @override
  void after() async {
    if (_didCircleGotChanged) {
      store.dispatch(GetMerchantDetails(getUrl: ApiURL.getBusinessesUrl));
      store.dispatch(LoadVideoFeed());
      store.dispatch(GetBannerDetailsAction());
      store.dispatch(GetTopBannerImageAction());
      store.dispatch(GetHomePageCategoriesAction());
    }
    super.after();
  }
}

class ChangeSelectedCircleAction extends ReduxAction<AppState> {
  final BuildContext context;

  ChangeSelectedCircleAction({@required this.context});

  @override
  FutureOr<AppState> reduce() async {
    final Cluster cluster = await showModalBottomSheet(
        context: context,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        builder: (context) => Container(
              child: MyCirclesBottomView(
                  myCircles: [
                ...state.authState.myClusters ?? <Cluster>[],
                ...state.authState.nearbyClusters ?? <Cluster>[],
              ].toSet().toList()),
            ));
    if (cluster == null || !(cluster is Cluster)) return null;
    return state.copyWith(
      authState: state.authState.copyWith(
        cluster: cluster,
      ),
    );
  }
}

///This action is dispatched on init of application. It hits mutiple APIs and makes
///things ready for the home page screen.
///This should be called elsewhere but only ONCE when app starts up
class HomePageOnInitMultipleDispatcherAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    // adress must be fetched isrrespective of cluster is null or not.
    var address = await UserManager.getAddress();
    if (address == null) {
      store.dispatch(GetAddressAction());
    } else {
      store.dispatch(GetAddressFromLocal());
    }

    if (state.authState.cluster != null) {
      await store.dispatchFuture(GetClusterDetailsAction());
      store.dispatch(GetMerchantDetails(getUrl: ApiURL.getBusinessesUrl));
      store.dispatch(LoadVideoFeed());
      store.dispatch(GetHomePageCategoriesAction());
      store.dispatch(GetCartFromLocal());
      store.dispatch(GetUserFromLocalStorageAction());
      store.dispatch(GetBannerDetailsAction());
      store.dispatch(GetTopBannerImageAction());
    }
    return state.copyWith(isInitializationDone: true);
  }
}

class SelectMerchantDetailsByID extends ReduxAction<AppState> {
  final String businessId;

  SelectMerchantDetailsByID({@required this.businessId});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
      url: ApiURL.baseURL + ApiURL.getBusinessesUrl + '$businessId',
      params: null,
      requestType: RequestType.get,
    );
    debugPrint(
        'GoToMerchantDetailsByID response=> ${response.status.toString()}');
    if (response.status == ResponseStatus.error404) {
      Fluttertoast.showToast(msg: 'Store Not Found');
      throw 'Something went wrong : ${response.data['message']}';
    } else if (response.status == ResponseStatus.error500) {
      Fluttertoast.showToast(msg: 'Something went wrong');
      throw 'Something went wrong : ${response.data['message']}';
    } else {
      var responseModel = Business.fromJson(response.data);

      if (responseModel != null) {
        DynamicLinkService().isLinkPathValid = true;
        return state.copyWith(
          productState: state.productState.copyWith(
            selectedMerchant: responseModel,
          ),
        );
      }
    }
    return null;
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
    super.after();
  }
}

class GetBannerDetailsAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.getBannersUrl(state.authState.cluster.clusterId),
        params: null,
        requestType: RequestType.get);
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      List<Photo> responseModel = [];
      if (response.data is List)
        response.data.forEach((v) => responseModel.add(Photo.fromJson(v)));

      return state.copyWith(
          homePageState: state.homePageState.copyWith(banners: responseModel));
    }
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeCircleBannersLoadingAction(true));
    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeCircleBannersLoadingAction(false));
    super.after();
  }
}

class GetClusterDetailsAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
      url: ApiURL.getClustersUrl,
      params: null,
      requestType: RequestType.get,
    );
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      List<Cluster> result = [];
      response?.data?.forEach((item) {
        result.add(Cluster.fromJson(item));
      });
      await dispatchFuture(SetCurrentCircleFromPrefsAction());
      if (result == null || result.isEmpty) return null;
      if (state.authState.cluster == null)
        return state.copyWith(
            authState: state.authState.copyWith(
          cluster: result?.first,
          myClusters: result,
        ));
      return state.copyWith(
          authState: state.authState.copyWith(
        myClusters: result,
      ));
    }
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeClusterDetailsLoadingAction(true));
    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeClusterDetailsLoadingAction(false));
    if (state.authState.cluster == null) dispatch(GetNearbyCirclesAction());
    super.after();
  }
}

class UpdateSelectedTabAction extends ReduxAction<AppState> {
  final index;

  UpdateSelectedTabAction(this.index);

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        homePageState: state.homePageState.copyWith(currentIndex: index));
  }
}

class UpdateSelectedMerchantAction extends ReduxAction<AppState> {
  final Business selectedMerchant;

  UpdateSelectedMerchantAction({this.selectedMerchant});

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        productState: state.productState.copyWith(
            selectedMerchant: selectedMerchant,
            spotlightItems: [],
            singleCategoryFewProducts: [],
            videosResponse: VideoFeedResponse(
              count: 0,
              results: [],
            ),
            categories: []));
  }
}

class GetTopBannerImageAction extends ReduxAction<AppState> {
  GetTopBannerImageAction();

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
      url: ApiURL.getBannersUrl(state.authState.cluster.clusterId),
      params: {'top': true},
      requestType: RequestType.get,
    );
    if (response.status == ResponseStatus.success200) {
      Photo topBanner = Photo();
      if (response.data is Map) topBanner = Photo.fromJson(response.data);
      return state.copyWith(
        homePageState: state.homePageState.copyWith(
          topBanner: topBanner,
        ),
      );
    } else {
      Fluttertoast.showToast(msg: response.data['msg']);
    }
    return null;
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeCircleTopBannerLoadingAction(true));
    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeCircleTopBannerLoadingAction(false));
    super.after();
  }
}
