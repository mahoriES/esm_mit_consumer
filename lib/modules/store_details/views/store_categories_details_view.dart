import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/home/actions/home_page_actions.dart';
import 'package:esamudaayapp/modules/home/models/category_response.dart';
import 'package:esamudaayapp/modules/home/models/merchant_response.dart';
import 'package:esamudaayapp/modules/store_details/actions/categories_actions.dart';
import 'package:esamudaayapp/modules/store_details/actions/store_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/repository/cart_datasourse.dart';
import 'package:esamudaayapp/store.dart';
import 'package:esamudaayapp/utilities/colors.dart';
import 'package:flutter/material.dart';

class StoreDetailsView extends StatefulWidget {
  @override
  _StoreDetailsViewState createState() => _StoreDetailsViewState();
}

class _StoreDetailsViewState extends State<StoreDetailsView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        List<Business> merchants = await CartDataSource.getListOfMerchants();
        if (merchants.isNotEmpty &&
            merchants.first.businessId !=
                store.state.productState.selectedMerchand.businessId) {
          var localMerchant = merchants.first;
          store.dispatch(
              UpdateSelectedMerchantAction(selectedMerchant: localMerchant));
        }
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () async {
                  List<Business> merchants =
                      await CartDataSource.getListOfMerchants();
                  if (merchants.isNotEmpty &&
                      merchants.first.businessId !=
                          store
                              .state.productState.selectedMerchand.businessId) {
                    var localMerchant = merchants.first;
                    store.dispatch(UpdateSelectedMerchantAction(
                        selectedMerchant: localMerchant));
                  }
                  Navigator.pop(context);
                }),
          ),
          body: StoreConnector<AppState, _ViewModel>(
              model: _ViewModel(),
              onInit: (store) {
                store.dispatch(GetCategoriesDetailsAction());
              },
              builder: (context, snapshot) {
                return snapshot.loadingStatus == LoadingStatus.loading
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ListView(
                        children: <Widget>[
                          Container(
//                    height: 130,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x29000000),
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      // Organic Store
                                      Text(
                                          snapshot.selectedMerchant
                                                  ?.businessName ??
                                              "",
                                          style: const TextStyle(
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Avenir",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 22.0),
                                          textAlign: TextAlign.left),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      // Milk, Egg, Bread, etc..
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Text(
                                                  snapshot.selectedMerchant
                                                          ?.description ??
                                                      "",
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff797979),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Avenir",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 14.0),
                                                  textAlign: TextAlign.left),
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8),
                                                child: snapshot.selectedMerchant
                                                        .hasDelivery
                                                    ? Image.asset(
                                                        'assets/images/delivery.png')
                                                    : Image.asset(
                                                        'assets/images/no_delivery.png'),
                                              ),
                                              Text(
                                                  snapshot.selectedMerchant
                                                          .hasDelivery
                                                      ? tr("shop.delivery_ok")
                                                      : tr("shop.delivery_no"),
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff6f6f6f),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Avenir",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16.0),
                                                  textAlign: TextAlign.left),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20, bottom: 10),
                                  child: MySeparator(
                                    color: AppColors.darkGrey,
                                    height: 0.5,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 10, top: 15, bottom: 20),
                                  child: Row(
                                    children: <Widget>[
                                      ImageIcon(
                                        AssetImage(
                                          'assets/images/path330.png',
                                        ),
                                        color: AppColors.darkGrey,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Text(
                                              snapshot.selectedMerchant?.address
                                                      ?.prettyAddress ??
                                                  "",
//                                              snapshot.selectedMerchant.address
//                                                      .addressLine1 +
//                                                  ", " +
//                                                  snapshot.selectedMerchant
//                                                      .address.addressLine2,
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff6f6f6f),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Avenir",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14.0),
                                              textAlign: TextAlign.left),
                                        ),
                                      ),
                                      ImageIcon(
                                        AssetImage(
                                          'assets/images/location2.png',
                                        ),
                                        color: AppColors.darkGrey,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 30, bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      "shop.item_category",
                                      style: TextStyle(
                                        color: Color(0xff151515),
                                        fontSize: 18,
                                        fontFamily: 'Avenir',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ).tr(),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: GridView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 20.0,
                                              mainAxisSpacing: 20.0,
                                              childAspectRatio: 100 / 130),
                                      itemBuilder: (context, index) {
                                        return Container(
//                                  color: Colors.red,
                                          child: InkWell(
                                            onTap: () {
                                              snapshot.updateSelectedCategory(
                                                  snapshot.categories[index]);
                                              snapshot
                                                  .navigateToProductDetails();
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: Color(0xffe0e0e0),
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    child: Container(
                                                      width: double.infinity,
//                                              padding: EdgeInsets.all(10),
                                                      child:
//                                            Image.asset(imageList[index])

                                                          Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child:
                                                            CachedNetworkImage(
                                                                height: 75,
                                                                fit: BoxFit
                                                                    .cover,
//                                                  height: 80,
                                                                imageUrl: snapshot
                                                                        .categories[
                                                                            index]
                                                                        .images
                                                                        .isEmpty
                                                                    ? ""
                                                                    : snapshot
                                                                        .categories[
                                                                            index]
                                                                        .images
                                                                        .first
                                                                        .photoUrl,
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Container(
//                                                              height: 170,
                                                                        child: Icon(Icons
                                                                            .image)),
                                                                errorWidget:
                                                                    (context,
                                                                            url,
                                                                            error) =>
                                                                        Center(
                                                                          child:
                                                                              Icon(Icons.error),
                                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
//                                      height: 30,
                                                  child: Center(
                                                    child: Text(
                                                        snapshot
                                                            .categories[index]
                                                            .categoryName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            color: const Color(
                                                                0xff747474),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                "JTLeonor",
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 15.0)),
                                                  ),
                                                ),
                                                Spacer()
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: snapshot.categories.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
              })),
    );
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  Function() navigateToProductDetails;
  Function(CategoriesNew) updateSelectedCategory;
  Business selectedMerchant;
  List<CategoriesNew> categories;
  LoadingStatus loadingStatus;
  _ViewModel();
  _ViewModel.build(
      {this.navigateToProductDetails,
      this.loadingStatus,
      this.categories,
      this.selectedMerchant,
      this.updateSelectedCategory})
      : super(equals: [selectedMerchant, loadingStatus, categories]);
  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        categories: state.productState.categories,
        updateSelectedCategory: (category) {
          dispatch(UpdateSelectedCategoryAction(selectedCategory: category));
        },
        navigateToProductDetails: () {
          dispatch(GetCatalogDetailsAction());
          dispatch(
            NavigateAction.pushNamed('/StoreProductListingView'),
          );
        },
        loadingStatus: state.authState.loadingStatus,
        selectedMerchant: state.productState.selectedMerchand);
  }
}
