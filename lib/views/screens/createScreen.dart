import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/profile_controller.dart';
import 'package:vibe/views/screens/confirm_screen.dart';
import 'package:vibe/views/screens/facefilter_screen.dart';
import 'package:vibe/views/screens/profile_screen.dart';
import 'package:vibe/views/screens/uploadAudio_screen.dart';
import 'package:vibe/views/screens/your_dms_screen.dart';
import 'package:video_player/video_player.dart';

class CreateScreen extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  pickVideoFromCamera(BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: ImageSource.camera);
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
            videoFile: File(video.path),
            videoPath: video.path,
          ),
        ),
      );
    }
  }

  pickVideoFromGallery(BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
            videoFile: File(video.path),
            videoPath: video.path,
          ),
        ),
      );
    }
  }

  showOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () => pickVideoFromGallery(context),
            child: Row(
              children: const [
                Icon(Icons.video_library),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Select Video',
                    style: TextStyle(fontSize: 20, fontFamily: 'Mona Sans'),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => pickVideoFromCamera(context),
            child: Row(
              children: const [
                Icon(Icons.videocam),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Record Video',
                    style: TextStyle(fontSize: 20, fontFamily: 'Mona Sans'),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: Row(
              children: const [
                Icon(Icons.cancel),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20, fontFamily: 'Mona Sans'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8.0),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                children: [
                                   _buildButton(context, 'Your Profile', ProfileScreen(uid: authController.user.uid)),
       
                  _buildButton(context, 'Add Video', TrendsScreen()),
                  _buildButton(context, 'Face Filter', FaceFilterScreen()),
            _buildButton(context, 'Trends!', TrendsScreen()),
                  _buildButton(context, 'Your DMs', DmScreen()),
                  _buildButton(context, 'Saved Videos', MoreScreen()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String title, Widget screenWidget) {
    return ElevatedButton(
      onPressed: () {
        if (title == 'Add Video') {
          showOptionsDialog(context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screenWidget),
          );
        }
      },
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          fontFamily: 'MonaSansExtraBoldWideItalic',
        ),
      ),
    );
  }
}


class TrendsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trends Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trending Videos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Placeholder for the number of trending videos
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            color: Colors.grey[400], // Placeholder for video thumbnail
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Video Title', // Placeholder for video title
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Channel Name', // Placeholder for channel name
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
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
            ),
          ],
        ),
      ),
    );
  }
}


class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Save the current date and time
    DateTime currentTime = DateTime.now();

    // Placeholder list of titles
    List<String> titles = [
      "Title 1",
      "Title 2",
      "Title 3",
      "Title 4",
      "Title 5",
    ];

    return Scaffold(
      
            appBar: AppBar(
        title: Text('Saved Videos screen'),
      ),
      body: Column(
        children: [
          // Display the list of titles
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: titles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(titles[index]),
                );
              },
            ),
          ),
          // Display the saved date and time
          Text('Last updated: $currentTime'),
        ],
      ),
    );
  
  }




  Widget _buildButtonx(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
         
        },
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}