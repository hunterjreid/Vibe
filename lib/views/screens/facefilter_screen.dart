import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FaceFilterScreen extends StatefulWidget {
  const FaceFilterScreen({Key? key}) : super(key: key);

  @override
  _FaceFilterScreenState createState() => _FaceFilterScreenState();
}

class _FaceFilterScreenState extends State<FaceFilterScreen> {
  late CameraController controller;
  Timer? _timer;
  int _secondsElapsed = 0;
  bool isRecording = false;

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        _secondsElapsed += 1;
      }),
    );
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      _secondsElapsed = 0;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RecordingCompleteScreen()),
      ).then((value) {
        isRecording = false;
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      final camera = cameras.first;
      controller = CameraController(
        camera,
        ResolutionPreset.high,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    controller.dispose();
    super.dispose();
  }


@override
Widget build(BuildContext context) {
  if (!controller.value.isInitialized) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  } else {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: CameraPreview(controller)),
          ElevatedButton(
            onPressed: () {
              if (isRecording) {
                _stopTimer();
              } else {
                _startTimer();
              }
              isRecording = !isRecording;
              setState(() {});
            },
            child: Text(isRecording ? _secondsElapsed.toString() : 'Record'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isRecording ? Colors.grey : Colors.red,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(32.0),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement cycle filter functionality here
            },
            child: const Text('Cycle Filter'),
          ),
        ],
      ),
    );
  }
}
}



class RecordingCompleteScreen extends StatelessWidget {
  const RecordingCompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recording Complete'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text('Recording has been stopped.'),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
  
              
            },
            child: const Text('Retake'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Implement upload functionality here
            },
            child: const Text('Upload'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}