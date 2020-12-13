import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/head_categories/actions/categories_action.dart';
import 'package:eSamudaay/modules/home/actions/dynamic_link_actions.dart';
import 'package:eSamudaay/modules/home/models/video_feed_response.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoadVideoFeed extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
      url: ApiURL.getVideoFeed,
      params: {"circle_id": state.authState.cluster.clusterId},
      requestType: RequestType.get,
    );

    if (response.status == ResponseStatus.success200) {
      VideoFeedResponse responseModel =
          VideoFeedResponse.fromJson(response.data);

      return state.copyWith(
        videosState: state.videosState.copyWith(videosResponse: responseModel),
      );
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
    }
    return null;
  }

  void before() {
    dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));
    dispatch(ChangeVideoFeedLoadingAction(true));
  }

  void after() {
    dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
    dispatch(ChangeVideoFeedLoadingAction(false));
  }
}

class UpdateSelectedVideoAction extends ReduxAction<AppState> {
  final VideoItem selectedVideo;

  UpdateSelectedVideoAction({@required this.selectedVideo});

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        videosState: state.videosState.copyWith(selectedVideo: selectedVideo));
  }
}

class SlelectVideoPlayerByID extends ReduxAction<AppState> {
  final String videoId;

  SlelectVideoPlayerByID({@required this.videoId});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
      url: ApiURL.getVideoFeed + '$videoId',
      params: null,
      requestType: RequestType.get,
    );
    debugPrint('GoToVideoPlayerByID response=> ${response.data.toString()}');
    if (response.status == ResponseStatus.error404) {
      Fluttertoast.showToast(msg: 'Video Not Found');
      throw 'Something went wrong : ${response.data['message']}';
    } else if (response.status == ResponseStatus.error500) {
      Fluttertoast.showToast(msg: 'Something went wrong');
      throw 'Something went wrong : ${response.data['message']}';
    } else {
      VideoItem responseModel = VideoItem.fromJson(response.data);

      if (responseModel != null) {
        DynamicLinkService().isLinkPathValid = true;
        return state.copyWith(
          videosState: state.videosState.copyWith(
            selectedVideo: responseModel,
          ),
        );
      }
    }
    return null;
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
    super.after();
  }
}
