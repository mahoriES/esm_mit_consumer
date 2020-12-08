import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/modules/address/actions/address_actions.dart';
import 'package:eSamudaay/modules/address/models/addess_models.dart';
import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/address/view/widgets/custom_input_field.dart';
import 'package:eSamudaay/modules/address/view/widgets/tag_button.dart';
import 'package:eSamudaay/modules/address/view/widgets/topTile.dart';
import 'package:eSamudaay/presentations/loading_dialog.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';

class AddressDetailsWidget extends StatefulWidget {
  const AddressDetailsWidget({Key key}) : super(key: key);

  @override
  _AddressDetailsWidgetState createState() => _AddressDetailsWidgetState();
}

class _AddressDetailsWidgetState extends State<AddressDetailsWidget> {
  final TextEditingController houseNumberController =
      new TextEditingController();

  final TextEditingController landMarkController = new TextEditingController();

  final TextEditingController addressNameController =
      new TextEditingController();

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      onInit: (store) {
        addressNameController.text =
            store.state.addressState.addressRequest.addressName;
      },
      builder: (context, snapshot) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (snapshot.isLoading) {
            LoadingDialog.show();
          } else {
            LoadingDialog.hide();
          }
        });

        return Container(
          padding: EdgeInsets.all(20.toWidth),
          color: CustomTheme.of(context).colors.backgroundColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TopTile(tr("address_picker.enter_address_details")),
                SizedBox(height: 14.toHeight),
                Text(
                  tr("address_picker.your_location"),
                  style: CustomTheme.of(context).textStyles.body2Faded,
                ),
                SizedBox(height: 8.toHeight),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: CustomTheme.of(context).colors.primaryColor,
                    ),
                    SizedBox(width: 8.toWidth),
                    Expanded(
                      child: Text(
                        (snapshot.addressRequest.prettyAddress?.toString() ??
                            ""),
                        style: CustomTheme.of(context).textStyles.body1,
                      ),
                    ),
                    SizedBox(width: 12.toWidth),
                    TextButton(
                      child: Text(
                        tr("address_picker.change").toUpperCase(),
                        style:
                            CustomTheme.of(context).textStyles.body2Secondary,
                      ),
                      onPressed: snapshot.goToSearchView,
                    ),
                  ],
                ),
                SizedBox(height: 6.toHeight),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputField(
                        hintText: tr("address_picker.house_number"),
                        controller: houseNumberController,
                        onChanged: (s) {
                          setState(() {});
                        },
                      ),
                      InputField(
                        hintText: tr("address_picker.landmark"),
                        controller: landMarkController,
                        onChanged: (s) {
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 20.toHeight),
                      Text(
                        tr("address_picker.save_address_as").toUpperCase(),
                        style: CustomTheme.of(context).textStyles.body2Faded,
                      ),
                      SizedBox(height: 12.toHeight),
                      Container(
                        height: 25.toHeight,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: AddressTags.tagList.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 16.toWidth),
                          itemBuilder: (context, index) {
                            return TagButton(
                              isSelected: snapshot.selectedtagIndex == index,
                              tag: AddressTags.tagList[index],
                              onTap: () {
                                addressNameController.text =
                                    AddressTags.tagList[index];
                                snapshot.updateAddressName(
                                    AddressTags.tagList[index]);
                              },
                            );
                          },
                        ),
                      ),
                      if (snapshot.selectedtagIndex == 2) ...[
                        InputField(
                          hintText: tr("address_picker.Other"),
                          controller: addressNameController,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 20.toHeight),
                ActionButton(
                  text: tr("address_picker.save_address"),
                  icon: null,
                  onTap: () {
                    print("ontap");
                    if (formKey.currentState.validate()) {
                      debugPrint("is validated **********");
                      Navigator.pop(context);
                      snapshot.addAddress(
                        houseNumberController.text,
                        landMarkController.text,
                        addressNameController.text,
                      );
                    }
                  },
                  isDisabled: landMarkController.text.trim() == "" ||
                      houseNumberController.text.trim() == "",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  AddressRequest addressRequest;
  Function(String) updateAddressName;
  Function() goToSearchView;
  Function(String, String, String) addAddress;
  bool isLoading;

  _ViewModel.build({
    this.addressRequest,
    this.updateAddressName,
    this.goToSearchView,
    this.addAddress,
    this.isLoading,
  }) : super(equals: [isLoading, addressRequest]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      addressRequest: state.addressState.addressRequest,
      isLoading: state.addressState.isLoading,
      updateAddressName: (name) => dispatch(UpdateAddressName(name)),
      goToSearchView: () =>
          dispatch(NavigateAction.pushNamed(RouteNames.SEARCH_ADDRESS)),
      addAddress: (String house, String landMark, String addressname) {
        AddressRequest _addressRequest =
            state.addressState.addressRequest.copyWith(
          addressName: addressname,
          geoAddr: state.addressState.addressRequest.geoAddr.copyWith(
            landmark: landMark,
            house: house,
          ),
        );
        if (!state.addressState.isRegisterFlow) {
          dispatch(AddAddressAction(request: _addressRequest));
        }
      },
    );
  }

  int get selectedtagIndex =>
      addressRequest.addressName == AddressTags.tagList[0]
          ? 0
          : addressRequest.addressName == AddressTags.tagList[1]
              ? 1
              : 2;
}
