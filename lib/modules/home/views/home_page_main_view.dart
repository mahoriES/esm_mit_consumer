import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/circles/actions/circle_picker_actions.dart';
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
import 'package:eSamudaay/modules/login/actions/login_actions.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:eSamudaay/modules/store_details/actions/categories_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/merchant_core_widget_classes/business_category_tile.dart';
import 'package:eSamudaay/reusable_widgets/plain_business_tile.dart';
import 'package:eSamudaay/store.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/custom_widgets.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePageMainView extends StatefulWidget {
  @override
  _HomePageMainViewState createState() => _HomePageMainViewState();
}

class _HomePageMainViewState extends State<HomePageMainView> {
  String address = "";
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  void _onRefresh(_ViewModel snapshot) async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    if (snapshot.response.previous != null) {
    } else {
      snapshot.getMerchantList(ApiURL.getBusinessesUrl);
      snapshot.loadVideoFeed();
    }

    _refreshController.refreshCompleted();
  }

  void _onLoading(_ViewModel snapshot) async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
//    items.add((items.length + 1).toString());
    if (snapshot.response.next != null) {
      snapshot.getMerchantList(snapshot.response.next);
    }
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return UserExceptionDialog<AppState>(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(134 / 375 * SizeConfig.screenWidth),
          // here the desired height
          child: SafeArea(
            child: StoreConnector<AppState, _ViewModel>(
                model: _ViewModel(),
                builder: (context, snapshot) {
                  debugPrint('This is top banner image url ${snapshot?.topBanner?.photoUrl}');
                  if (snapshot?.topBanner?.photoUrl == null) return SizedBox.shrink();
                  return CircleTopBannerView(
                      imageUrl: snapshot?.topBanner?.photoUrl ?? '',
                      circleName: snapshot?.cluster?.clusterName ?? '',
                      onTapCircleButton: () {
                        snapshot.changeSelectedCircle(
                            ApiURL.getBusinessesUrl, context);
                      });
                }),
          ),
        ),
        body: StoreConnector<AppState, _ViewModel>(
            model: _ViewModel(),
            onInit: (snapshot) async {
              if (snapshot.state.authState.cluster == null) {
                await snapshot.dispatchFuture(GetNearbyCirclesAction());
                snapshot.dispatch(
                    GetMerchantDetails(getUrl: ApiURL.getBusinessesUrl));
                snapshot.dispatch(LoadVideoFeed());
                store.dispatchFuture(GetHomePageCategoriesAction());
              }
              store.dispatch(GetCartFromLocal());
              store.dispatch(GetUserFromLocalStorageAction());
              store.dispatch(GetTopBannerImageAction());
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
              return ModalProgressHUD(
                progressIndicator: Card(
                  child: Image.asset(
                    'assets/images/indicator.gif',
                    height: 75,
                    width: 75,
                  ),
                ),
                inAsyncCall:
                    snapshot.loadingStatus == LoadingStatusApp.loading &&
                        snapshot.merchants.isEmpty,
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropHeader(
                    waterDropColor: AppColors.icColors,
                    complete: Image.asset(
                      'assets/images/indicator.gif',
                      height: 75,
                      width: 75,
                    ),
                    refresh: Image.asset(
                      'assets/images/indicator.gif',
                      height: 75,
                      width: 75,
                    ),
                  ),
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = Text("");
                      } else if (mode == LoadStatus.loading) {
                        body = CupertinoActivityIndicator();
                      } else if (mode == LoadStatus.failed) {
                        body = Text("Load Failed!Click retry!");
                      } else if (mode == LoadStatus.canLoading) {
                        body = Text("");
                      } else {
                        body = Text("No more Data");
                      }
                      return Container(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  controller: _refreshController,
                  onRefresh: () {
                    _onRefresh(snapshot);
                  },
                  onLoading: () {
                    _onLoading(snapshot);
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
                        (snapshot.merchants != null &&
                                    snapshot.merchants.isEmpty) &&
                                snapshot.loadingStatus !=
                                    LoadingStatusApp.loading
                            ? const EmptyListView()
                            : ListView(
                                padding: EdgeInsets.only(top: 2, bottom: 15),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 11),
                                    child: Text(
                                            'home_stores_categories.featured',
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
                                          var business =
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
                                          return Container(
                                            height: 10,
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
  Function navigateToVideoView;
  Function(String) getMerchantList;
  Function(String, BuildContext) changeSelectedCircle;
  String userAddress;
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

  _ViewModel.build({
    this.updateSelectedVideo,
    this.navigateToVideoView,
    this.navigateToAddAddressPage,
    this.navigateToCart,
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
    this.userAddress,
    this.updateSelectedMerchant,
    this.getMerchantList,
    this.response,
    this.changeSelectedCircle,
    this.videoFeedResponse,
    this.navigateToCircles,
  }) : super(equals: [
          currentIndex,
          merchants,
          banners,
          loadingStatus,
          userAddress,
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
      userAddress: "",
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
      getMerchantList: (url) {
        dispatch(GetMerchantDetails(getUrl: url));
      },
      changeSelectedCircle: (url, context) async {
        await dispatchFuture(ChangeSelectedCircleAction(context: context));
        dispatch(GetMerchantDetails(getUrl: url));
        dispatch(LoadVideoFeed());
      },
      navigateToCircles: () {
        dispatch(NavigateAction.pushNamed("/circles"));
      },
      currentIndex: state.homePageState.currentIndex,
      navigateToVideoView: () {
        dispatch(NavigateAction.pushNamed("/videoPlayer"));
      },
    );
  }
}
