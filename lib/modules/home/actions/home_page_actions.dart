import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/models/cluster.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/home/views/my_clusters_view.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
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
        params: {"cluster_id": state.authState.cluster.clusterId},
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
    dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
    dispatch(GetBannerDetailsAction());
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
        url: "api/v1/clusters/${state.authState.cluster.clusterId}/banners",
        params: {"": ""},
        requestType: RequestType.get);
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      List<Photo> responseModel = [];
      response.data.forEach((v) => responseModel.add(Photo.fromJson(v)));

      return state.copyWith(
          homePageState: state.homePageState.copyWith(banners: responseModel));
    }
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
      response.data.forEach((item) {
        result.add(Cluster.fromJson(item));
        debugPrint("Cluster++++++++++++++++++" + item.toString());
      });
//      if ((response.data == null || response.data.isEmpty) &&
//          (state.authState.myClusters == null || state.authState.myClusters
//              .isEmpty)) {
//        dispatch(NavigateAction.pushNamed('/circles'));
//      }
      return state.copyWith(
          authState: state.authState.copyWith(
        cluster: result.first,
        myClusters: result,
      ));
    }
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
//class GetClusterDetailsAction extends ReduxAction<AppState> {
//  @override
//  FutureOr<AppState> reduce() async {
//    var response = await APIManager.shared.request(
//        url: ApiURL.getClustersUrl,
//        params: {"": ""},
//        requestType: RequestType.get);
//    if (response.status == ResponseStatus.error404)
//      throw UserException(response.data['message']);
//    else if (response.status == ResponseStatus.error500)
//      throw UserException('Something went wrong');
//    else {
//      var responseModel = CatalogSearchResponse.fromJson(response.data);
//      var items = responseModel.catalog != null
//          ? responseModel.catalog.first.products
//          : responseModel.products;
//      var products = items.map((f) {
//        f.product.count = 0;
//        return f.product;
//      }).toList();
//
//      List<Product> allCartItems = await CartDataSource.getListOfCartWith();
//
//      products.forEach((item) {
//        allCartItems.forEach((localCartItem) {
//          if (item.id == localCartItem.id) {
//            item.count = localCartItem.count;
//          }
//        });
//      });
//      products.sort((a, b) {
//        bool aOutOfStock = a.restockingAt == null ||
//            (DateTime.fromMillisecondsSinceEpoch(
//                        int.parse(a.restockingAt) * 1000))
//                    .difference(DateTime.now())
//                    .inSeconds <=
//                0;
//        bool bOutOfStock = b.restockingAt == null ||
//            (DateTime.fromMillisecondsSinceEpoch(
//                        int.parse(b.restockingAt) * 1000))
//                    .difference(DateTime.now())
//                    .inSeconds <=
//                0;
//        return bOutOfStock.toString().compareTo(aOutOfStock.toString());
//      });
//
//      return state.copyWith(
//          productState:
//              state.productState.copyWith(productListingDataSource: products));
//    }
//  }
//
//  @override
//  FutureOr<void> before() {
//    dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));
//
//    return super.before();
//  }
//
//  @override
//  void after() {
//    dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
//    super.after();
//  }
//}

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
        productState:
            state.productState.copyWith(selectedMerchant: selectedMerchant));
  }
}
