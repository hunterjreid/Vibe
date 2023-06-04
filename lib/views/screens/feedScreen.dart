import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:vibe/controllers/video_controller.dart';
import 'package:vibe/models/video.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';

import 'comment_screen.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final VideoController videoController = Get.put(VideoController());
  List<VideoPlayerController> videoControllers = [];
  ChewieController? chewieController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    preloadVideos();
  }

  void preloadVideos() async {
    for (int i = 0; i < videoController.videoList.length; i++) {
      final Video video = videoController.videoList[i];
      final VideoPlayerController videoPlayerController =
          VideoPlayerController.network(video.videoUrl);

      await videoPlayerController.initialize();

      setState(() {
        _isLoading = false;
      });

      videoControllers.add(videoPlayerController);
    }
  }

  @override
  void dispose() {
    for (final controller in videoControllers) {
      controller.dispose();
    }
    chewieController?.dispose(); // Add this line
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      body: _isLoading
          ? Center(
  child: Container(
    width: 100, // Set the desired width
    height: 100, // Set the desired height
    child: CupertinoActivityIndicator(),
  ),
)
          : Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: videoController.videoList.length,
                    controller: PageController(initialPage: 0, viewportFraction: 1),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final Video video = videoController.videoList[index];
                      final VideoPlayerController videoPlayerController =
                          videoControllers[index];
                      chewieController = ChewieController(
                        videoPlayerController: videoPlayerController,
                        showControlsOnInitialize: false,
                        autoPlay: true,
                        materialProgressColors: ChewieProgressColors(
                          backgroundColor: Color.fromARGB(255, 40, 5, 165),
                          bufferedColor: Color.fromARGB(255, 228, 17, 200),
                        ),
                        looping: true,
                        allowedScreenSleep: false,
                        overlay: null,
                      );

                      return Stack(
                        children: [
                          VisibilityDetector(
                            key: Key(video.videoUrl),
                            onVisibilityChanged: (visibilityInfo) {
                              if (visibilityInfo.visibleFraction != 0) {
                                chewieController!.play();
                              } else {
                                chewieController!.pause();
                              }
                            },
                            child: Chewie(
                              controller: chewieController!,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 55.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Rest of your overlay content goes here
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Icon(
                                          Icons.favorite,
                                          size: 45,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "0",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.share,
                                              size: 45,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "0",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.comment,
                                              size: 45,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "0",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.audio_file,
                                              size: 45,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "0",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Video saved"),
                                                content: Text(
                                                  "Your video has been saved to your saved folder."
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text("OK"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.folder,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "0",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
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
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'MonaSans',
                                    ),
                                    TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
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
                  ),
                ),
              ],
            ),
    );
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
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: c_width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(texts.length, (index) {
            final textStyle =
                textStyles.length > index ? textStyles[index] : TextStyle();
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                texts[index],
                style: textStyle,
              ),
            );
          }),
        ),
      ),
    );
  }
}
