import 'dart:math';

import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RatingIndicator extends StatelessWidget {
  final int rating;
  final Function(int) onRate;
  final TextStyle style;
  final double iconSize;
  final bool shouldIncludeMessage;
  const RatingIndicator({
    @required this.rating,
    @required this.onRate,
    this.style,
    this.iconSize,
    this.shouldIncludeMessage = true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Setting iconSize to maximum 30 and responsive for smaller screen sizes by default.
    final double _size = iconSize ?? min((SizeConfig.screenWidth / 12), 30);

    return Column(
      children: [
        if (shouldIncludeMessage) ...{
          Text(
            rating == 0
                ? tr("screen_order.rating_pending_message")
                : rating < 3
                    ? tr("screen_order.poor_rating_message")
                    : rating == 3
                        ? tr("screen_order.average_rating_message")
                        : tr("screen_order.good_rating_message"),
            style: style ?? CustomTheme.of(context).textStyles.cardTitleFaded,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
        },
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (index) => InkWell(
              onTap: onRate == null ? null : () => onRate(index + 1),
              child: Padding(
                padding: EdgeInsets.only(left: index == 0 ? 0 : (_size / 5)),
                child: (rating == 0 || index + 1 <= rating)
                    ? Icon(
                        Icons.star,
                        color: rating == 0
                            ? CustomTheme.of(context).colors.placeHolderColor
                            : CustomTheme.of(context).colors.primaryColor,
                        size: _size,
                      )
                    : Icon(
                        Icons.star_outline,
                        color: CustomTheme.of(context).colors.primaryColor,
                        size: _size,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
