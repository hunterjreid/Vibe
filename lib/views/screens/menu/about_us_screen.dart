import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  void _rateApp(BuildContext context) {
    // Implement your rate app functionality here
    // For example, you can launch an external URL to a rating page
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              'assets/images/logo.png',
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
                fontFamily: 'MonaSans',
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Find your vibes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkTheme ? Colors.white : Colors.black,
                fontFamily: 'MonaSans',
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Created by Hunter Reid. Special mentions to Arthur, Mohammad, Rouwa.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDarkTheme ? Colors.white : Colors.black,
                fontFamily: 'MonaSans',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _rateApp(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MonaSans',
                ),
              ),
              child: Text('Rate App'),
            ),
          ],
        ),
      ),
    );
  }
}
