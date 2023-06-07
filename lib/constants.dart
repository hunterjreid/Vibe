import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:vibe/controllers/auth_controller.dart';
import 'package:vibe/views/screens/add_video_screen.dart';
import 'package:vibe/views/screens/feedScreen.dart';
import 'package:vibe/views/screens/home_screen.dart';
import 'package:vibe/views/screens/newLayout_screen.dart';
import 'package:vibe/views/screens/profile_screen.dart';
import 'package:vibe/views/screens/search_screen.dart';
import 'package:vibe/views/screens/video_screen.dart';

List pages = [
  FeedScreen(),
  SearchScreen(),
  AddVideoScreen(),
  ProfileScreen(uid: authController.user.uid),
  NewLayoutScreen(),

];
var darkTheme = true;

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Color.fromARGB(255, 44, 113, 179);
const borderColor = Color.fromARGB(255, 214, 40, 147);

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// CONTROLLER
var authController = AuthController.instance;
