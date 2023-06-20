import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/video_controller.dart';
import 'package:vibe/views/screens/comment_screen.dart';
import 'package:vibe/views/widgets/video_player_item.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class ShowOwnVideo extends StatefulWidget {
  final int videoIndex;
  final VideoController videoController = Get.find();
  bool _isModalVisible = false;

  ShowOwnVideo({Key? key, required this.videoIndex}) : super(key: key);

  @override
  _ShowOwnVideoState createState() => _ShowOwnVideoState();
}

class _ShowOwnVideoState extends State<ShowOwnVideo> {
  late PageController _pageController;
  late VideoPlayerController _videoPlayerController;
  bool _isVideoLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.videoIndex);
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _pageController.dispose();
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

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this video?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteVideo();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteVideo() {
    final data = widget.videoController.videoList[widget.videoIndex];

    debugPrint(data.uid);

    FirebaseFirestore.instance.collection('videos').doc(data.id).delete().then((_) {
      // Video deleted successfully
      // You can perform any additional tasks or show a success message
      print('Video deleted successfully');
      Navigator.popUntil(context, (route) => route.isFirst);
    }).catchError((error) {
      // An error occurred while deleting the video
      // Handle the error or show an error message
      print('Error deleting video: $error');
    });
  }

  Widget buildProfile(String profilePhoto) {
    return CircleAvatar(
      radius: 28,
      backgroundImage: NetworkImage(profilePhoto),
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoController = widget.videoController;
    bool _isModalVisible = false;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Video'),
        actions: [
          IconButton(
            icon: Icon(Icons.analytics_outlined),
           onPressed: () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('View-to-Like Ratio'),
        content: Text('V/L Ratio: ${(widget.videoController.videoList[widget.videoIndex].likes.length/widget.videoController.videoList[widget.videoIndex].views)}%'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  },
          ),
        
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog();
            },
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: videoController.videoList.length,
        itemBuilder: (context, index) {
          final data = videoController.videoList[index];
          final video = videoController.videoList[index];
          final videoId = video.id;
          videoController.addView(videoId);
          videoController.likeVideo(videoId);
          return Center(
            child: _isVideoLoading
                ? CircularProgressIndicator()
                : Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: VideoPlayer(_videoPlayerController),
                      ),
                      VideoTextOverlay(
                        texts: [
                          data.username,
                          data.caption2,
                          data.caption,
                          data.caption3,
                          'Soundtrack: ' + data.songName,
                          'Posted on: ' + data.timestamp.toDate().toString(),
                          'Views: ' + data.views.toString(),
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
                        child: buildProfile(data.profilePhoto),
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
                                    videoController.videoList[index].likes.length.toString(),
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
                                    id: videoController.videoList[index].id,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.comment_rounded,
                                    size: 45,
                                    color: videoController.videoList[index].commentBy.contains(authController.user.uid)
                                        ? Colors.purple
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
          );
        },
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
