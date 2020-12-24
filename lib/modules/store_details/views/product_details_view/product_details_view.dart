import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/modules/store_details/views/product_details_view/widgets/product_details_image_carausel.dart';
import 'package:eSamudaay/reusable_widgets/cart_details_bottom_sheet.dart';
import 'package:eSamudaay/reusable_widgets/custom_app_bar.dart';
import 'package:eSamudaay/presentations/loading_dialog.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/product_count_widget/product_count_widget.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/link_sharing_service.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        Product selectedProduct = snapshot.selectedProduct;
        Business selectedMerchant = snapshot.selectedMerchant;
        return Scaffold(
          appBar: CustomAppBar(
            title: selectedProduct.productName,
            subTitle: selectedMerchant.businessName,
            actions: [
              IconButton(
                icon: Icon(Icons.share),
                iconSize: 30.toFont,
                onPressed: () async {
                  LoadingDialog.show();
                  await LinkSharingService().shareProductLink(
                    productId: selectedProduct.productId.toString(),
                    businessId: selectedMerchant.businessId,
                    storeName: selectedMerchant.businessName,
                  );
                  LoadingDialog.hide();
                },
              ),
            ],
          ),
          bottomSheet: CartDetailsBottomSheet(),
          body: ListView(
            children: [
              Hero(
                tag: selectedProduct.productName,
                child: ProductDetailsImageCarousel(
                  productName: selectedProduct.productName,
                  images: selectedProduct.images,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 22.toWidth,
                  vertical: 20.toHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedProduct.productName,
                                style: CustomTheme.of(context)
                                    .textStyles
                                    .topTileTitle,
                              ),
                              SizedBox(height: 5.toHeight),
                              Text(
                                selectedProduct.firstSkuWeight,
                                style: CustomTheme.of(context).textStyles.body2,
                              ),
                              SizedBox(height: 4.toHeight),
                              Text(
                                selectedProduct.firstSkuPrice,
                                style: CustomTheme.of(context).textStyles.body2,
                              ),
                              SizedBox(height: 4.toHeight),
                              if (selectedProduct.skus.length > 1) ...[
                                Text(
                                  tr("product_details.options_available"),
                                  style: CustomTheme.of(context)
                                      .textStyles
                                      .bottomMenu,
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(width: 8.toWidth),
                        Flexible(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (selectedProduct.hasRating) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 15.toFont,
                                      color: CustomTheme.of(context)
                                          .colors
                                          .primaryColor,
                                    ),
                                    SizedBox(width: 4.toWidth),
                                    Text(
                                      selectedProduct.getRatingValue,
                                      style: CustomTheme.of(context)
                                          .textStyles
                                          .cardTitle
                                          .copyWith(
                                            color: CustomTheme.of(context)
                                                .colors
                                                .primaryColor,
                                          ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 8.toHeight),
                              ],
                              ProductCountWidget(
                                product: selectedProduct,
                                isSku: false,
                                selectedMerchant: snapshot.selectedMerchant,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (selectedProduct.productDescription != null &&
                        selectedProduct.productDescription.trim() != "") ...[
                      SizedBox(height: 20.toHeight),
                      Text(
                        tr("product_details.product_information"),
                        style:
                            CustomTheme.of(context).textStyles.sectionHeading2,
                      ),
                      SizedBox(height: 11.toHeight),
                      Text(
                        selectedProduct.productDescription,
                        style: CustomTheme.of(context).textStyles.body1,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                    // SizedBox(height: 20.toHeight),
                    // ProductDetailsSimilarItemsWidget(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  Function navigateToCart;
  List<Product> localCartListing;
  List<JITProduct> freeFormItemsList;
  Business selectedMerchant;
  Product selectedProduct;

  _ViewModel();

  _ViewModel.build({
    this.navigateToCart,
    this.freeFormItemsList,
    this.localCartListing,
    this.selectedMerchant,
    this.selectedProduct,
  }) : super(
          equals: [
            localCartListing,
            selectedMerchant,
            freeFormItemsList,
            selectedProduct,
          ],
        );

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      freeFormItemsList: state.cartState.localFreeFormCartItems,
      navigateToCart: () {
        dispatch(NavigateAction.pushNamed('/CartView'));
      },
      localCartListing: state.cartState.localCartItems,
      selectedMerchant: state.productState.selectedMerchant,
      selectedProduct: state.productState.selectedProductForDetails,
    );
  }
}
