import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/language/view/core_widgets/language_options_dropdown.dart';
import 'package:eSamudaay/reusable_widgets/ios_back_button.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:eSamudaay/utilities/stringConstants.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  bool fromAccount = false;

  @override
  void didChangeDependencies() {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    fromAccount = arguments != null
        ? arguments[StringConstants.fromAccountKey] ?? false
        : false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return WillPopScope(
      onWillPop: () {
        return Future.value(fromAccount);
      },
      child: Scaffold(
        body: StoreConnector<AppState, _ViewModel>(
          model: _ViewModel(),
          builder: (context, snapshot) {
            return Scaffold(
              body: SafeArea(
                child: SizedBox(
                  height: SizeConfig.screenHeight,
                  child: Stack(
                    children: [
                      Image.asset(
                        ImagePathConstants.languageSelectionBackdrop,
                        height: 496.toHeight,
                        width: SizeConfig.screenWidth,
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        right: 38.toWidth,
                        top: 53.toHeight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "screen_language.title_1",
                              textAlign: TextAlign.end,
                              style: CustomTheme.of(context)
                                  .textStyles
                                  .topTileTitle
                                  .copyWith(
                                      color: CustomTheme.of(context)
                                          .colors
                                          .primaryColor,
                                      fontSize: 30),
                            ).tr(),
                            Text(
                              "screen_language.title_2",
                              textAlign: TextAlign.end,
                              style: CustomTheme.of(context)
                                  .textStyles
                                  .topTileTitle
                                  .copyWith(
                                      color: CustomTheme.of(context)
                                          .colors
                                          .primaryColor,
                                      fontSize: 30),
                            ).tr(),
                          ],
                        ),
                      ),
                      if (fromAccount)
                        Positioned(
                          left: 25.toWidth,
                          top: 35.toHeight,
                          child: CupertinoStyledBackButton(
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: AnimatedPadding(
                          duration: const Duration(milliseconds: 100),
                          padding: EdgeInsets.only(
                            top: 476.toHeight - 48.toHeight - bottomInsets,
                          ),
                          child: LanguageOptionsDropDown(
                            fromAccountAction: () {
                              snapshot.navigateToPhoneNumberPage(fromAccount);
                            },
                            fromAccount: fromAccount,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  Function(bool fromAccount) navigateToPhoneNumberPage;

  _ViewModel.build({
    this.navigateToPhoneNumberPage,
  }) : super(equals: []);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      navigateToPhoneNumberPage: (value) {
        value
            ? dispatch(NavigateAction.pop())
            : dispatch(NavigateAction.pushNamed(RouteNames.LANDING_PAGE));
      },
    );
  }
}
