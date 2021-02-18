import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:eSamudaay/utilities/environment_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaay_app_update/esamudaay_app_update.dart';
import 'package:flutter/material.dart';
import 'package:esamudaay_themes/esamudaay_themes.dart' as themesPackage;

class ChangeLoadingStatusAction extends ReduxAction<AppState> {
  final LoadingStatusApp appStatus;
  ChangeLoadingStatusAction(this.appStatus);

  @override
  AppState reduce() {
    // TODO: implement reduce
    return state.copyWith(
        authState: state.authState.copyWith(loadingStatus: appStatus));
  }
}

class CheckAppUpdateAction extends ReduxAction<AppState> {
  BuildContext context;
  CheckAppUpdateAction(this.context);

  @override
  Future<AppState> reduce() async {
    // on app launch, isSelectedLater is false by default.
    // if isSelectedLater is false then show app update prompt to user.
    // if update is not available, showUpdateDialog will return null;
    // otherwise user will have to either update the app or
    // select later (if flexible update is allowed).

    if (!AppUpdateService.isSelectedLater) {
      await AppUpdateService.showUpdateDialog(
        context: context,
        title: tr('app_update.title'),
        message: tr('app_update.popup_msg'),
        laterButtonText: tr('app_update.later'),
        updateButtonText: tr('app_update.update'),
        customThemeData: themesPackage.EsamudaayTheme.of(context),
        packageName: EnvironmentConfig.packageName,
        logoImage: Image.asset(
          ImagePathConstants.appLogo,
          height: 42,
          fit: BoxFit.contain,
        ),
      );
      // If user selects later then update state variable to true.
      debugPrint("git here => ${AppUpdateService.isSelectedLater}");
      if (AppUpdateService.isSelectedLater) {
        return state.copyWith(isSelectedAppUpdateLater: true);
      }
    }

    return null;
  }
}
