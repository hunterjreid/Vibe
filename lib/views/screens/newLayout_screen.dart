import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';

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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadVideos();
  }

  void loadVideos() async {
    for (var i = 0; i < videoUrls.length; i++) {
      final videoUrl = videoUrls[i];
      final videoController = VideoPlayerController.network(videoUrl);
      await videoController.initialize();
      final chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: i == 0,
        looping: true,
        autoInitialize: true,
        allowFullScreen: false,
        allowMuting: true,
        showControls: false,
      );
      videoControllers.add(videoController);
      chewieControllers.add(chewieController);
      isVideoPlaying.add(i == 0);

      if (i == 0) {
        videoController.addListener(() {
          if (videoController.value.isInitialized) {
            setState(() {
              isLoading = false;
            });
          }
        });
      }
    }

    chewieControllers[currentIndex].play();
    isVideoPlaying[currentIndex] = true;
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
        backgroundColor: Colors.black, // Set the app bar background color to black
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                // Handle the action when the more button is pressed
              },
              child: Icon(
                Icons.more_horiz_outlined, // Use the outlined variant of the more icon
                // Specify the desired size and color for the icon
                size: 24,
                color: Colors.white,
              ),
            ),
            Image.asset(
              'assets/images/logo.png', // Replace with your logo image path
              width: 50,
              height: 50,
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Settings'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Color theme:'),
                          RadioListTile(
                            title: Text('System'),
                            value: 'System',
                            groupValue: 'System',
                            onChanged: (value) {
                              // Handle color theme change
                            },
                          ),
                          RadioListTile(
                            title: Text('White'),
                            value: 'White',
                            groupValue: 'System',
                            onChanged: (value) {
                              // Handle color theme change
                            },
                          ),
                          RadioListTile(
                            title: Text('Black'),
                            value: 'Black',
                            groupValue: 'System',
                            onChanged: (value) {
                              // Handle color theme change
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Icon(
                Icons.settings,
                // Specify the desired size and color for the icon
                size: 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: CupertinoActivityIndicator(
                radius: 16.0,
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshVideos,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (notification) {
                  notification.disallowGlow(); // Disable the bouncy physics effect
                  return true;
                },
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
                                child: Center(
                                  child: AnimatedScale(
                                    duration: Duration(milliseconds: 200),
                                    scale: isVideoPlaying[currentIndex] ? 0.0 : 0.7,
                                    child: Icon(
                                      chewieControllers[currentIndex].isPlaying ? Icons.play_arrow : Icons.pause,
                                      size: 48,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              ),
                              VideoTextOverlay(
                                texts: [
                                  'Hunter',
                                  '#Explore #Adventure',
                                  'Join usndscapes and experienc th landscapes and experience thrilling adventures!',
                                  'Discover the hidden treasures of nature',
                                  'Soundtrack: Epic Exploration',
                                ],
                                textStyles: [
                                  TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontFamily: 'MonaSansExtraBoldWideItalic',
                                  ),
                                  TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'MonaSans',
                                  ),
                                  TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 230, 230, 230),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'MonaSans',
                                  ),
                                  TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'MonaSans',
                                  ),
                                  TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontFamily: 'MonaSansExtraBoldWide',
                                  ),
                                ],
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
            ),
    );
  }

  Future<void> _refreshVideos() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      videoUrls.shuffle();
      for (var controller in videoControllers) {
        controller.dispose();
      }
      for (var controller in chewieControllers) {
        controller.dispose();
      }

      chewieControllers.clear();
      isVideoPlaying.clear();

      loadVideos();
    });
  }
}

class VideoTextOverlay extends StatelessWidget {
  final List<TextStyle> textStyles;
  final List<String> texts;

  const VideoTextOverlay({
    Key? key,
    required this.texts,
    required this.textStyles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.9;

    return Positioned(
      bottom: 16,
      left: 16,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: c_width,
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(texts.length, (index) {
                final textStyle = textStyles.length > index ? textStyles[index] : TextStyle();
                return Text(
                  texts[index],
                  style: textStyle,
                  overflow: TextOverflow.clip,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
