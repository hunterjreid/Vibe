// Vibe - Find your Vibe
// Architected by Hunter Reid
//
//dependencies import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vibe/models/dm.dart';

class GetDMController extends GetxController {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance; // Instance of FirebaseFirestore for interacting with Firestore
  final FirebaseAuth auth = FirebaseAuth.instance; // Instance of FirebaseAuth for user authentication
  final Rx<List<DM>> _dms = Rx<List<DM>>([]); // Reactive variable to store the list of DMs
  final TextEditingController textEditingController =
      TextEditingController(); // TextEditingController for the input text

  List<DM> get dms => _dms.value; // Getter to access the list of DMs

  @override
  void onInit() {
    super.onInit();
    fetchDMs(auth.currentUser!.uid); // Fetch DMs when the controller is initialized
  }

  Future<void> fetchDMs(String userId) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('dms')
        .where('participants', arrayContains: userId)
        .get(); // Fetch DMs where the current user is a participant

    final List<DM> dmList = []; // List to store DM objects

    for (final docSnapshot in querySnapshot.docs) {
      final participants = List<String>.from(docSnapshot['participants']); // Retrieve participants from the snapshot

      final messagesCollection = docSnapshot.reference.collection('messages'); // Reference to the 'messages' collection
      final messagesSnapshot = await messagesCollection.get(); // Fetch messages

      final messages = messagesSnapshot.docs.map((messageDoc) {
        final messageData = messageDoc.data() as Map<String, dynamic>; // Retrieve message data from the snapshot
        final senderUID = messageData['senderUID'] as String; // Retrieve sender UID
        final text = messageData['text'] as String; // Retrieve message text
        final sent = messageData['sent'] as Timestamp; // Retrieve sent timestamp

        return Message(senderUID: senderUID, text: text, sent: sent.toDate()); // Create a Message object
      }).toList();

      final dm = DM(
        participants: participants,
        messages: messages,
      ); // Create a DM object

      dmList.add(dm); // Add DM to the list
    }

    _dms.value = dmList; // Update the list of DMs
  }

  Future<void> sendMessage(String senderUID, String recipientUID, String text) async {
    if (auth.currentUser != null) {
      final idPair = [senderUID, recipientUID].toList()..sort(); // Sort sender and recipient UID pair
      final collectionID = idPair.join('_'); // Generate collection ID

      final dmRef = firestore
          .collection('dms')
          .doc(collectionID)
          .collection('messages'); // Reference to the 'messages' collection of the DM

      final newMessage = {
        'senderUID': senderUID,
        'text': text,
        'sent': DateTime.now(),
      }; // Create a new message object

      await dmRef.add(newMessage); // Add the new message to the 'messages' collection

      textEditingController.clear(); // Clear the text input field

      // Update the local DM list with the new message
      final updatedDMs = List<DM>.from(_dms.value); // Create a copy of the current DM list
      final existingDMIndex = updatedDMs.indexWhere((dm) =>
          (dm.participants.contains(senderUID) && dm.participants.contains(recipientUID)) ||
          (dm.participants.contains(recipientUID) &&
              dm.participants.contains(senderUID))); // Find the index of the existing DM with the same participants

      if (existingDMIndex != -1) {
        final existingDM = updatedDMs[existingDMIndex]; // Get the existing DM
        final updatedMessages = List<Message>.from(existingDM.messages); // Create a copy of the existing messages
        final newDM = DM(
          participants: existingDM.participants,
          messages: [...updatedMessages, Message.fromMap(newMessage)], // Add the new message to the existing messages
        );
        updatedDMs[existingDMIndex] = newDM; // Replace the existing DM with the updated DM
      } else {
        final newDM = DM(
          participants: [senderUID, recipientUID],
          messages: [Message.fromMap(newMessage)], // Create a new DM with the new message
        );
        updatedDMs.add(newDM); // Add the new DM to the list
      }

      _dms.value = updatedDMs; // Update the list of DMs with the updated DM list
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
