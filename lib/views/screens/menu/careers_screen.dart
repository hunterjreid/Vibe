import 'package:flutter/material.dart';

class CareersScreen extends StatelessWidget {
  void _showApplyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Apply'),
          content: Text('Please apply on the website.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Careers'),
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text('Software Engineer'),
              subtitle: Text('The Product Manager will be responsible for defining and executing product strategies, conducting market research, collaborating with cross-functional teams, and driving product innovation.'),
              trailing: ElevatedButton(
                onPressed: () {
                  _showApplyDialog(context);
                },
                child: Text('Apply'),
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Product Manager'),
              subtitle: Text('The Software Engineer will design, develop, and implement software solutions, collaborate with a team of engineers, and ensure the scalability and performance of applications.'),
              trailing: ElevatedButton(
                onPressed: () {
                  _showApplyDialog(context);
                },
                child: Text('Apply'),
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Data Analyst'),
              subtitle: Text('The Data Analyst will collect, analyze, and interpret large datasets to uncover insights, develop data models, and collaborate with stakeholders to support data-driven decision-making.'),
              trailing: ElevatedButton(
                onPressed: () {
                  _showApplyDialog(context);
                },
                child: Text('Apply'),
              ),
            ),
          ),
          // Add more job positions as needed
        ],
      ),
    );
  }
}
