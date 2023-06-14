import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibe/views/screens/record_sound_screen.dart';

class BrowseSongsPage extends StatefulWidget {
  @override
  _BrowseSongsPageState createState() => _BrowseSongsPageState();
}

class _BrowseSongsPageState extends State<BrowseSongsPage> {
  List<String> songs = [
    'sounds/[FREE] 808 Mafia x Future Type Beat 2023 _Villains_ (320 kbps) (1).mp3',
    'sounds/[FREE] Future Type Beat 2021 _Big Tools_ [Prod.Onokey] (320 kbps).mp3',
    'sounds/[FREE] Future Type Beat 2022 -  A Brick.mp3',
    // Add more songs here...
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

  Future<void> goToUseSoundScreen() async {
    if (isPlaying) {
      await pauseSong();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecordSoundScreen(title: currentSong)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentSong.isNotEmpty ? currentSong : 'Nothing'),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (BuildContext context, int index) {
          String songPath = songs[index];
          String songName = songPath.split('/').last.replaceAll('.mp3', '');
          return ListTile(
            title: Text(songName),
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
                    child: Text('Use this sound'),
                    onPressed: goToUseSoundScreen,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
