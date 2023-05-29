import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class NewLayoutScreen extends StatefulWidget {
  @override
  _NewLayoutScreenState createState() => _NewLayoutScreenState();
}

class _NewLayoutScreenState extends State<NewLayoutScreen> {
  List<String> videoUrls = [
    'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
    'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
    'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
    'https://storage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
    'https://storage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
  ];

  List<VideoPlayerController> videoControllers = [];
  List<ChewieController> chewieControllers = [];
  List<bool> isVideoPlaying = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < videoUrls.length; i++) {
      final videoUrl = videoUrls[i];
      final videoController = VideoPlayerController.network(videoUrl);
      final chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: i == 0,
        looping: true,
        autoInitialize: true,
        allowFullScreen: false,
        allowMuting: true, // Add this line to allow muting
        showControls: false,
      );
      videoControllers.add(videoController);
      chewieControllers.add(chewieController);
      isVideoPlaying.add(i == 0);
    }
    videoControllers[currentIndex].initialize().then((_) {
      setState(() {
        chewieControllers[currentIndex].play();
        isVideoPlaying[currentIndex] = true;
      });
    });
  }

  @override
  void dispose() {
    for (var controller in chewieControllers) {
      controller.dispose();
    }
    for (var controller in videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scrol lazyload + Pause and autoplay '),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshVideos,
        child: PageView.builder(
          itemCount: videoUrls.length,
          scrollDirection: Axis.vertical,
          controller: PageController(
            initialPage: currentIndex,
          ),
          itemBuilder: (context, index) {
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (chewieControllers[currentIndex].isPlaying) {
                        chewieControllers[currentIndex].pause();
                        isVideoPlaying[currentIndex] = false;
                      } else {
                        chewieControllers[currentIndex].play();
                        isVideoPlaying[currentIndex] = true;
                      }
                    });
                  },
                  child: Container(
                    color: Colors.black,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: Chewie(
                          controller: chewieControllers[currentIndex],
                        ),
                      ),
                    ),
                  ),
                ),
            AnimatedSwitcher(
  duration: Duration(milliseconds: 100),
  transitionBuilder: (child, animation) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  },
  child: Stack(
    children: [
      Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (chewieControllers[currentIndex].isPlaying) {
                chewieControllers[currentIndex].pause();
                isVideoPlaying[currentIndex] = false;
              } else {
                chewieControllers[currentIndex].play();
                isVideoPlaying[currentIndex] = true;
              }
            });
          },
        ),
      ),
      IgnorePointer(
        // Ignores touches while the animation is in progress
        child: Center(
          child: AnimatedScale(
            duration: Duration(milliseconds: 200),
            scale: isVideoPlaying[currentIndex] ? 0.0 : 0.7,
            child: Icon(
              chewieControllers[currentIndex].isPlaying
                  ? Icons.play_arrow
                  : Icons.pause,
              size: 48,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
      ),
    ],
  ),
),
   ],
            );
          },
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
              for (var i = 0; i < isVideoPlaying.length; i++) {
                if (i != currentIndex && isVideoPlaying[i]) {
                  chewieControllers[i].pause();
                  isVideoPlaying[i] = false;
                }
              }
              chewieControllers[currentIndex].play();
              isVideoPlaying[currentIndex] = true;
            });
          },
        ),
      ),
    );
  }

  Future<void> _refreshVideos() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      videoUrls.shuffle();
      for (var controller in videoControllers) {
        controller.dispose();
      }
      for (var controller in chewieControllers) {
        controller.dispose();
      }
      videoControllers.clear();
      chewieControllers.clear();
      isVideoPlaying.clear();
      currentIndex = 0;
      for (var i = 0; i < videoUrls.length; i++) {
        final videoUrl = videoUrls[i];
        final videoController = VideoPlayerController.network(videoUrl);
        final chewieController = ChewieController(
          videoPlayerController: videoController,
          autoPlay: i == 0,
          looping: true,
          autoInitialize: true,
          allowFullScreen: false,
          allowMuting: true, // Add this line to allow muting
          showControls: false,
        );
        videoControllers.add(videoController);
        chewieControllers.add(chewieController);
        isVideoPlaying.add(i == 0);
      }
      videoControllers[currentIndex].initialize().then((_) {
        setState(() {
          chewieControllers[currentIndex].play();
          isVideoPlaying[currentIndex] = true;
        });
      });
    });
  }
}
