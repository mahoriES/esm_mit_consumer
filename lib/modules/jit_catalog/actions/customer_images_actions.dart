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
import 'package:flutter_luban/flutter_luban.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PickImageAction extends ReduxAction<AppState> {
  final int imageSource;

  PickImageAction({@required this.imageSource});

  Future<dynamic> getImage(int source) async {
    debugPrint('Inside get image');
    final imageSource = source == 0 ? ImageSource.camera : ImageSource.gallery;
    final _picker = ImagePicker();
    var imageFile = await _picker.getImage(source: imageSource);
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

  Future<dynamic> compressImageAndGetFile(dynamic imageFile) async {
    debugPrint("Three-1");
    String dir = (await getTemporaryDirectory()).path;
    debugPrint("Three-2");
    CompressObject compressObject = CompressObject(
        imageFile: imageFile,
        path: dir,
        mode: CompressMode.LARGE2SMALL,
        step: 5,
        quality: 55);
    debugPrint('Start image compression');
    final compressedPath = await Luban.compressImage(compressObject);
    debugPrint('End image compression');
    return File(compressedPath);
  }

  @override
  FutureOr<AppState> reduce() async {
    final imageFile = await getImage(imageSource);
    if (imageFile == false) return null;
    final compressedFile = await compressImageAndGetFile(imageFile);
    if (compressedFile == null) return null;
    String fileName = compressedFile.path.split('/').last ?? "customerImage.jpg";
    var response = await APIManager.shared.request(
        requestType: RequestType.post,
        url: ApiURL.imageUpload,
        params: FormData.fromMap({
          "file": await MultipartFile.fromFile(compressedFile.path,
              filename: fileName)
        }),);
    if (response.status == ResponseStatus.success200) {
      if (response.data['photo_url'] == null) return null;
      final customerNoteImagesList =
          state.productState.customerNoteImages ?? [];
      customerNoteImagesList.add(response.data['photo_url']);
      final newCustomerNoteImagesList = [];
      customerNoteImagesList.forEach((element) {
        newCustomerNoteImagesList.add(element);
      });
      CartDataSource.insertCustomerNoteImagesList(newCustomerNoteImagesList);
      return state.copyWith(
        productState: state.productState.copyWith(
          customerNoteImages: newCustomerNoteImagesList,
        ),
      );
    } else {
      debugPrint("Error occured in getting image");
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
