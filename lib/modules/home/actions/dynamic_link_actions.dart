import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/circles/actions/circle_picker_actions.dart';
import 'package:eSamudaay/modules/home/actions/video_feed_actions.dart';
import 'package:eSamudaay/modules/home/models/dynamic_link_params.dart';
import 'package:eSamudaay/modules/store_details/actions/categories_actions.dart';
import 'package:eSamudaay/store.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'home_page_actions.dart';

class DynamicLinkService {
  DynamicLinkService._();
  static DynamicLinkService _instance = DynamicLinkService._();
  factory DynamicLinkService() => _instance;

  bool isDynamicLinkInitialized = false;
  PendingDynamicLinkData pendingLinkData;
  bool isLinkPathValid = false;

  disposeDynamicLinkListener() async {}

  initDynamicLink(BuildContext context) async {
    debugPrint(
        '********************************************************** init dynamic link');
    PendingDynamicLinkData linkData =
        await FirebaseDynamicLinks.instance.getInitialLink();
    handleLinkData(linkData);
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (dynamicLink) async {
        if (!store.state.authState.isLoggedIn) {
          pendingLinkData = dynamicLink;
          debugPrint(
              '***************** not logged in ${pendingLinkData?.link?.toString()}');
        } else {
          handleLinkData(dynamicLink);
        }
      },
      onError: (e) async {
        throw UserException('Some Error Occured.');
      },
    );
    isDynamicLinkInitialized = true;
  }

  handleLinkData(PendingDynamicLinkData data) async {
    final Uri uri = data?.link;
    isLinkPathValid = false;
    debugPrint('handle dynamic link => $uri');
    if (uri != null) {
      final queryParams = uri.queryParameters;
      if (queryParams.length > 0) {
        DynamicLinkDataValues dynamicLinkDataValues =
            DynamicLinkDataValues.fromJson(queryParams);
        debugPrint(dynamicLinkDataValues.toString());
        if (dynamicLinkDataValues.clusterId != null) {
          await _changeCircleById(dynamicLinkDataValues.clusterId);
          if (dynamicLinkDataValues.videoId != null) {
            await _goToVideoById(dynamicLinkDataValues.videoId);
          } else if (dynamicLinkDataValues.businessId != null) {
            await _goToStoreDetailsById(dynamicLinkDataValues.businessId);
          }
        }
      }
    }
  }

  _changeCircleById(String clusterId) async {
    await store.dispatchFuture(GetNearbyCirclesAction());
    await store.dispatchFuture(ChangeCircleByIdAction(clusterId));
    await store
        .dispatchFuture(GetMerchantDetails(getUrl: ApiURL.getBusinessesUrl));
    await store.dispatchFuture(LoadVideoFeed());
  }

  _goToStoreDetailsById(String businessId) async {
    await store.dispatchFuture(SelectStoreDetailsByIdAction(businessId));
    if (isLinkPathValid) {
      store.dispatch(RemoveCategoryAction());
      store.dispatch(NavigateAction.pushNamed('/StoreDetailsView'));
    }
  }

  _goToVideoById(String videoId) async {
    await store.dispatchFuture(UpdateSelectedVideoByIdAction(videoId: videoId));
    if (isLinkPathValid) {
      store.dispatch(NavigateAction.pushNamed("/videoPlayer"));
    }
  }
}
