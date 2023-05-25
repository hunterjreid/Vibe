import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController _usernameController = TextEditingController();
  String _username = 'JohnDoe'; // Initial username
  

  @override
  void initState() {
    super.initState();
    _usernameController.text = _username;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _updateUsername() {
    setState(() {
      _username = _usernameController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
                TextField(
    
              decoration: InputDecoration(
                labelText: 'Bio',
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateUsername,
              child: Text('Save'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Current Username: $_username',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
           
          ],
        ),
      ),
    );
  }
}
