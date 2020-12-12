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
          preferredSize: Size.fromHeight(120.0), // here the desired height
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            brightness: Brightness.light,
            automaticallyImplyLeading: false,
            centerTitle: false,
            flexibleSpace: // Rect
                // angle 2102
                Container(
              height: 160,
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/HeaderImage.png"),
                      fit: BoxFit.fill)),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/splash.png',
                            width: 200,
                            color: Colors.white,
                          ),
                          StoreConnector<AppState, _ViewModel>(
                              model: _ViewModel(),
                              onInit: (store) {
                                store.dispatch(GetCartFromLocal());
                                store.dispatch(GetUserFromLocalStorageAction());
                              },
                              builder: (context, snapshot) {
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: 45,
                                    ),
                                    ImageIcon(
                                      AssetImage('assets/images/location2.png'),
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(snapshot?.cluster?.clusterName ?? "",
                                        style: TextStyle(
                                          fontFamily: 'JTLeonor',
                                          color: Colors.white,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      child: Text(
                                        'Change Circle',
                                        style: TextStyle(
                                          fontFamily: 'JTLeonor',
                                          color: AppColors.offWhitish,
                                          fontSize: fit.t(12),
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                      onTap: () {
                                        snapshot.changeSelectedCircle(
                                          ApiURL.getBusinessesUrl,
                                          context,
                                        );
                                      },
                                    ),
                                  ],
                                );
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
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

  _ViewModel.build({
    this.updateSelectedVideo,
    this.navigateToVideoView,
    this.navigateToAddAddressPage,
    this.navigateToCart,
    this.cluster,
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
          cluster,
          response,
          videoFeedResponse,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
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
