import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vibe/constants.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vibe/controllers/auth_controller.dart';
import 'package:vibe/views/screens/appScreen.dart';
import 'package:vibe/views/screens/auth/login_screen.dart';
import 'package:vibe/views/screens/auth/signup_screen.dart';

import 'package:vibe/views/screens/video_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    Get.put(AuthController());
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyAZh_j8C_YUkXSUHqPTX6AwMc-veEirBqY",
      appId: "1:782902269864:web:629aeb7c1f08e7a2f5ef9d",
      messagingSenderId: "782902269864",
      projectId: "vibe-d9b2d",
      storageBucket: "vibe-d9b2d.appspot.com",
    ));
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
