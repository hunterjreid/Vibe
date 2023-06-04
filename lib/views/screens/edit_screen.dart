import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_editor/video_editor.dart';

class EditScreen extends StatefulWidget {
  final File videoFile;

  const EditScreen({Key? key, required this.videoFile}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late final VideoEditorController _controller;
  double _rotationAngle = 0.0;
  ColorFilter? _colorFilter;

  @override
  void initState() {
    super.initState();
    _controller = VideoEditorController.file(
      widget.videoFile,
      minDuration: const Duration(seconds: 1),
      maxDuration: const Duration(seconds: 10),
    );
    _controller.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _exportVideo() async {
    // Export video logic
  }

  void _trimVideo() {
    // Apply trim logic
  }

  void _rotateVideo() {
    setState(() {
      _rotationAngle += 90;
    });
  }

  void _applyColorFilter(ColorFilter? filter) {
    setState(() {
      _colorFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Screen'),
      ),
      body: _controller.initialized
          ? Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Transform.rotate(
                        angle: _rotationAngle,
                        child: CropGridViewer.preview(
                          controller: _controller,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _trimVideo,
                      child: Text('Trim'),
                    ),
                    ElevatedButton(
                      onPressed: _rotateVideo,
                      child: Text('Rotate'),
                    ),
                    ElevatedButton(
                      onPressed: () => _applyColorFilter(
                        ColorFilter.matrix(<double>[
              
                          0.393, 0.769, 0.189, 0, 0,
                          0.349, 0.686, 0.168, 0, 0,
                          0.272, 0.534, 0.131, 0, 0,
                          0, 0, 0, 1, 0,
                        ]),
                      ),
                      child: Text('Sepia Filter'),
                    ),
                    ElevatedButton(
                      onPressed: () => _applyColorFilter(null),
                      child: Text('Remove Filter'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _exportVideo,
                  child: Text('Export Video'),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
