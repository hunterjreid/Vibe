import 'dart:io';
import 'package:flutter/material.dart';

class AudioUploadScreen extends StatefulWidget {
  @override
  _AudioUploadScreenState createState() => _AudioUploadScreenState();
}

class _AudioUploadScreenState extends State<AudioUploadScreen> {
  File? _selectedFile;
  bool _useProfilePicture = false;
  String _soundTitle = '';

  void _handleFileSelection(File file) {
    setState(() {
      _selectedFile = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_selectedFile != null)
              Text(
                'Selected File: ${_selectedFile!.path}',
              ),
            SizedBox(height: 20.0),
            ListTile(
              title: Text('Upload Cover'),
              leading: Radio(
                value: false,
                groupValue: _useProfilePicture,
                onChanged: (value) {
                  setState(() {
                    _useProfilePicture = value as bool;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Use Your Profile Picture As Cover'),
              leading: Radio(
                value: true,
                groupValue: _useProfilePicture,
                onChanged: (value) {
                  setState(() {
                    _useProfilePicture = value as bool;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Title of Sound',
                ),
                onChanged: (value) {
                  setState(() {
                    _soundTitle = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle the extraction of audio from video and MP3 file upload
                // based on the selected options (_selectedFile, _useProfilePicture, _soundTitle).
              },
              child: Text('Extract and Upload from video'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle the extraction of audio from video and MP3 file upload
                // based on the selected options (_selectedFile, _useProfilePicture, _soundTitle).
              },
              child: Text('Upload mp3 file.'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AudioUploadScreen(),
  ));
}
