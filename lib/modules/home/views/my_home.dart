import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/accounts/views/accounts_view.dart';
import 'package:eSamudaay/modules/cart/views/cart_view.dart';
import 'package:eSamudaay/modules/circles/views/circle_picker_view.dart';
import 'package:eSamudaay/modules/home/actions/home_page_actions.dart';
import 'package:eSamudaay/modules/home/models/cluster.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/home/views/cart_bottom_navigation_view.dart';
import 'package:eSamudaay/modules/home/views/home_page_main_view.dart';
import 'package:eSamudaay/modules/orders/views/orders_View.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/stringConstants.dart';
import 'package:esamudaay_app_update/app_update_banner.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaay_themes/esamudaay_themes.dart' as themesPackage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyHomeView extends StatefulWidget {
  MyHomeView({
    Key key,
  }) : super(key: key);

  @override
  _MyHomeViewState createState() => _MyHomeViewState();
}

class _MyHomeViewState extends State<MyHomeView> with TickerProviderStateMixin {
  final PageStorageBucket bucket = PageStorageBucket();

  final Key keyOne = PageStorageKey('dailyLog');

  final Key keyTwo = PageStorageKey('projects');

  final Key keyThree = PageStorageKey('queue');

  GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');

  Widget currentPage({index: int, bool shouldShowCircleScreenInstead}) {
    if (index == 0) {
      return shouldShowCircleScreenInstead
          ? CirclePickerView()
          : HomePageMainView();
    } else if (index == 1) {
      return OrdersView();
    } else if (index == 2) {
      return CartView();
    } else {
      return AccountsView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StoreConnector<AppState, _ViewModel>(
          model: _ViewModel(),
          onInit: (store) {
            if (!store.state.isInitializationDone)
              store.dispatch(HomePageOnInitMultipleDispatcherAction());
          },
          onInitialBuild: (snapshot) {
            snapshot.checkForAppUpdate(context);
          },
          builder: (context, snapshot) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                snapshot.showAppUpdateBanner
                    ? AppUpdateBanner(
                        updateMessage: tr('app_update.banner_msg'),
                        updateButtonText: tr('app_update.update').toUpperCase(),
                        customThemeData:
                            themesPackage.EsamudaayTheme.of(context),
                        packageName: StringConstants.packageName,
                      )
                    : SizedBox.shrink(),
                BottomNavigationBar(
                  selectedItemColor:
                      CustomTheme.of(context).colors.primaryColor,
                  currentIndex: snapshot.currentIndex,
                  type: BottomNavigationBarType.fixed,
                  selectedLabelStyle: activatedTextStyle,
                  unselectedLabelStyle: deactivatedTextStyle,
                  items: [
                    BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage('assets/images/path330.png'),
                      ),
                      activeIcon: ImageIcon(
                        AssetImage('assets/images/path330.png'),
                      ),
                      label: tr('screen_home.tab_bar.store'),
                    ),
                    BottomNavigationBarItem(
                        icon: ImageIcon(
                          AssetImage('assets/images/path338.png'),
                        ),
                        activeIcon: ImageIcon(
                          AssetImage('assets/images/path338.png'),
                        ),
                        label: tr('screen_home.tab_bar.orders')),
                    BottomNavigationBarItem(
                        icon: NavigationCartItem(
                          icon: ImageIcon(
                            AssetImage(
                              'assets/images/bag2.png',
                            ),
                          ),
                        ),
                        activeIcon: NavigationCartItem(
                          icon: ImageIcon(
                            AssetImage('assets/images/bag2.png'),
                          ),
                        ),
                        label: tr('screen_home.tab_bar.cart')),
                    BottomNavigationBarItem(
                        icon: ImageIcon(
                          AssetImage('assets/images/path5.png'),
                        ),
                        activeIcon: ImageIcon(
                          AssetImage('assets/images/path5.png'),
                        ),
                        label: tr('screen_home.tab_bar.account'))
                  ],
                  onTap: (index) {
                    snapshot.updateCurrentIndex(index);
                  },
                ),
              ],
            );
          }),
      body: StoreConnector<AppState, _ViewModel>(
          model: _ViewModel(),
          builder: (context, snapshot) {
            return PageStorage(
                bucket: bucket,
                child: currentPage(
                    index: snapshot.currentIndex,
                    shouldShowCircleScreenInstead:
                        snapshot.selectedCluster == null));
          }),
    );
  }

  TextStyle get activatedTextStyle =>
      CustomTheme.of(context).textStyles.bottomMenu;

  TextStyle get deactivatedTextStyle => CustomTheme.of(context)
      .textStyles
      .bottomMenu
      .copyWith(color: CustomTheme.of(context).colors.disabledAreaColor);

  double height(BuildContext context, int totalItemCount) {
    var totalHeight = MediaQuery.of(context).size.height;
    var emptySpace = totalHeight - 250 + 150;
    var numberOfItemsInEmptySpace = (emptySpace ~/ 150).toInt();
    var remainingItemCount = totalItemCount - numberOfItemsInEmptySpace;
    return emptySpace + (130 * remainingItemCount);
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  Function navigateToAddAddressPage;
  Function navigateToProductSearch;
  Function updateCurrentIndex;
  VoidCallback getMerchants;
  Function(Business) updateSelectedMerchant;
  Cluster selectedCluster;
  int currentIndex;
  bool showAppUpdateBanner;
  Function(BuildContext) checkForAppUpdate;

  _ViewModel.build({
    this.navigateToAddAddressPage,
    this.getMerchants,
    this.navigateToProductSearch,
    this.updateCurrentIndex,
    this.selectedCluster,
    this.updateSelectedMerchant,
    this.currentIndex,
    this.showAppUpdateBanner,
    this.checkForAppUpdate,
  }) : super(equals: [currentIndex, selectedCluster, showAppUpdateBanner]);

  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        selectedCluster: state.authState.cluster,
        updateSelectedMerchant: (merchant) {
          dispatch(UpdateSelectedMerchantAction(selectedMerchant: merchant));
        },
        getMerchants: () {
          dispatch(GetMerchantDetails());
        },
        navigateToAddAddressPage: () {
          dispatch(NavigateAction.pushNamed('/AddAddressView'));
        },
        navigateToProductSearch: () {
          dispatch(NavigateAction.pushNamed('/ProductSearchView'));
        },
        updateCurrentIndex: (index) {
          dispatch(UpdateSelectedTabAction(index));
        },
        currentIndex: state.homePageState.currentIndex,
        checkForAppUpdate: (context) => dispatch(CheckAppUpdateAction(context)),
        showAppUpdateBanner: state.isSelectedAppUpdateLater);
  }
}
