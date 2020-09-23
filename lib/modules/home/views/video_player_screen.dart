import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:eSamudaay/utilities/size_cpnfig.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoPlayerController controller;
  VideoPlayerScreen(this.controller);
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  ChewieController chewieController;

  @override
  void initState() {
    // controller = new VideoPlayerController.network(widget.url);

    chewieController = ChewieController(
      videoPlayerController: widget.controller,
      fullScreenByDefault: true,
      looping: true,
      allowMuting: true,
    );

    // controller.initialize().then((value) => setState(() {}));
    // controller.play();

    super.initState();
  }

  // @override
  // void deactivate() {
  //   widget.controller?.pause();
  //   chewieController?.pause();

  //   super.deactivate();
  // }

  @override
  void dispose() {
    // widget.controller?.dispose();
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
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: (widget.controller?.value?.initialized ?? false)
          ? Center(
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
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
                      imageUrl: "http://via.placeholder.com/350x150",
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
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
