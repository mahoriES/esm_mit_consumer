import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///[CircleBannersCarousel] implements the horizontal carousel view of the promotional banners
///for the circle. These banners are meant for the promotion related stuff for the circle.
///These are added by the CP or the admin.
///
/// This is mainly a dumb-widget, which is oblivious of state/store
class CircleBannersCarousel extends StatefulWidget {
  ///List of banners fetched from  the API, for the selected circle
  final List<Photo> banners;

  const CircleBannersCarousel({Key key, @required this.banners})
      : super(key: key);

  @override
  _CircleBannersCarouselState createState() => _CircleBannersCarouselState();
}

class _CircleBannersCarouselState extends State<CircleBannersCarousel> {
  ///[_current] holds the index of the current visible page in the carousel
  ///This is used to highlight the correct page indicator
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.banners == null || widget.banners.isEmpty)
      return SizedBox.shrink();
    return Padding(padding: EdgeInsets.only(top: AppSizes.separatorPadding),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CarouselSlider(
            items: widget.banners
                    .map((banner) => CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: banner.photoUrl,
                        placeholder: (context, url) =>
                            CupertinoActivityIndicator(),
                        errorWidget: (context, url, error) => Center(
                              child: Icon(Icons.error),
                            )))
                    .toList(),
            aspectRatio: 374 / 211,
            viewportFraction: 1.0,
            initialPage: 0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            pauseAutoPlayOnTouch: const Duration(seconds: 10),
            scrollDirection: Axis.horizontal,
            onPageChanged: (index) {setState(() {
              _current = index;
            });},
          ),
          ///Implementation of the page indicator
          Positioned(bottom: 10,child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.banners.map((url) {
              int index = widget.banners.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? CustomTheme.of(context).colors.backgroundColor
                      : CustomTheme.of(context)
                      .colors
                      .backgroundColor
                      .withOpacity(0.5),
                ),
              );
            }).toList(),
          ))
        ],
      ),
    );
  }
}
