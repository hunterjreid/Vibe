//DIRECT MESSAGE MODEL

import 'package:cloud_firestore/cloud_firestore.dart';

class DM {
  final List<String> participants; // List of participants' IDs
  final List<Message> messages; // List of messages in the direct message (DM)

  DM({
    required this.participants,
    required this.messages,
  });

  factory DM.fromMap(Map<String, dynamic> map) {
    final List<dynamic> participantList = map['participants']; // Retrieve participants from the map
    final List<String> participants = participantList.map((e) => e.toString()).toList();

    final List<dynamic> messageList = map['messages']; // Retrieve messages from the map
    final List<Message> messages = messageList.map((e) => Message.fromMap(e)).toList();

    return DM(
      participants: participants,
      messages: messages,
    );
  }
}

class Message {
  final String senderUID; // ID of the sender of the message
  final String text; // Text content of the message
  final DateTime sent; // Timestamp indicating when the message was sent

  Message({
    required this.senderUID,
    required this.text,
    required this.sent,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderUID: map['senderUID'] as String, // Retrieve sender's ID from the map
      text: map['text'] as String, // Retrieve message text from the map
      sent: map['sent'] as DateTime, // Retrieve sent timestamp from the map
    );
  }
}
