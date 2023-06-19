import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/models/user.dart' as model;
import 'package:vibe/views/screens/appScreen.dart';
import 'package:vibe/views/screens/auth/login_screen.dart';
import 'package:vibe/views/screens/web_app_screen.dart';

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

_setInitialScreen(User? user) {
  if (kIsWeb) {
    Get.offAll(() => WebAppScreen());
  } else {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const AppScreen());
    }
  }
}




  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Profile Picture', 'You have successfully selected your profile picture!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  // upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage.ref().child('profilePics').child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // registering the user
  void registerUser(String username, String email, String password, File? image) async {
    try {
      if (image == null) {
        Get.snackbar(
          'Error Creating Account',
          'Please select a profile picture',
        );
        return;
      }
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty && image != null) {
        // save out user to our ath and firebase firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
          name: username,
          email: email,
          uid: cred.user!.uid,
          profilePhoto: downloadUrl,
        );
        await firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

          // Send notification for successful registration
        _sendNotification('Registration Successful', 'Your account has been created successfully.');

      } else {
        Get.snackbar(
          'Error Creating Account',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Creating Account',
        e.toString(),
      );
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

           // Send notification for successful login
        _sendNotification('Login Successful', 'Welcome back!');
      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Loggin gin',
        e.toString(),
      );
    }
  }

  void signOut() async {
    await firebaseAuth.signOut();
  }


// Send a notification to the user
  void _sendNotification(String title, String message) async {
    try {
      // Add notification to the user's UID collection
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('notifications')
          .add({
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
      print('Error sending notification: $e');
    }
  }

}