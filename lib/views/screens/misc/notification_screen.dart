import 'package:flutter/material.dart';
import 'package:vibe/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = isDarkTheme == false ? lightTheme : darkTheme;

    return MaterialApp(
      theme: themeData,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Notifications',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'MonaSansExtraBoldWideItalic',
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .collection('notifications')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot> notifications = snapshot.data!.docs;
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  final title = notification['title'];
                  final message = notification['message'];

                  return ListTile(
                    title: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'MonaSansExtraBoldWideItalic',
                      ),
                    ),
                    subtitle: Text(
                      message,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'MonaSansExtraBoldWideItalic',
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error fetching notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'MonaSansExtraBoldWideItalic',
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
