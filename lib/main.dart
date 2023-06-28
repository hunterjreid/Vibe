// Vibe- Find Your Vibes/ by HUNTER REID

// ██╗   ██╗██╗██████╗ ███████╗    ███████╗██╗███╗   ██╗██████╗     ██╗   ██╗ ██████╗ ██╗   ██╗██████╗     ██╗   ██╗██╗██████╗ ███████╗███████╗
// ██║   ██║██║██╔══██╗██╔════╝    ██╔════╝██║████╗  ██║██╔══██╗    ╚██╗ ██╔╝██╔═══██╗██║   ██║██╔══██╗    ██║   ██║██║██╔══██╗██╔════╝██╔════╝
// ██║   ██║██║██████╔╝█████╗      █████╗  ██║██╔██╗ ██║██║  ██║     ╚████╔╝ ██║   ██║██║   ██║██████╔╝    ██║   ██║██║██████╔╝█████╗  ███████╗
// ╚██╗ ██╔╝██║██╔══██╗██╔══╝      ██╔══╝  ██║██║╚██╗██║██║  ██║      ╚██╔╝  ██║   ██║██║   ██║██╔══██╗    ╚██╗ ██╔╝██║██╔══██╗██╔══╝  ╚════██║
//  ╚████╔╝ ██║██████╔╝███████╗    ██║     ██║██║ ╚████║██████╔╝       ██║   ╚██████╔╝╚██████╔╝██║  ██║     ╚████╔╝ ██║██████╔╝███████╗███████║
//   ╚═══╝  ╚═╝╚═════╝ ╚══════╝    ╚═╝     ╚═╝╚═╝  ╚═══╝╚═════╝        ╚═╝    ╚═════╝  ╚═════╝ ╚═╝  ╚═╝      ╚═══╝  ╚═╝╚═════╝ ╚══════╝╚══════╝
                                                                                                                                            
// ██████╗ ██╗   ██╗    ██╗  ██╗██╗   ██╗███╗   ██╗████████╗███████╗██████╗     ██████╗ ███████╗██╗██████╗                                     
// ██╔══██╗╚██╗ ██╔╝    ██║  ██║██║   ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗    ██╔══██╗██╔════╝██║██╔══██╗                                    
// ██████╔╝ ╚████╔╝     ███████║██║   ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝    ██████╔╝█████╗  ██║██║  ██║                                    
// ██╔══██╗  ╚██╔╝      ██╔══██║██║   ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗    ██╔══██╗██╔══╝  ██║██║  ██║                                    
// ██████╔╝   ██║       ██║  ██║╚██████╔╝██║ ╚████║   ██║   ███████╗██║  ██║    ██║  ██║███████╗██║██████╔╝                                    
// ╚═════╝    ╚═╝       ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚═╝╚═════╝                                     
                                                                                                                                            
// https://github.com/hunterjreid/vibe

// Vibe is a video sharing app where you can add filters and music to your videos. Inside this repo includes Andriod, iOS, and web-app files and is the master copy.
// Built 100% by Hunter Reid as a project for Yoobee Colleges CS301 lectures: Arthur, Mohammad, Rouwa, All rights resereved.

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

// Entry point of the application
Future main() async {
  // Ensure that Flutter app's bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the app is running on the web platform
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
     // Initialize Firebase and put AuthController instance into GetX dependency management
   
    await Firebase.initializeApp().then((value) {
      
      Get.put(AuthController());
    });
  }
// Run the app
  runApp(const MyApp());
}

// The root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vibe',
      initialRoute: '/',
      getPages: [
         // Define the routes/pages of the application
        GetPage(name: '/', page: () => LoginScreen()),
        GetPage(name: '/HomeScreen', page: () => const AppScreen()),
      ],
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
    );
  }
}
