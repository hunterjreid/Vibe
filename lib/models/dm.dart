import 'package:cloud_firestore/cloud_firestore.dart';

class DM {
  final List<String> participants;
  final List<Message> messages;

  DM({
    required this.participants,
    required this.messages,
  });

  factory DM.fromMap(Map<String, dynamic> map) {
    final List<dynamic> participantList = map['participants'];
    final List<String> participants = participantList.map((e) => e.toString()).toList();

    final List<dynamic> messageList = map['messages'];
    final List<Message> messages = messageList.map((e) => Message.fromMap(e)).toList();

    return DM(
      participants: participants,
      messages: messages,
    );
  }
}

class Message {
  final String senderUID;
  final String text;
  final DateTime sent;

  Message({
    required this.senderUID,
    required this.text,
    required this.sent,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderUID: map['senderUID'] as String,
      text: map['text'] as String,
      sent: map['sent'] as DateTime,
    );
  }
}
