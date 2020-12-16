import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:eSamudaay/modules/login/actions/login_actions.dart';
import 'package:eSamudaay/store.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/user_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

//TODO: Will need to add logic to handle throttling (429 response) and convey that to the user accordingly

class APIManager {
  static var shared = APIManager();
  static beginRequest() {}

  static Future<ResponseModel> postRequest(List params) async {
    Dio dio = new Dio(new BaseOptions(
      baseUrl: ApiURL.baseURL,
      connectTimeout: 50000,
      receiveTimeout: 100000,
      followRedirects: false,
      validateStatus: (status) {
        return status < 500;
      },
      responseType: ResponseType.json,
    ));
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      request: true,
      requestBody: true,
    ));
    return await dio
        .post(
      params[1],
      data: params.first,
    )
        .then((res) {
      if (res.statusCode == 400) {
        return ResponseModel(res.data, ResponseStatus.error404);
      } else if (res.statusCode >= 500) {
        return ResponseModel(res.data, ResponseStatus.error500);
      } else if (res.statusCode == 401) {
        return ResponseModel(res.data, ResponseStatus.error401);
      } else {
        return ResponseModel(res.data, ResponseStatus.success200);
      }
    }).catchError((error) {
      print(error);
      return ResponseModel(null, ResponseStatus.error500);
    });
  }

  Future<ResponseModel> request(
      {params: dynamic,
      url: String,
      requestType: RequestType,
      beginCallback: Function}) async {
    emptyParams[''] = '';

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    } else if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: tr("new_changes.offline"));
//      store.dispatch(UserExceptionAction(
//        "No internet connection",
//      ));
    }

    String token = await UserManager.getToken();
    var dio = new Dio(new BaseOptions(
      baseUrl: ApiURL.baseURL,
      connectTimeout: 50000,
      receiveTimeout: 100000,
      followRedirects: false,
      validateStatus: (status) {
        return status < 500;
      },
      responseType: ResponseType.json,
//      contentType: ContentType.json,
    ));
//    Directory appDocDir = await getApplicationDocumentsDirectory();
//    String appDocPath = appDocDir.path;
//    var cookieJar = PersistCookieJar(dir: appDocPath + "/.cookies/");
//    cookieJar.loadForRequest(Uri.parse(ApiURL.baseURL + url));
//    dio.interceptors.add(CookieManager(cookieJar));
    if (token != null && token != "") {
      dio.options.headers = {
        "Authorization": "JWT $token",
      };
    }
    dio.interceptors.add(LogInterceptor(
        responseBody: true,
        request: true,
        requestBody: true,
        requestHeader: true));

    switch (requestType) {
      case RequestType.get:
        try {
          return await dio.get(url, queryParameters: params).then((response) {
            if (response.statusCode == 400) {
              return ResponseModel(response.data, ResponseStatus.error404);
            } else if (response.statusCode >= 500) {
              return ResponseModel(response.data, ResponseStatus.error500);
            } else if (response.statusCode == 401) {
              return ResponseModel(response.data, ResponseStatus.error401);
            } else if (response.statusCode == 429) {
              return ResponseModel(response.data, ResponseStatus.error404);
            } else {
              return ResponseModel(response.data, ResponseStatus.success200);
            }
          });
        } catch (e) {
          print(e);
          return ResponseModel(null, ResponseStatus.error500);
        }
        break;
      case RequestType.post:
        try {
          return await dio
              .post(
            url,
            data: params,
          )
              .then((res) {
            debugPrint(res.toString(), wrapWidth: 1024);
            if (res.statusCode == 450) {
              store.dispatch(UserExceptionAction(
                "Session expired, Please login to continue..",
              ));
              store.dispatch(CheckTokenAction());
              UserManager.deleteUser();

              store.dispatch(NavigateAction.pushNamedAndRemoveAll('/loginView'));
            }
            if (res.statusCode == 400) {
              return ResponseModel(res.data, ResponseStatus.error404);
            } else if (res.statusCode >= 500) {
              return ResponseModel(res.data, ResponseStatus.error500);
            } else if (res.statusCode == 401) {
              return ResponseModel(res.data, ResponseStatus.error401);
            } else if (res.statusCode == 429) {
              return ResponseModel(res.data, ResponseStatus.error404);
            }
            // TODO : add proper status code for success state
            // and return "some error occured in case of default status code".
            else {
              return ResponseModel(res.data, ResponseStatus.success200);
            }
          });
        } catch (e) {
          print(e);
          return ResponseModel(null, ResponseStatus.error500);
        }
        break;
      case RequestType.patch:
        try {
          return await dio.patch(url, data: params).then((response) {
            if (response.statusCode == 400) {
              return ResponseModel(response.data, ResponseStatus.error404);
            } else if (response.statusCode >= 500) {
              return ResponseModel(response.data, ResponseStatus.error500);
            } else if (response.statusCode == 401) {
              return ResponseModel(response.data, ResponseStatus.error401);
            } else {
              return ResponseModel(response.data, ResponseStatus.success200);
            }
          });
        } catch (e) {
          print(e);
          return ResponseModel(null, ResponseStatus.error500);
        }
        break;
      case RequestType.delete:
        try{
          return await dio.delete(url,data: params).then((response) {
            if (response.statusCode == 400 || response.statusCode == 404) {
              return ResponseModel(response.data, ResponseStatus.error404);
            } else if (response.statusCode >= 500) {
              return ResponseModel(response.data, ResponseStatus.error500);
            } else if (response.statusCode == 401) {
              return ResponseModel(response.data, ResponseStatus.error401);
            } else {
              return ResponseModel(response.data, ResponseStatus.success200);
            }
          });
        } catch (e) {
          print(e);
          return ResponseModel(null, ResponseStatus.error500);
        }
    }
    return null;
  }
}

Map<String, dynamic> emptyParams = Map<String, dynamic>();
enum RequestType { get, post, put, patch, delete }
enum ResponseStatus { success200, error404, error500, error401 }

class ResponseModel {
  final data;
  final ResponseStatus status;
  ResponseModel(this.data, this.status);
}

class DioComputeParams {
  Dio dio;
  String url;
  dynamic params;
  DioComputeParams({this.params, this.url, this.dio});
}
