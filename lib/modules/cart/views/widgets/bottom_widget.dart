import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/cart_details_bottom_sheet.dart';
import 'package:flutter/material.dart';

import 'delivery_option_widget.dart';

class CartBottomWidget extends StatelessWidget {
  const CartBottomWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) => snapshot.isCartEmpty
          ? SizedBox.shrink()
          : BottomSheet(
              elevation: 4,
              enableDrag: false,
              onClosing: () {},
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DeliveryOptionWidget(),
                  CartDetailsBottomSheet(isOnCartScreen: true),
                ],
              ),
            ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  List<Product> productsList;
  List<String> customerNoteImages;

  _ViewModel.build({
    this.productsList,
    this.customerNoteImages,
  }) : super(equals: [productsList, customerNoteImages]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      productsList: state.cartState.localCartItems ?? [],
      customerNoteImages: state.cartState.customerNoteImages ?? [],
    );
  }

  bool get isCartEmpty => productsList.isEmpty && customerNoteImages.isEmpty;
}
