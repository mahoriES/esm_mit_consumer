import 'dart:math';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/models/order_models.dart';
import 'package:eSamudaay/modules/orders/views/order_card/widgets/card_header.dart';
import 'package:eSamudaay/modules/orders/views/order_card/widgets/rating_indicator.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/validators/validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// A local widget specific to feedback_view.
// In general, this view consists a widget to rate the overall order and a text input for feedback comments.

class OrderRatingCard extends StatelessWidget {
  OrderRatingCard({Key key}) : super(key: key);
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                OrderCardHeader(snapshot.orderDetails),
                const SizedBox(height: 36),
                RatingIndicator(
                  rating: snapshot.orderRating,
                  style: CustomTheme.of(context).textStyles.topTileTitle,
                  iconSize: min((SizeConfig.screenWidth / 8), 45),
                  onRate: (value) =>
                      snapshot.updateOrderRating(value, _controller.text),
                ),
                const SizedBox(height: 36),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38),
                  child: TextFormField(
                    maxLines: null,
                    minLines: 1,
                    controller: _controller,
                    validator: Validators.nullStringValidator,
                    decoration: InputDecoration(
                      hintText: snapshot.getHintText,
                    ),
                    style: CustomTheme.of(context).textStyles.cardTitle,
                    textAlign: TextAlign.center,
                    onChanged: (v) {
                      snapshot.updateOrderRating(
                        snapshot.orderRating,
                        _controller.text,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  AddReviewRequest reviewRequest;
  Function(int, String) updateOrderRating;
  PlaceOrderResponse orderDetails;

  _ViewModel.build({
    this.reviewRequest,
    this.updateOrderRating,
    this.orderDetails,
  }) : super(equals: [reviewRequest]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      orderDetails: state.ordersState.selectedOrderDetails,
      reviewRequest: state.ordersState.reviewRequest,
      updateOrderRating: (rating, comment) => dispatch(
        UpdateOrderReviewRequest(rating: rating, comment: comment),
      ),
    );
  }

  int get orderRating => reviewRequest.ratingValue ?? 0;

  String get getHintText {
    return orderRating < 3
        ? tr("screen_order.poor_feedback_hint")
        : orderRating == 3
            ? tr("screen_order.average_feedback_hint")
            : tr("screen_order.good_feedback_hint");
  }
}
