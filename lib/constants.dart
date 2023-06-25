import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:vibe/controllers/auth_controller.dart';
import 'package:vibe/views/screens/create_screen.dart';
import 'package:vibe/views/screens/feed_screen.dart';
import 'package:vibe/views/screens/app_screen.dart';
import 'package:vibe/views/screens/home_screen.dart';

import 'package:vibe/views/screens/profile/profile_screen.dart';

import 'package:vibe/views/screens/profile/user_screen.dart';

List pages = [
  FeedScreen(),
  HomeScreen(),
  const UserScreen(),
];

bool isDarkTheme = true;

//  VIBE KEY COLORS !
const Color backgroundColor = Colors.black;
const Color buttonColor = Color.fromARGB(255, 44, 113, 179);
const Color borderColor = Color.fromARGB(255, 214, 40, 147);

// THEMES
ThemeData get lightTheme => ThemeData(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Colors.white,
        onPrimary: Colors.black,
        secondary: borderColor,
        onSecondary: Colors.black,
        background: Color.fromARGB(255, 199, 199, 199),
        onBackground: Colors.black,
        surface: Color.fromARGB(255, 0, 0, 0),
        onSurface: Colors.black,
        error: Colors.red,
        onError: Colors.black,
      ),
    );

ThemeData get darkTheme => ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color.fromARGB(255, 0, 0, 0),
        onPrimary: Colors.white,
        secondary: borderColor,
        onSecondary: Colors.black,
        background: Color.fromARGB(255, 0, 0, 0),
        onBackground: Colors.white,
        surface: Color.fromARGB(255, 0, 0, 0),
        onSurface: Colors.white,
        error: Colors.red,
        onError: Colors.black,
      ),
    );

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// CONTROLLER
var authController = AuthController.instance;
