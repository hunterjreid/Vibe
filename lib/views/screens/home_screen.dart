import 'package:flutter/material.dart';
import 'package:vibe/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 0;
  int feedNotificationCount = 2; // Notification count for Feed
  int homeNotificationCount = 4; // Notification count for Home

  bool isDarkTheme = false;
  String selectedColorOption = 'System Detect';

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[900],
    colorScheme: ColorScheme.dark(
      primary: Color.fromARGB(255, 0, 0, 0),
      onPrimary: Colors.white,
      secondary: Colors.tealAccent,
      onSecondary: Colors.black,
      background: Color.fromARGB(255, 0, 0, 0),
      onBackground: Colors.white,
      surface: Colors.grey,
      onSurface: Colors.white,
      error: Colors.red,
      onError: Colors.black,
    ),
    // ...
  );

  final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Colors.white,
      onPrimary: Colors.black,
      secondary: Colors.teal,
      onSecondary: Colors.black,
      background: Colors.white,
      onBackground: Colors.black,
      surface: Colors.grey,
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.black,
    ),
    // ...
  );

  BottomNavigationBarThemeData bottomNavigationBarTheme =
      ThemeData().bottomNavigationBarTheme;

  @override
  void initState() {
    super.initState();
    _setSystemTheme();
  }

  Future<void> _setSystemTheme() async {
    final brightness = MediaQuery.of(context).platformBrightness;
    setState(() {
      isDarkTheme = brightness == Brightness.dark;
    });
  }

  void _updateColorTheme(String colorOption) {
    setState(() {
      selectedColorOption = colorOption;

      if (colorOption == 'Marble White') {
        isDarkTheme = false;
        bottomNavigationBarTheme =
            lightTheme.bottomNavigationBarTheme.copyWith(
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
        bottomNavigationBarTheme =
            darkTheme.bottomNavigationBarTheme.copyWith(
          backgroundColor: Color.fromRGBO(253, 252, 252, 1),
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
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                        Icons.animation_rounded,
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
                        Icons.home,
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
                    Icons.create,
                    size: 38, // Adjust the icon size here
                  ),
                  label: 'Create',
                ),
              ],
            ),
          ),
        ),
        body: pages[pageIdx],
        appBar: AppBar(
          title: Text('Change Color Theme'),
          backgroundColor: currentTheme.primaryColor,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Set Colors'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        'Marble White',
                        style: TextStyle(
                          fontWeight: selectedColorOption == 'Marble White'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        _updateColorTheme('Marble White');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Jet Black',
                        style: TextStyle(
                          fontWeight: selectedColorOption == 'Jet Black'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        _updateColorTheme('Jet Black');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text(
                        'System Detect',
                        style: TextStyle(
                          fontWeight: selectedColorOption == 'System Detect'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        _setSystemTheme().then((_) {
                          _updateColorTheme('System Detect');
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: Icon(Icons.color_lens),
          backgroundColor: currentTheme.colorScheme.secondary,
        ),
      ),
    );
  }
}
