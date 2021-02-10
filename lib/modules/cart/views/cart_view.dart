import 'dart:ui';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/cart/views/widgets/bottom_widget.dart';
import 'package:eSamudaay/modules/cart/views/widgets/catalogue_items_widget.dart';
import 'package:eSamudaay/modules/cart/views/widgets/charges_list_widget/charges_list_widget.dart';
import 'package:eSamudaay/modules/cart/views/widgets/customer_note_images_view/customer_note_images_view.dart';
import 'package:eSamudaay/modules/cart/views/widgets/empty_cart_view.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/register/model/register_request_model.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/presentations/loading_dialog.dart';
import 'package:eSamudaay/presentations/loading_indicator.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/custom_app_bar.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      onDidChange: (snapshot) {
        // TODO : use a common action to handle loading dialog.
        if (snapshot.isImageUploading) {
          LoadingDialog.show();
        } else {
          LoadingDialog.hide();
        }
      },
      builder: (context, snapshot) => GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: ModalProgressHUD(
          progressIndicator: LoadingIndicator(),
          inAsyncCall: snapshot.isCartLoading,
          child: !snapshot.isMerchantSelected
              ? EmptycartView()
              : Scaffold(
                  appBar: CustomAppBar(
                    title: snapshot.appBarTitle,
                    subTitle: snapshot.appBarSubtitle,
                    isStoreClosed: snapshot.isStoreClosed,
                  ),
                  bottomSheet: CartBottomWidget(),
                  body: SingleChildScrollView(
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
                                hintText: tr(
                                  "cart.add_a_note",
                                  args: [snapshot.storeName],
                                ),
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
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  Business cartMerchant;
  List<Product> productsList;
  List<Photo> customerNoteImages;
  bool isCartLoading;
  TextEditingController noteController;
  bool isImageUploading;
  bool isStoreClosed;

  _ViewModel.build({
    this.cartMerchant,
    this.productsList,
    this.customerNoteImages,
    this.isCartLoading,
    this.isStoreClosed,
    this.noteController,
    this.isImageUploading,
  }) : super(equals: [cartMerchant, isCartLoading, isImageUploading, isStoreClosed]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      isStoreClosed: !(state.cartState.cartMerchant?.isOpen ?? false),
      cartMerchant: state.cartState.cartMerchant,
      productsList: state.cartState.localCartItems ?? [],
      customerNoteImages: state.cartState.customerNoteImages ?? [],
      isCartLoading: state.cartState.isCartLoading ?? false,
      noteController: state.cartState.customerNoteMessage,
      isImageUploading: state.cartState.isImageUploading,
    );
  }

  String get storeName => cartMerchant?.businessName ?? "";
  int get productsCount => productsList.length;
  int get customerNoteImagesCount => customerNoteImages.length;
  int get totalCount => productsCount + customerNoteImagesCount;

  String get appBarTitle => isMerchantSelected ? storeName : "";

  String get appBarSubtitle {
    if (!isMerchantSelected) return "";
    if (totalCount == 0) return "";
    return (productsCount > 0
            ? ("$productsCount " +
                tr("cart.${productsCount > 1 ? 'items' : 'item'}"))
            : "") +
        ((productsCount > 0 && customerNoteImagesCount > 0) ? " , " : "") +
        (customerNoteImagesCount > 0
            ? ("$customerNoteImagesCount " +
                tr("cart.${customerNoteImagesCount > 1 ? 'lists' : 'list'}"))
            : "") +
        " " +
        tr("cart.added");
  }

  bool get isMerchantSelected => cartMerchant != null;

  bool get isCartEmpty => productsList.isEmpty && customerNoteImages.isEmpty;
}
