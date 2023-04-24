import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibe/controller/auth_controller.dart';

const backgroundColor = Colors.black;
var buttonColor = Color.fromARGB(255, 44, 113, 179);
const borderColor = Color.fromARGB(255, 214, 40, 147);

var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

//controller
var authController = AuthController.instance;