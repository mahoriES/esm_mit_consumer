import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/login/actions/login_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginLandingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 91.6.toHeight,
                ),
                Center(
                  child: Image.asset(
                    ImagePathConstants.appBrandingImage,
                    height: 30.toHeight,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: Image.asset(
                    ImagePathConstants.landingPageBanner,
                    fit: BoxFit.cover,
                    height: 200.toHeight,
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                GestureDetector(
                  onTap: snapshot.navigateToLoginScreen,
                  child: Container(
                    width: 305.toWidth,
                    height: 48.toHeight,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.5,
                        color: CustomTheme.of(context).colors.primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        'screen_phone.login_phone',
                        style: CustomTheme.of(context)
                            .textStyles
                            .sectionHeading1Regular
                            .copyWith(
                                color:
                                    CustomTheme.of(context).colors.primaryColor),
                      ).tr(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: snapshot.navigateToSignupScreen,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: tr('screen_phone.new_user'),
                            style:
                                CustomTheme.of(context).textStyles.cardTitleFaded),
                        TextSpan(
                            text: tr('screen_phone.register_now'),
                            style: CustomTheme.of(context).textStyles.cardTitlePrimary)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  Function navigateToSignupScreen;
  Function navigateToLoginScreen;

  _ViewModel.build({this.navigateToLoginScreen, this.navigateToSignupScreen});

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      navigateToLoginScreen: () {
        dispatch(UpdateIsSignUpAction(isSignUp: false));
        dispatch(NavigateAction.pushNamed(RouteNames.LOGIN_VIEW));
      },
      navigateToSignupScreen: () {
        dispatch(UpdateIsSignUpAction(isSignUp: true));
        dispatch(NavigateAction.pushNamed(RouteNames.LOGIN_VIEW));
      },
    );
  }
}
