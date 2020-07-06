import 'dart:async';
import 'dart:convert';
import 'package:eSamudaay/modules/address/models/addess_models.dart';
import 'package:eSamudaay/modules/login/actions/login_actions.dart';
import 'package:eSamudaay/utilities/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/Profile/model/profile_update_model.dart';
import 'package:eSamudaay/modules/login/model/authentication_response.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:status_alert/status_alert.dart';

class UpdateProfileAction extends ReduxAction<AppState> {
  final UpdateProfile request;

  UpdateProfileAction({this.request});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.profileUpdateURL,
        params: request.toJson(),
        requestType: RequestType.patch);

    if (response.status == ResponseStatus.success200) {
      UpdatedProfile profile = UpdatedProfile.fromJson(response.data);

      UserManager.saveUser(profile.data).then((onValue) {
        store.dispatch(GetUserFromLocalStorageAction());
      });
      dispatch(NavigateAction.pop());
    } else {
      //Fluttertoast.showToast(msg: response.data['status']);
      //throw UserException(response.data['status']);
    }
    return state.copyWith(authState: state.authState.copyWith());
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}

class GetProfileAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared
        .request(url: ApiURL.profileUpdateURL, requestType: RequestType.get);

    if (response.data['statusCode'] == 200) {
      GetProfile profile = GetProfile.fromJson(response.data);

      dispatch(NavigateAction.pop());
    } else {
      Fluttertoast.showToast(msg: response.data['status']);
      //throw UserException(response.data['status']);
    }
    return state.copyWith(authState: state.authState.copyWith());
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}

class UploadImageAction extends ReduxAction<AppState> {
  final File imageFile;

  UploadImageAction({this.imageFile});
  @override
  FutureOr<AppState> reduce() async {
    String token = await UserManager.getToken();

    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(ApiURL.imageUpload);
    print(uri);

    var request = new http.MultipartRequest("POST", uri);
    if (token != null && token != "") {
      Map<String, String> headers = {"Authorization": "JWT $token"};
      request.headers.addAll(headers);
    }

    var multipartFile = new http.MultipartFile(
      'file',
      stream,
      length,
      filename: basename(imageFile.path),
    );
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);

    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print("value");
      print(value);
      final body = json.decode(value);
      print(body);
      ImageResponse imageResponse = ImageResponse.fromJson(body);
      dispatch(UpdateProfileAction(
          request: UpdateProfile(
              profilePic: ProfilePic(photoId: imageResponse.photoId))));
    });
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));
    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
    super.after();
  }
}
