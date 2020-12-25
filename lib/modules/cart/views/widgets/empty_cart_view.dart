import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/home/actions/home_page_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmptycartView extends StatelessWidget {
  const EmptycartView({Key key}) : super(key: key);

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
                    ImagePathConstants.emptyCartImage,
                  ),
                ),
              ),
              const SizedBox(height: 55),
              Text(
                snapshot.circleNameString,
                style:
                    CustomTheme.of(context).textStyles.sectionHeading1.copyWith(
                          color: CustomTheme.of(context).colors.textColor,
                        ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                tr("cart.empty_cart_message"),
                style: CustomTheme.of(context).textStyles.body1Faded,
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
  String circleName;
  VoidCallback goToHome;

  _ViewModel.build({
    this.circleName,
    this.goToHome,
  }) : super(equals: [circleName]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      circleName: state.authState.cluster?.clusterName,
      goToHome: () => dispatch(UpdateSelectedTabAction(0)),
    );
  }

  String get circleNameString => circleName == null
      ? tr("cart.empty_cart_title_without_circle_name")
      : tr(
          "cart.empty_cart_title_with_circle_name",
          args: [circleName],
        );
}
