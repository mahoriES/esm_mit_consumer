import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';

class ShimmeringView extends StatelessWidget {

  const ShimmeringView();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: ListView(
        children: [
          YoutubeShimmer(),
          ProfileShimmer(),
          ListTileShimmer(),
          ProfileShimmer(),
          ProfileShimmer(),
          YoutubeShimmer(),
          ListTileShimmer(),
        ],
      ),
    );
  }
}
