import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/modules/circles/actions/circle_picker_actions.dart';
import 'package:fm_fit/fm_fit.dart';

class CirclePicker extends StatefulWidget {
  @override
  _CirclePickerState createState() => _CirclePickerState();
}

class _CirclePickerState extends State<CirclePicker> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      model: _ViewModel(),
      onInit: (store){
        store.dispatch(GetNearbyCirclesAction());
      },
      builder: (context, snapshot) {
        return SizedBox.expand(

        );
      },
    );
  }

  Widget get noCirclesNearbyWidget {

    return Container(
      child: Column(
        children: [
          Icon(
            Icons.location_on,
            color: AppColors.green,

          ),
          Padding(padding: EdgeInsets.only(
            top: AppSizes.widgetPadding,
            left: AppSizes.widgetPadding,
            right: AppSizes.widgetPadding,
            ),child: Text(
            '', style: TextStyle(
            fontFamily: 'Avenir',
            fontSize: fit.t(40),
          ),
          ),)
        ],
      ),
    );

  }

}


class _ViewModel extends BaseModel<AppState> {

  _ViewModel();

  _ViewModel.build();

  @override
  BaseModel fromStore() {

    _ViewModel.build(

    );
  }


}
