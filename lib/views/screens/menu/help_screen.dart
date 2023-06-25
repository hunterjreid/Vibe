import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  late List<bool> _expandedList;

  @override
  void initState() {
    super.initState();
    _expandedList = List<bool>.generate(10, (_) => false); // Adjust the count based on the number of FAQs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: ListView(
        children: [
          _buildFAQItem(1, 'What can users upload to Vibe?',
              'Users can upload music and quick videos to express themselves and convey their creativity.'),
          _buildFAQItem(2, 'How can Vibe foster a fraternal community?',
              'Vibe aims to foster a fraternal community by providing a platform where users can interact, collaborate on projects, and engage with others who share similar interests and hobbies.'),
          _buildFAQItem(3, 'What are the distinctive features of Vibe?',
              'Vibe offers several distinctive features, such as the ability to upload music and quick videos, participate in creative endeavors, and meet like-minded individuals.'),
          _buildFAQItem(4, 'How does Vibe ensure security?',
              'Vibe incorporates modern technologies like cloud computing and cybersecurity measures to build a strong, reliable, and secure social networking platform.'),
          _buildFAQItem(5, 'Can users connect with others on Vibe?',
              'Yes, Vibe enables users to connect with others who have similar hobbies and interests, providing an opportunity to meet new people and collaborate on projects.'),
          _buildFAQItem(6, 'What are the potential effects of using Vibe?',
              'Using Vibe can have positive effects, such as uniting individuals from different backgrounds, inspiring creativity, and providing fresh and exciting ways to express oneself.'),
          _buildFAQItem(7, 'Is Vibe accessible to all devices?',
              'Yes, Vibe is designed to be accessible on various devices, including smartphones, tablets, and computers, allowing users to engage with the platform anytime and anywhere.'),
          _buildFAQItem(8, 'Can users monetize their content on Vibe?',
              'Vibe provides opportunities for users to monetize their content through various means, such as sponsored collaborations, advertising partnerships, and merchandise sales.'),
          _buildFAQItem(9, 'How can users discover new content on Vibe?',
              'Vibe offers features like personalized recommendations, trending sections, and user-curated playlists, allowing users to discover new and exciting content within the community.')
        ],
      ),
    );
  }

  Widget _buildFAQItem(int index, String question, String answer) {
    return Card(
      child: ExpansionPanelList(
        elevation: 2,
        expansionCallback: (int panelIndex, bool isExpanded) {
          setState(() {
            _expandedList[index] = !isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  question,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                answer,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            isExpanded: _expandedList[index],
          ),
        ],
      ),
    );
  }
}
