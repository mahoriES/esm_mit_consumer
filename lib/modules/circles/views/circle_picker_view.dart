import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/home/models/cluster.dart';
import 'package:eSamudaay/modules/home/views/core_home_widgets/circle_top_banner.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CirclePickerView extends StatelessWidget {
  const CirclePickerView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: CircleTopBannerView(
            imageUrl: '',
            isBannerShownOnCircleScreen: true,
          ),
          body: Material(
            type: MaterialType.transparency,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CirclesSearchBar(onTap: () {}),
                ],
              ),
            ),
          ),
        );
      },
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
        child: Hero(
          tag: 'toSearchScreen',
          child: TextField(
            onTap: () {
              onTap();
            },
            decoration: InputDecoration(
              hintText: tr('circle.search'),
              hintStyle: CustomTheme.of(context)
                  .themeData
                  .textTheme
                  .subtitle1
                  .copyWith(
                      color: CustomTheme.of(context).colors.disabledAreaColor),
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
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  List<Cluster> myClusters;
  List<Cluster> nearbyClusters;
  List<Cluster> suggestedClusters;
  Function(String circleCode) addCircleAction;
  Function(String circleCode, String circleId) removeCircleAction;
  Function(String textualQuery) getCircleSuggestionsAction;

  _ViewModel();

  _ViewModel.build(
      {@required this.myClusters,
      @required this.suggestedClusters,
      @required this.nearbyClusters,
      @required this.addCircleAction,
      @required this.getCircleSuggestionsAction,
      @required this.removeCircleAction})
      : super(equals: [myClusters, nearbyClusters, suggestedClusters]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      myClusters: state.authState.myClusters,
      suggestedClusters: state.authState.suggestedClusters,
      nearbyClusters: state.authState.nearbyClusters,
      addCircleAction: (String circleCode) {},
      removeCircleAction: (String circleCode, String circleId) {},
      getCircleSuggestionsAction: (String queryText) {},
    );
  }
}
