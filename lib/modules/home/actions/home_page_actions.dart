import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/home/models/banner_response.dart';
import 'package:esamudaayapp/modules/home/models/cluster.dart';
import 'package:esamudaayapp/modules/home/models/merchant_response.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';

class GetMerchantDetails extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.getBusinessesUrl,
        params: {"cluster_id": state.authState.cluster.clusterId},
        requestType: RequestType.get);
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      var responseModel = GetBusinessesResponse.fromJson(response.data);
      return state.copyWith(
          homePageState:
              state.homePageState.copyWith(merchants: responseModel.results));
    }
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
    super.after();
  }
}

class GetBannerDetailsAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.bannerUrl, params: {"": ""}, requestType: RequestType.post);
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      var responseModel = BannersResponse.fromJson(response.data);
      return state.copyWith(
          homePageState:
              state.homePageState.copyWith(banners: responseModel.banners));
    }
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
    super.after();
  }
}

class GetClusterDetailsAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.getClustersUrl,
        params: {"": ""},
        requestType: RequestType.get);
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      List<Cluster> result = [];
      response.data.forEach((item) {
        result.add(Cluster.fromJson(item));
      });
      return state.copyWith(
          authState: state.authState.copyWith(cluster: result.first));
    }
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
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
    // TODO: implement reduce
    return state.copyWith(
        productState:
            state.productState.copyWith(selectedMerchant: selectedMerchant));
  }
}
