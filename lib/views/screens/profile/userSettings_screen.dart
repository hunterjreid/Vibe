import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/profile_controller.dart';
import 'package:vibe/controllers/settings_controller.dart';

class UserSettingsScreen extends StatefulWidget {
  Color startColor;
  Color endColor;
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
    Color currentColor = isStartColor ? widget.startColor : widget.endColor;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) {
                if (isStartColor) {
                  setState(() {
                    widget.startColor = color;
                    controller.startColor.value = color;
                  });
                } else {
                  setState(() {
                    widget.endColor = color;
                    controller.endColor.value = color;
                  });
                }
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

  void saveChanges() {
    controller.updateProfile();
    widget.onSaveChanges(
      controller.startColor.value,
      controller.endColor.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () => Navigator.of(context).pop(),
  ),
  title: Text('Edit'),
  actions: [
    IconButton(
      icon: Icon(Icons.logout),
      onPressed: () => controller.authController.signOut(),
    ),
  ],
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
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 153, 153, 153),
                onPrimary: Color.fromARGB(255, 26, 26, 26),
                textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MonaSansExtraBoldWideItalic',
                ),
              ),
              child: Text('Change'),
            ),
        Expanded(
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ElevatedButton(
        onPressed: () => showColorPicker(true),
        style: ElevatedButton.styleFrom(
          primary: widget.startColor,
        ),
        child: Text('Start Color'),
      ),
      ElevatedButton(
        onPressed: () => showColorPicker(false),
        style: ElevatedButton.styleFrom(
          primary: widget.endColor,
        ),
        child: Text('End Color'),
      ),
    ],
  ),
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
                Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        'Email is not publicly visible',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
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

               InkWell(
                                          onTap: () {
                                           saveChanges();
                                          },
           child:     Container(
                                            width: 170,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors:  [Colors.red, Colors.pink]
                                                    
                                              ),
                                              border: Border.all(),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Text(
                                               "Save Changes",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'MonaSansExtraBoldWideItalic',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),

               ),
                                
  //  ElevatedButton(
  //             onPressed: () => controller.authController.signOut(),
  //             child: Text(
  //               'LOG OUT ',
  //               style: TextStyle(
  //                 fontSize: 15,
  //                 fontWeight: FontWeight.bold,
  //                 fontFamily: 'MonaSansExtraBoldWideItalic',
  //               ),
  //             ),
  //           ),
           ],
        ),
      ),
    );
  }
}
