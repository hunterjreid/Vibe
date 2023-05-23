import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class BrowseSongsPage extends StatefulWidget {
  @override
  _BrowseSongsPageState createState() => _BrowseSongsPageState();
}

class _BrowseSongsPageState extends State<BrowseSongsPage> {
  late AudioPlayer audioPlayer;
  List<String> songs = [
    'Song 1',
    'Song 2',
    'Song 3',
    // Add more songs here...
  ];

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Songs'),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (BuildContext context, int index) {
          String songName = songs[index];
          return ListTile(
            title: Text(songName),
            onTap: () {},
          );
        },
      ),
    );
  }
}
