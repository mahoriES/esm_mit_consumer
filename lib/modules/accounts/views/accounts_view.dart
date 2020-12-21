import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/accounts/views/widgets/log_out_dialog.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eSamudaay/modules/accounts/action/account_action.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:flutter/material.dart';

class AccountsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
        titleSpacing: 30.0,
        title: Text(
          tr('screen_account.title'),
          style: CustomTheme.of(context).textStyles.topTileTitle,
        ),
      ),
      body: StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        onInit: (store) async {
          store.dispatch(GetVersionString());
        },
        builder: (context, snapshot) {
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot._accountItemsList.length,
                itemBuilder: (context, index) {
                  final _AccountItem _currentItem =
                      snapshot._accountItemsList[index];
                  return ListTile(
                    onTap: () {
                      if (_currentItem.isLogout) {
                        showDialog(
                          context: context,
                          builder: (context) => LogOutDialog(snapshot.logout),
                        );
                      } else {
                        snapshot.navigate(_currentItem.routeName);
                      }
                    },
                    leading: Image.asset(
                      _currentItem.imagePath,
                      color: AppColors.iconColors,
                    ),
                    title: Text(
                      tr(_currentItem.title),
                      style: CustomTheme.of(context).textStyles.sectionHeading2,
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                snapshot.versionString,
                style: CustomTheme.of(context).textStyles.cardTitle,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();
  Function(String) navigate;
  VoidCallback logout;
  String versionString;

  _ViewModel.build({
    this.logout,
    this.navigate,
    this.versionString,
  }) : super(equals: [versionString]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      versionString: state.versionString,
      navigate: (routeName) => dispatch(NavigateAction.pushNamed(routeName)),
      logout: () => dispatch(LogoutAction()),
    );
  }

  // TODO : define these imagePath and routename as constants.
  final List<_AccountItem> _accountItemsList = [
    _AccountItem(
      imagePath: "assets/images/AI_user.png",
      title: 'screen_account.profile',
      routeName: "/profile",
    ),
    _AccountItem(
      imagePath: "assets/images/home41.png",
      title: 'screen_account.address',
      routeName: RouteNames.CHANGE_ADDRESS,
    ),
    _AccountItem(
      imagePath: "assets/images/question_cr.png",
      title: 'screen_account.about',
      routeName: "/about",
    ),
    _AccountItem(
      imagePath: "assets/images/location2.png",
      title: 'screen_account.circles',
      routeName: RouteNames.CIRCLE_PICKER,
    ),
    _AccountItem(
      imagePath: "assets/images/Group_240.png",
      title: 'screen_account.language',
      routeName: "/language",
    ),
    _AccountItem(
      imagePath: "assets/images/power.png",
      title: 'screen_account.logout',
      routeName: "/",
      isLogout: true,
    ),
  ];
}

class _AccountItem {
  String imagePath;
  String title;
  String routeName;
  bool isLogout;
  _AccountItem({
    @required this.imagePath,
    @required this.title,
    @required this.routeName,
    this.isLogout = false,
  });
}
