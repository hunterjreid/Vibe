import 'package:flutter/material.dart';

class CareersScreen extends StatelessWidget {
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
                  // Apply button functionality
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
                  // Apply button functionality
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
