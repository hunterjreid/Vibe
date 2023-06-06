import 'package:flutter/material.dart';
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
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
        
                  fontSize: 24,
                ),
              ),
            ),
            buildMenuItem(
              title: 'Settings',
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
              onTap: () {
                // Handle Career Help tap
              },
            ),
            buildMenuItem(
              title: 'Help',
              gradientColors: [Colors.purple, Colors.blue],
              onTap: () {
                // Handle Help tap
              },
            ),
            buildMenuItem(
              title: 'About Us',
              gradientColors: [Colors.purple, Colors.blue],
              onTap: () {
                // Handle About Us tap
              },
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