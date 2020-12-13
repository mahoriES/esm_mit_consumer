import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/head_categories/actions/categories_action.dart';
import 'package:eSamudaay/modules/head_categories/models/main_categories_response.dart';
import 'package:eSamudaay/modules/home/actions/home_page_actions.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/actions/categories_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/plain_business_tile.dart';
import 'package:eSamudaay/reusable_widgets/shimmering_view.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BusinessesListUnderSelectedCategoryScreen extends StatefulWidget {
  @override
  _BusinessesListUnderSelectedCategoryScreenState createState() =>
      _BusinessesListUnderSelectedCategoryScreenState();
}

class _BusinessesListUnderSelectedCategoryScreenState
    extends State<BusinessesListUnderSelectedCategoryScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _onRefresh(_ViewModel snapshot) async {
      if (snapshot.businessesResponse.previous == null) {
        await snapshot.getBusinessesList(ApiURL.getBusinessesUrl,
            snapshot.selectedCategory.categoryId.toString());
      }
      _refreshController.refreshCompleted();
    }

    void _onLoading(_ViewModel snapshot) async {
      if (snapshot.businessesResponse.next != null) {
        snapshot.getBusinessesList(snapshot.businessesResponse.next,
            snapshot.selectedCategory.categoryId.toString());
      }
      //if (mounted) setState(() {});
      _refreshController.loadComplete();
    }

    return StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        onInit: (store) {
          store.dispatchFuture(ClearPreviousCategoryDetailsAction());
          final String bCatId = store
              .state.homeCategoriesState.selectedCategory.categoryId
              .toString();
          store.dispatchFuture(GetBusinessesUnderSelectedCategory(
              getBusinessesUrl: ApiURL.getBusinessesUrl, categoryId: bCatId));
          store.dispatchFuture(
              GetPreviouslyBoughtBusinessesListUnderSelectedCategoryAction(
                  categoryId: bCatId));
        },
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: CustomTheme.of(context).colors.brandViolet,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.selectedCategory.categoryName ?? '',
                        style: CustomTheme.of(context).textStyles.topTileTitle,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        snapshot.selectedCategory.categoryDescription ?? '',
                        style: CustomTheme.of(context).textStyles.body1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body:(snapshot.showShimmering) ?  const ShimmeringView() : SmartRefresher(
              enablePullUp: true,
              controller: _refreshController,
              onLoading: () {
                _onLoading(snapshot);
              },
              onRefresh: () {
                _onRefresh(snapshot);
              },
              footer: CustomFooter(
                builder: (context, loadStatus) {
                  if (loadStatus == LoadStatus.loading)
                    return CupertinoActivityIndicator();
                  else
                    return SizedBox.shrink();
                },
              ),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: AppSizes.separatorPadding),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: AppSizes.separatorPadding),
                          child: Text(
                            'home_stores_categories.featured',
                            style: CustomTheme.of(context)
                                .textStyles
                                .sectionHeading2,
                          ).tr()),
                      ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final Business business =
                                snapshot.businessesUnderSelectedCategory[index];
                            return InkWell(
                              onTap: () {
                                snapshot.navigateToBusiness(business);
                              },
                              child: HybridBusinessTileConnector(
                                business: business,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: AppSizes.widgetPadding,
                            );
                          },
                          itemCount:
                              snapshot.businessesUnderSelectedCategory.length),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  Function(Business) navigateToBusiness;
  HomePageCategoryResponse selectedCategory;
  List<Business> previouslyBoughtBusinessesUnderSelectedCategory;
  List<Business> businessesUnderSelectedCategory;
  GetBusinessesResponse businessesResponse;
  Future<void> Function(String getUrl, String categoryId) getBusinessesList;
  bool showShimmering;

  _ViewModel.build(
      {this.selectedCategory,
      this.navigateToBusiness,
      this.businessesUnderSelectedCategory,
      this.businessesResponse,
      this.showShimmering,
      this.getBusinessesList,
      this.previouslyBoughtBusinessesUnderSelectedCategory})
      : super(equals: [
          selectedCategory,
          previouslyBoughtBusinessesUnderSelectedCategory,
          showShimmering,
          businessesResponse,
          businessesUnderSelectedCategory,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
        showShimmering: state.componentsLoadingState.businessesUnderCategoryLoading,
        businessesResponse: state.homeCategoriesState.currentBusinessResponse,
        selectedCategory: state.homeCategoriesState.selectedCategory,
        previouslyBoughtBusinessesUnderSelectedCategory: state
            .homeCategoriesState.previouslyBoughtBusinessUnderSelectedCategory,
        businessesUnderSelectedCategory:
            state.homeCategoriesState.businessesUnderSelectedCategory,
        navigateToBusiness: (business) {
          dispatch(UpdateSelectedMerchantAction(selectedMerchant: business));
          dispatch(ResetCatalogueAction());
          dispatch(NavigateAction.pushNamed('/StoreDetailsView'));
        },
        getBusinessesList: (getUrl, bCatId) async {
          await dispatchFuture(GetBusinessesUnderSelectedCategory(
              getBusinessesUrl: getUrl, categoryId: bCatId));
        });
  }
}
