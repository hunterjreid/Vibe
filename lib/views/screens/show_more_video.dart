import 'package:flutter/material.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/video_controller.dart';
import 'package:vibe/views/screens/comment_screen.dart';
import 'package:vibe/views/screens/profile_screen.dart';
import 'package:vibe/views/screens/user_screen.dart';
import 'package:vibe/views/widgets/video_player_item.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firebase;

class ShowMoreVideo extends StatefulWidget {
  final String videoId;

  ShowMoreVideo({Key? key, required this.videoId}) : super(key: key);

  @override
  _ShowMoreVideoState createState() => _ShowMoreVideoState();
}

class _ShowMoreVideoState extends State<ShowMoreVideo> {
  late VideoPlayerController _videoPlayerController;
  bool _isVideoLoading = true;
  bool _isModalVisible = false;

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

  Future<void> _initializeVideoPlayer() async {
    final videoId = widget.videoId;
    final videoUrl = await getVideoUrlFromDatabase(videoId);

    setState(() {
      _videoPlayerController = VideoPlayerController.network(videoUrl);
      _videoPlayerController.initialize().then((_) {
        setState(() {
          _isVideoLoading = false;
        });
        _videoPlayerController.setLooping(true);
        _videoPlayerController.play();
      });
    });
  }

  Widget buildProfile(String profilePhoto) {
    return CircleAvatar(
      radius: 28,
      backgroundImage: NetworkImage(profilePhoto),
    );
  }

  void navigateToHomeScreen() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final videoController = Get.find<VideoController>();
    final videoId = widget.videoId;
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
            child: _isVideoLoading
                ? Center(child: CircularProgressIndicator())
                : VideoPlayer(_videoPlayerController),
          ),
          VideoTextOverlay(
            texts: [
              'Username',
              'Caption 2',
              'Caption',
              'Caption 3',
              'Soundtrack: Song Name',
              'Posted on: ${DateTime.now().toString()}',
              'Views: 0',
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
                fontFamily: 'MonaSans',
              ),
              TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontFamily: 'MonaSans',
              ),
              TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontFamily: 'MonaSans',
              ),
            ],
          ),
          Positioned(
            top: 16,
            left: 16,
            child: InkWell(
              onTap: navigateToHomeScreen,
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isModalVisible = !_isModalVisible;
                });
              },
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          ),
          if (_isModalVisible)
            Positioned(
              top: 72,
              right: 16,
              child: Container(
                width: 160,
                height: 96,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ListTile(
                      onTap: () {
                        setState(() {
                          _isModalVisible = false;
                        });

                        navigateToHomeScreen();
                      },
                      leading: Icon(Icons.delete),
                      title: Text('Delete Video'),
                    ),
                    ListTile(
                      onTap: () {
                        setState(() {
                          _isModalVisible = false;
                        });

                        navigateToHomeScreen();
                      },
                      leading: Icon(Icons.favorite),
                      title: Text('Add to Favorites'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class VideoTextOverlay extends StatelessWidget {
  final List<String> texts;
  final List<TextStyle> textStyles;

  VideoTextOverlay({required this.texts, required this.textStyles});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < texts.length; i++)
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  texts[i],
                  style: textStyles[i],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Future<String> getVideoUrlFromDatabase(String videoId) async {
  // Implement your logic to retrieve the video URL from the database
  // Here's an example using Cloud Firestore

  final document = await firebase.FirebaseFirestore.instance
      .collection('videos')
      .doc(videoId)
      .get();

  final data = document.data() as Map<String, dynamic>?;
  if (data != null && data.containsKey('videoUrl')) {
    return data['videoUrl'];
  }

  return '';
}
