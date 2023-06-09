import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ShareVideoDMController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<CollectionReference> getDMCollection(String uid) async {
    if (_auth.currentUser != null) {
      final idPair = [_auth.currentUser!.uid, uid].toList()..sort();
      final collectionID = idPair.join('_');
      return _firestore.collection('dms').doc(collectionID).collection('messages');
    } else {
      throw FirebaseAuthException(message: 'User not authenticated', code: '');
    }
  }

  sendMessage(String uid, String message) async {
    try {
      final collection = await getDMCollection(uid);
      final user = _auth.currentUser;
      if (user != null) {
        final messageData = {
          'senderId': user.uid,
          'video_id': message,
          'timestamp': Timestamp.now(),
        };
        await collection.add(messageData);
        print('Message sent successfully.');
      } else {
        throw FirebaseAuthException(message: 'User not authenticated', code: '');
      }
    } catch (e) {
      print('Failed to send message: $e');
    }
  }
}
