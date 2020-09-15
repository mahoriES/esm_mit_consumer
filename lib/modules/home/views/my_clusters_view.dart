import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/home/models/cluster.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';

///This class implements the bottom sheet based circle switcher. The circles
///shown are both the saved as well as nearby circles.
class MyCirclesBottomView extends StatelessWidget {
  final List<Cluster> myCircles;
  Cluster selectedCircle;

  MyCirclesBottomView({@required this.myCircles});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot){

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
          ),
          decoration: BoxDecoration(
            color: AppColors.offWhitish,
            boxShadow: [
              BoxShadow(
                  color: AppColors.blackShadowColor,
                  blurRadius: AppSizes.shadowBlurRadius)
            ],
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(AppSizes.bottomSheetBorderRadius),
              topLeft: Radius.circular(AppSizes.bottomSheetBorderRadius),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: AppSizes.sliverPadding,
              bottom: AppSizes.sliverPadding,
              left: AppSizes.sliverPadding/2,
              right: AppSizes.sliverPadding/2,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) => index == 0
                  ? buildTopHeader(context, snapshot)
                  : buildCircleItem(
                  context: context, cluster: myCircles[index - 1]),
              itemCount: myCircles.length + 1,
              separatorBuilder: (context, index) => Container(
                height: AppSizes.itemSubtitle2FontSize,
              ),
            ),
          ),
        );

      },
    );
  }

  Widget buildTopHeader(BuildContext context, _ViewModel snapshot) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.itemSubtitle2FontSize,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select your circle',
                  style: TextStyle(
                    fontSize: fit.t(AppSizes.itemSubtitleFontSize),
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Expanded(
              flex: 30,
              child: GestureDetector(
                onTap: () {
                  snapshot.closeBottomSheet();
                  snapshot.navigateToCircleScreen();
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.location_on,
                    color: AppColors.iconColors,
                    size: AppSizes.itemTitleFontSize,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget buildCircleItem({Cluster cluster, BuildContext context}) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, cluster);
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: AppSizes.sliverPadding/2),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.sliverPadding/2,
          ),
          decoration: BoxDecoration(
            color: AppColors.pureWhite,
            borderRadius: BorderRadius.all(Radius.circular(AppSizes.bottomSheetBorderRadius)),
            boxShadow: [
              BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  offset: Offset(0, 1),
                  blurRadius: 3)
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                cluster.clusterName,
                style: TextStyle(
                  color: AppColors.blackTextColor,
                  fontFamily: 'Avenir',
                  fontSize: fit.t(AppSizes.itemSubtitle2FontSize),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                "Circle Code : " + cluster.clusterCode,
                style: TextStyle(
                  color: AppColors.blackTextColor,
                  fontFamily: 'Avenir',
                  fontSize: fit.t(AppSizes.itemSubtitle2FontSize),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {

  VoidCallback navigateToCircleScreen;
  VoidCallback closeBottomSheet;

  _ViewModel();

  _ViewModel.build({
    @required this.navigateToCircleScreen,
    @required this.closeBottomSheet,
  });

  @override
  BaseModel fromStore() {
    return _ViewModel.build(

        navigateToCircleScreen: () {
      dispatch(NavigateAction.pushNamed('/circles'));
    },
      closeBottomSheet: () {
          dispatch(NavigateAction.pop());
      }
    );
  }
}
