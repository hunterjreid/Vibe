import 'package:flutter/material.dart';

class UseSongScreen extends StatelessWidget {
  final String albumCoverUrl = 'https://picsum.photos/400/300';
  final List<Map<String, String>> sounds = [    {      'title': 'Sound 1',      'description': 'Lorem ipsum dolor sit amet',      'url': 'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3',    },    {      'title': 'Sound 2',      'description': 'Consectetur adipiscing elit',      'url': 'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3',    },    {      'title': 'Sound 3',      'description': 'Sed do eiusmod tempor incididunt',      'url': 'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3',    },  ];

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
                onPressed: () {
                  // Handle preview sound button tap
                },
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
        ],
      ),
    );
  }
}