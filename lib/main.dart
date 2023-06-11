import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:vibe/constants.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vibe/controllers/auth_controller.dart';
import 'package:vibe/views/screens/auth/login_screen.dart';
import 'package:vibe/views/screens/auth/signup_screen.dart';
import 'package:vibe/views/screens/appScreen.dart';
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
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vibe',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const IntroductionScreenPage()), // Add the introduction screen as the first page
        GetPage(name: '/HomeScreen', page: () => const AppScreen()),
      ],
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
    );
  }
}

class IntroductionScreenPage extends StatelessWidget {
  const IntroductionScreenPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to Vibe!",
          body: "Find your vibes",
          image: Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 300,
              height: 300,
            ),
          ),
          decoration: const PageDecoration(
            pageColor: Colors.blue,
          ),
        ),
        // Add more pages as needed
      ],
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward), // Add next icon
      nextFlex: 0, // Make next button non-flexible
      done: const Text("Done"),
      onDone: () {
   IntroductionScreenState state = context.findAncestorStateOfType<IntroductionScreenState>()!;
        state.next();
      },
      
    );
  }
}
