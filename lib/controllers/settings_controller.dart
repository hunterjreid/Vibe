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

  RxBool isAnonymous = false.obs; // Added RxBool for isAnonymous

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void fetchUserData() async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(authController.user.uid).get();

       

    Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
    if (userData != null) {
      usernameController.text = userData['username'] ?? '';
      bioController.text = userData['bio'] ?? '';
      websiteController.text = userData['website'] ?? '';
      emailController.text = userData['email'] ?? '';
    }
  }

  void updateUsername() {
    String updatedUsername = usernameController.text;
    FirebaseFirestore.instance
        .collection('users')
        .doc(authController.user.uid)
        .update({'username': updatedUsername}).then((_) {
      print('Username updated successfully');
    }).catchError((error) {
      print('Failed to update username: $error');
    });
  }

  void updateBio() {
    String updatedBio = bioController.text;
    FirebaseFirestore.instance.collection('users').doc(authController.user.uid).update({'bio': updatedBio}).then((_) {
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
        .update({'website': updatedWebsite}).then((_) {
      print('Website updated successfully');
    }).catchError((error) {
      print('Failed to update website: $error');
    });
  }

  void updateEmail() {
    String updatedEmail = emailController.text;
    // Update the email in your authentication provider here
    // Example: authController.updateEmail(updatedEmail);
    FirebaseFirestore.instance
        .collection('users')
        .doc(authController.user.uid)
        .update({'email': updatedEmail}).then((_) {
      print('Email updated successfully');
    }).catchError((error) {
      print('Failed to update email: $error');
    });
  }

  void updateSettings() {
    updateUsername();
    updateBio();
    updateWebsite();
    updateEmail();
  }
}
