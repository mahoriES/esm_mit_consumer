import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/models/order_models.dart';
import 'package:eSamudaay/modules/orders/views/widgets/rating_indicator.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/business_image_with_logo.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A local widget specific to feedback_view.
// In general, this view consists list of products and respective rating_widgets
// to take rating_value input for individual products .

class ProductRatingCard extends StatelessWidget {
  const ProductRatingCard({Key key}) : super(key: key);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BusinessImageWithLogo(
                        imageUrl: snapshot.orderDetails.businessImageUrl ?? ""),
                    Text(
                      snapshot.orderDetails.businessName,
                      style: CustomTheme.of(context)
                          .textStyles
                          .sectionHeading1Regular,
                    ),
                  ],
                ),
                Divider(
                  color: CustomTheme.of(context).colors.dividerColor,
                  thickness: 1,
                  height: 30,
                ),
                Text(
                  tr("screen_order_feedback.rate_products"),
                  style: CustomTheme.of(context).textStyles.sectionHeading2,
                ),
                const SizedBox(height: 4),
                Text(
                  tr("screen_order_feedback.rate_products_message"),
                  style: CustomTheme.of(context).textStyles.body2,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.orderDetails.orderItems.length,
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final OrderItems _currentOrder =
                          snapshot.orderDetails.orderItems[index];
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(
                                top: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _currentOrder.productName,
                                    style: CustomTheme.of(context)
                                        .textStyles
                                        .cardTitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    _currentOrder.variationOption.size,
                                    style: CustomTheme.of(context)
                                        .textStyles
                                        .body2,
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            ),
                          ),
                          RatingIndicator(
                            rating: snapshot.productRating(_currentOrder.skuId),
                            onRate: (ratingValue) async {
                              await snapshot.addProductRating(
                                _currentOrder.skuId,
                                ratingValue,
                              );
                            },
                            shouldIncludeMessage: false,
                          ),
                        ],
                      );
                    },
                  ),
                ),
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

  PlaceOrderResponse orderDetails;
  AddReviewRequest reviewRequest;
  Function(int, int) addProductRating;
  bool changedProductRatingList;

  _ViewModel.build({
    this.orderDetails,
    this.reviewRequest,
    this.addProductRating,
    this.changedProductRatingList,
  }) : super(equals: [changedProductRatingList]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      orderDetails: state.ordersState.selectedOrderDetails,
      reviewRequest: state.ordersState.reviewRequest,
      addProductRating: (productId, rating) async => await dispatchFuture(
        UpdateProductReviewRequest(productId: productId, rating: rating),
      ),
      changedProductRatingList: state.ordersState.changedProductRatingList,
    );
  }

  int productRating(int productId) {
    int rating = 0;
    if (reviewRequest.productRatings == null ||
        reviewRequest.productRatings.isEmpty) {
      return rating;
    }
    reviewRequest.productRatings.forEach((product) {
      if (product.productId == productId) {
        rating = product.ratingValue;
      }
    });
    return rating;
  }
}
