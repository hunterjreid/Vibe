import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/profile_controller.dart';
import 'package:vibe/views/screens/confirm_screen.dart';

import 'package:vibe/views/screens/profile_screen.dart';
import 'package:vibe/views/screens/uploadAudio_screen.dart';

import 'browsesongs_screen.dart';

class AddVideoScreen extends StatelessWidget {
  AddVideoScreen({Key? key}) : super(key: key);

  final ProfileController profileController = Get.put(ProfileController());
  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
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
            onPressed: () => pickVideo(ImageSource.gallery, context),
            child: Row(
              children: const [
                Icon(Icons.image),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20, fontFamily: 'Mona Sans'),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.camera, context),
            child: Row(
              children: const [
                Icon(Icons.camera_alt),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Camera',
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
      appBar: AppBar(
        backgroundColor: Color.fromARGB(120, 217, 0, 255),
        title: Wrap(
          children: [
            Text(
              'This is my BANNER i\'ll announce new filters and trending hashtags here!',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(34, 3, 168, 244),
              Color.fromARGB(24, 155, 39, 176),
              Color.fromARGB(38, 0, 0, 0),
              Color.fromARGB(19, 0, 0, 0),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(uid: authController.user.uid),
                    ),
                  );
                },
              ),
              CircleAvatar(
                radius: 56,
                backgroundImage: profileController.user['profilePhoto'] != null
                    ? CachedNetworkImageProvider(profileController.user['profilePhoto'])
                    : null,
                child: profileController.user['profilePhoto'] == null ? CircularProgressIndicator() : null,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: profileController.user['name'] != null
                      ? Text(
                          profileController.user['name'],
                          style: TextStyle(
                            fontFamily: 'MonaSansExtraBoldWideItalic',
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : CircularProgressIndicator(),
                ),
              ),
              Text(
                'You are logged in as: ' + profileController.user['name'].toString(),
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MonaSans',
                ),
              ),
              Text(
                'Welcome to Create!',
                style: TextStyle(
                  fontSize: 29,
                  fontFamily: 'MonaSansExtraBoldWide',
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => showOptionsDialog(context),
                    child: Container(
                      width: 190,
                      height: 50,
                      decoration: BoxDecoration(color: borderColor),
                      child: const Center(
                        child: Text(
                          'Add Video',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MonaSans',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), //  spacing between the two widgets
                ],
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BrowseSongsPage(),
                  ),
                ),
                child: Container(
                  width: 190,
                  height: 50,
                  decoration: BoxDecoration(color: Color.fromARGB(255, 39, 155, 176)),
                  child: const Center(
                    child: Text(
                      'Browse Sounds😋',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MonaSans',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
