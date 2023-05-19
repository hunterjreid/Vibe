import 'package:flutter/material.dart';

class DirectMessageScreen extends StatefulWidget {
  final String recipientName; // Name of the other person

  DirectMessageScreen({required this.recipientName});

  @override
  _DirectMessageScreenState createState() => _DirectMessageScreenState();
}

class _DirectMessageScreenState extends State<DirectMessageScreen> {
  List<String> messages = []; // List to store the messages
  TextEditingController _textEditingController =
      TextEditingController(); // Controller for the input field

  void sendMessage(String message) {
    setState(() {
      messages.add(message); // Append the message to the list
    });
  }

  @override
  void dispose() {
    _textEditingController
        .dispose(); // Dispose the controller when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.recipientName), // Display the recipient's name in the header
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                // Display the messages in the list
                return Align(
                  alignment: messages[index].startsWith('You: ')
                      ? Alignment.topRight
                      : Alignment.topLeft,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: messages[index].startsWith('You: ')
                          ? Colors.blue
                          : Colors.grey[300],
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
            ),
          ),
          Divider(), // Optional divider to separate chat area and chat bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                        _textEditingController, // Set the controller for the input field
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                    onSubmitted: (value) {
                      sendMessage(
                          'You: $value'); // Send the message when submitted
                      _textEditingController
                          .clear(); // Clear the input field after sending
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    String message = 'You: ${_textEditingController.text}';
                    sendMessage(message);
                    _textEditingController.clear();
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
