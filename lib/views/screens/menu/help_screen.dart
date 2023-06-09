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
    _expandedList = List<bool>.generate(6, (_) => false); // Adjust the count based on the number of FAQs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: ListView(
        children: [
          _buildFAQItem(0, 'FAQ 1', 'Answer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQ 1'),
          _buildFAQItem(1, 'FAQ 2',
              'Answer to FAAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQQ 2'),
          _buildFAQItem(2, 'FAQ 3', 'Answer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQ 1'),
          _buildFAQItem(3, 'FAQ 2',
              'Answer to FAAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQQ 2'),
          _buildFAQItem(4, 'FAQ 5', 'Answer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQ 1'),
          _buildFAQItem(5, 'FAQ 6',
              'Answer to FAAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQAnswer to FAQQ 2'),
          // Add more FAQs as needed
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
