import 'package:eSamudaay/modules/home/views/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:eSamudaay/utilities/size_cpnfig.dart';
import 'package:visibility_detector/visibility_detector.dart';

List<String> url = [
  'https://stream.mux.com/JpLPLOnbuOB7oEfxp401pNU6psesmkMRe.m3u8',
  "https://multiplatform-f.akamaihd.net/i/multi/will/bunny/big_buck_bunny_,640x360_400,640x360_700,640x360_1000,950x540_1500,.f4v.csmil/master.m3u8",
  'https://stream.mux.com/JpLPLOnbuOB7oEfxp401pNU6psesmkMRe.m3u8',
  "https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/master.m3u8",
  'https://stream.mux.com/JpLPLOnbuOB7oEfxp401pNU6psesmkMRe.m3u8',
];

class VideosListWidget extends StatefulWidget {
  @override
  _VideosViewState createState() => _VideosViewState();
}

class _VideosViewState extends State<VideosListWidget> {
  Map<int, UniqueKey> keys = {};
  List<Widget> items;
  int activeIndex = 0;
  UniqueKey getKey(int index) {
    if (keys[index] == null) keys[index] = UniqueKey();
    return keys[index];
  }

  UniqueKey uniqueKey = UniqueKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      key: uniqueKey,
      height: 200.toHeight,
      margin: EdgeInsets.symmetric(vertical: 20.toHeight),
      child: ListView.builder(
        itemCount: url.length,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) => VisibilityDetector(
          key: getKey(index + url.length),
          onVisibilityChanged: (visibility) {
            if (visibility.visibleFraction >= 1.0)
              setState(() {
                activeIndex = index;
              });
          },
          child: _VideoPlayView(
            url[index],
            key: getKey(index),
            index: index,
            activeIndex: activeIndex,
          ),
        ),
      ),
    );
  }
}

class _VideoPlayView extends StatefulWidget {
  final String url;
  final int index;
  final int activeIndex;
  _VideoPlayView(this.url, {Key key, this.index, this.activeIndex})
      : super(key: key);
  @override
  __VideoPlayViewState createState() => __VideoPlayViewState();
}

class __VideoPlayViewState extends State<_VideoPlayView>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController controller;

  @override
  void didUpdateWidget(_VideoPlayView oldWidget) {
    if (oldWidget.activeIndex != widget.activeIndex) {
      if (widget.activeIndex == widget.index)
        controller.play();
      else {
        if (controller.value.isPlaying) controller.pause();
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    print("init for ${widget.index}");
    controller = new VideoPlayerController.network(widget.url)
      ..initialize().then(
        (value) {
          if (widget.activeIndex == widget.index) controller.play();
          setState(() {});
        },
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.toWidth),
      height: 200.toHeight,
      width: 250.toWidth,
      child: controller?.value?.initialized ?? false
          ? InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(controller),
                  ),
                );
              },
              child: Stack(
                children: [
                  VideoPlayer(controller),
                  Positioned(
                    bottom: 10.toHeight,
                    right: 10.toWidth,
                    left: 10.toWidth,
                    child: Card(
                      elevation: 10,
                      child: Container(
                        height: 60.toHeight,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.toWidth,
                          vertical: 5.toHeight,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.toFont),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Video Title',
                              style: TextStyle(
                                fontSize: 20.toFont,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Flexible(
                              child: Text(
                                'Video descriptoion : Lorem Ipsum Lorem Ipsum',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              color: Colors.grey[300],
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
