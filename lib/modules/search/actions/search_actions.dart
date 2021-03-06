import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/search/models/models.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchAction extends ReduxAction<AppState> {
  final SearchRequest searchRequest;

  SearchAction({this.searchRequest});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.searchURL,
        params: searchRequest.toJson(),
        requestType: RequestType.post);
    if (response.data['statusCode'] == 200) {
//      MerchantSearchResponse responseModel =
//          MerchantSearchResponse.fromJson(response.data);

//      return state.copyWith(
//          productState: state.productState
//              .copyWith(searchResults: responseModel.merchants));
    } else {
      Fluttertoast.showToast(msg: response.data['status']);
    }

    return state.copyWith(authState: state.authState.copyWith());
  }
}
