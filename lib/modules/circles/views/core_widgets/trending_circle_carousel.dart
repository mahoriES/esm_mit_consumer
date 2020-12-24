import 'package:eSamudaay/modules/circles/model/circle_tile_type.dart';
import 'package:eSamudaay/modules/circles/views/core_widgets/circle_tile_widget.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class TrendingCirclesCarouselView extends StatelessWidget {
  final List<CircleTileType> trendingCirclesList;
  final Function(String) onTap;

  const TrendingCirclesCarouselView(
      {Key key, @required this.trendingCirclesList, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (trendingCirclesList.isEmpty) return SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 23),
          child: Text(
            'circle.trending',
            style: CustomTheme.of(context).textStyles.sectionHeading2,
          ).tr(),
        ),
        const SizedBox(
          width: 20,
        ),
        SizedBox(
          width: SizeConfig.screenWidth,
          height: 163.8 / 375 * SizeConfig.screenWidth + 20,
          child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 23),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final CircleTileType circle = trendingCirclesList[index];
                return CircleTileWidget(
                    imageUrl: circle.imageUrl,
                    onTap: () {
                      onTap(circle.circleCode);
                    },
                    isSelected: circle.isSelected,
                    onDelete: null,
                    circleName: circle.circleName,
                    circleDescription: circle.circleDescription);
              },
              separatorBuilder: (_, __) => const SizedBox(
                width: 20,
              ),
              itemCount: trendingCirclesList.length),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }
}