import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:vibe/controllers/video_controller.dart';
import 'package:vibe/models/video.dart';
import 'package:video_player/video_player.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final VideoController videoController = Get.put(VideoController());
  List<VideoPlayerController> videoControllers = [];

  @override
  void initState() {
    super.initState();
    preloadVideos();
  }

  void preloadVideos() {
    for (int i = 0; i < 1; i++) {
      final Video video = videoController.videoList[i];
      final VideoPlayerController videoPlayerController =
          VideoPlayerController.network(video.videoUrl);
      videoControllers.add(videoPlayerController);
      videoPlayerController.initialize();
    }
  }

  @override
  void dispose() {
    for (final controller in videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      body: PageView.builder(
        itemCount: videoController.videoList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final Video video = videoController.videoList[index];
          final VideoPlayerController videoPlayerController =
              videoControllers[index];
          final ChewieController chewieController = ChewieController(
            videoPlayerController: videoPlayerController,
            autoPlay: true,
              materialProgressColors:ChewieProgressColors(backgroundColor: Color.fromARGB(255, 40, 5, 165),bufferedColor: Color.fromARGB(255, 228, 17, 200),),
            looping: true,
            allowedScreenSleep: false,
          );
          return VisibilityDetector(
            key: Key(video.videoUrl),
            onVisibilityChanged: (visibilityInfo) {
              if (visibilityInfo.visibleFraction == 0) {
                videoPlayerController.pause();
              } else {
                videoPlayerController.play();
              }
            },
            child: Chewie(
              controller: chewieController,
            ),
          );
        },
      ),
    );
  }
}
