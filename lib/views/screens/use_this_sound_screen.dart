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
  bool _isCameraInitialized = false;

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
    setState(() {
      _isCameraInitialized = true;
    });
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

  Widget _buildRecordButton() {
    if (!_isCameraInitialized) {
      // Show a spinner/loader while the camera is being initialized
      return CircularProgressIndicator();
    }

    return GestureDetector(
      onTap: () {
        if (_isRecording) {
          _stopRecording();
        } else {
          _startRecording();
        }
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        child: Icon(
          _isRecording ? Icons.stop : Icons.fiber_manual_record,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  void _startRecording() async {
    // Implement recording logic here
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      // Show a spinner/loader while the camera is being initialized
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Use Sound',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'MonaSansExtraBoldWideItalic',
            ),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Use Sound',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'MonaSansExtraBoldWideItalic',
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You are using song: ${widget.title}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'MonaSansExtraBoldWideItalic',
            ),
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRecordButton(),
            ],
          ),
        ],
      ),
    );
  }
}
