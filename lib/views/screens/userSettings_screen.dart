import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe/controllers/profile_controller.dart';
import 'package:vibe/controllers/settings_controller.dart';

class UserSettingsScreen extends StatelessWidget {
  final SettingsController controller = Get.put(SettingsController());

  final ProfileController profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color.fromARGB(255, 175, 175, 175),
                    Color.fromARGB(255, 255, 255, 255),
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
            ElevatedButton(
              onPressed: () => controller.updateSettings(),
              child: Text('UPDATE PROFILE PICTURE'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: controller.usernameController,
              onChanged: (value) => controller.updateUsername(),
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: controller.bioController,
              onChanged: (value) => controller.updateBio(),
              decoration: InputDecoration(
                labelText: 'Bio',
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
              onPressed: () => controller.updateSettings(),
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
