import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:vibe/constants.dart';
import 'package:vibe/controllers/profile_controller.dart';
import 'package:vibe/views/screens/feed_screen.dart';
import 'package:vibe/views/widgets/side_menu_widget.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:vibe/views/screens/auth/login_screen.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int pageIdx = 0;
  int feedNotificationCount = 2; // Notification count for Feed
  int homeNotificationCount = 4; // Notification count for Home

  final ProfileController profileController = Get.put(ProfileController());

  String selectedColorOption = 'Jet Black';

  BottomNavigationBarThemeData bottomNavigationBarTheme = ThemeData().bottomNavigationBarTheme;

  @override
  void initState() {
    super.initState();

    print(authController.user.uid);
    profileController.updateUserId(authController.user.uid);
    profileController.getUserData();

    isDarkTheme = true;
    bottomNavigationBarTheme = darkTheme.bottomNavigationBarTheme.copyWith(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      selectedItemColor: Color.fromARGB(255, 0, 0, 0),
      unselectedItemColor: Color.fromARGB(255, 0, 0, 0),
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontFamily: 'MonaSansExtraBoldWideItalic',
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'MonaSans',
      ),
    );
  }

  Future<void> _setSystemTheme() async {
    final brightness = MediaQuery.of(context).platformBrightness;
    setState(() {
      isDarkTheme = brightness == Brightness.dark;
    });
  }

  void changeBody(int index) {
    setState(() {
      pageIdx = index;
    });
  }

  void _updateColorTheme(String colorOption) {
    setState(() {
      selectedColorOption = colorOption;

      if (colorOption == 'Marble White') {
        isDarkTheme = false;
        bottomNavigationBarTheme = lightTheme.bottomNavigationBarTheme.copyWith(
          backgroundColor: Color.fromRGBO(0, 0, 0, 1),
          selectedItemColor: Color.fromARGB(255, 255, 255, 255),
          unselectedItemColor: Color.fromARGB(255, 255, 255, 255),
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: 'MonaSansExtraBoldWideItalic',
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'MonaSans',
          ),
        );
      } else if (colorOption == 'Jet Black') {
        isDarkTheme = true;
        bottomNavigationBarTheme = darkTheme.bottomNavigationBarTheme.copyWith(
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          selectedItemColor: Color.fromARGB(255, 0, 0, 0),
          unselectedItemColor: Color.fromARGB(255, 0, 0, 0),
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: 'MonaSansExtraBoldWideItalic',
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'MonaSans',
          ),
        );
      } else if (colorOption == 'System Detect') {
        _setSystemTheme().then((_) {
          bottomNavigationBarTheme = Theme.of(context).bottomNavigationBarTheme;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = isDarkTheme ? darkTheme : lightTheme;

    return Theme(
      data: currentTheme,
      child: Scaffold(
        appBar: pageIdx == 1 || pageIdx == 2
            ? null
            : AppBar(
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png', // Replace with your logo image path
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      ShowDialog.showSetColorsDialog(context, _updateColorTheme);
                    },
                    icon: Icon(
                      Icons.settings,
                      size: 24,
                    ),
                  ),
                ],
              ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: bottomNavigationBarTheme.selectedItemColor,
          ),
          padding: EdgeInsets.fromLTRB(10, 3, 10, 7),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            child: BottomNavigationBar(
              backgroundColor: bottomNavigationBarTheme.backgroundColor,
              selectedItemColor: bottomNavigationBarTheme.selectedItemColor,
              unselectedItemColor: bottomNavigationBarTheme.unselectedItemColor,
              selectedLabelStyle: bottomNavigationBarTheme.selectedLabelStyle,
              unselectedLabelStyle: bottomNavigationBarTheme.unselectedLabelStyle,
              currentIndex: pageIdx,
              onTap: (index) {
                setState(() {
                  pageIdx = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      Icon(
                        Iconsax.video_square,
                        size: 38, // Adjust the icon size here
                      ),
                      if (feedNotificationCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 245, 34, 19),
                            ),
                            child: Text(
                              feedNotificationCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  label: 'Feed',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      Icon(
                        Iconsax.home_2,
                        size: 38, // Adjust the icon size here
                      ),
                      if (homeNotificationCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 245, 34, 19),
                            ),
                            child: Text(
                              homeNotificationCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Iconsax.colors_square,
                    size: 38, // Adjust the icon size here
                  ),
                  label: 'Create',
                ),
              ],
            ),
          ),
        ),
        body: pages[pageIdx],
        drawer: MenuWidget(),
      ),
    );
  }
}

class ShowDialog {
  static void showSetColorsDialog(BuildContext context, Function(String) updateColorTheme) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'By defualt it will Automatically detect system theme',
                style: TextStyle(fontSize: 14),
              ),
              // SizedBox(height: 8),
              // ElevatedButton(
              //   onPressed: () => updateColorTheme('System Detect'),
              //   style: ButtonStyle(
              //     backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              //     minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(48)),
              //   ),
              //   child: Text('Detect Theme', style: TextStyle(fontSize: 16)),
              // ),
              // SizedBox(height: 16),
              Text(
                'Select Color Theme',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => updateColorTheme('Marble White'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 0, 0, 0)),
                  foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 255, 255, 255)),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MonaSansExtraBoldWideItalic',
                    ),
                  ),
                ),
                child: Text('Marble Theme'),
              ),
              ElevatedButton(
                onPressed: () => updateColorTheme('Jet Black'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 255, 255, 255)),
                  foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 15, 15, 15)),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MonaSansExtraBoldWideItalic',
                    ),
                  ),
                ),
                child: Text('Jet Theme'),
              ),
              SizedBox(height: 16),
              Text(
                'You can also Alter the Search Algorithm',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Handle educational class selection
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 42, 186, 230)),
                  minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(48)),
                ),
                child: Text('Educational Only', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  FeedScreen? feedScreen = context.findAncestorWidgetOfExactType<FeedScreen>();
                  if (feedScreen != null) {
                    feedScreen.refreshVideos();
                  }
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 189, 189, 189)),
                  minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(48)),
                ),
                child: Text('Mixed', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                  minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(48)),
                ),
                child: Text('Entertainment Only', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  static void showClassDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Choose one:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
