import 'package:flutter/material.dart';

class CareersScreen extends StatelessWidget {
  void _showApplyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Apply'),
          content: Text('Please apply on the website.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Careers'),
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text('Job Position 1'),
              subtitle: Text('Job description for Position 1'),
              trailing: ElevatedButton(
                onPressed: () {
                  _showApplyDialog(context);
                },
                child: Text('Apply'),
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Job Position 2'),
              subtitle: Text('Job description for Position 2'),
              trailing: ElevatedButton(
                onPressed: () {
                  _showApplyDialog(context);
                },
                child: Text('Apply'),
              ),
            ),
          ),
          // Add more job positions as needed
        ],
      ),
    );
  }
}
