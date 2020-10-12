import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/models/video_feed_response.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/api_manager.dart';
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

  void before() =>
      dispatch(ChangeLoadingStatusAction(LoadingStatusApp.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatusApp.success));
}

class UpdateSelectedVideoAction extends ReduxAction<AppState> {
  final VideoItem selectedVideo;

  UpdateSelectedVideoAction({this.selectedVideo});
  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        videosState: state.videosState.copyWith(selectedVideo: selectedVideo));
  }
}

class UpdateSelectedVideoByIdAction extends ReduxAction<AppState> {
  final String videoId;

  UpdateSelectedVideoByIdAction({this.videoId});
  @override
  FutureOr<AppState> reduce() {
    int selectedIndex;
    for (int i = 0; i < state.videosState.videosResponse.results.length; i++) {
      if (state.videosState.videosResponse.results[i].postId == videoId) {
        selectedIndex = i;
        break;
      }
    }
    if (selectedIndex != null) {
      return state.copyWith(
          videosState: state.videosState.copyWith(
        selectedVideo: state.videosState.videosResponse.results[selectedIndex],
      ));
    } else
      throw UserException('Video Not Found');
  }
}
