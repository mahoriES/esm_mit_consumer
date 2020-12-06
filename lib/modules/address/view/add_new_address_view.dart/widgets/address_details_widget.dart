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
      builder: (context, snapshot) {
        addressNameController.text = snapshot.addressTag;

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
                        (snapshot.address?.toString() ?? ""),
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
                                snapshot.updateAddressTag(
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

  String address;
  String addressTag;
  bool isAddressLoading;
  Function(String) updateAddressTag;
  Function() goToSearchView;
  Function(String, String, String) addAddress;
  bool isLoading;

  _ViewModel.build({
    this.address,
    this.isAddressLoading,
    this.addressTag,
    this.updateAddressTag,
    this.goToSearchView,
    this.addAddress,
    this.isLoading,
  }) : super(equals: [address, isAddressLoading, addressTag, isLoading]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      address: state.addressState.addressDetails?.addressLine ?? "",
      isAddressLoading: state.addressState.isAddressLoading,
      isLoading: state.addressState.isAddressLoading,
      addressTag: state.addressState.addressTag,
      updateAddressTag: (tag) => dispatch(UpdateAddressTag(tag)),
      goToSearchView: () =>
          dispatch(NavigateAction.pushNamed(RouteNames.SEARCH_ADDRESS)),
      addAddress: (String house, String landMark, String addressname) {
        AddressRequest _addressRequest = AddressRequest(
          addressName: addressname,
          prettyAddress: state.addressState.addressDetails?.addressLine,
          lat: state.addressState.addressDetails.coordinates.latitude,
          lon: state.addressState.addressDetails.coordinates.longitude,
          geoAddr: GeoAddr(
            pincode: state.addressState.addressDetails.postalCode,
            city: state.addressState.addressDetails.adminArea,
            landmark: landMark,
            house: house,
          ),
        );
        if (state.addressState.isRegisterView) {
          dispatch(SaveAddressRequest(_addressRequest));
        } else {
          dispatch(AddAddressAction(request: _addressRequest));
        }
      },
    );
  }

  int get selectedtagIndex => addressTag == AddressTags.tagList[0]
      ? 0
      : addressTag == AddressTags.tagList[1]
          ? 1
          : 2;
}
