// ------------------------------
//  Hunter Reid 2023 ⓒ
//  Vibe Find your Vibes
//
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
    _expandedList = List<bool>.generate(16, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 16.0),
                Text(
                  'FAQ',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MonaSans',
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Here are some frequently asked questions for Vibe.',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'MonaSans',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // FAQs
            _buildFAQItem(1, '🎵  What kind of content can I upload to Vibe?',
                'You can upload your favorite music and quick videos to express yourself and showcase your creativity.'),
            _buildFAQItem(2, '🤝 How does Vibe create a strong community?',
                'Vibe aims to build a tight-knit community where users can interact, collaborate on cool projects, and connect with like-minded people who share similar interests and hobbies.'),
            _buildFAQItem(3, '✨ What makes Vibe unique?',
                'Vibe has some awesome features! You can upload music and quick videos, dive into creative endeavors, and meet like-minded folks who are all about good vibes.'),
            _buildFAQItem(4, '🔒 How does Vibe ensure security?',
                'Vibe takes security seriously! They utilize advanced technology, including cloud computing and top-notch cybersecurity measures, to ensure a safe and reliable experience on the platform.'),
            _buildFAQItem(5, '👥 Can I connect with others on Vibe?',
                'Absolutely! Vibe allows users to connect with like-minded individuals who share their hobbies and interests. Get ready to meet new people and collaborate on exciting projects!'),
            _buildFAQItem(6, '🌟 What are the potential effects of using Vibe?',
                'Using Vibe can have some seriously positive effects! It brings together individuals from different backgrounds, inspires creativity ✨, and gives you fresh and exciting ways to express yourself.'),
            _buildFAQItem(7, '📱 Is Vibe accessible on all devices?',
                'You bet! Vibe is designed to work seamlessly on smartphones 📱, tablets 📚, and computers 💻. So, you can engage with the platform anytime, anywhere.'),
            _buildFAQItem(8, '💰 Can I monetize my content on Vibe?',
                'If you have more questions or need help, feel free to reach out! The Vibe team is here to assist you and ensure you have the best experience on the platform.'),
            _buildFAQItem(9, '🔍 How can users discover new content on Vibe?',
                'Discovering new content on Vibe is a breeze! With personalized recommendations, trending sections, and user-curated playlists, you\'ll never run out of awesome stuff to explore.'),
            _buildFAQItem(10, '❓ Got more questions?',
                'If you have any more questions or need help, don\'t hesitate to reach out! The Vibe team is here to assist you and ensure you have the best experience on the platform. 🙌'),
            _buildFAQItem(11, '👍 Can I like and comment on posts?',
                'Show some love ❤️ by liking and leaving comments on posts that resonate with you. It\'s all about spreading positive vibes and connecting with fellow Vibe users.'),
            _buildFAQItem(12, '🚀 Can I promote my creative projects on Vibe?',
                'Vibe is the perfect platform to promote your creative projects. Whether it\'s your music, artwork, or short films, share your passion and get the recognition you deserve.'),
            _buildFAQItem(13, '🌐 Is Vibe available worldwide?',
                'Vibe is a global community that welcomes users from all around the world. No matter where you\'re from, you can join in and be part of the awesome Vibe.'),
            _buildFAQItem(14, '🔔 How can I stay updated with the latest on Vibe?',
                'Don\'t miss out on the latest happenings on Vibe! Stay in the loop by following their social media channels, subscribing to newsletters, and checking out their blog for exciting updates. 📢')
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(int index, String question, String answer) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
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
                    fontFamily: 'MonaSans',
                    fontSize: 18,
                  ),
                ),
              );
            },
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'MonaSans',
                ),
              ),
            ),
            isExpanded: _expandedList[index],
          ),
        ],
      ),
    );
  }
}
