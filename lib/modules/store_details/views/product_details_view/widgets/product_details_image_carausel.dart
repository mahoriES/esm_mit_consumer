import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetailsImageCarousel extends StatefulWidget {
  final String productName;
  final List<Photo> images;
  ProductDetailsImageCarousel(this.productName, this.images, {Key key})
      : super(key: key);

  @override
  _ProductDetailsImageCarouselState createState() =>
      _ProductDetailsImageCarouselState();
}

class _ProductDetailsImageCarouselState
    extends State<ProductDetailsImageCarousel> {
  PageController pageController;

  @override
  void initState() {
    pageController = new PageController()
      ..addListener(() {
        if (pageController.page.toInt() == pageController.page) setState(() {});
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 282.toHeight,
      color: AppColors.greyedout,
      child: widget.images == null || widget.images.isEmpty
          ? Center(
              child: Icon(
                Icons.image,
                size: 30.toFont,
              ),
            )
          : Stack(
              children: [
                PageView(
                  controller: pageController,
                  children: List.generate(
                    widget.images.length,
                    (index) => CachedNetworkImage(
                      imageUrl: (widget.images[index]?.photoUrl ?? ""),
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          Center(child: CupertinoActivityIndicator()),
                      errorWidget: (context, url, error) => Center(
                        child: Icon(
                          Icons.image,
                          size: 30.toFont,
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.images.length > 1) ...[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 8.toHeight,
                      margin: EdgeInsets.symmetric(vertical: 10.toHeight),
                      child: ListView.builder(
                        itemCount: widget.images?.length ?? 0,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(horizontal: 4.toWidth),
                          color: index == pageController.page
                              ? CustomTheme.of(context).colors.backgroundColor
                              : CustomTheme.of(context)
                                  .colors
                                  .backgroundColor
                                  .withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.toHeight),
                          ),
                          child: Container(
                            width: 8.toHeight,
                            height: 8.toHeight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
