import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/models/video_feed_response.dart';
import 'package:flutter/material.dart';

class VideosState {
  final VideoFeedResponse videosResponse;
  final LoadingStatusApp loadingStatus;
  final int currentIndex;

  VideosState({
    @required this.videosResponse,
    @required this.loadingStatus,
    @required this.currentIndex,
  });

  factory VideosState.initial() {
    return new VideosState(
      loadingStatus: LoadingStatusApp.success,
      videosResponse: VideoFeedResponse(
        count: 0,
        results: [],
      ),
      currentIndex: 0,
    );
  }

  VideosState copyWith({
    LoadingStatusApp loadingStatus,
    int currentIndex,
    final VideoFeedResponse videosResponse,
  }) {
    return new VideosState(
      currentIndex: currentIndex ?? this.currentIndex,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      videosResponse: videosResponse ?? this.videosResponse,
    );
  }
}
