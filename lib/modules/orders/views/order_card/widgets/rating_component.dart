import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingComponent extends StatelessWidget {
  final bool isAlreadyRated;
  final int rating;
  final Function(int) onRate;
  const RatingComponent({
    @required this.isAlreadyRated,
    this.rating,
    this.onRate,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          isAlreadyRated
              ? rating < 3
                  ? tr("screen_order.poor_rating_message")
                  : tr("screen_order.good_rating_message")
              : tr("screen_order.rating_pending_message"),
          style: CustomTheme.of(context).textStyles.cardTitleFaded,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        isAlreadyRated
            ? RatingBarIndicator(
                rating: rating.toDouble(),
                unratedColor: CustomTheme.of(context).colors.primaryColor,
                itemBuilder: (context, index) => Icon(
                  (index <= rating - 1)
                      ? Icons.star
                      : Icons.star_border_outlined,
                  color: CustomTheme.of(context).colors.primaryColor,
                ),
                itemSize: 30,
              )
            : RatingBar(
                onRatingUpdate: (ratingValue) => onRate(ratingValue.toInt()),
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: CustomTheme.of(context).colors.placeHolderColor,
                ),
                itemSize: 30,
              ),
      ],
    );
  }
}
