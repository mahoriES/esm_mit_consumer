import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/actions/home_page_actions.dart';
import 'package:eSamudaay/modules/home/models/cluster.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/modules/circles/actions/circle_picker_actions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


///This class implements the picker screen to let user add/remove circles to
///their profiles. It shows the nearby circles as well as the circles already
///saved in the user's profile.
///There is also a text field where user can directly enter the circle code and
///add the aforementioned circle to their profile, although it is a feature
///which would probably be used by the advanced user only!

class CirclePicker extends StatefulWidget {
  final bool fromAccountScreen = false;

  @override
  _CirclePickerState createState() => _CirclePickerState();
}

class _CirclePickerState extends State<CirclePicker> {
  TextEditingController _clusterCodeTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      onInit: (store) async {
        await store.dispatchFuture(GetNearbyCirclesAction());
        if (store.state.authState.cluster != null &&
            (ModalRoute.of(context).settings.arguments
                    as Map)["fromAccountScreen"] ==
                false) {
          debugPrint('Tis getting called man!');
          Future.delayed(Duration.zero, () {
            store.dispatch(NavigateAction.pushNamedAndRemoveAll("/myHomeView"));
          });
        }
      },
      builder: (context, snapshot) {
        ///[WillPopScope] will prevent the user from popping by clicking the
        ///back button on Android phones only!
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'My Circles',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: fit.t(AppSizes.adjustableFontTitleSize),
                  color: AppColors.blackTextColor,
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.blackTextColor,
                ),
                onPressed: () {
                  if (!snapshot.hasSelectedCluster) {
                    Fluttertoast.showToast(
                        msg: 'Please add at least one circle'
                            ' to your profile, to view merchants in that circle!');
                    return;
                  }
                  debugPrint('Coming here!');
                  snapshot.closeWindow();
                },
              ),
            ),
            body: Material(
              child: SizedBox.expand(
                child: ModalProgressHUD(
                  progressIndicator: Card(
                    child: Image.asset(
                      'assets/images/indicator.gif',
                      height: 74,
                    ),
                  ),
                  inAsyncCall:
                      snapshot.loadingStatusApp == LoadingStatusApp.loading,
                  child: Container(
                    child: CustomScrollView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.only(
                              top: AppSizes.sliverPadding,
                              bottom: AppSizes.sliverPadding),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: AppSizes.adjustableFontTitleSize,
                                    right: AppSizes.adjustableFontTitleSize,
                                  ),
                                  child: Text(
                                    'You can manually add more circles to your '
                                    'profile.',
                                    style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: fit
                                            .t(AppSizes.itemSubtitle2FontSize),
                                        color: AppColors.greyishText),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: AppSizes.adjustableWidgetPadding,
                                    right: AppSizes.adjustableWidgetPadding,
                                    top: AppSizes.separatorPadding,
                                  ),
                                  child: TextField(
                                    onSubmitted: (circleCode) {
                                      if (circleCode.length == 0) return;
                                      snapshot.addCircleAction(
                                          circleCode.toUpperCase());
                                      _clusterCodeTextEditingController.text =
                                          "";
                                    },
                                    controller:
                                        _clusterCodeTextEditingController,
                                    decoration: new InputDecoration(
                                        border: new OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(
                                              AppSizes.separatorPadding,
                                            ),
                                          ),
                                        ),
                                        filled: true,
                                        hintStyle: new TextStyle(
                                            color: AppColors.greyishText,
                                            fontSize: fit.t(
                                                AppSizes.itemSubtitle2FontSize),
                                            fontFamily: 'Arial'),
                                        hintText:
                                            "Add circle using circle code...",
                                        fillColor: Colors.white70),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (snapshot.nearbyClusters != null &&
                            snapshot.nearbyClusters.isNotEmpty)
                          buildNearbyCirclesList(snapshot),
                        if (snapshot.myClusters != null &&
                            snapshot.myClusters.isNotEmpty)
                          buildSavedCirclesList(snapshot),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildSavedCirclesList(_ViewModel snapshot) {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: AppSizes.sliverPadding,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => index == 0
                ? getClusterTypeTitle('My Saved Circles')
                : buildSavedCircleTile(
                    circleCode: snapshot.myClusters[index - 1].clusterCode,
                    circleName: snapshot.myClusters[index - 1].clusterName,
                    snapshot: snapshot,
                    circleId: snapshot.myClusters[index - 1].clusterId,
                  ),
            childCount: snapshot.myClusters.length + 1),
      ),
    );
  }

  Widget getClusterTypeTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.adjustableWidgetPadding,
        right: AppSizes.adjustableWidgetPadding,
        top: AppSizes.sliverPadding,
        bottom: AppSizes.sliverPadding,
      ),
      child: Text(
        title,
        style: TextStyle(
            color: AppColors.blackTextColor,
            fontSize: fit.t(AppSizes.adjustableFontTitleSize),
            fontFamily: 'Arial',
            fontWeight: FontWeight.w300),
      ),
    );
  }

  Widget buildNearbyCirclesList(_ViewModel snapshot) {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: AppSizes.sliverPadding,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => index == 0
                ? getClusterTypeTitle('My Nearby Circles')
                : buildNearbyCircleTile(
                    circleCode: snapshot.nearbyClusters[index - 1].clusterCode,
                    circleName: snapshot.nearbyClusters[index - 1].clusterName,
                    snapshot: snapshot,
                  ),
            childCount: snapshot.nearbyClusters.length + 1),
      ),
    );
  }

  Widget buildSavedCircleTile(
      {String circleName,
      String circleCode,
      _ViewModel snapshot,
      String circleId}) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSizes.adjustableWidgetPadding,
        top: AppSizes.sliverPadding,
        bottom: AppSizes.sliverPadding,
        right: AppSizes.adjustableWidgetPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.adjustableWidgetPadding),
        color: AppColors.pureWhite,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  circleName,
                  style: TextStyle(
                      fontSize: fit.t(AppSizes.itemSubtitle2FontSize),
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackTextColor),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: AppSizes.widgetPadding,
                ),
                Text('Circle Code: ' + circleCode,
                    style: TextStyle(
                        fontSize: fit.t(AppSizes.itemSubtitle3FontSize),
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.w400,
                        color: AppColors.greyishText),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Expanded(
            flex: 30,
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  snapshot.removeCircleAction(circleCode, circleId);
                },
                child: Text('Remove',
                    style: TextStyle(
                        color: AppColors.iconColors,
                        fontSize: fit.t(AppSizes.itemSubtitle2FontSize),
                        fontFamily: 'Arial'),
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNearbyCircleTile(
      {String circleName, String circleCode, _ViewModel snapshot}) {
    return Container(
      padding: EdgeInsets.only(
        top: AppSizes.sliverPadding,
        bottom: AppSizes.sliverPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.adjustableWidgetPadding),
        color: AppColors.pureWhite,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 20,
            child: SizedBox(
              height: AppSizes.adjustableWidgetPadding,
              width: AppSizes.adjustableWidgetPadding,
              child: Image.asset(
                "assets/images/location2.png",
                color: AppColors.iconColors,
              ),
            ),
          ),
          Expanded(
            flex: 60,
            child: Column(
              children: [
                Text(
                  circleName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: fit.t(15),
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackTextColor,
                  ),
                ),
                SizedBox(
                  height: AppSizes.widgetPadding,
                ),
                Text("Circle Code: " + circleCode,
                    style: TextStyle(
                        fontSize: fit.t(12),
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.w400,
                        color: AppColors.greyishText),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Expanded(
            flex: 20,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  snapshot.addCircleAction(circleCode);
                },
                child: Text('+ Add',
                    style: TextStyle(
                        color: AppColors.green,
                        fontSize: fit.t(AppSizes.itemSubtitle2FontSize),
                        fontFamily: 'Arial'),
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
        ],
      ),
    );
  }
///This widget shall be displayed when user has neither saved cirlces nor nearby
  ///circles.
  Widget get noCirclesNearbyWidget {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.sliverPadding,
        horizontal: AppSizes.sliverPadding,
      ),
      sliver: SliverList(
          delegate: SliverChildListDelegate(<Widget>[
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.green,
                size: fit.t(AppSizes.adjustableFontTitleSize),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: AppSizes.widgetPadding,
                  left: AppSizes.widgetPadding,
                  right: AppSizes.widgetPadding,
                ),
                child: Text(
                  'Sorry we could not find any circles nearby! Please add manually.',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: fit.t(AppSizes.adjustableWidgetPadding),
                  ),
                ),
              ),
            ],
          ),
        )
      ],),),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  LoadingStatusApp loadingStatusApp;
  List<Cluster> myClusters;
  List<Cluster> nearbyClusters;
  Function(String circleCode) addCircleAction;
  Function(String circleCode, String circleId) removeCircleAction;
  bool hasSelectedCluster;
  VoidCallback closeWindow;

  _ViewModel();

  _ViewModel.build(
      {@required this.loadingStatusApp,
      @required this.myClusters,
      @required this.nearbyClusters,
      @required this.addCircleAction,
      @required this.removeCircleAction,
      @required this.hasSelectedCluster,
      @required this.closeWindow})
      : super(equals: [
          loadingStatusApp,
          myClusters,
          nearbyClusters,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
        closeWindow: () {
          dispatch(NavigateAction.pop());
        },
        hasSelectedCluster: state.authState.cluster != null,
        loadingStatusApp: state.authState.loadingStatus,
        myClusters: state.authState.myClusters,
        nearbyClusters: state.authState.nearbyClusters,
        addCircleAction: (circleCode) async {
          await dispatchFuture(
              AddCircleToProfileAction(circleCode: circleCode));
          ///To load the merchants for the new selected circle
          dispatch(GetMerchantDetails(getUrl: ApiURL.getBusinessesUrl));
        },
        removeCircleAction: (circleCode, circleId) async {
          await dispatchFuture(RemoveCircleFromProfileAction(
              circleCode: circleCode, circleId: circleId));
          ///To load the merchants for the new selected circle
          dispatch(GetMerchantDetails(getUrl: ApiURL.getBusinessesUrl));
        });
  }
}
