import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:flutter/material.dart';

class ImageZoomView extends StatelessWidget {
  final String imageUrl;
  ImageZoomView(this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: CachedNetworkImage(
            height: double.infinity,
            width: double.infinity,
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            placeholder: (context, url) => Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (_, __, ___) => Center(
              child: SizedBox(
                child: Image.asset(ImagePathConstants.emptyBagImage),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
