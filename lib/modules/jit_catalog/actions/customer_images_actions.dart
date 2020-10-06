import 'dart:async';
import 'dart:io';

import 'package:async_redux/async_redux.dart';
import 'package:dio/dio.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImageAction extends ReduxAction<AppState> {
  final int imageSource;

  PickImageAction({@required this.imageSource});

  ///Using the ImagePicker library for getting image and compressing its size as
  ///well. Adjust the [imageQuality] parameter below to adjust the imageQuality

  Future<dynamic> getImage(int source) async {
    debugPrint('Inside get image');
    final imageSource = source == 0 ? ImageSource.camera : ImageSource.gallery;
    final _picker = ImagePicker();
    var imageFile = await _picker.getImage(source: imageSource,
      imageQuality: 25);
    if (imageFile == null) {
      debugPrint('Inside secondary check');
      var lostImageFile = await _picker.getLostData();
      if (lostImageFile.file == null) {
        return false;
      }
      imageFile = lostImageFile.file;
    }
    return File(imageFile.path);
  }


  @override
  FutureOr<AppState> reduce() async {
    final imageFile = await getImage(imageSource);
    if (imageFile == false) return null;
    var response = await APIManager.shared.request(
        requestType: RequestType.post,
        url: ApiURL.imageUpload,
        params: FormData.fromMap({
          "file": await MultipartFile.fromFile(imageFile.path,
              filename: 'customerImage.jpg')
        },),);
    if (response.status == ResponseStatus.success200) {
      if (response.data['photo_url'] == null) return null;
      final List<String> customerNoteImagesList =
          state.productState.customerNoteImages ?? [];
      customerNoteImagesList.add(response.data['photo_url'].toString());
      final List<String> newCustomerNoteImagesList = [];
      if (customerNoteImagesList.isNotEmpty) {
        customerNoteImagesList.forEach((element) {
          newCustomerNoteImagesList.add(element);
        });
      }
      CartDataSource.insertCustomerNoteImagesList(newCustomerNoteImagesList);
      return state.copyWith(
        productState: state.productState.copyWith(
          customerNoteImages: newCustomerNoteImagesList,
        ),
      );
    } else {
      debugPrint("Error occurred in getting image");
      return null;
    }
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}

class RemoveCustomerNoteImageAction extends ReduxAction<AppState> {
  final int imageIndex;

  RemoveCustomerNoteImageAction({@required this.imageIndex});

  @override
  FutureOr<AppState> reduce() {
    final customerNoteImagesList = state.productState.customerNoteImages ?? [];
    customerNoteImagesList.removeAt(imageIndex);

    ///New list required to let Redux know that that model changed and let the
    ///ViewModel know when to rebuild the dumb widget.

    List<String> newCustomerNoteImagesList = [];
    customerNoteImagesList.forEach((element) {
      newCustomerNoteImagesList.add(element);
    });
    CartDataSource.insertCustomerNoteImagesList(newCustomerNoteImagesList);
    return state.copyWith(
        productState: state.productState.copyWith(
      customerNoteImages: newCustomerNoteImagesList,
    ));
  }

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));

}
