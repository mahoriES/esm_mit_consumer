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
      child:  ListView(
        children: const [
          YoutubeShimmer(padding: EdgeInsets.all(0),),
          ProfileShimmer(padding: EdgeInsets.all(0),),
          YoutubeShimmer(padding: EdgeInsets.all(0),),
          ListTileShimmer(padding: EdgeInsets.all(0),),
          ProfileShimmer(padding: EdgeInsets.all(0),),
          ProfileShimmer(padding: EdgeInsets.all(0),),
        ],
      ),
    );
  }
}
