import 'package:eSamudaay/modules/home/models/cluster.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';

class MyCirclesBottomView extends StatelessWidget {
  final List<Cluster> myCircles;
  Cluster selectedCircle;

  MyCirclesBottomView({@required this.myCircles});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.25,
      ),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
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
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 10,
        ),
        child: ListView.separated(
          itemBuilder: (context, index) => buildCircleItem(
            context: context,
            cluster: myCircles[index]
          ),
          itemCount: myCircles.length,
          separatorBuilder: (context, index) => Container(
            color: AppColors.greyishText,
            height: 0.3,
          ),
        ),
      ),
    );
  }

  Widget buildCircleItem({Cluster cluster, BuildContext context}) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, cluster);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            cluster.clusterName,
            style: TextStyle(
              color: AppColors.blackTextColor,
              fontFamily: 'Avenir',
              fontSize: fit.t(14),
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            cluster.clusterCode,
            style: TextStyle(
              color: AppColors.blackTextColor,
              fontFamily: 'Avenir',
              fontSize: fit.t(14),
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
