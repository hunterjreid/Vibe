import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/views/screens/friendSearch_screen.dart';
import 'package:vibe/views/screens/profile_screen.dart';
import 'package:vibe/views/screens/user_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:vibe/controllers/video_controller.dart';
import 'package:vibe/models/video.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'comment_screen.dart';



class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

class _FeedScreenState extends State<FeedScreen> {
  final VideoController videoController = Get.put(VideoController());
  List<VideoPlayerController> videoControllers = [];
  List<ChewieController> chewieControllers = []; // Added list of ChewieControllers
  bool _isLoading = true;
  bool _isModalVisible = false;
  bool _refreshing = false; // Added refreshing state

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      preloadVideos();
    });
  }

  void preloadVideos() async {
    if (videoController != null) {}
    for (int i = 0; i < 3; i++) {
      final Video video = videoController.videoList[i];
      final VideoPlayerController videoPlayerController = VideoPlayerController.network(video.videoUrl);

      await videoPlayerController.initialize();
      setState(() {
        _isLoading = false;
      });

      print(videoPlayerController);

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
          looping: true,
          allowedScreenSleep: false,
          overlay: null,
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Center(
                child: Container(
                  width: 100, // Set the desired width
                  height: 100, // Set the desired height
                  child: CupertinoActivityIndicator(),
                ),
              )
            : RefreshIndicator(
                onRefresh: _refreshVideos, // Add the onRefresh callback
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          itemCount: videoController.videoList.length,
                          controller: PageController(initialPage: 0, viewportFraction: 1),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final Video video = videoController.videoList[index];
                            final data = videoController.videoList[index];
                            final VideoPlayerController videoPlayerController = videoControllers[index];
                            final ChewieController chewieController =
                                chewieControllers[index]; // Get the ChewieController from the list

                            return Stack(
                              children: [
                                VisibilityDetector(
                                  key: Key(video.videoUrl),
                                  onVisibilityChanged: (visibilityInfo) {
                                    if (visibilityInfo.visibleFraction != 0) {
                                      chewieController.play();
                                    } else {
                                      chewieController.pause();
                                    }
                                  },
                                  child: Chewie(
                                    controller: chewieController,
                                  ),
                                ),
                                  Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.visibility,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '0',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
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
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => UserScreen(uid: data.uid),
                                                    ),
                                                  );
                                                },
                                                child: Column(
                                                  children: [
                                                    buildProfile(data.profilePhoto),
                                                  ],
                                                ),
                                              ),
                                            const SizedBox(height: 5),
                                            InkWell(
                                              onTap: () => videoController.likeVideo(data.id),




                                              child: Icon(
                                                Icons.favorite,
                                                size: 45,
                                                color: video.likes.contains(authController.user.uid)
                                                    ? Color.fromARGB(255, 44, 113, 179)
                                                    : Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              videoController.videoList[index].likes.length.toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _isModalVisible = true;
                                                });
                                              },
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
                                              onTap: () => Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => CommentScreen(
                                                    id: videoController.videoList[index].id,
                                                  ),
                                                ),
                                              ),
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
                                                          "Your video has been saved to your saved to your gallery."),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context),
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
                                          videoController.videoList[index].username,
                                          '#Explore #Adventure',
                                          videoController.videoList[index].caption,
                                          'Discover the hidden treasures of nature',
                                          'Soundtrack: ' + videoController.videoList[index].songName,
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
                      if (_isModalVisible)
                        Container(
                          color: Theme.of(context).colorScheme.primary,
                          child: SizedBox(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        setState(() {
                                          _isModalVisible = false;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.facebook),
                                      onPressed: () {
                                        // Perform action for Facebook icon
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.read_more),
                                      onPressed: () {
                                        // Perform action for Twitter icon
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.e_mobiledata),
                                      onPressed: () {
                                        // Perform action for Instagram icon
                                      },
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _showShareOptions(context, '2');
                                      },
                                      child: const Text('MORE'),
                                    ),
                                    // Add more social icons as needed
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ));
  }

  void _loadVideos() async {
    // Your video loading logic here...
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshVideos() async {
    setState(() {
      _refreshing = true;
    });

    // Scramble the video list
    final List<Video> scrambledList = List.of(videoController.videoList);
    scrambledList.shuffle();

    // Clear the previous video controllers and chewie controllers
    for (final controller in videoControllers) {
      controller.dispose();
    }
    for (final controller in chewieControllers) {
      controller.dispose();
    }
    videoControllers.clear();
    chewieControllers.clear();

    // Reinitialize the video and chewie controllers
    for (int i = 0; i < scrambledList.length; i++) {
      final Video video = scrambledList[i];
      final VideoPlayerController videoPlayerController = VideoPlayerController.network(video.videoUrl);

      await videoPlayerController.initialize();
      setState(() {
        _refreshing = false;
      });

      videoControllers.add(videoPlayerController);

      chewieControllers.add(
        ChewieController(
          videoPlayerController: videoPlayerController,
          showControlsOnInitialize: false,
          autoPlay: true,
          materialProgressColors: ChewieProgressColors(
            backgroundColor: Color.fromARGB(255, 121, 121, 121),
            bufferedColor: Color.fromARGB(255, 204, 204, 204),
          ),
          looping: true,
          allowedScreenSleep: false,
          overlay: null,
        ),
      );
    }
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
            final textStyle = textStyles.length > index ? textStyles[index] : TextStyle();
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

void _showShareOptions(BuildContext context, String videoId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Share Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Share other'),
              onTap: () {
                // Share.share('Check out this video on vibe!', subject: 'Look what I made!');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Share to DM'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FriendSearchPage(
                            videoId: videoId,
                          )),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
