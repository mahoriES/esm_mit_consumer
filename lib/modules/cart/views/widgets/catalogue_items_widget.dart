import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/product_count_widget/product_count_widget.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eSamudaay/utilities/extensions.dart';
import 'package:flutter/material.dart';

class CartCatalogueItemsWidget extends StatelessWidget {
  const CartCatalogueItemsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr("cart.catalogue_items"),
            style: CustomTheme.of(context).textStyles.body1,
          ),
          const SizedBox(height: 20),
          ListView.builder(
            itemCount: snapshot.productsList.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final Product _currentProduct = snapshot.productsList[index];
              if (_currentProduct.count == 0) return SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentProduct.productName,
                            style: CustomTheme.of(context).textStyles.cardTitle,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _currentProduct.selectedSkuWeight,
                            style: CustomTheme.of(context).textStyles.body2,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ProductCountWidget(
                        product: _currentProduct,
                        selectedMerchant: snapshot.cartMerchant,
                        isSku: true,
                        // skuIndex: _currentProduct.selectedSkuIndex,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _currentProduct.selectedSkuPrice.withRupeePrefix,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(
            color: CustomTheme.of(context).colors.dividerColor,
            thickness: 1,
            height: 5,
          ),
          const SizedBox(height: 15)
        ],
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  Business cartMerchant;
  List<Product> productsList;

  _ViewModel.build({
    this.cartMerchant,
    this.productsList,
  });

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      cartMerchant: state.cartState.cartMerchant,
      productsList: state.cartState.localCartItems ?? [],
    );
  }
}
