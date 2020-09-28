import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/utilities/size_cpnfig.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String playUrl;
  final String thumbnailUrl;
  final String title;
  VideoPlayerScreen({
    @required this.playUrl,
    @required this.thumbnailUrl,
    @required this.title,
  });

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController controller;
  ChewieController chewieController;

  @override
  void initState() {
    controller = new VideoPlayerController.network(
      widget.playUrl ?? '',
    );

    chewieController = ChewieController(
      videoPlayerController: controller,
      fullScreenByDefault: false,
      looping: true,
      allowMuting: true,
    );

    if (!(widget.playUrl == null || (widget.playUrl?.isEmpty ?? true))) {
      controller.initialize().then((value) => setState(() {}));
      controller.play();
    }

    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: FittedBox(
          child: Text(
            widget.title ?? '',
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: (controller?.value?.initialized ?? false)
          ? Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: Chewie(
                  controller: chewieController,
                ),
              ),
            )
          : Stack(
              children: [
                Center(
                  child: Opacity(
                    opacity: 0.8,
                    child: CachedNetworkImage(
                      imageUrl: widget.thumbnailUrl ?? '',
                      errorWidget: (context, url, error) => Container(
                        width: SizeConfig.screenWidth,
                        height: 200.toHeight,
                        color: Colors.grey,
                      ),
                      fit: BoxFit.cover,
                      width: SizeConfig.screenWidth,
                    ),
                  ),
                ),
                Center(child: CircularProgressIndicator())
              ],
            ),
    );
  }
}
