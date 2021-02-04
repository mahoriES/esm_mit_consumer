import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/home/actions/video_feed_actions.dart';
import 'package:eSamudaay/modules/home/models/dynamic_link_params.dart';
import 'package:eSamudaay/modules/store_details/actions/categories_actions.dart';
import 'package:eSamudaay/modules/store_details/actions/store_actions.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/store.dart';
import 'package:eSamudaay/utilities/navigation_handler.dart';
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
        throw UserException(
            'Some Error Occured while processing the deep link  : ${e.toString()}.');
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
        if (dynamicLinkDataValues.videoId != null) {
          await _goToVideoById(dynamicLinkDataValues.videoId);
        } else if (dynamicLinkDataValues.productId != null) {
          await _goToProductById(
            dynamicLinkDataValues.productId,
            dynamicLinkDataValues.businessId,
          );
        } else if (dynamicLinkDataValues.businessId != null) {
          await _goToStoreDetailsById(dynamicLinkDataValues.businessId);
        }
      }
    }
  }

  _goToStoreDetailsById(String businessId) async {
    await store
        .dispatchFuture(SelectMerchantDetailsByID(businessId: businessId));
    if (isLinkPathValid) {
      store.dispatch(ResetCatalogueAction());

      // If user opens the app through a merchant's shared link
      // we need to bookmark that merchant.If it's not bookmarked already.

      if (!store.state.productState.selectedMerchant.isBookmarked) {
        store.dispatch(BookmarkBusinessAction(businessId: businessId));
      }
      String _routeName = '/StoreDetailsView';
      if (NavigationHandler.navigationStack.contains(_routeName)) {
        store.dispatch(NavigateAction.popUntil(_routeName));
        store.dispatch(NavigateAction.pushReplacementNamed(_routeName));
      } else
        store.dispatch(NavigateAction.pushNamed(_routeName));
    }
  }

  _goToVideoById(String videoId) async {
    await store.dispatchFuture(SlelectVideoPlayerByID(videoId: videoId));
    if (isLinkPathValid) {
      String _routeName = '/videoPlayer';
      if (NavigationHandler.navigationStack.contains(_routeName)) {
        store.dispatch(NavigateAction.popUntil(_routeName));
        store.dispatch(NavigateAction.pushReplacementNamed(_routeName));
      } else
        store.dispatch(NavigateAction.pushNamed(_routeName));
    }
  }

  _goToProductById(String productId, String businessId) async {
    await store.dispatchFuture(
      GetProductDetailsByID(productId: productId, businessId: businessId),
    );
    await store
        .dispatchFuture(SelectMerchantDetailsByID(businessId: businessId));
    if (isLinkPathValid) {
      String _routeName = RouteNames.PRODUCT_DETAILS;
      if (NavigationHandler.navigationStack.contains(_routeName)) {
        store.dispatch(NavigateAction.popUntil(_routeName));
        store.dispatch(NavigateAction.pushReplacementNamed(_routeName));
      } else
        store.dispatch(NavigateAction.pushNamed(_routeName));
    }
  }
}
