import 'package:flutter/material.dart';

class BrowseSongsPage extends StatefulWidget {
  @override
  _BrowseSongsPageState createState() => _BrowseSongsPageState();
}

class _BrowseSongsPageState extends State<BrowseSongsPage> {

  List<String> songs = [
    'Song 1',
    'Song 2',
    'Song 3',
    // Add more songs here...
  ];


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
