import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vibe/models/dm.dart';

class GetDMController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Rx<List<DM>> _dms = Rx<List<DM>>([]);
  final TextEditingController textEditingController = TextEditingController();

  List<DM> get dms => _dms.value;

  @override
  void onInit() {
    super.onInit();
    fetchDMs(auth.currentUser!.uid);
  }

void fetchDMs(String userId) {
  firestore
      .collectionGroup('dms')
      .where('title', isGreaterThanOrEqualTo: userId)
      .where('title', isLessThan: userId + 'z')
      .snapshots()
      .listen((QuerySnapshot query) {
    final List<DM> dmList = query.docs
        .map((doc) => DM.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    _dms.value = dmList;
  });
}

  
Future<void> sendMessage(String senderUID, String recipientUID, String text) async {
  if (auth.currentUser != null) {
    final idPair = [senderUID, recipientUID].toList()..sort();
    final collectionID = idPair.join('_');

    final dmRef = firestore.collection('dms').doc(collectionID).collection('messages');

    final newMessage = {
      'senderUID': senderUID,
      'text': text,
      'sent': DateTime.now(),
    };

    await dmRef.add(newMessage);

    textEditingController.clear();

    // Update the local DM list with the new message
    final updatedDMs = List<DM>.from(_dms.value);
    final existingDMIndex = updatedDMs.indexWhere((dm) =>
        (dm.participants.contains(senderUID) && dm.participants.contains(recipientUID)) ||
        (dm.participants.contains(recipientUID) && dm.participants.contains(senderUID)));

    if (existingDMIndex != -1) {
      final existingDM = updatedDMs[existingDMIndex];
      final updatedMessages = List<Message>.from(existingDM.messages);
      final newDM = DM(
        participants: existingDM.participants,
        messages: [...updatedMessages, Message.fromMap(newMessage)],
      );
      updatedDMs[existingDMIndex] = newDM;
    } else {
      final newDM = DM(
        participants: [senderUID, recipientUID],
        messages: [Message.fromMap(newMessage)],
        
      );
      updatedDMs.add(newDM);
    }

    _dms.value = updatedDMs;
  }
}

  @override
  void dispose() {
    super.dispose();
  }
}
