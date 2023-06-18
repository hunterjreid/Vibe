import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
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
  Color startColor = Colors.white;
  Color endColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    startColor = widget.startColor;
    endColor = widget.endColor;
  }

  void showColorPicker(bool isStartColor) {
    Color currentColor = isStartColor ? startColor : endColor;
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
                    startColor = color;
                  } else {
                    endColor = color;
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
                Navigator.of(context).pop({
                  'startColor': startColor,
                  'endColor': endColor,
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());
    final ProfileController profileController = Get.put(ProfileController());

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
                        startColor,
                        endColor,
                      ],
                      stops: [0.0, 1.0],
                      center: Alignment.center,
                      radius: 1.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      profileController.user['profilePhoto'],
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => controller.updateSettings(),
              child: Text('UPDATE PROFILE PICTURE'),
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Short Bio',
              ),
            ),
            TextField(
              maxLines: 4, // Allow multiple lines for long bio
              decoration: InputDecoration(
                labelText: 'Long Bio',
              ),
            ),
            TextField(
              controller: controller.websiteController,
              onChanged: (value) => controller.updateWebsite(),
              decoration: InputDecoration(
                labelText: 'Website',
              ),
            ),
            TextField(
              controller: controller.emailController,
              onChanged: (value) => controller.updateEmail(),
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
       
            ElevatedButton(
  onPressed: () {
    controller.updateSettings();
    widget.onSaveChanges(startColor, endColor);
  },
  child: Text('Save Color and Changes'),
),
           
            SizedBox(height: 16.0),
            Obx(() {
              return SwitchListTile(
                title: Text('Anonymous Account'),
                value: controller.isAnonymous.value,
                onChanged: (value) {
                  controller.isAnonymous.value = value;
                },
              );
            }),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => showColorPicker(true),
                    child: Text('Start Color'),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => showColorPicker(false),
                    child: Text('End Color'),
                  ),
                ),
              ],
            ), ElevatedButton(
              onPressed: () => authController.signOut(),
              
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
