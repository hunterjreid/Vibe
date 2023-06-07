import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('FAQ 1'),
            subtitle: Text('Answer to FAQ 1'),
          ),
          ListTile(
            title: Text('FAQ 2'),
            subtitle: Text('Answer to FAQ 2'),
          ),
          // Add more FAQs as needed
        ],
      ),
    );
  }
}
