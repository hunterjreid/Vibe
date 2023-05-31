import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibe/controllers/auth_controller.dart';

class SettingsController extends GetxController {
  
  final AuthController authController = Get.find<AuthController>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void updateUsername() {
    String updatedUsername = usernameController.text;
    FirebaseFirestore.instance
        .collection('users')
        .doc(authController.user.uid)
        .update({'username': updatedUsername})
        .then((_) {
      print('Username updated successfully');
    }).catchError((error) {
      print('Failed to update username: $error');
    });
  }

  void updateBio() {
    String updatedBio = bioController.text;
    FirebaseFirestore.instance
        .collection('users')
        .doc(authController.user.uid)
        .update({'bio': updatedBio})
        .then((_) {
      print('Bio updated successfully');
    }).catchError((error) {
      print('Failed to update bio: $error');
    });
  }

  void updateWebsite() {
    String updatedWebsite = websiteController.text;
    FirebaseFirestore.instance
        .collection('users')
        .doc(authController.user.uid)
        .update({'website': updatedWebsite})
        .then((_) {
      print('Website updated successfully');
    }).catchError((error) {
      print('Failed to update website: $error');
    });
  }

  void updateEmail(String value) {
    emailController.text = value;
  }

  void updateSettings() {
  updateUsername();
  updateBio();
  updateWebsite();
  updateEmail(emailController.text);
}
}
