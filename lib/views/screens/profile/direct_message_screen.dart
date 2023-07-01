// ------------------------------
//  Hunter Reid 2023 ⓒ
//  Vibe Find your Vibes
//
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DirectMessageScreen extends StatefulWidget {
  final String recipientUID;
  final String senderUID;

  DirectMessageScreen({required this.recipientUID, required this.senderUID});

  @override
  _DirectMessageScreenState createState() => _DirectMessageScreenState();
}

class _DirectMessageScreenState extends State<DirectMessageScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference dmCollection(String uid) {
    if (auth.currentUser != null) {
      final idPair = [widget.recipientUID, widget.senderUID].toList()..sort();
      final collectionID = idPair.join('_');
      return firestore.collection('dms').doc(collectionID).collection('messages');
    }
    throw FirebaseAuthException(message: 'User not authenticated', code: '');
  }

  TextEditingController _textEditingController = TextEditingController(); // Controller for the input field

  @override
  void dispose() {
    _textEditingController.dispose(); // Dispose the controller when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: firestore.collection('users').doc(widget.recipientUID).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              final userName = userData['name'] as String;
              return Text('Chat with ' + userName,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'MonaSansExtraBoldWideItalic',
                  ));
            } else {
              return Text('Loading DM...',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'MonaSansExtraBoldWideItalic',
                  ));
            }
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: dmCollection(widget.recipientUID).orderBy('sent', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final List<DocumentSnapshot> messages = snapshot.data?.docs ?? [];

                  return ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index].data() as Map<String, dynamic>;

                      return Align(
                        alignment: message['from'] == auth.currentUser!.uid ? Alignment.topRight : Alignment.topLeft,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: message['from'] == auth.currentUser!.uid ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            message['text'] as String,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'MonaSansExtraBoldWideItalic',
                              color: message['from'] == auth.currentUser!.uid ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Divider(), // Optional divider to separate chat area and chat bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      fillColor: Color.fromARGB(255, 71, 71, 71),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'MonaSansExtraBoldWideItalic',
                      color: Colors.black,
                    ),
                    onSubmitted: (value) {
                      sendMessage('You: $value');
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    String message = 'You: ${_textEditingController.text}';
                    sendMessage(message);
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage(String message) async {
    if (auth.currentUser != null) {
      await dmCollection(widget.recipientUID).add({
        'from': auth.currentUser!.uid,
        'text': message,
        'sent': FieldValue.serverTimestamp(),
      });

      _textEditingController.clear(); // Clear the input field after sending
    }
  }
}
