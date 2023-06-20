import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DirectMessageScreen extends StatefulWidget {
  final String recipientUID; // UID of the recipient user
  final String senderUID; // UID of the recipient user

  DirectMessageScreen({required this.recipientUID,required this.senderUID});

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

  List<String> messages = []; // List to store the messages
  TextEditingController _textEditingController = TextEditingController(); // Controller for the input field

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<List<String>> fetchMessages() async {
    QuerySnapshot snapshot = await dmCollection(widget.recipientUID).orderBy('sent', descending: true).get();

    List<String> fetchedMessages = [];
    snapshot.docs.forEach((doc) {
      fetchedMessages.add((doc.data() as Map<String, dynamic>)['text'] as String);
    });

    return fetchedMessages;
  }

  Future<void> sendMessage(String message) async {
    if (auth.currentUser != null) {
      await dmCollection(widget.recipientUID).add({
        'from': auth.currentUser!.uid,
        'text': message,
        'sent': FieldValue.serverTimestamp(),
      });

      _textEditingController.clear(); // Clear the input field after sending
      fetchMessages();
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose(); // Dispose the controller when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Direct Messages'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<String>>(
              future: fetchMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final messages = snapshot.data ?? [];

                  return ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      // Display the messages in the list
                      return Align(
                        alignment: messages[index].startsWith('You: ') ? Alignment.topRight : Alignment.topLeft,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: messages[index].startsWith('You: ') ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            messages[index],
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
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
}