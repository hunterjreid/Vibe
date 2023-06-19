import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/views/screens/comment_screen.dart';
import 'package:vibe/views/screens/friendSearch_screen.dart';
import 'package:vibe/views/screens/profile_screen.dart';
import 'package:vibe/views/screens/use_this_sound_screen.dart';
import 'package:vibe/views/screens/user_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:vibe/controllers/video_controller.dart';
import 'package:vibe/models/video.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';

import '../../controllers/auth_controller.dart';

class WebAppScreen extends StatefulWidget {
  @override
  _WebAppScreenState createState() => _WebAppScreenState();
}

class _WebAppScreenState extends State<WebAppScreen> {
  final VideoController videoController = Get.put(VideoController());
  AuthController authController = Get.put(AuthController());
  List<VideoPlayerController> videoControllers = [];
  List<ChewieController> chewieControllers = [];
  bool _isLoading = true;
  bool _isModalVisible = false;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      waitForValidVideoRange();
    });
  }

  bool hasValidVideoRange() {
    return videoController.videoList.isNotEmpty;
  }

  void waitForValidVideoRange() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (hasValidVideoRange()) {
        preloadVideos();
      } else {
        waitForValidVideoRange();
      }
    });
  }

  void navigateToUseThisSoundScreen(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordThisSoundScreen(
          title: title,
        ),
      ),
    );
  }

  void preloadVideos() async {
    for (int i = 0; i < 2; i++) {
      final Video video = videoController.videoList[i];
      final VideoPlayerController videoPlayerController =
          VideoPlayerController.network(video.videoUrl);

      await videoPlayerController.initialize();

      videoController.addView(videoController.videoList[i].id);

      videoControllers.add(videoPlayerController);

      chewieControllers.add(
        ChewieController(
          videoPlayerController: videoPlayerController,
          showControlsOnInitialize: false,
          autoPlay: true,
          materialProgressColors: ChewieProgressColors(
            backgroundColor: Color.fromARGB(255, 40, 5, 165),
            bufferedColor: Color.fromARGB(255, 255, 255, 255),
          ),
          additionalOptions: (context) {
            return <OptionItem>[
              OptionItem(
                onTap: () => debugPrint('My option works!'),
                iconData: Icons.report,
                title: 'Report Video',
              ),
              OptionItem(
                onTap: () => debugPrint('Another option working!'),
                iconData: Icons.copy,
                title: 'Copy Link to Video',
              ),
            ];
          },
          looping: true,
          allowedScreenSleep: false,
          overlay: null,
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    for (final controller in videoControllers) {
      controller.dispose();
    }
    for (final controller in chewieControllers) {
      controller.dispose();
    }
    super.dispose();
  }

 
  Future<void> _onRefresh() async {
    setState(() {
      _refreshing = true;
    });

    setState(() {
      _refreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebApp Screen'),
      ),
      body: VisibilityDetector(
        key: Key('videosVisibilityKey'),
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.visibleFraction == 1.0) {
            videoController.addView(videoController.videoList[0].id);
          }
        },
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  itemCount: videoController.videoList.length,
                  itemBuilder: (context, index) {
                    final Video video = videoController.videoList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Chewie(
                        controller: chewieControllers[index],
                      ),
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isModalVisible = !_isModalVisible;
          });
        },
        child: Icon(Icons.menu),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _isModalVisible
          ? Container(
              height: 250,
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.search),
                    title: Text('Search Friends'),
                  
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('My Profile'),
                   
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Logout'),
                  
                  ),
                ],
              ),
            )
          : null,
    );
  }
}