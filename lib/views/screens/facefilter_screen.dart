import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:timeago/timeago.dart';
import 'package:vibe/views/screens/home_screen.dart';
import 'package:flutter/painting.dart';

class FaceFilterScreen extends StatefulWidget {
  const FaceFilterScreen({Key? key}) : super(key: key);

  @override
  _FaceFilterScreenState createState() => _FaceFilterScreenState();
}

InputImageRotation _rotationIntToImageRotation(int rotation) {
  switch (rotation) {
    case 90:
      return InputImageRotation.rotation90deg;
    case 180:
      return InputImageRotation.rotation180deg;
    case 270:
      return InputImageRotation.rotation270deg;
    default:
      return InputImageRotation.rotation0deg;
  }
}
class _FaceFilterScreenState extends State<FaceFilterScreen> {
  FaceDetector? faceDetector;
  List<Face> detectedFaces = [];
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

  void _stopTimer() async {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      _secondsElapsed = 0;

      // Stop recording and process the video frames for face detection
      final XFile videoFile = await controller.stopVideoRecording();

      // Navigate to the recording complete screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      ).then((value) {
        isRecording = false;
        setState(() {



        });
      });
    }
  }

  void _detectFaces(CameraImage cameraImage) async {
    if (faceDetector == null) return;
    if (!mounted) return;




    final WriteBuffer allBytes = WriteBuffer();
for (Plane plane in cameraImage.planes) {
  allBytes.putUint8List(plane.bytes);
}
final bytes = allBytes.done().buffer.asUint8List();

final Size imageSize = Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

InputImageRotation imageRotation = InputImageRotation.rotation0deg;



 

final inputImageData = InputImageMetadata(
  size: imageSize,
  rotation: imageRotation,
  format: InputImageFormat.yuv420,
  bytesPerRow: cameraImage.planes[0].bytesPerRow
);

final inputImage = InputImage.fromBytes(bytes: bytes, metadata: inputImageData);





    final List<Face> faces = await faceDetector!.processImage(inputImage);

    setState(() {
      detectedFaces = faces;
    });
  }

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      final camera = cameras.first;

      controller = CameraController(
        camera,
        ResolutionPreset.medium,
      );

      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }

        setState(() {
          faceDetector = GoogleMlKit.vision.faceDetector();
          controller.startImageStream((CameraImage cameraImage) {
            if (!isRecording) {
              _detectFaces(cameraImage);
            }
          });
        });
      });
    });
  }

  @override
  void dispose() {
    
    if (_timer != null) {
      _timer!.cancel();
    }
    controller.dispose();
    faceDetector?.close();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
  return Scaffold(
    body: AspectRatio(
  aspectRatio: 9 / 16,
  child: Stack(
    children: [
      if (controller != null && controller.value.isInitialized)
        CustomPaint(
          foregroundPainter: FaceFilterPainter(detectedFaces: detectedFaces),
          child: CameraPreview(controller),
        ),
      Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          detectedFaces.isNotEmpty ? 'Face Found' : 'No face',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      Align(
      alignment: Alignment.bottomRight,
        child: ElevatedButton(
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
      ),
    ],
  ),
),
 );
}
}

class FaceFilterPainter extends CustomPainter {
  final List<Face> detectedFaces;

  FaceFilterPainter({required this.detectedFaces});

  @override
  void paint(Canvas canvas, Size size) {
    // Tint the screen red
    // final redPaint = Paint()..color = Color.fromARGB(64, 194, 9, 240);
    // canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), redPaint);

    for (final face in detectedFaces) {
      final double scaleX = size.width/2;
      final double scaleY = size.height/2;

      final Rect boundingBox = Rect.fromLTRB(
        face.boundingBox.left*scaleX,
        face.boundingBox.top*scaleY,
        face.boundingBox.right*scaleX,
        face.boundingBox.bottom*scaleY,
      );

      print(boundingBox);

   final Paint outlinePaint = Paint()
  ..color = Color.fromARGB(255, 21, 230, 108)
  ..style = PaintingStyle.stroke
  ..strokeWidth = 2.0;

// Draw a rectangle around the face with a purple outline
canvas.drawRect(
  boundingBox,
  outlinePaint,
);

      // Add your face filter graphics here
      final double faceWidth = boundingBox.width;
      final double faceHeight = boundingBox.height;

      // Example: Draw a circle on the face
      final Offset center = Offset(boundingBox.center.dx, boundingBox.center.dy);
      final double radius = faceWidth * 0.3;
      final Paint circlePaint = Paint()..color = Color.fromARGB(0, 57, 3, 206);
      canvas.drawCircle(center, radius, circlePaint);
    }
  }

  @override
  bool shouldRepaint(FaceFilterPainter oldDelegate) => true;
}
