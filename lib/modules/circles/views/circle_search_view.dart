import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/circles/actions/circle_picker_actions.dart';
import 'package:eSamudaay/modules/circles/views/circle_picker_view.dart';
import 'package:eSamudaay/modules/circles/views/circle_screen.dart';
import 'package:eSamudaay/modules/home/actions/home_page_actions.dart';
import 'package:eSamudaay/modules/home/models/cluster.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CircleSearchView extends StatefulWidget {
  @override
  _CircleSearchViewState createState() => _CircleSearchViewState();
}

class _CircleSearchViewState extends State<CircleSearchView> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: StoreConnector<AppState, _ViewModel>(
            model: _ViewModel(),
            onInit: (store) {},
            builder: (context, snapshot) {
              return Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      onChanged: (text) {
                        snapshot.onSearchAction(text);
                      },
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: tr('circle.search'),
                        hintStyle: CustomTheme.of(context)
                            .themeData
                            .textTheme
                            .subtitle1
                            .copyWith(
                                color: CustomTheme.of(context)
                                    .colors
                                    .disabledAreaColor),
                        prefixIcon: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: CustomTheme.of(context).colors.primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  CustomTheme.of(context).colors.shadowColor16),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  CustomTheme.of(context).colors.shadowColor16),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        contentPadding: const EdgeInsets.all(0.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,),
                  if (!snapshot.suggestedCirclesLoading) ...[
                    if (snapshot.searchResultsCircles.isEmpty)
                      circleInfoProviderWidget,
                    if (snapshot.searchResultsCircles.isNotEmpty)
                      Expanded(
                        child: SingleChildScrollView(
                          child: CircleTileGridView(
                              tilesDataList: snapshot.searchResultCirclesBuilderList,
                              onTap: snapshot.onTapSearchResultCircle),
                        ),
                      )
                  ] else
                    const CirclesLoadingIndicator(),
                ],
              );
            }),
      ),
    );
  }

  Widget get circleInfoProviderWidget => Padding(
        padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
        child: Text(
          'circle.search_info',
          style: CustomTheme.of(context).textStyles.sectionHeading1.copyWith(
              color: CustomTheme.of(context).colors.disabledAreaColor),
          textAlign: TextAlign.center,
        ).tr(),
      );
}

class _ViewModel extends BaseModel<AppState> {
  List<Cluster> searchResultsCircles;
  Function(String) onSearchAction;
  Function(String) onTapSearchResultCircle;
  bool suggestedCirclesLoading;
  Cluster selectedCluster;

  _ViewModel();

  _ViewModel.build(
      {@required this.suggestedCirclesLoading,
      @required this.onTapSearchResultCircle,
      @required this.searchResultsCircles,
      @required this.selectedCluster,
      @required this.onSearchAction})
      : super(equals: [searchResultsCircles, suggestedCirclesLoading]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      selectedCluster: state.authState.cluster,
      suggestedCirclesLoading:
          state.componentsLoadingState.suggestedCirclesLoading,
      searchResultsCircles: state.authState.suggestedClusters ?? [],
      onSearchAction: (String queryKeyword) {
        if (queryKeyword.isEmpty) return;
        dispatch(GetSuggestionsForCircleAction(queryText: queryKeyword));
      },
      onTapSearchResultCircle: (String circleCode) async {
        if (state.authState.myClusters
                .indexWhere((element) => element.clusterCode == circleCode) ==
            -1) dispatch(AddCircleToProfileAction(circleCode: circleCode));
        await dispatchFuture(
            ChangeSelectedCircleUsingCircleCodeAction(circleCode: circleCode));
        dispatch(NavigateAction.pushNamedAndRemoveAll("/myHomeView"));
      },
    );
  }

  List<CircleTileType> get searchResultCirclesBuilderList {
    final List<CircleTileType> circleResults = [];
    searchResultsCircles?.forEach((circle) {
      circleResults.add(CircleTileType(
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
    return circleResults;
  }
}
