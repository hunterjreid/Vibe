import 'package:flutter/material.dart';

class CareersScreen extends StatelessWidget {
  void _showApplyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Apply'),
          content: Text('Sure, you can apply on our website.'),
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
              leading: Image.asset(
                'assets/images/logo.png',
                width: 50,
                height: 50,
              ),
              title: Text('Software Engineer'),
              subtitle: Text(
                'As a Software Engineer, you\'ll have the opportunity to design, develop, and implement software solutions. You\'ll collaborate with a team of talented engineers and contribute to building innovative applications that make a real impact.',
                style: TextStyle(
                  fontFamily: 'MonaSansExtraBoldWideItalic',
                ),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlueAccent, Colors.purple],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _showApplyDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent, // Set the button background color to transparent
                    elevation: 0, // Remove button elevation
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.blue), // Apply blue border color
                    ),
                  ),
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MonaSansExtraBoldWideItalic',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Image.asset(
                'assets/images/logo.png',
                width: 50,
                height: 50,
              ),
              title: Text('Content Manager'),
              subtitle: Text(
                'Are you passionate about driving product innovation? As a Content Manager, you\'ll define and execute market strategies, conduct market research, and collaborate with cross-functional teams. Join us and help shape the future of our products!',
                style: TextStyle(
                  fontFamily: 'MonaSansExtraBoldWideItalic',
                ),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlueAccent, Colors.purple],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _showApplyDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.blue),
                    ),
                  ),
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MonaSansExtraBoldWideItalic',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Image.asset(
                'assets/images/logo.png',
                width: 50,
                height: 50,
              ),
              title: Text('Data Analyst'),
              subtitle: Text(
                'Love working with data? Join our team as a Data Analyst, where you\'ll collect, analyze, and interpret large datasets to uncover valuable insights. Your work will directly contribute to data-driven decision-making and support our organization in achieving its goals.',
                style: TextStyle(
                  fontFamily: 'MonaSansExtraBoldWideItalic',
                ),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlueAccent, Colors.purple],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _showApplyDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.blue),
                    ),
                  ),
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MonaSansExtraBoldWideItalic',
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Add more job positions as needed
          Card(
            child: ListTile(
              leading: Image.asset(
                'assets/images/logo.png',
                width: 50,
                height: 50,
              ),
              title: Text('Job Title'),
              subtitle: Text(
                'Job description goes here...',
                style: TextStyle(
                  fontFamily: 'MonaSansExtraBoldWideItalic',
                ),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlueAccent, Colors.purple],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _showApplyDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.blue),
                    ),
                  ),
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MonaSansExtraBoldWideItalic',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}







