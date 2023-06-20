import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class RecordSoundScreen extends StatefulWidget {
  final String title;
  final String songPath;

  RecordSoundScreen({required this.title, required this.songPath});

  @override
  _RecordSoundScreenState createState() => _RecordSoundScreenState();
}

class _RecordSoundScreenState extends State<RecordSoundScreen> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  bool _isRecording = false;
  late String _outputFilePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.high);
    await _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Use Sound'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You are using song: ${widget.title}',
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: _isRecording ? Text('Stop Recording') : Text('Record'),
                onPressed: () {
                
                },
              ),
              ElevatedButton(
                child: Text('Retake'),
                onPressed: () {},
              ),
              ElevatedButton(
                child: Text('Upload'),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
