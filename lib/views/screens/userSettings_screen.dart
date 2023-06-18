import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/profile_controller.dart';
import 'package:vibe/controllers/settings_controller.dart';
class UserSettingsScreen extends StatefulWidget {
  final Color startColor;
  final Color endColor;
  final Function(Color startColor, Color endColor) onSaveChanges;

  UserSettingsScreen({
    required this.startColor,
    required this.endColor,
    required this.onSaveChanges,
  });

  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  late SettingsController controller;
  late ProfileController profileController;
  late TextEditingController usernameController;
  late TextEditingController bioController;
  late TextEditingController websiteController;
  late TextEditingController emailController;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SettingsController());
    profileController = Get.put(ProfileController());
    usernameController = TextEditingController();
    bioController = TextEditingController();
    websiteController = TextEditingController();
    emailController = TextEditingController();

    usernameController.text = controller.usernameController.text;
    bioController.text = controller.bioController.text;
    websiteController.text = controller.websiteController.text;
    emailController.text = controller.emailController.text;
  }

  void showColorPicker(bool isStartColor) {
    Color currentColor =
        isStartColor ? controller.startColor.value : controller.endColor.value;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) {
                setState(() {
                  if (isStartColor) {
                    controller.startColor.value = color;
                  } else {
                    controller.endColor.value = color;
                  }
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        controller.startColor.value,
                        controller.endColor.value,
                      ],
                      stops: [0.0, 1.0],
                      center: Alignment.center,
                      radius: 1.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                 backgroundImage: _pickedImage != null
  ? Image.file(_pickedImage!).image
  : NetworkImage(profileController.user['profilePhoto'] ?? ''),

                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: controller.pickImage,
              child: Text('SELECT PROFILE PICTURE'),
            ),
            ElevatedButton(
              onPressed: controller.uploadProfilePicture,
              child: Text('UPLOAD PROFILE PICTURE'),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
              onChanged: (value) {
                controller.usernameController.text = value;
              },
            ),
            TextField(
              controller: bioController,
              decoration: InputDecoration(
                labelText: 'Bio',
              ),
              onChanged: (value) {
                controller.bioController.text = value;
              },
            ),
            TextField(
              controller: websiteController,
              decoration: InputDecoration(
                labelText: 'Website',
              ),
              onChanged: (value) {
                controller.websiteController.text = value;
              },
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              onChanged: (value) {
                controller.emailController.text = value;
              },
            ),
            ElevatedButton(
              onPressed: () {
                controller.updateProfile();
              },
              child: Text('UPDATE PROFILE'),
            ),
            Obx(() {
              return SwitchListTile(
                title: Text('Anonymous Account'),
                value: controller.isAnonymous.value,
                onChanged: (value) {
                  controller.isAnonymous.value = value;
                },
              );
            }),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => showColorPicker(true),
                    child: Text('Start Color'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => showColorPicker(false),
                    child: Text('End Color'),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                controller.updateProfile();
                widget.onSaveChanges(
                  controller.startColor.value,
                  controller.endColor.value,
                );
              },
              child: Text('Save Color and Changes'),
            ),
            ElevatedButton(
              onPressed: () => controller.authController.signOut(),
              child: Text(
                'LOG OUT ',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MonaSansExtraBoldWideItalic',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}