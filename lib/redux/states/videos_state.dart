import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/models/video_feed_response.dart';
import 'package:flutter/material.dart';

class VideosState {
  final VideoFeedResponse videosResponse;
  final LoadingStatusApp loadingStatus;
  final int currentIndex;
  final VideoItem selectedVideo;

  VideosState({
    @required this.videosResponse,
    @required this.loadingStatus,
    @required this.currentIndex,
    @required this.selectedVideo,
  });

  factory VideosState.initial() {
    return new VideosState(
      loadingStatus: LoadingStatusApp.success,
      videosResponse: VideoFeedResponse(
        count: 0,
        results: [],
      ),
      currentIndex: 0,
      selectedVideo: null,
    );
  }

  VideosState copyWith({
    LoadingStatusApp loadingStatus,
    int currentIndex,
    VideoFeedResponse videosResponse,
    VideoItem selectedVideo,
  }) {
    return new VideosState(
      currentIndex: currentIndex ?? this.currentIndex,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      videosResponse: videosResponse ?? this.videosResponse,
      selectedVideo: selectedVideo ?? this.selectedVideo,
    );
  }
}
