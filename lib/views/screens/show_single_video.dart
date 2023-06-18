import 'package:flutter/material.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/video_controller.dart';
import 'package:vibe/views/screens/comment_screen.dart';
import 'package:vibe/views/screens/profile_screen.dart';
import 'package:vibe/views/screens/user_screen.dart';
import 'package:vibe/views/widgets/video_player_item.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class ShowSingleVideo extends StatefulWidget {
  final int videoIndex;
  final VideoController videoController = Get.find();
  bool _isModalVisible = false;

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

  Widget buildProfile(String profilePhoto) {
    return CircleAvatar(
      radius: 28,
      backgroundImage: NetworkImage(profilePhoto),
    );
  }
    void navigateToHomeScreen() {
    Navigator.pop(context); // Navigate back to the previous screen (home screen)
  }

  @override
  Widget build(BuildContext context) {
    final videoController = widget.videoController;
    bool _isModalVisible = false;
    final data = videoController.videoList[widget.videoIndex];
    final video = videoController.videoList[widget.videoIndex];
    final videoId = video.id;
    videoController.addView(videoId);
    videoController.likeVideo(videoId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Video'),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: VideoPlayer(_videoPlayerController),
          ),
          VideoTextOverlay(
            texts: [
              video.username,
              video.caption2,
              video.caption,
              video.caption3,
              'Soundtrack: ' + video.songName,
              'Posted on: ' + video.timestamp.toDate().toString(),
              'Views: ' + video.views.toString(),
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
      Positioned(
     top: 10,
                        right: 15,
                        width: 37.5,
                        height: 37.5,
  child: GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen(uid: data.uid)),
      );
    },
    child: buildProfile(data.profilePhoto),
  ),
),
          Positioned(
            top: 60,
            right: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      // Update the like count and color immediately
                      video.likes.contains(authController.user.uid)
                          ? video.likes.remove(authController.user.uid)
                          : video.likes.add(authController.user.uid);
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 35,
                        color: video.likes.contains(authController.user.uid)
                            ? Color.fromARGB(255, 44, 113, 179)
                            : Colors.white,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        video.likes.length.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
                        Icons.share,
                        size: 45,
                        color: _isModalVisible ? Color.fromARGB(255, 157, 96, 255) : Colors.white,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        video.commentCount.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentScreen(
                        id: videoController.videoList[widget.videoIndex].id,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.comment_rounded,
                        size: 45,
                        color: videoController.videoList[widget.videoIndex].commentBy.contains(authController.user.uid)
                            ? Colors.purple
                            : Colors.white,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        videoController.videoList[widget.videoIndex].commentCount.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
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
                      ),
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
                          content: Text("Your video has been saved to your gallery."),
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
                        Icons.save,
                        size: 45,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Save",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
       bottomNavigationBar: Container(
        height: 50,
        child: Center(
          child: TextButton(
            onPressed: navigateToHomeScreen, // Call the navigateToHomeScreen function
            child: Text(
              'Show Similar Videos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
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
