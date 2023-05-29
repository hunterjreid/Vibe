import 'dart:io';
import 'package:flutter/material.dart';


class AudioUploadScreen extends StatefulWidget {
  @override
  _AudioUploadScreenState createState() => _AudioUploadScreenState();
}

class _AudioUploadScreenState extends State<AudioUploadScreen> {
  File? _selectedFile;


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
