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
  final TextEditingController _audioNameController = TextEditingController();

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
    _videoEditorController?.dispose(); // Dispose the VideoEditorController as good habbit
    super.dispose();
  }

  void openVideoEditor() async {
    //  video editing

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Confirm Video',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
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
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width - 20,
              child: TextInputField(
                controller: _songController,
                labelText: 'Song',
                icon: Icons.music_note,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width / 1.2,
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: VideoPlayer(controller),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _captionController,
                      labelText: 'Caption',
                      icon: Icons.closed_caption,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _longCaptionController,
                      labelText: 'Long Caption',
                      icon: Icons.closed_caption,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 30,
                    child: TextInputField(
                      controller: _shortCaptionController,
                      labelText: 'Short Caption',
                      icon: Icons.closed_caption,
                    ),
                  ),
                  Obx(() => LinearProgressIndicator(value: uploadVideoController.progress.value / 100)),
                  ElevatedButton(
                    onPressed: () => uploadVideoController.uploadVideo(
                      _songController.text,
                      _captionController.text,
                      _longCaptionController.text,
                      _shortCaptionController.text,
                      widget.videoPath,
                    ),
                    child: const Text(
                      'Share!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
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
