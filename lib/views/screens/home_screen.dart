import 'package:flutter/material.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/views/widgets/side_menu_widget.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int pageIdx = 0;
  int feedNotificationCount = 2; // Notification count for Feed
  int homeNotificationCount = 4; // Notification count for Home

  bool isDarkTheme = false;
  String selectedColorOption = 'Jet Black';
  

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color.fromARGB(255, 2, 201, 78),
    colorScheme: ColorScheme.dark(
      primary: Color.fromARGB(255, 0, 0, 0),
      onPrimary: Colors.white,
      secondary: Colors.tealAccent,
      onSecondary: Colors.black,
      background: Color.fromARGB(255, 0, 0, 0),
      onBackground: Colors.white,
      surface: Color.fromARGB(255, 0, 0, 0),
      onSurface: Colors.white,
      error: Colors.red,
      onError: Colors.black,
    ),
    // ...
  );

  final lightTheme = ThemeData(
    brightness: Brightness.light,
    
    primaryColor: Color.fromARGB(255, 201, 11, 11),
    colorScheme: ColorScheme.light(
            primary: Colors.white,

      onPrimary: Colors.black,
      secondary: Colors.teal,
      onSecondary: Colors.black,
      background: Color.fromARGB(255, 199, 199, 199),
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
          )
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
     







// appBar: AppBar(
//   centerTitle: true, // this is all you need
//   title: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Container(
//         alignment: Alignment.center,
//         child: Image.asset(
//           'assets/images/logo.png', // Replace with your logo image path
//           width: 50,
//           height: 50,
//         ),
//       ),
   
//     ],
//   ),
//   leading:    InkWell(
//         onTap: () {
//           ShowDialog.showSetColorsDialog(context, _updateColorTheme);
//         },
//         child: Icon(
//           Icons.settings,
//           // Specify the desired size and color for the icon
//           size: 24,
//         ),
//       ),
// ),



    

// AppBar(centerTitle: true, title: child: Image.asset(
//     'assets/images/logo.png', // Replace with your logo image path
//     width: 50,
//     height: 50,
//   ),
// ),)


//    appBar: AppBar(
//       centerTitle: true, // this is all you need
//   title: Center(
    
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//       Container(
//   alignment: Alignment.center,
//   child: Image.asset(
//     'assets/images/logo.png', // Replace with your logo image path
//     width: 50,
//     height: 50,
//   ),
// ),
//         InkWell(
//           onTap: () {
//             ShowDialog.showSetColorsDialog(context, _updateColorTheme);
//           },
//           child: Icon(
//             Icons.settings,
//             // Specify the desired size and color for the icon
//             size: 24,
//           ),
//         ),
//       ],
//     ),
//   ),

//   leading:    InkWell(
//         onTap: () {
//           ShowDialog.showSetColorsDialog(context, _updateColorTheme);
//         },
//         child: Icon(
//           Icons.settings,
//           // Specify the desired size and color for the icon
//           size: 24,
//         ),
//       ),




// ),




    


appBar: AppBar(
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
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
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

           drawer: MenuWidget(),

      ),
    );
  }
}

class ShowDialog {
  static void showSetColorsDialog(
      BuildContext context, Function(String) updateColorTheme) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Color Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: Text('System Detect'),
                value: 'System Detect',
                groupValue: 'System Detect',
                onChanged: (value) => updateColorTheme(value as String),
              ),
              RadioListTile(
                title: Text('Marble White'),
                value: 'Marble White',
                groupValue: 'System Detect',
                onChanged: (value) => updateColorTheme(value as String),
              ),
              RadioListTile(
                title: Text('Jet Black'),
                value: 'Jet Black',
                groupValue: 'System Detect',
                onChanged: (value) => updateColorTheme(value as String),
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
}
