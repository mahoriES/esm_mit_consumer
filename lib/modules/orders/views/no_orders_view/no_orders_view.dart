import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/home/actions/home_page_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NoOrdersView extends StatelessWidget {
  const NoOrdersView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) => Scaffold(
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 65),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 161,
                height: 161,
                child: CircleAvatar(
                  backgroundColor:
                      CustomTheme.of(context).colors.placeHolderColor,
                  backgroundImage: AssetImage(
                    ImagePathConstants.categoryPlaceHolder,
                  ),
                ),
              ),
              const SizedBox(height: 55),
              Text(
                tr("screen_order.no_orders_message"),
                style:
                    CustomTheme.of(context).textStyles.sectionHeading1.copyWith(
                          color: CustomTheme.of(context).colors.textColor,
                        ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ActionButton(
                text: tr("cart.browse_stores"),
                onTap: snapshot.goToHome,
                isDisabled: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();
  VoidCallback goToHome;

  _ViewModel.build({
    this.goToHome,
  });

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      goToHome: () async {
        dispatch(UpdateSelectedTabAction(0));
        dispatch(NavigateAction.pushNamedAndRemoveAll(RouteNames.HOME_PAGE));
      },
    );
  }
}
