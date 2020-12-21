import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/head_categories/actions/categories_action.dart';
import 'package:eSamudaay/modules/home/actions/dynamic_link_actions.dart';
import 'package:eSamudaay/modules/home/actions/home_page_actions.dart';
import 'package:eSamudaay/modules/home/actions/video_feed_actions.dart';
import 'package:eSamudaay/modules/home/models/cluster.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/home/models/video_feed_response.dart';
import 'package:eSamudaay/modules/home/views/core_home_widgets/circle_banners_carousel.dart';
import 'package:eSamudaay/modules/home/views/core_home_widgets/circle_top_banner.dart';
import 'package:eSamudaay/modules/home/views/core_home_widgets/empty_view.dart';
import 'package:eSamudaay/modules/home/views/video_list_widget.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:eSamudaay/modules/store_details/actions/categories_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/merchant_core_widget_classes/business_category_tile.dart';
import 'package:eSamudaay/reusable_widgets/plain_business_tile.dart';
import 'package:eSamudaay/reusable_widgets/shimmering_view.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePageMainView extends StatefulWidget {
  @override
  _HomePageMainViewState createState() => _HomePageMainViewState();
}

class _HomePageMainViewState extends State<HomePageMainView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UserExceptionDialog<AppState>(
      child: Scaffold(
        //TODO: Create a separate Widget along with ViewModel for this
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(134 / 375 * SizeConfig.screenWidth),
          child: StoreConnector<AppState, _ViewModel>(
            model: _ViewModel(),
            builder: (context, snapshot) {
              if (snapshot?.topBanner?.photoUrl == null &&
                  snapshot.shouldShowLoading) return SizedBox.shrink();
              return CircleTopBannerView(
                  isBannerShownOnCircleScreen: false,
                  imageUrl: snapshot?.topBanner?.photoUrl ?? '',
                  circleName: snapshot?.cluster?.clusterName ?? '',
                  onTapCircleButton: () {
                    snapshot.changeSelectedCircle(
                        ApiURL.getBusinessesUrl, context);
                  });
            },
          ),
        ),
        body: StoreConnector<AppState, _ViewModel>(
            model: _ViewModel(),
            onInit: (snapshot) async {
              debugPrint(
                  'home view init state => initialized : ${DynamicLinkService().isDynamicLinkInitialized} && pending Link : ${DynamicLinkService().pendingLinkData?.link.toString()}');
              if (!DynamicLinkService().isDynamicLinkInitialized) {
                DynamicLinkService().initDynamicLink(context);
              } else if (DynamicLinkService().pendingLinkData != null) {
                DynamicLinkService()
                    .handleLinkData(DynamicLinkService().pendingLinkData);
                DynamicLinkService().pendingLinkData = null;
              }
            },
            builder: (context, snapshot) {
              if (snapshot.shouldShowLoading) return const ShimmeringView();
              return SmartRefresher(
                enablePullUp: true,
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus mode) {
                    if (mode == LoadStatus.loading)
                      return const CupertinoActivityIndicator();
                    else
                      return const SizedBox.shrink();
                  },
                ),
                controller: _refreshController,
                onRefresh: () async {
                  await snapshot.onRefresh();
                  _refreshController.refreshCompleted();
                },
                onLoading: () async {
                  await snapshot.onLoading();
                  _refreshController.loadComplete();
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      VideosListWidget(
                        videoFeedResponse: snapshot.videoFeedResponse,
                        onRefresh: () => snapshot.dispatch(LoadVideoFeed()),
                        onTapOnVideo: (videoItem) {
                          snapshot.updateSelectedVideo(videoItem);
                          snapshot.navigateToVideoView();
                        },
                      ),
                      CircleBannersCarousel(banners: snapshot.banners),
                      HomeCategoriesGridView(),
                      snapshot.shouldShowEmptyView
                          ? const EmptyListView()
                          : ListView(
                              padding: EdgeInsets.only(top: 2, bottom: 15),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 11),
                                  child: Text('home_stores_categories.featured',
                                          style: CustomTheme.of(context)
                                              .textStyles
                                              .sectionHeading2,
                                          textAlign: TextAlign.left)
                                      .tr(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: AnimationLimiter(
                                    child: ListView.separated(
                                      itemBuilder: (context, index) {
                                        final Business business =
                                            snapshot.merchants[index];
                                        return InkWell(
                                            onTap: () {
                                              snapshot.updateSelectedMerchant(
                                                  business);
                                              snapshot
                                                  .navigateToStoreDetailsPage();
                                            },
                                            child: AnimationConfiguration
                                                .staggeredList(
                                              position: index,
                                              duration: const Duration(
                                                  milliseconds: 375),
                                              child: SlideAnimation(
                                                horizontalOffset: 5.0,
                                                child: FadeInAnimation(
                                                  child:
                                                      HybridBusinessTileConnector(
                                                    business: snapshot
                                                        .merchants[index],
                                                  ),
                                                ),
                                              ),
                                            ));
                                      },
                                      itemCount: snapshot.merchants.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const SizedBox(
                                          height: 16,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  Function(VideoItem) updateSelectedVideo;
  bool shouldShowLoading;
  Function navigateToVideoView;
  Future<void> Function(String) getMerchantList;
  Function(String, BuildContext) changeSelectedCircle;
  Function navigateToAddAddressPage;
  Function navigateToProductSearch;
  Function navigateToStoreDetailsPage;
  Function loadVideoFeed;
  Function updateCurrentIndex;
  VoidCallback navigateToCart;
  VoidCallback navigateToCircles;
  Function(Business) updateSelectedMerchant;
  int currentIndex;
  List<Business> merchants;
  VideoFeedResponse videoFeedResponse;
  List<Photo> banners;
  LoadingStatusApp loadingStatus;
  Cluster cluster;
  GetBusinessesResponse response;
  Photo topBanner;
  bool shouldShowEmptyView;

  _ViewModel.build({
    this.updateSelectedVideo,
    this.navigateToVideoView,
    this.navigateToAddAddressPage,
    this.navigateToCart,
    this.shouldShowEmptyView,
    this.shouldShowLoading,
    this.cluster,
    this.topBanner,
    this.banners,
    this.navigateToProductSearch,
    this.navigateToStoreDetailsPage,
    this.updateCurrentIndex,
    this.currentIndex,
    this.loadingStatus,
    this.loadVideoFeed,
    this.merchants,
    this.updateSelectedMerchant,
    this.getMerchantList,
    this.response,
    this.changeSelectedCircle,
    this.videoFeedResponse,
    this.navigateToCircles,
  }) : super(equals: [
          currentIndex,
          shouldShowLoading,
          shouldShowEmptyView,
          merchants,
          banners,
          loadingStatus,
          topBanner,
          cluster,
          response,
          videoFeedResponse,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      topBanner: state.homePageState.topBanner,
      response: state.homePageState.response,
      cluster: state.authState.cluster,
      loadingStatus: state.authState.loadingStatus,
      merchants: state.homePageState.merchants,
      banners: state.homePageState.banners,
      videoFeedResponse: state.videosState.videosResponse,
      loadVideoFeed: () {
        dispatch(LoadVideoFeed());
      },
      updateSelectedVideo: (video) {
        dispatch(UpdateSelectedVideoAction(selectedVideo: video));
      },
      navigateToCart: () {
        dispatch(NavigateAction.pushNamed('/CartView'));
      },
      updateSelectedMerchant: (merchant) {
        dispatch(UpdateSelectedMerchantAction(selectedMerchant: merchant));
      },
      navigateToStoreDetailsPage: () {
        dispatch(ResetCatalogueAction());
        dispatch(NavigateAction.pushNamed('/StoreDetailsView'));
      },
      navigateToAddAddressPage: () {
        dispatch(NavigateAction.pushNamed('/AddAddressView'));
      },
      navigateToProductSearch: () {
        dispatch(UpdateSelectedTabAction(1));
      },
      getMerchantList: (url) async {
        await dispatchFuture(GetMerchantDetails(getUrl: url));
      },
      changeSelectedCircle: (url, context) async {
        dispatch(NavigateAction.pushNamed(RouteNames.CIRCLE_PICKER));
      },
      navigateToCircles: () {
        dispatch(NavigateAction.pushNamed("/circles"));
      },
      currentIndex: state.homePageState.currentIndex,
      navigateToVideoView: () {
        dispatch(NavigateAction.pushNamed("/videoPlayer"));
      },
      shouldShowEmptyView: (merchants != null && merchants.isEmpty) &&
          loadingStatus != LoadingStatusApp.loading,
      shouldShowLoading: state.componentsLoadingState.circleDetailsLoading ||
          state.componentsLoadingState.circleCategoriesLoading ||
          state.componentsLoadingState.circleTopBannerLoading ||
          state.componentsLoadingState.circleBannersLoading ||
          (state.componentsLoadingState.businessListLoading &&
              !(state.homePageState.response.previous != null ||
                  state.homePageState.response.next != null)) ||
          state.componentsLoadingState.videosLoading,
    );
  }

  Future<void> onRefresh() async {
    getMerchantList(ApiURL.getBusinessesUrl);
    loadVideoFeed();
  }

  Future<void> onLoading() async {
    if (response.next != null) {
      await getMerchantList(response.next);
    }
  }
}
