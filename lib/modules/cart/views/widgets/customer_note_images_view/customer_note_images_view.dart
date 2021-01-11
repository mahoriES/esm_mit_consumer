import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/image_picker_dialog.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eSamudaay/modules/cart/views/widgets/customer_note_images_view/widgets/widgets.dart';

class CartCustomerNoteImagesWidget extends StatelessWidget {
  const CartCustomerNoteImagesWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) => Card(
        elevation: 4,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr("cart.list_items"),
                style: CustomTheme.of(context).textStyles.body1,
              ),
              const SizedBox(height: 20),
              if (snapshot.customerNoteImagesCount == 0) ...[
                CustomerNoteImagePlaceHolder(),
              ] else ...[
                CustomerNoteImageView(
                  customerNoteImages: snapshot.customerNoteImages,
                  onRemove: snapshot.removeCustomerNoteImage,
                ),
              ],
              const SizedBox(height: 16),
              ActionButton(
                text: tr("cart.upload_list"),
                icon: Icons.add_a_photo,
                onTap: () {
                  if (!snapshot.isImageUploading) {
                    if (snapshot.customerNoteImagesCount < 5) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => ImagePickerDialog(
                          (ImageSource source) =>
                              snapshot.addCustomerNoteImage(source),
                        ),
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: "cart.max_list_images_error".tr(),
                      );
                    }
                  }
                },
                isDisabled: snapshot.customerNoteImagesCount == 5 ||
                    snapshot.isImageUploading,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();
  List<String> customerNoteImages;
  Function(ImageSource) addCustomerNoteImage;
  Function(int) removeCustomerNoteImage;
  bool isImageUploading;

  _ViewModel.build({
    this.customerNoteImages,
    this.addCustomerNoteImage,
    this.removeCustomerNoteImage,
    this.isImageUploading,
  });

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      customerNoteImages: state.cartState.customerNoteImages ?? [],
      addCustomerNoteImage: (ImageSource imageSource) {
        dispatch(AddCustomerNoteImageAction(imageSource: imageSource));
      },
      removeCustomerNoteImage: (int index) {
        dispatch(RemoveCustomerNoteImageAction(imageIndex: index));
      },
      isImageUploading: state.cartState.isImageUploading,
    );
  }

  int get customerNoteImagesCount => customerNoteImages.length;
}
