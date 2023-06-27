import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/auth_controller.dart';
import 'package:vibe/controllers/profile_controller.dart';
import 'package:vibe/views/screens/misc/browse_songs_screen.dart';
import 'package:vibe/views/screens/video/confirm_screen.dart';
import 'package:vibe/views/screens/profile/profile_screen.dart';

import 'package:vibe/views/screens/profile/your_dms_screen.dart';
import 'package:video_player/video_player.dart';

class CreateScreen extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  pickVideoFromCamera(BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: ImageSource.camera);
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
            videoFile: File(video!.path),
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
            videoFile: File(video!.path),
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
      backgroundColor: Colors.black,
      children: [
        SimpleDialogOption(
          onPressed: () => pickVideoFromGallery(context),
          child: Row(
            children: const [
              Icon(Icons.video_library, color: Colors.white),
              Padding(
                padding: EdgeInsets.all(7.0),
                child: Text(
                  'Select Video',
                  style: TextStyle(fontSize: 20, fontFamily: 'MonaSans', color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        SimpleDialogOption(
          onPressed: () => pickVideoFromCamera(context),
          child: Row(
            children: const [
              Icon(Icons.videocam, color: Colors.white),
              Padding(
                padding: EdgeInsets.all(7.0),
                child: Text(
                  'Record Video',
                  style: TextStyle(fontSize: 20, fontFamily: 'MonaSans', color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(),
          child: Row(
            children: const [
              Icon(Icons.cancel, color: Colors.white),
              Padding(
                padding: EdgeInsets.all(7.0),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 20, fontFamily: 'MonaSans', color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

showChangeBioDialog(BuildContext context) {
  String bio = profileController.user['longBio'];

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.black,
      title: Text(
        'Change Long Bio',
        style: TextStyle(fontFamily: 'MonaSans', color: Colors.white),
      ),
      content: TextFormField(
        initialValue: bio,
        onChanged: (value) {
          bio = value;
        },
        decoration: InputDecoration(
          labelText: 'Enter your new long bio',
          labelStyle: TextStyle(fontFamily: 'MonaSans', color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        style: TextStyle(fontFamily: 'MonaSans', color: Colors.white),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(fontFamily: 'MonaSans', color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () {
            profileController.updateProfileBio(bio);
            Navigator.of(context).pop();
          },
          child: Text(
            'Save',
            style: TextStyle(fontFamily: 'MonaSans', color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildButton(BuildContext context, String title, String imagePath, VoidCallback onTap) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          width: 94,
          height: 94,
        ),
        ElevatedButton(
          onPressed: onTap,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'MonaSansExtraBoldWideItalic',
            ),
          ),
        ),
      ],
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
                childAspectRatio: 1.2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                children: [
                  _buildButton(
                    context,
                    'Add Video',
                    'assets/images/createIcons/1.png',
                    () {
                      showOptionsDialog(context);
                    },
                  ),
                  _buildButton(
                    context,
                    'Music',
                    'assets/images/createIcons/4.png',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BrowseSongsPage()),
                      );
                    },
                  ),
                  _buildButton(
                    context,
                    'Trends',
                    'assets/images/createIcons/2.png',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TrendsScreen()),
                      );
                    },
                  ),
                  _buildButton(
                    context,
                    'Change Long Bio',
                    'assets/images/createIcons/3.png',
                    () {
                      showChangeBioDialog(context);
                    },
                  ),
                  _buildButton(
                    context,
                    'Unpublished',
                    'assets/images/createIcons/5.png',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MoreScreen()),
                      );
                    },
                  ),

                  // Add more buttons with local images here
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoData {
  final String imagePath;
  final String title;
  final String description;

  VideoData({required this.imagePath, required this.title, required this.description});
}

class TrendsScreen extends StatelessWidget {
  final List<VideoData> videos = [
    VideoData(
      imagePath: 'assets/images/trends/trend(1).jpg',
      title: 'Trend Name #vibes 1',
      description: 'This is what to do it and what makes it trendy! 1',
    ),
    VideoData(
      imagePath: 'assets/images/trends/trend(2).jpg',
      title: 'Trend Name #vibes 2',
      description: 'This is what to do it and what makes it trendy! 2',
    ),
    VideoData(
      imagePath: 'assets/images/trends/trend(3).jpg',
      title: 'Trend Name #vibes 3',
      description: 'This is what to do it and what makes it trendy! 1',
    ),
    VideoData(
      imagePath: 'assets/images/trends/trend(4).jpg',
      title: 'Trend Name #vibes 4',
      description: 'This is what to do it and what makes it trendy! 2',
    ),
    VideoData(
      imagePath: 'assets/images/trends/trend(5).jpg',
      title: 'Trend Name #vibes 5',
      description: 'This is what to do it and what makes it trendy! 1',
    ),
    VideoData(
      imagePath: 'assets/images/trends/trend(6).jpg',
      title: 'Trend Name #vibes 6',
      description: 'This is what to do it and what makes it trendy! 2',
    ),
    VideoData(
      imagePath: 'assets/images/trends/trend(7).jpg',
      title: 'Trend Name #vibes 7',
      description: 'This is what to do it and what makes it trendy! 1',
    ),
    VideoData(
      imagePath: 'assets/images/trends/trend(8).jpg',
      title: 'Trend Name #vibes 8',
      description: 'This is what to do it and what makes it trendy! 2',
    ),
    VideoData(
      imagePath: 'assets/images/trends/trend(9).jpg',
      title: 'Trend Name #vibes 9',
      description: 'This is what to do it and what makes it trendy! 1',
    ),
    VideoData(
      imagePath: 'assets/images/trends/trend(10).jpg',
      title: 'Trend Name #vibes 10',
      description: 'This is what to do it and what makes it trendy! 2',
    ),

    // Add more video data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vibe Trends'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trending Challenges',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.asset(
                            video.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                video.description,
                                style: TextStyle(
                                  fontSize: 14,
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
        title: Text('Draft Videos'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 46),
          Text(
            'Here, your draft videos will appear',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          //   SizedBox(height: 16),
          //   Expanded(
          //     child: ListView.builder(s
          //       shrinkWrap: true,
          //       itemCount: titles.length,
          //       itemBuilder: (context, index) {
          //         return ListTile(
          //           title: Text(titles[index]),
          //         );
          //       },
          //     ),
          //   ),
          //   Text('Last updated: $currentTime'),
        ],
      ),
    );
  }
}
