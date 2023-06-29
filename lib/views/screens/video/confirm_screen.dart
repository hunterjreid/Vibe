import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe/controllers/upload_video_controller.dart';
import 'package:vibe/views/screens/misc/browse_songs_screen.dart';
import 'package:vibe/views/screens/video/edit_screen.dart';
import 'package:vibe/views/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';
import 'package:video_editor/video_editor.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const ConfirmScreen({
    Key? key,
    required this.videoFile,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController controller;
  final TextEditingController _songController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _longCaptionController = TextEditingController();
  final TextEditingController _shortCaptionController = TextEditingController();

  final UploadVideoController uploadVideoController = Get.put(UploadVideoController());

  VideoEditorController? _videoEditorController;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {
          controller.play();
          controller.setVolume(1);
          controller.setLooping(true);
        });
      });
  }

  @override
  void dispose() {
    controller.dispose();
    _videoEditorController?.dispose(); // Dispose the VideoEditorController as a good habit
    super.dispose();
  }

  void openVideoEditor() async {
    // Video editing

    _videoEditorController = VideoEditorController.file(
      File(widget.videoPath),
      minDuration: const Duration(seconds: 1),
      maxDuration: const Duration(seconds: 120),
    );

    await _videoEditorController!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirm Video',
          style: TextStyle(fontSize: 19, fontFamily: 'MonaSansExtraBoldWideItalic', fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditScreen(videoFile: widget.videoFile),
                ),
              );
            },
            icon: Icon(Icons.video_library),
            tooltip: 'Open Video Editor',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BrowseSongsPage(),
                ),
              );
            },
            icon: Icon(Icons.music_note),
            tooltip: 'Change Music',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextInputField(
                controller: _songController,
                labelText: 'Song',
                icon: Icons.music_note,
              ),
            ),
            Container(
              height: 400,
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _captionController,
                    decoration: InputDecoration(
                      labelText: 'Brief',
                      prefixIcon: Icon(Icons.architecture_outlined),
                    ),
                  ),
                  TextField(
                    controller: _longCaptionController,
                    decoration: InputDecoration(
                      labelText: 'Explanation',
                      prefixIcon: Icon(Icons.closed_caption),
                    ),
                  ),
                  TextField(
                    controller: _shortCaptionController,
                    decoration: InputDecoration(
                      labelText: 'Tag',
                      prefixIcon: Icon(Icons.app_shortcut_outlined),
                    ),
                  ),
                  SizedBox(height: 8),
                  Obx(() => LinearProgressIndicator(value: uploadVideoController.progress.value / 100)),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF00D2FF), Color(0xFF3A7BD5)],
                        stops: [0.0, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      onPressed: () => uploadVideoController.uploadVideo(
                        _songController.text,
                        _captionController.text,
                        _longCaptionController.text,
                        _shortCaptionController.text,
                        widget.videoPath,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        primary: Colors.transparent,
                        onPrimary: Colors.white,
                      ),
                      child: Text(
                        'Share!',
                        style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
