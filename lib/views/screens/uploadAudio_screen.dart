import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AudioUploadScreen extends StatefulWidget {
  @override
  _AudioUploadScreenState createState() => _AudioUploadScreenState();
}

class _AudioUploadScreenState extends State<AudioUploadScreen> {
  File? _selectedFile;

  Future<void> _openFileExplorer() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        setState(() {
          _selectedFile = file;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
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
            ElevatedButton(
              onPressed: _openFileExplorer,
              child: Text('Select Audio'),
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
