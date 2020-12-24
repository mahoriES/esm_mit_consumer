import 'dart:ui';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/cart/views/widgets/catalogue_items_widget.dart';
import 'package:eSamudaay/modules/cart/views/widgets/charges_list_widget/charges_list_widget.dart';
import 'package:eSamudaay/modules/cart/views/widgets/customer_note_images_view/customer_note_images_view.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/presentations/loading_dialog.dart';
import 'package:eSamudaay/presentations/loading_indicator.dart';
import 'package:eSamudaay/presentations/no_iems_view.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/cart_details_bottom_sheet.dart';
import 'package:eSamudaay/reusable_widgets/custom_app_bar.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'widgets/delivery_option_widget.dart';

class CartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      onDidChange: (snapshot) {
        debugPrint(
            "on changes cart view ${snapshot.cartMerchant} && ${snapshot.isDataAddedInCart}");
        if (snapshot.isAddressLoading) {
          LoadingDialog.show();
        } else {
          LoadingDialog.hide();
        }
      },
      builder: (context, snapshot) => Scaffold(
        appBar: CustomAppBar(
          title: snapshot.appBarTitle,
          subTitle: snapshot.appBarSubtitle,
        ),
        bottomSheet: snapshot.isDataAddedInCart
            ? BottomSheet(
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
              )
            : null,
        body: ModalProgressHUD(
          progressIndicator: LoadingIndicator(),
          inAsyncCall: snapshot.isCartLoading,
          child: !snapshot.isDataAddedInCart
              ? Center(child: NoItemsFoundView())
              : SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        if (snapshot.productsCount > 0) ...[
                          Card(
                            elevation: 4,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Column(
                                children: [
                                  CartCatalogueItemsWidget(),
                                  CartChargesListWidget(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        CartCustomerNoteImagesWidget(),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          child: TextField(
                            controller: snapshot.noteController,
                            decoration: InputDecoration(
                              focusColor:
                                  CustomTheme.of(context).colors.primaryColor,
                              prefixIcon: Icon(Icons.edit),
                              hintText: "Add a note for merchant",
                              hintStyle: CustomTheme.of(context)
                                  .textStyles
                                  .cardTitleFaded,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: Text(
                            tr("cart.cart_message"),
                            style: CustomTheme.of(context)
                                .textStyles
                                .cardTitleSecondary
                                .copyWith(height: 1.5),
                          ),
                        ),
                        const SizedBox(height: 300),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  Business cartMerchant;
  List<Product> productsList;
  List<String> customerNoteImages;
  bool isCartLoading;
  TextEditingController noteController;
  bool isAddressLoading;

  _ViewModel.build({
    this.cartMerchant,
    this.productsList,
    this.customerNoteImages,
    this.isCartLoading,
    this.noteController,
    this.isAddressLoading,
  }) : super(equals: [cartMerchant, isCartLoading, isAddressLoading]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      cartMerchant: state.cartState.cartMerchant,
      productsList: state.cartState.localCartItems ?? [],
      customerNoteImages: state.cartState.customerNoteImages ?? [],
      isCartLoading: state.cartState.isCartLoading ?? false,
      noteController: state.cartState.customerNoteMessage,
      isAddressLoading: state.addressState.isLoading,
    );
  }

  String get _storeName => cartMerchant?.businessName ?? "";
  int get productsCount => productsList.length;
  int get customerNoteImagesCount => customerNoteImages.length;
  int get totalCount => productsCount + customerNoteImagesCount;

  String get appBarTitle => isDataAddedInCart ? _storeName : "Cart";

  String get appBarSubtitle {
    if (!isDataAddedInCart) return null;
    if (totalCount == 0) return null;
    return (productsCount > 0 ? "$productsCount Item" : "") +
        (productsCount > 1 ? "s" : "") +
        (productsCount > 0 && customerNoteImagesCount > 0 ? " , " : "") +
        (customerNoteImagesCount > 0 ? "$customerNoteImagesCount List" : "") +
        (customerNoteImagesCount > 1 ? "s" : "") +
        " added";
  }

  bool get isDataAddedInCart =>
      cartMerchant != null &&
      (productsList.isNotEmpty || customerNoteImages.isNotEmpty);
}
