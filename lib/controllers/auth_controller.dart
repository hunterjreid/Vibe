// Vibe - Find your Vibe
// Architected by Hunter Reid
//
//dependencies import
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/models/user.dart' as model;
import 'package:vibe/views/screens/app_screen.dart';
import 'package:vibe/views/screens/auth/login_screen.dart';
import 'package:vibe/views/screens/desktop_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  late Rx<File?> _pickedImage = Rx<File?>(null);

  File? get profilePhoto => _pickedImage.value;
  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  // Set the initial screen based on the user's authentication state
  _setInitialScreen(User? user) {
    if (kIsWeb) {
      // If running on the web, navigate to the WebAppScreen
      Get.offAll(() => WebAppScreen());
    } else {
      if (user == null) {
        // If user is not logged in, navigate to the LoginScreen
        Get.offAll(() => LoginScreen());
      } else {
        // If user is logged in, navigate to the AppScreen
        Get.offAll(() => const AppScreen());
      }
    }
  }

  // Pick an image from the gallery
  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // Show a snackbar indicating successful image selection
      Get.snackbar('Profile Picture', 'You have successfully selected your profile picture!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  // Upload image to Firebase Storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage.ref().child('profilePics').child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // Register a new user
  void registerUser(String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        // Save the user to Firebase Authentication and Firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String downloadUrl =
            'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png';
        if (image != null) {
          // If an image is provided, upload it to Firebase Storage
          downloadUrl = await _uploadToStorage(image);
        }

        model.User user = model.User(
          name: username,
          email: email,
          uid: cred.user!.uid,
          profilePhoto: downloadUrl,
        );
        await firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

        // Send a notification for successful registration
        _sendNotification('Registration Successful', 'Your account has been created successfully.');
      } else {
        // Show a snackbar if any of the fields are empty
        Get.snackbar(
          'Error Creating Account',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      // Show a snackbar if an error occurs during registration
      Get.snackbar(
        'Error Creating Account',
        e.toString(),
      );
    }
  }

  // Log in a user
  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

        // Send a notification for successful login
        _sendNotification('Login Successful', 'Welcome back!');
      } else {
        // Show a snackbar if any of the fields are empty
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      // Show a snackbar if an error occurs during login
      Get.snackbar(
        'Error Logging in',
        e.toString(),
      );
    }
  }

  // Sign out the current user
  void signOut() async {
    await firebaseAuth.signOut();
  }

  // Send a notification to the user
  void _sendNotification(String title, String message) async {
    try {
      // Add the notification to the user's UID collection
      await firestore.collection('users').doc(firebaseAuth.currentUser!.uid).collection('notifications').add({
        'title': title,
        'message': message,
        'timestamp': DateTime.now(),
      });

      // Create a notification collection and add the notification
      await firestore.collection('notifications').add({
        'uid': firebaseAuth.currentUser!.uid,
        'title': title,
        'message': message,
        'timestamp': DateTime.now(),
      });

      // Replace this with your preferred notification implementation
      // This is just a placeholder for demonstration purposes
      print('Notification: $title - $message');
    } catch (e) {
      // Print an error message if sending the notification fails
      print('Error sending notification: $e');
    }
  }
}
