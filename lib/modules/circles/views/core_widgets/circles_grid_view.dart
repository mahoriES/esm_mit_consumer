import 'package:eSamudaay/modules/circles/model/circle_tile_type.dart';
import 'package:eSamudaay/modules/circles/views/core_widgets/circle_tile_widget.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';

class CircleTileGridView extends StatelessWidget {
  final List<CircleTileType> tilesDataList;
  final Function(String, String) onDelete;
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