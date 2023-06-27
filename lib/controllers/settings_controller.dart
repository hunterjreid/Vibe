import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibe/controllers/auth_controller.dart';
import 'package:vibe/controllers/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../views/screens/app_screen.dart';

// Controller class for managing user settings and profile information
class SettingsController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final RxBool isAnonymous = false.obs;
  final Rx<Color> startColor = Colors.transparent.obs;
  final Rx<Color> endColor = Colors.transparent.obs;

  File? _pickedImage;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  // Fetches the user's profile data from Firestore and populates the controllers
  void fetchUserData() async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(authController.user!.uid).get();

    Map<String, dynamic>? userData = userSnapshot.data();
    if (userData != null) {
      usernameController.text = userData['username'] ?? '';
      bioController.text = userData['bio'] ?? '';
      websiteController.text = userData['website'] ?? '';
      emailController.text = userData['email'] ?? '';
    }
  }

  // Allows the user to pick an image from the gallery
  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _pickedImage = File(pickedImage.path);
      Get.snackbar(
        'Profile Picture',
        'You have successfully selected your profile picture!',
      );

      // Create a notification for the profile picture change
      _createNotification('Profile Picture', 'You have changed your profile picture.');

      // Upload the selected image as the profile picture
      uploadProfilePicture();

      // Navigate to the AppScreen after the profile picture upload is complete
      Get.offAll(() => const AppScreen());
    }
  }

  // Uploads the selected profile picture to Firebase Storage
  void uploadProfilePicture() async {
    if (_pickedImage != null) {
      String downloadUrl = await _uploadToStorage(_pickedImage!);

      // Update the profile photo URL in the profileController
      Get.find<ProfileController>().updateProfilePhoto(downloadUrl);

      Get.snackbar('Upload Success', 'Profile picture uploaded successfully!');

      // Create a notification for the profile picture upload
      _createNotification('Profile Picture Upload', 'Your profile picture has been uploaded successfully.');
    } else {
      Get.snackbar('Upload Error', 'Please select a profile picture first.');
    }
  }

  // Uploads the image file to Firebase Storage and returns the download URL
  Future<String> _uploadToStorage(File image) async {
    Reference ref = FirebaseStorage.instance.ref().child('profilePics').child(FirebaseAuth.instance.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  // Updates the user's profile information in Firestore
  void updateProfile() {
    String updatedUsername = usernameController.text;
    String updatedBio = bioController.text;
    String updatedWebsite = websiteController.text;
    String updatedEmail = emailController.text;
    bool updatedIsAnonymous = isAnonymous.value;

    // Get the start and end colors from the controller
    Color startColorValue = startColor.value;
    Color endColorValue = endColor.value;

    // Convert the colors to hex strings
    String startColorHex = '#${startColorValue.value.toRadixString(10).padLeft(8, '0')}';
    String endColorHex = '#${endColorValue.value.toRadixString(10).padLeft(8, '0')}';

      final ProfileController profileController = Get.put(ProfileController());

    startColorHex = startColorHex.replaceAll(RegExp(r'[^0-9]'), '');

    endColorHex = endColorHex.replaceAll(RegExp(r'[^0-9]'), '');

    // Update the colors in the profileController
    print(startColorHex + endColorHex);
    Get.find<ProfileController>().updateProfileColors(startColorHex, endColorHex);

    FirebaseFirestore.instance.collection('users').doc(authController.user!.uid).update({
      'username': updatedUsername,
      'bio': updatedBio,
      'website': updatedWebsite,
      'email': updatedEmail,
      'isAnonymous': updatedIsAnonymous,
    }).then((_) {
      print('Profile updated successfully');


    profileController.updateUserId(authController.user.uid);







      // Create a notification for the profile update
      _createNotification('Profile Update', 'Your profile information has been updated.');
    }).catchError((error) {
      print('Failed to update profile: $error');
    });
  }

  // Creates a notification for the user and adds it to Firestore
  void _createNotification(String title, String message) {
    var uid = authController.user?.uid;

    if (uid != null) {
      var notification = {
        'title': title,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      };

      FirebaseFirestore.instance.collection('users').doc(uid).collection('notifications').add(notification);
    }
  }
}
