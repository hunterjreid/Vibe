import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class RecordThisSoundScreen extends StatefulWidget {
  final String title;

  RecordThisSoundScreen({required this.title});

  @override
  _RecordThisSoundScreenState createState() => _RecordThisSoundScreenState();
}

class _RecordThisSoundScreenState extends State<RecordThisSoundScreen> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  bool _isRecording = false;

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



  Future<void> _stopRecording() async {
    if (_controller.value.isRecordingVideo) {
      try {
        await _controller.stopVideoRecording();
        setState(() {
          _isRecording = false;
        });
      } catch (e) {
        print('Error stopping recording: $e');
      }
    }
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
                  if (_isRecording) {
                    _stopRecording();
                  } 
                },
              ),
              ElevatedButton(
                child: Text('Retake'),
                onPressed: () {
                  // Handle retake logic
                },
              ),
              ElevatedButton(
                child: Text('Upload'),
                onPressed: () {
                  // Handle upload logic
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
