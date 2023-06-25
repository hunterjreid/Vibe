import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print(theme.brightness);
    final isDarkTheme = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png', // Replace with the path to your logo image
              width: 200,
              height: 200,
            ),
            SizedBox(height: 16.0),
            Text(
              'v1.0.0',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Find your vibes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'created by Hunter Reid Special mentions to Arthur, Mohammad, Rouwa',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
