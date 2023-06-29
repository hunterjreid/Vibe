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
    _expandedList = List<bool>.generate(16, (_) => false); // Adjust the count based on the number of FAQs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0), // Adding padding around the container
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
            _buildFAQItem(1, '🎵 What can users upload to Vibe?',
                'Users can upload their favorite music 🎵 and quick videos 📹 to express themselves and show off their creativity.'),
            _buildFAQItem(2, '🤝 How can Vibe foster a tight-knit community?',
                'Vibe aims to create a super chill community where users can interact, collaborate on cool projects, and connect with others who share similar interests and hobbies.'),
            _buildFAQItem(3, '✨ What makes Vibe stand out?',
                'Vibe has some awesome features! You can upload music and quick videos, dive into creative endeavors, and meet like-minded folks who are all about good vibes.'),
            _buildFAQItem(4, '🔒 How does Vibe keep things secure?',
                'Vibe takes security seriously! They use the latest tech, like cloud computing ☁️ and top-notch cybersecurity measures, to make sure your experience on the platform is safe and reliable.'),
            _buildFAQItem(5, '👥 Can users connect with others on Vibe?',
                'Absolutely! Vibe allows users to connect with like-minded peeps who share their hobbies and interests. Get ready to meet new people and collaborate on exciting projects!'),
            _buildFAQItem(6, '🌟 What are the potential effects of using Vibe?',
                'Using Vibe can have some seriously positive effects! It brings together individuals from different backgrounds, inspires creativity ✨, and gives you fresh and exciting ways to express yourself.'),
            _buildFAQItem(7, '📱 Is Vibe accessible on all devices?',
                'You bet! Vibe is designed to work seamlessly on smartphones 📱, tablets 📚, and computers 💻. So, you can engage with the platform anytime, anywhere.'),
            _buildFAQItem(8, '💰 Can users make money from their content on Vibe?',
                'Absolutely! Vibe offers various opportunities for users to monetize their content. You can score sponsored collaborations, advertising partnerships, and even sell some dope merch! 💸'),
            _buildFAQItem(9, '🔍 How can users discover new content on Vibe?',
                'Discovering new content on Vibe is a breeze! With personalized recommendations, trending sections, and user-curated playlists, you\'ll never run out of awesome stuff to explore.'),
            _buildFAQItem(10, '❓ Got more questions?',
                'If you have any more questions or need help, don\'t hesitate to reach out! The Vibe team is here to assist you and ensure you have the best experience on the platform. 🙌'),
            _buildFAQItem(11, '👍 Can I like and comment on posts?',
                'Absolutely! Show some love ❤️ by liking and leaving comments on posts that resonate with you. It\'s all about spreading positive vibes and connecting with fellow Vibe users.'),
            _buildFAQItem(12, '🚀 Can I promote my creative projects on Vibe?',
                'Definitely! Vibe is the perfect platform to promote your creative projects. Whether it\'s your music, artwork, or short films, share your passion and get the recognition you deserve.'),
            _buildFAQItem(13, '🌐 Is Vibe available worldwide?',
                'Absolutely! Vibe is a global community that welcomes users from all around the world. No matter where you\'re from, you can join in and be part of the awesome Vibe.'),
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
        borderRadius: BorderRadius.circular(8.0), // Adding border radius
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
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adding padding below the text
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
