import 'package:eSamudaay/modules/circles/model/circle_tile_type.dart';
import 'package:eSamudaay/modules/circles/views/core_widgets/circles_grid_view.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

///
///This is a grid view which shows the saved / profile circles in a grid layout
///

class SavedCirclesView extends StatelessWidget {
  ///
  ///List of saved circles to be shown in a grid view
  ///
  final List<CircleTileType> savedCirclesList;
  ///
  /// The function to be invoked when user taps on the circle tile
  ///
  final Function onTap;
  ///
  /// Function to be invoked when user taps on the delete icon button
  ///
  final Function onDelete;

  const SavedCirclesView(
      {Key key,
        @required this.savedCirclesList,
        @required this.onDelete,
        @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (savedCirclesList.isEmpty) return SizedBox.shrink();
    debugPrint('Saved list ${savedCirclesList.toSet()}');
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              'circle.saved',
              style: CustomTheme.of(context).textStyles.sectionHeading2,
            ).tr(),
          ),
          CircleTileGridView(
              tilesDataList: savedCirclesList, onDelete: onDelete, onTap: onTap)
        ],
      ),
    );
  }
}