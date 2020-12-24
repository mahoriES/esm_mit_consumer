import 'package:eSamudaay/modules/circles/model/circle_tile_type.dart';
import 'package:eSamudaay/modules/circles/views/core_widgets/circle_tile_widget.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';

class CircleTileGridView extends StatelessWidget {
  ///
  ///List of tiles to be shown in the grid
  ///
  final List<CircleTileType> tilesDataList;
  ///
  ///The function to be invoked if user taps on delete icon. If this is null
  ///the delete icon is not shown
  ///
  final Function(String, String) onDelete;
  ///
  ///Function to be invoked if user taps on the circle tile
  ///
  final Function(String) onTap;

  const CircleTileGridView(
      {Key key,
        @required this.tilesDataList,
        this.onDelete,
        @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: GridView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        primary: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 16.0,
          ///Aspect ratio for the tile. Picked from the design for screen size 375 sp
          childAspectRatio: 149.5 / 163.8,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return CircleTileWidget(
              imageUrl: tilesDataList[index].imageUrl,
              onTap: () {
                onTap(tilesDataList[index].circleCode);
              },
              isSelected: tilesDataList[index].isSelected,
              onDelete: onDelete != null
                  ? () {
                onDelete(tilesDataList[index].circleCode,
                    tilesDataList[index].circleId);
              }
                  : onDelete,
              circleName: tilesDataList[index].circleName,
              circleDescription: tilesDataList[index].circleDescription);
        },
        itemCount: tilesDataList.length,
      ),
    );
  }
}