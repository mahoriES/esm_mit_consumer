import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';

import 'business_details_popup.dart';

class BusinessImageWithLogo extends StatelessWidget {
  final String imageUrl;
  const BusinessImageWithLogo({
    @required this.imageUrl,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.217 * SizeConfig.screenWidth,
      width: 0.217 * SizeConfig.screenWidth,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 0.168 * SizeConfig.screenWidth,
              width: 0.168 * SizeConfig.screenWidth,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const ShapeDecoration(shape: CircleBorder()),
                child: CachedNetworkImage(
                  errorWidget: (_, __, ___) =>
                      Image.asset('assets/images/shop1.png'),
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: eSamudaayLogo(scaledHeight: 0.093 * SizeConfig.screenWidth),
          ),
        ],
      ),
    );
  }
}
