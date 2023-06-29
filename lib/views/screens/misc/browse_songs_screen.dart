import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibe/views/screens/video/confirm_screen.dart';
import 'package:vibe/views/screens/profile/record_sound_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class BrowseSongsPage extends StatefulWidget {
  @override
  _BrowseSongsPageState createState() => _BrowseSongsPageState();
}


class _BrowseSongsPageState extends State<BrowseSongsPage> {
List<String> songs = [
  'sounds/epic-opener-115681.mp3',
'sounds/uplifting-summer-10356.mp3',
'sounds/funny-guy-loop-121180.mp3',
'sounds/upbeat-future-bass-138706.mp3',
   'sounds/[FREE] Future Type Beat 2021 _Big Tools_ [Prod.Onokey] (320 kbps).mp3',
'sounds/chiller-144272.mp3',
'sounds/forgotten-bird-144412.mp3',
'sounds/like-a-boss-136519.mp3',
'sounds/short-intro-music-20-30-seconds-109414.mp3',
// other songs
];

  AudioPlayer audioPlayer = AudioPlayer();
  String currentSong = '';
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        setState(() {
          currentSong = '';
          isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playSong(String songPath) async {
    try {
      String downloadUrl = await FirebaseStorage.instance.ref(songPath).getDownloadURL();
      await audioPlayer.setUrl(downloadUrl);
      audioPlayer.play();
      setState(() {
        currentSong = songPath.split('/').last.replaceAll('.mp3', '');
        isPlaying = true;
      });
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  Future<void> pauseSong() async {
    await audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  Future<void> goToUseSoundScreen(String songPath) async {
    if (isPlaying) {
      await pauseSong();
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordSoundScreen(
          title: currentSong,
          songPath: songPath,
        ),
      ),
    );
  }

  Future<void> pickVideoFromCamera(BuildContext context) async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    final video = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front, // or CameraDevice.rear for back camera
    );

    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
            videoFile: File(video.path),
            videoPath: video.path,
          ),
        ),
      );
    }
  }

  Future<void> pickVideoFromGallery(BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
            videoFile: File(video.path),
            videoPath: video.path,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentSong.isNotEmpty ? 'Playing: ' + currentSong : 'Nothing playing',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'MonaSansExtraBoldWideItalic',
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (BuildContext context, int index) {
          String songPath = songs[index];
          String songName = songPath.split('/').last.replaceAll('.mp3', '');
          return ListTile(
            title: Text(
              songName,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'MonaSans',
              ),
            ),
            onTap: () {
              if (isPlaying && currentSong == songName) {
                pauseSong();
              } else {
                playSong(songPath);
              }
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (currentSong == songName && isPlaying)
                  IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: () {
                      pauseSong();
                    },
                  )
                else
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {
                      playSong(songPath);
                    },
                  ),
                if (currentSong == songName && isPlaying)
                  ElevatedButton(
                    child: Text(
                      'Use this sound',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'MonaSansExtraBoldWideItalic',
                      ),
                    ),
                    onPressed: () {
                      goToUseSoundScreen(songPath);
                    },
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.video_call),
        onPressed: () {
          pickVideoFromCamera(context);
        },
      ),
    );
  }
}
