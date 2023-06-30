// ------------------------------
//  Hunter Reid 2023 ⓒ
//  Vibe Find your Vibes
//
//  feed_screen.dart
//

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:vibe/views/screens/video/comment_screen.dart';
import 'package:vibe/views/screens/misc/friend_search_screen.dart';
import 'package:vibe/views/screens/profile/profile_screen.dart';
import 'package:vibe/views/screens/misc/use_sound_screen.dart';
import 'package:vibe/views/widgets/folder_icon.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:vibe/controllers/video_controller.dart';
import 'package:vibe/models/video.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:vibe/controllers/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:iconsax/iconsax.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();

  void refreshVideos() {}
  final VideoController videoController = Get.put(VideoController());
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
            child: Image.network(
              profilePhoto,
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

  AuthController authController = Get.put(AuthController());
  List<VideoPlayerController> videoControllers = [];
  List<ChewieController> chewieControllers = [];
  bool _isLoading = true;
  bool _isModalVisible = false;
  bool _refreshing = false;
  int _currentPageIndex = 0;
  int _currentVideoIndex = 0;
  int _videosPerPage = 8;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      waitForValidVideoRange();
    });
  }

  bool hasValidVideoRange() {
    return videoController.videoList.isNotEmpty;
  }

  void waitForValidVideoRange() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
              )),
    );
  }

  void preloadVideos() async {
    for (int i = _currentVideoIndex; i < _currentVideoIndex + _videosPerPage; i++) {
      print(videoController.videoList.length);
      if (i >= videoController.videoList.length) {
        _currentVideoIndex = 0;
        i = 0;
      }

      final Video video = videoController.videoList[i];
      final VideoPlayerController videoPlayerController = VideoPlayerController.network(video.videoUrl);

      await videoPlayerController.initialize();

      videoController.addView(videoController.videoList[i].id);
      setState(() {
        _isLoading = false;
      });
      videoControllers.add(videoPlayerController);

      chewieControllers.add(
        ChewieController(
          videoPlayerController: videoPlayerController,
          autoPlay: true,
          looping: true,
        ),
      );
    }
  }

  ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      preloadVideos();
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
                  width: 100,
                  height: 100,
                  child: CupertinoActivityIndicator(),
                ),
              )
            : RefreshIndicator(
                onRefresh: _refreshVideos,
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          itemCount: videoController.videoList.length * 2,
                          controller: PageController(initialPage: 0, viewportFraction: 1),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final int pageIndex = index % videoController.videoList.length;
                            final Video video = videoController.videoList[pageIndex];
                            final data = videoController.videoList[pageIndex];
                            final VideoPlayerController videoPlayerController = videoControllers[pageIndex];
                            final ChewieController chewieController = chewieControllers[pageIndex];

                            bool isFileOpen = true;
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
                                  left: 25,
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
                                          data.views.toString(),
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
                                  padding: EdgeInsets.only(bottom: 60.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 40),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ProfileScreen(uid: data.uid),
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
                                              onTap: () {
                                                final video = videoController.videoList[index];
                                                final videoId = video.id;

                                                videoController.likeVideo(videoId);

                                                setState(() {
                                                  if (video.likes.contains(authController.user.uid)) {
                                                    video.likes.remove(authController.user.uid);
                                                  } else {
                                                    video.likes.add(authController.user.uid);
                                                  }
                                                });
                                              },
                                              child: Tab(
                                                icon: video.likes.contains(authController.user.uid)
                                                    ? Icon(
                                                        FontAwesomeIcons.solidHeart,
                                                        size: 45,
                                                        color: Colors.red,
                                                      )
                                                    : Icon(
                                                        FontAwesomeIcons.heartCrack,
                                                        size: 45,
                                                        color: Color.fromARGB(255, 255, 255, 255),
                                                      ),
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
                                                  _isModalVisible = !_isModalVisible;
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Iconsax.share,
                                                    size: 45,
                                                    color: _isModalVisible
                                                        ? Color.fromARGB(255, 157, 96, 255)
                                                        : Colors.white,
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
                                                    return CommentScreen(
                                                      id: videoController.videoList[index].id,
                                                    );
                                                  },
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Iconsax.note_text,
                                                    size: 45,
                                                    color: videoController.videoList[index].commentBy
                                                            .contains(authController.user.uid)
                                                        ? Color.fromARGB(255, 17, 255, 255)
                                                        : Colors.white,
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    videoController.videoList[index].commentCount.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () => navigateToUseThisSoundScreen(
                                                  videoController.videoList[index].songName.toString()),
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
                                                setState(() {
                                                  isFileOpen = !isFileOpen;
                                                });
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text("Video saved"),
                                                      content: Text("Your video has been saved to your gallery."),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: Text("OK"),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );

                                                videoController.saveVideo(videoController.videoList[index].id);
                                              },
                                              child: FolderIcon(
                                                isFolderOpen: false,
                                                savedCount: videoController.videoList[index].savedCount,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      VideoTextOverlay(
                                        texts: [
                                          videoController.videoList[index].username,
                                          videoController.videoList[index].caption2,
                                          videoController.videoList[index].caption,
                                          videoController.videoList[index].caption3,
                                          ' Soundtrack: ' + videoController.videoList[index].songName + ' 🎵🔊',
                                        ],
                                        textStyles: [
                                          TextStyle(
                                            fontSize: 18,
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
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'MonaSans',
                                          ),
                                          TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'MonaSans',
                                          ),
                                          TextStyle(
                                            fontSize: 11,
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
                      Visibility(
                        visible: _isModalVisible,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: _isModalVisible ? 5 : 0,
                            sigmaY: _isModalVisible ? 5 : 0,
                          ),
                          child: Container(
                            color: Color.fromARGB(54, 0, 0, 0).withOpacity(0.5),
                            child: Center(),
                          ),
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
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isModalVisible = false;
                                        });
                                      },
                                      child: const Text('HIDE'),
                                    ),
                                    IconButton(
                                      icon: Image.asset('assets/images/share_socials/facebook.png'),
                                      onPressed: () {
                                        setState(() {
                                          _isModalVisible = false;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Image.asset('assets/images/share_socials/instagram.png'),
                                      onPressed: () {
                                        setState(() {
                                          _isModalVisible = false;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Image.asset('assets/images/share_socials/linkedin.png'),
                                      onPressed: () {
                                        setState(() {
                                          _isModalVisible = false;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Image.asset('assets/images/share_socials/slack.png'),
                                      onPressed: () {
                                        setState(() {
                                          _isModalVisible = false;
                                        });
                                      },
                                    ),
                                    // IconButton(
                                    //   icon: Image.asset('assets/images/share_socials/tik-tok.png'),
                                    //   onPressed: () {
                                    //     // Perform action for TikTok icon
                                    //   },
                                    // ),
                                    IconButton(
                                      icon: Image.asset('assets/images/share_socials/youtube.png'),
                                      onPressed: () {
                                        // Perform action for YouTube icon
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
          additionalOptions: (context) {
            return <OptionItem>[
              OptionItem(
                onTap: () => debugPrint('My option works!'),
                iconData: Icons.chat,
                title: 'My localized title',
              ),
              OptionItem(
                onTap: () => debugPrint('Another option working!'),
                iconData: Icons.chat,
                title: 'Another localized title',
              ),
            ];
          },
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
        backgroundColor: Colors.black, // Set black background color
        title: Text(
          'Share Options',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.people, color: Colors.white), // Set icon color to white
              title: Text(
                'Share other',
                style: TextStyle(fontFamily: 'MonaSansExtraBoldWide', color: Colors.white), // Set text color to white
              ),
              onTap: () {
                // Share.share('Check out this video on vibe!', subject: 'Look what I made!');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.message, color: Colors.white), // Set icon color to white
              title: Text(
                'Share to DM',
                style: TextStyle(fontFamily: 'MonaSansExtraBoldWide', color: Colors.white), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FriendSearchPage(
                      videoId: videoId,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
