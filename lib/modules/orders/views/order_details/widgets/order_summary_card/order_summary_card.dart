import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/cart/views/widgets/charges_list_widget/widgets/widgets.dart';
import 'package:eSamudaay/modules/cart/views/widgets/customer_note_images_view/widgets/widgets.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/views/widgets/secondary_action_button.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/custom_positioned_dialog.dart';
import 'package:eSamudaay/reusable_widgets/dashed_line.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/extensions.dart';

part 'widgets.dart';

class OrderSummaryCard extends StatelessWidget {
  OrderSummaryCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        final OrderStateData stateData = OrderStateData.getStateData(
          orderDetails: snapshot.orderDetails,
          context: context,
        );

        debugPrint("order summary => ${stateData.secondaryAction}");

        return Container(
          padding: const EdgeInsets.all(12),
          child: Card(
            elevation: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 23),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr("screen_order.order_summary"),
                        style:
                            CustomTheme.of(context).textStyles.sectionHeading2,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        snapshot.itemAvailabilityString,
                        style: CustomTheme.of(context).textStyles.body1Faded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    color: CustomTheme.of(context).colors.dividerColor,
                    thickness: 1,
                    height: 0,
                  ),
                  const SizedBox(height: 16),

                  // available item list
                  if (snapshot.availableItems.isNotEmpty) ...{
                    _OrderSummaryAvailableItemsList(
                      availableItemsList: snapshot.availableItems,
                      isOrderConfirmed: stateData.isOrderConfirmed,
                    ),
                  },

                  // charges list
                  ChargesList(snapshot.orderDetails),

                  // unavailable items list (if nonzero)
                  if (snapshot.unavailableItems.isNotEmpty) ...{
                    _OrderSummaryNoAvailableItemsList(
                      unavailableItemsList: snapshot.unavailableItems,
                    ),
                  },

                  // list images and freeform items list (if nonzero)
                  if (snapshot.hasCustomerNoteImages ||
                      snapshot.freeFormOrderItems.isNotEmpty) ...[
                    CustomerListItemsView(
                      customerNoteImages:
                          snapshot.orderDetails.customerNoteImages,
                      freeFormItems: snapshot.freeFormOrderItems,
                    ),
                  ],

                  // secondary action button : CANCEL/REORDER.
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: stateData.secondaryAction == SecondaryAction.CANCEL
                          ? CancelOrderButton(
                              onCancel: snapshot.onCancel,
                              orderCreationTimeDiffrenceInSeconds: snapshot
                                  .orderDetails
                                  .orderCreationTimeDiffrenceInSeconds,
                            )
                          : stateData.secondaryAction == SecondaryAction.REORDER
                              ? ReorderButton(snapshot.onReorder)
                              : stateData.secondaryAction ==
                                      SecondaryAction.REJECT
                                  ? RejectOrderButton(snapshot.onCancel)
                                  : SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
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
  Function(String) onCancel;
  Function() onReorder;

  _ViewModel.build({
    this.orderDetails,
    this.onCancel,
    this.onReorder,
  });

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      orderDetails: state.ordersState.selectedOrderDetails,
      onCancel: (String cancellationNote) {
        dispatch(
          CancelOrderAPIAction(
            orderId: state.ordersState.selectedOrderDetails.orderId,
            cancellationNote: cancellationNote,
          ),
        );
      },
      onReorder: () {
        dispatch(NavigateAction.pop());
        dispatch(
          ReorderAction(
            orderResponse: state.ordersState.selectedOrderDetails,
            shouldFetchOrderDetails: false,
          ),
        );
      },
    );
  }

  bool get isOrderCancelled =>
      orderDetails.orderStatus == OrderState.CUSTOMER_CANCELLED ||
      orderDetails.orderStatus == OrderState.MERCHANT_CANCELLED;

  List<OrderItems> get availableItems {
    List<OrderItems> temp = [];
    orderDetails.orderItems.forEach((product) {
      if (product.productStatus == ProductStatus.Available) {
        temp.add(product);
      }
    });
    return temp;
  }

  int get availableItemCount => availableItems.length;
  int get unavailableItemCount => unavailableItems.length;
  int get totalItemsCount => orderDetails.orderItems.length;

  String get itemAvailabilityString {
    if (unavailableItemCount == 0)
      return "$totalItemsCount " +
          (totalItemsCount > 1
              ? tr("product_details.items")
              : tr("product_details.item"));

    return "$availableItemCount/$totalItemsCount " +
        tr("screen_order.items_available");
  }

  List<OrderItems> get unavailableItems {
    List<OrderItems> temp = [];
    orderDetails.orderItems.forEach((product) {
      if (product.productStatus == ProductStatus.NotAvailable) {
        temp.add(product);
      }
    });
    return temp;
  }

  bool get hasCustomerNoteImages =>
      orderDetails.customerNoteImages != null &&
      orderDetails.customerNoteImages.length > 0;

  List<FreeFormOrderItems> get freeFormOrderItems =>
      orderDetails.freeFormOrderItems ?? [];
}
