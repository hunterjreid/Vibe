
import 'package:flutter/material.dart';

import 'browsesongs_screen.dart';

class UseSongScreen extends StatelessWidget {
  final String albumCoverUrl = 'https://picsum.photos/400/300';
  final List<Map<String, String>> sounds = [
    {
      'title': 'Sound 1',
      'description': 'Lorem ipsum dolor sit amet',
      'url':
          'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3',
    },
    {
      'title': 'Sound 2',
      'description': 'Consectetur adipiscing elit',
      'url':
          'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3',
    },
    {
      'title': 'Sound 3',
      'description': 'Sed do eiusmod tempor incididunt',
      'url':
          'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(albumCoverUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sounds.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(sounds[index]['title']!),
                  subtitle: Text(sounds[index]['description']!),
                  onTap: () {
                    // Handle sound tap
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle use sound button tap
                },
                child: Text('Use Sound'),
              ),
              ElevatedButton(
                 onPressed: () {},
                child: Text('Preview Sound'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle share sound button tap
                },
                child: Text('Share Sound'),
              ),
            ],
          ),
             SizedBox(height: 16.0), // Add spacing between the ListView and the buttons
          Container(
            color: Colors.pink,
            child: ElevatedButton(
              onPressed:  () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>  BrowseSongsPage(),
                ),
              ),
              child: Text(
                'Browse Sound',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
