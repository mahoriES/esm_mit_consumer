import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/models/order_models.dart';
import 'package:eSamudaay/modules/orders/views/order_card/widgets/rating_component.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/business_image_with_logo.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductRatingWidget extends StatefulWidget {
  final PlaceOrderResponse orderResponse;
  const ProductRatingWidget(this.orderResponse, {Key key}) : super(key: key);

  @override
  _ProductRatingWidgetState createState() => _ProductRatingWidgetState();
}

class _ProductRatingWidgetState extends State<ProductRatingWidget> {
  @override
  Widget build(BuildContext context) {
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
                    imageUrl: widget.orderResponse.businessImageUrl ?? ""),
                Text(
                  widget.orderResponse.businessName,
                  style:
                      CustomTheme.of(context).textStyles.sectionHeading1Regular,
                ),
              ],
            ),
            Divider(
              color: CustomTheme.of(context).colors.dividerColor,
              thickness: 1,
              height: 30,
            ),
            Text(
              "Rate Products",
              style: CustomTheme.of(context).textStyles.sectionHeading2,
            ),
            const SizedBox(height: 4),
            Text(
              "Rate products you love to get better suggestions in the app",
              style: CustomTheme.of(context).textStyles.body2,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.orderResponse.orderItems.length,
                separatorBuilder: (context, index) => SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final OrderItems _currentOrder =
                      widget.orderResponse.orderItems[index];
                  return Row(
                    children: [
                      // if (_currentOrder.hasImages) ...[
                      //   ClipRRect(
                      //     borderRadius: BorderRadius.circular(4),
                      //     child: Container(
                      //       height: 100,
                      //       width: 100,
                      //       color:
                      //           CustomTheme.of(context).colors.placeHolderColor,
                      //       child: CachedNetworkImage(
                      //         imageUrl: _currentOrder.firstImageUrl,
                      //         height: 100,
                      //         width: 100,
                      //         placeholder: (context, url) =>
                      //             CupertinoActivityIndicator(),
                      //         errorWidget: (context, url, error) =>
                      //             Icon(Icons.image, size: 30),
                      //       ),
                      //     ),
                      //   ),
                      // ],
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            // left: _currentOrder.hasImages ? 18 : 0,
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
                                style: CustomTheme.of(context).textStyles.body2,
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                      StoreConnector<AppState, _ViewModel>(
                        model: _ViewModel(),
                        builder: (context, snapshot) {
                          return RatingComponent(
                            rating: snapshot.productRating(_currentOrder.skuId),
                            onRate: (ratingValue) async {
                              await snapshot.addProductRating(
                                _currentOrder.skuId,
                                ratingValue,
                              );
                              setState(() {});
                            },
                            shouldIncludeMessage: false,
                          );
                        },
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
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  AddReviewRequest reviewRequest;
  Function(int, int) addProductRating;

  _ViewModel.build({
    this.reviewRequest,
    this.addProductRating,
  }) : super(equals: [reviewRequest.productRatings]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      reviewRequest: state.ordersState.reviewRequest,
      addProductRating: (productId, rating) async => await dispatchFuture(
        UpdateProductReviewRequest(productId: productId, rating: rating),
      ),
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
