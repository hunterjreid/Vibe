import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/models/user.dart' as model;
import 'package:vibe/views/screens/auth/login_screen.dart';
import 'package:vibe/views/screens/appScreen.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => AppScreen());
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

  // registering the user with email and password
  void registerUser(String username, String email, String password, File? image, String birthday) async {
    try {
      if (image == null) {
        Get.snackbar(
          'Error Creating Account',
          'Please select a profile picture',
        );
        return;
      }
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty && image != null) {
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
          website: '',
          birthday: birthday,
          bio: '',
        );
        await firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
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

  // registering the user with Google authentication
  Future<void> registerUserWithGoogle(
    String username,
    String email,
    String password,
    File? image,
  ) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        Get.snackbar(
          'Error Creating Account',
          'Failed to sign in with Google',
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.additionalUserInfo?.isNewUser == true) {
        User? user = userCredential.user;

        if (user != null) {
          String? downloadUrl = '';
          if (image != null) {
            downloadUrl = await _uploadToStorage(image);
          }

          model.User newUser = model.User(
            name: username,
            email: email,
            uid: user.uid,
            profilePhoto: downloadUrl ?? '',
            website: '',
            birthday: '',
            bio: '',
          );

          await firestore.collection('users').doc(user.uid).set(newUser.toJson());
        }
      }

      Get.offAll(() => AppScreen());
    } catch (e) {
      Get.snackbar(
        'Error Creating Account',
        e.toString(),
      );
    }
  }

  // registering the user with Facebook authentication
  Future<void> registerUserWithFacebook(
    String username,
    String email,
    String password,
    File? image,
  ) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status != LoginStatus.success) {
        Get.snackbar(
          'Error Creating Account',
          'Failed to sign in with Facebook',
        );
        return;
      }

      final AccessToken accessToken = result.accessToken!;
      final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.token);

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.additionalUserInfo?.isNewUser == true) {
        User? user = userCredential.user;

        if (user != null) {
          String? downloadUrl = '';
          if (image != null) {
            downloadUrl = await _uploadToStorage(image);
          }

          model.User newUser = model.User(
            name: username,
            email: email,
            uid: user.uid,
            profilePhoto: downloadUrl ?? '',
            website: '',
            birthday: '',
            bio: '',
          );

          await firestore.collection('users').doc(user.uid).set(newUser.toJson());
        }
      }

      Get.offAll(() => AppScreen());
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
      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Logging in',
        e.toString(),
      );
    }
  }

  void signOut() async {
    await firebaseAuth.signOut();
  }
}
