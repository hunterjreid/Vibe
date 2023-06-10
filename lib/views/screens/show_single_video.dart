import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              // Handle favorite button tap
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Handle share button tap
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
        itemCount: widget.videoController.videoList.length,
        itemBuilder: (context, index) {
          final data = widget.videoController.videoList[index];
          return Center(
            child: _isVideoLoading
                ? CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: VideoPlayer(_videoPlayerController),
                  ),
          );
        },
      ),
    );
  }
}
