import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/circles/actions/circle_picker_actions.dart';
import 'package:eSamudaay/modules/circles/views/circle_screen.dart';
import 'package:eSamudaay/modules/home/actions/home_page_actions.dart';
import 'package:eSamudaay/modules/home/models/cluster.dart';
import 'package:eSamudaay/modules/home/views/core_home_widgets/circle_top_banner.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app_settings/app_settings.dart';

class CirclePickerView extends StatelessWidget {
  const CirclePickerView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      onInit: (store) async {
        await store.dispatchFuture(GetClusterDetailsAction());
      },
      builder: (context, snapshot) {
        return WillPopScope(
          onWillPop: ()=>Future.value(false),
          child: Scaffold(
            appBar: CircleTopBannerView(
              imageUrl: '',
              isBannerShownOnCircleScreen: true,
            ),
            body: Material(
              type: MaterialType.transparency,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CirclesSearchBar(onTap: () {
                      snapshot.navigateToSearchCirclesScreen();
                    }),
                    snapshot.savedClustersLoading
                        ? const CirclesLoadingIndicator()
                        : SavedCirclesView(
                            onTap: snapshot.setSelectedCircleAction,
                            onDelete: snapshot.removeCircleAction,
                            savedCirclesList: snapshot.savedCirclesList),
                    snapshot.suggestedClustersLoading
                        ? const CirclesLoadingIndicator()
                        : SuggestedNearbyCirclesView(
                            onSelectCircle: snapshot.setSelectedCircleAction,
                            onTapLocationAction: () {
                              snapshot.onTapLocationAction();
                            },
                            isLocationDisabled: !snapshot.locationEnabled,
                            suggestedCirclesList: snapshot.suggestedNearbyCirclesList,
                          ),
                    const CircleInfoFooter(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CirclesLoadingIndicator extends StatelessWidget {
  const CirclesLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenHeight / 4,
      width: SizeConfig.screenWidth,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class CirclesSearchBar extends StatelessWidget {
  final VoidCallback onTap;

  const CirclesSearchBar({Key key, @required this.onTap})
      : assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: AppSizes.widgetPadding, horizontal: AppSizes.widgetPadding),
      child: Container(
        child: InkWell(
          onTap: onTap,
          child: IgnorePointer(
            child: TextField(
              decoration: InputDecoration(
                hintText: tr('circle.search'),
                hintStyle: CustomTheme.of(context)
                    .themeData
                    .textTheme
                    .subtitle1
                    .copyWith(
                        color:
                            CustomTheme.of(context).colors.disabledAreaColor),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: CustomTheme.of(context).colors.primaryColor,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: CustomTheme.of(context).colors.shadowColor16),
                  borderRadius: BorderRadius.circular(5),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  List<Cluster> myClusters;
  List<Cluster> nearbyClusters;
  Cluster selectedCluster;
  Function(String circleCode, String circleId) removeCircleAction;
  Function(String textualQuery) getCircleSuggestionsAction;
  VoidCallback navigateToSearchCirclesScreen;
  VoidCallback onTapLocationAction;
  Function(String circleCode) setSelectedCircleAction;
  Function getSavedCircles;
  bool savedClustersLoading;
  bool suggestedClustersLoading;
  bool locationEnabled;

  _ViewModel();

  _ViewModel.build(
      {@required this.myClusters,
      @required this.selectedCluster,
      @required this.navigateToSearchCirclesScreen,
      @required this.locationEnabled,
      @required this.onTapLocationAction,
      @required this.nearbyClusters,
      @required this.savedClustersLoading,
      @required this.suggestedClustersLoading,
      @required this.setSelectedCircleAction,
      @required this.getSavedCircles,
      @required this.getCircleSuggestionsAction,
      @required this.removeCircleAction})
      : super(equals: [
          savedClustersLoading,
          suggestedClustersLoading,
          myClusters,
          nearbyClusters,
          locationEnabled,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
        locationEnabled: state.authState.locationEnabled,
        selectedCluster: state.authState.cluster,
        savedClustersLoading: state.componentsLoadingState.circleDetailsLoading,
        suggestedClustersLoading:
            state.componentsLoadingState.savedCirclesLoading,
        myClusters: state.authState.myClusters,
        nearbyClusters: state.authState.nearbyClusters,
        removeCircleAction: (String circleCode, String circleId) async {
          await dispatchFuture(RemoveCircleFromProfileAction(
              circleCode: circleCode, circleId: circleId));
        },
        getCircleSuggestionsAction: (String textQuery) {
          if (textQuery.isEmpty) return;
          dispatch(GetSuggestionsForCircleAction(queryText: textQuery));
        },
        getSavedCircles: () {},
        navigateToSearchCirclesScreen: () {
          debugPrint('Navigate to search circles called');
          dispatch(NavigateAction.pushNamed(RouteNames.CIRCLE_SEARCH));
        },
        setSelectedCircleAction: (String circleCode) async {
          if (state.authState.myClusters
                  .indexWhere((element) => element.clusterCode == circleCode) ==
              -1) dispatch(AddCircleToProfileAction(circleCode: circleCode));
          await dispatchFuture(ChangeSelectedCircleUsingCircleCodeAction(
              circleCode: circleCode));
          dispatch(SaveCurrentCircleToPrefsAction(circleCode));
          dispatch(NavigateAction.pushNamedAndRemoveAll("/myHomeView"));
        },
        onTapLocationAction: () async {
          await AppSettings.openLocationSettings();
          dispatch(GetNearbyCirclesAction());
        });
  }

  List<CircleTileType> get savedCirclesList {
    final List<CircleTileType> savedCircles = [];
    myClusters?.forEach((circle) {
      savedCircles.add(CircleTileType(
          circleId: circle.clusterId,
          circleCode: circle.clusterCode,
          imageUrl: circle.thumbnail?.photoUrl ?? '',
          isSelected: selectedCluster == null
              ? false
              : circle.clusterId == selectedCluster.clusterId
                  ? true
                  : false,
          circleName: circle.clusterName,
          circleDescription: circle.description));
    });
    return savedCircles;
  }

  List<CircleTileType> get suggestedNearbyCirclesList {
    final List<CircleTileType> suggestedCircles = [];
    nearbyClusters?.forEach((circle) {
      suggestedCircles.add(CircleTileType(
          circleCode: circle.clusterCode,
          circleId: circle.clusterId,
          imageUrl: circle.thumbnail?.photoUrl ?? '',
          isSelected: false,
          circleName: circle.clusterName,
          circleDescription: circle.description));
    });
    return suggestedCircles;
  }
}
