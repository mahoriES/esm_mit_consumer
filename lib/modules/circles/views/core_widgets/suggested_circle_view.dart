import 'package:eSamudaay/modules/circles/model/circle_tile_type.dart';
import 'package:eSamudaay/modules/circles/views/core_widgets/circles_grid_view.dart';
import 'package:eSamudaay/modules/circles/views/core_widgets/location_disabled_view.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SuggestedNearbyCirclesView extends StatelessWidget {
  final List<CircleTileType> suggestedCirclesList;
  final bool isLocationDisabled;
  final Function(String) onSelectCircle;
  final VoidCallback onTapLocationAction;

  const SuggestedNearbyCirclesView(
      {Key key,
        this.suggestedCirclesList,
        this.onSelectCircle,
        this.onTapLocationAction,
        @required this.isLocationDisabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLocationDisabled && suggestedCirclesList.isEmpty)
      return const SizedBox.shrink();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
            const EdgeInsets.only(top: AppSizes.widgetPadding, left: 24),
            child: Text(
              'circle.suggested',
              style: CustomTheme.of(context).textStyles.sectionHeading2,
            ).tr(),
          ),
          const SizedBox(height: 5,),
          Padding(padding: const EdgeInsets.only(left: 24),
            child: Text(
              'circle.nearby_msg',
              style: CustomTheme.of(context).textStyles.body2Faded,
            ).tr(),
          ),
          if (isLocationDisabled)
            LocationDisabledView(onTapLocationAction: onTapLocationAction),
          if (suggestedCirclesList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: CircleTileGridView(
                  tilesDataList: suggestedCirclesList, onTap: onSelectCircle),
            )
        ],
      ),
    );
  }
}