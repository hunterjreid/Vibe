import 'package:flutter/material.dart';
import 'package:vibe/controllers/video_controller.dart';
import 'package:vibe/views/widgets/video_player_item.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class ShowSingleVideo extends StatefulWidget {
  final int videoIndex;
  final VideoController videoController = Get.find();

  ShowSingleVideo({Key? key, required this.videoIndex}) : super(key: key);

  @override
  _ShowSingleVideoState createState() => _ShowSingleVideoState();
}

class _ShowSingleVideoState extends State<ShowSingleVideo> {
  late VideoPlayerController _videoPlayerController;
  bool _isVideoLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer() {
    final data = widget.videoController.videoList[widget.videoIndex];
    _videoPlayerController = VideoPlayerController.network(data.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isVideoLoading = false;
        });
        _videoPlayerController.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.videoController.videoList[widget.videoIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(data.caption),
      ),
      body: Center(
        child: _isVideoLoading
            ? CircularProgressIndicator() // Show a spinner while video is loading
            : SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: VideoPlayer(_videoPlayerController),
              ),
      ),
    );
  }
}