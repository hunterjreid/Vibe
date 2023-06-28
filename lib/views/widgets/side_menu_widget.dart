import 'package:flutter/material.dart';
import 'package:vibe/views/screens/menu/about_us_screen.dart';
import 'package:vibe/views/screens/menu/careers_screen.dart';
import 'package:vibe/views/screens/menu/help_screen.dart';
import 'package:vibe/views/screens/misc/settings_screen.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/menu.jpg'), // Replace with your image path
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              colorScheme.background.withOpacity(0.6),
              BlendMode.darken,
            ), 
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // DrawerHeader(
            //   decoration: BoxDecoration(),
            //   child: Text(
            //     'VIBE',
            //     style: TextStyle(
            //       fontSize: 30,
            //       color: colorScheme.onBackground,
            //       fontFamily: 'MonaSansExtraBoldWideItalic',
            //     ),
            //   ),
            // ),
              SizedBox(height: 56.0),
                 Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 16.0),
               
            buildMenuItem(
              title: 'Options',
              gradientColors: [
                colorScheme.primary,
                colorScheme.secondary,
              ],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              ),
            ),
            buildMenuItem(
              title: 'Careers',
              gradientColors: [
                colorScheme.primary,
                colorScheme.secondary,
              ],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CareersScreen(),
                ),
              ),
            ),
            buildMenuItem(
              title: 'Help',
              gradientColors: [
                colorScheme.primary,
                colorScheme.secondary,
              ],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HelpScreen(),
                ),
              ),
            ),
            buildMenuItem(
              title: 'About Us',
              gradientColors: [
                colorScheme.primary,
                colorScheme.secondary,
              ],
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
          fontSize: 30,
          fontFamily: 'MonaSansExtraBoldWideItalic',
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
