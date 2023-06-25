import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vibe/constants.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vibe/controllers/auth_controller.dart';
import 'package:vibe/views/screens/app_screen.dart';
import 'package:vibe/views/screens/auth/login_screen.dart';
import 'package:vibe/views/screens/auth/signup_screen.dart';
import 'package:vibe/views/screens/desktop_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    Get.put(AuthController());
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDGysXqovYjblg9Rd08bSod0l3dXo47lbQ",
            authDomain: "vibe-3926d.firebaseapp.com",
            projectId: "vibe-3926d",
            storageBucket: "vibe-3926d.appspot.com",
            messagingSenderId: "569358034431",
            appId: "1:569358034431:web:e5e53a86b84e8bf36ab3ca",
            measurementId: "G-DG0Z0EJJR6"));
  } else {
    await Firebase.initializeApp().then((value) {
      Get.put(AuthController());
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vibe',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => LoginScreen()),
        GetPage(name: '/HomeScreen', page: () => const AppScreen()),
      ],
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
    );
  }
}
