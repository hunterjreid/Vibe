import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe/controllers/upload_video_controller.dart';
import 'package:vibe/views/screens/edit_screen.dart';
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
  TextEditingController _songController = TextEditingController();
  TextEditingController _captionController = TextEditingController();
  TextEditingController _longCaptionController = TextEditingController();
  TextEditingController _shortCaptionController = TextEditingController();
  TextEditingController _audioNameController = TextEditingController();

  UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

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
    _videoEditorController?.dispose(); // Dispose the VideoEditorController
    super.dispose();
  }

  void openVideoEditor() async {
    print("clicked");
    _videoEditorController = VideoEditorController.file(
      File(widget.videoPath),
      minDuration: const Duration(seconds: 1),
      maxDuration: const Duration(seconds: 120),
    );

    await _videoEditorController!.initialize();

    // Perform video editing operations here

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: VideoPlayer(controller),
            ),
            const SizedBox(
              height: 30,
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
                      controller: _songController,
                      labelText: 'Song Name',
                      icon: Icons.music_note,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _captionController,
                      labelText: 'Caption',
                      icon: Icons.closed_caption,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _shortCaptionController,
                      labelText: 'Short Caption',
                      icon: Icons.closed_caption,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _audioNameController,
                      labelText: 'Audio Name',
                      icon: Icons.audiotrack,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() => LinearProgressIndicator(
                      value: uploadVideoController.progress.value / 100)),
                        ElevatedButton(
                    onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditScreen(videoFile: widget.videoFile),
                  ),
                );
                    },
                    child: const Text(
                      'Open Video Editor',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
            ElevatedButton(
                    onPressed: () => uploadVideoController.uploadVideo(
                      _songController.text,
                      _captionController.text,
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
