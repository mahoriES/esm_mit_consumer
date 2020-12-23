import 'dart:ui';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/cart/models/charge_details_response.dart';
import 'package:eSamudaay/modules/cart/views/cart_bottom_view.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/presentations/loading_indicator.dart';
import 'package:eSamudaay/presentations/no_iems_view.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/custom_app_bar.dart';
import 'package:eSamudaay/reusable_widgets/product_count_widget/product_count_widget.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:eSamudaay/utilities/extensions.dart';

part "widgets/catalogue_items_card.dart";
part "widgets/charges_list_view.dart";
part "widgets/list_images_widget.dart";
part "widgets/customer_note_widget.dart";
part "widgets/cart_bottom_sheet.dart";

class CartScreen extends StatefulWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // final ScrollController _controller = new ScrollController();

  // @override
  // void initState() {
  //   super.initState();
  //   _controller.addListener(() {
  //     if(_controller.)
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) => GestureDetector(
        onTap: () {
          print("******************** onat p 9");
          snapshot._overlayEntry?.remove();
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: snapshot.appBarTitle,
            subTitle: snapshot.appBarSubtitle,
          ),
          // bottomSheet: CartBottomSheet(ORDER_TYPE.DELIVERY),
          body: ModalProgressHUD(
            progressIndicator: LoadingIndicator(),
            inAsyncCall: snapshot.isCartLoading,
            child: !snapshot.isDataAddedInCart
                ? Center(child: NoItemsFoundView())
                : SingleChildScrollView(
                    // controller: _controller,
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          _CatalogueItemCard(snapshot),
                          const SizedBox(height: 20),
                          _ListImagesWidget(snapshot),
                          const SizedBox(height: 20),
                          _CustomerNoteWidget(),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 58),
                            child: Text(
                              tr("cart.cart_message"),
                              style: CustomTheme.of(context)
                                  .textStyles
                                  .cardTitleSecondary,
                            ),
                          ),
                          const SizedBox(height: 260),
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
  List<String> listImages;
  bool isCartLoading;
  CartCharges charges;

  _ViewModel.build({
    this.cartMerchant,
    this.productsList,
    this.listImages,
    this.isCartLoading,
    this.charges,
  }) : super(equals: [
          cartMerchant,
          productsList,
          listImages,
          isCartLoading,
          charges,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      cartMerchant: state.cartState.cartMerchant,
      productsList: state.cartState.localCartItems ?? [],
      listImages: state.cartState.customerNoteImages ?? [],
      isCartLoading: state.cartState.isCartLoading ?? false,
      charges: state.cartState.charges,
    );
  }

  String get _storeName => cartMerchant?.businessName ?? "";
  int get productsCount => productsList.length;
  int get listImagesCount => listImages.length;
  int get totalCount => productsCount + listImagesCount;

  String get appBarTitle => isDataAddedInCart ? _storeName : "Cart";

  String get appBarSubtitle {
    if (totalCount == 0) return null;
    return (productsCount > 0 ? "$productsCount Item" : "") +
        (productsCount > 1 ? "s" : "") +
        (productsCount > 0 && listImagesCount > 0 ? " , " : "") +
        (listImagesCount > 0 ? "$listImagesCount List" : "") +
        (listImagesCount > 1 ? "s" : "") +
        " added";
  }

  double get getCartTotal {
    if (productsList.isEmpty) return 0;
    return productsList.fold(0, (previous, current) {
          double price = current.selectedSkuPrice * current.count;
          return (previous + price);
        }) ??
        0;
  }

  OverlayEntry _overlayEntry;

  double get deliveryCharge => charges?.deliveryCharge?.amount?.toDouble() ?? 0;
  double get packingCharge => charges?.packingCharge?.amount?.toDouble() ?? 0;
  double get serviceCharge => charges?.serviceCharge?.amount?.toDouble() ?? 0;

  double get merchantCharge => packingCharge + serviceCharge;

  double get grandTotal => getCartTotal + deliveryCharge + merchantCharge;

  bool get isDataAddedInCart =>
      cartMerchant != null &&
      (productsList.isNotEmpty || listImages.isNotEmpty);
}
