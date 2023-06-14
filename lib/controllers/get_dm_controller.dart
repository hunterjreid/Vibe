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
        .collection('dms')
        .where('participants', arrayContains: userId)
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

      await dmRef.add({
        'senderUID': senderUID,
        'text': text,
        'sent': FieldValue.serverTimestamp(),
      });

      textEditingController.clear();
    }
  }
}

