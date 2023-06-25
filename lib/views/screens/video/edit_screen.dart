import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_editor/video_editor.dart';
import 'package:video_player/video_player.dart';

class EditScreen extends StatefulWidget {
  final File videoFile;

  const EditScreen({Key? key, required this.videoFile}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> with WidgetsBindingObserver {
  late final VideoPlayerController _controller;
  double _rotationAngle = 0.0;
  ColorFilter? _colorFilter;
  bool _isExporting = false;
  double _currentVideoPosition = 0.0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        _autoplayVideo();
        _controller.addListener(_onVideoPositionChanged); // Add listener for position updates
      });

    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  void _exportVideo() async {
    if (!_isExporting) {
      setState(() {
        _isExporting = true;
      });

      setState(() {
        _isExporting = false;
      });
    }
  }

  void _trimVideo() async {
    TextEditingController startController = TextEditingController();
    TextEditingController endController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Trim Video'),
          content: Column(
            children: [
              TextField(
                controller: startController,
                decoration: InputDecoration(labelText: 'Start Time'),
              ),
              TextField(
                controller: endController,
                decoration: InputDecoration(labelText: 'End Time'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Retrieve start and end time values
                String start = startController.text;
                String end = endController.text;

                // Apply trim logic using the start and end time values
                // ...

                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _changeSounds() {
    // Add logic to change sounds
    // ...
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

  void _onVideoPositionChanged() {
    setState(() {
      _currentVideoPosition = _controller.value.position.inSeconds.toDouble();
    });
  }

  void _autoplayVideo() {
    if (_controller.value.isInitialized) {
      _controller.play();
    }
  }

  void _pauseVideo() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    }
  }

  void _seekToPosition(double position) {
    setState(() {
      _currentVideoPosition = position;
      _controller.seekTo(Duration(seconds: position.toInt()));
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _autoplayVideo();
    } else if (state == AppLifecycleState.paused) {
      _controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Screen'),
      ),
      body: _controller.value.isInitialized
          ? Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ListView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: Transform.rotate(
                              angle: _rotationAngle,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: _autoplayVideo,
                              icon: Icon(Icons.play_arrow),
                            ),
                            IconButton(
                              onPressed: _pauseVideo,
                              icon: Icon(Icons.pause),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Slider(
                  min: 0.0,
                  max: _controller.value.duration!.inSeconds.toDouble(),
                  value: _currentVideoPosition,
                  onChanged: _seekToPosition,
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
                          0.393,
                          0.769,
                          0.189,
                          0,
                          0,
                          0.349,
                          0.686,
                          0.168,
                          0,
                          0,
                          0.272,
                          0.534,
                          0.131,
                          0,
                          0,
                          0,
                          0,
                          0,
                          1,
                          0,
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
                  onPressed: _isExporting ? null : _exportVideo,
                  child: _isExporting ? CircularProgressIndicator() : Text('Export Video'),
                ),
                ElevatedButton(
                  onPressed: _changeSounds,
                  child: Text('Change Sounds'),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
