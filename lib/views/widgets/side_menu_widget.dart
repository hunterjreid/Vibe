import 'package:flutter/material.dart';
import 'package:vibe/views/screens/menu/about_us_screen.dart';
import 'package:vibe/views/screens/menu/careers_screen.dart';
import 'package:vibe/views/screens/menu/help_screen.dart';
import 'package:vibe/views/screens/settings_screen.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(

        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(54, 33, 149, 243),
              ),
              child: Text(
                'VIBE',
                style: TextStyle(
        
                  fontSize: 24,
                ),
              ),
            ),
            buildMenuItem(
              title: 'Options',
              gradientColors: [Colors.purple, Colors.blue],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              ),
            ),
            buildMenuItem(
              title: 'Careers',
              gradientColors: [Colors.purple, Colors.blue],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CareersScreen(),
                ),
              ),
            ),
            buildMenuItem(
              title: 'Help',
              gradientColors: [Colors.purple, Colors.blue],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HelpScreen(),
                ),
              ),
            ),
            buildMenuItem(
              title: 'About Us',
              gradientColors: [Colors.purple, Colors.blue],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AboutUsScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String title,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(

        ),
      ),
      onTap: onTap,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,

      ),
    );
  }
}