import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ShareVideoDMController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // This method retrieves the collection reference for direct messages (DMs) between the current user and another user.
  // It takes the UID (user ID) of the other user as a parameter.
  Future<CollectionReference> getDMCollection(String uid) async {
    if (_auth.currentUser != null) {
      // Check if the user is authenticated
      final idPair = [_auth.currentUser!.uid, uid].toList()..sort();
      final collectionID = idPair.join('_'); // Generate a unique collection ID for the DMs
      return _firestore.collection('dms').doc(collectionID).collection('messages');
    } else {
      throw FirebaseAuthException(message: 'User not authenticated', code: '');
    }
  }

  // This method sends a message in a direct conversation (DM) with another user.
  // It takes the UID of the recipient user and the message content as parameters.
  sendMessage(String uid, String message) async {
    try {
      final collection = await getDMCollection(uid); // Get the DM collection reference
      final user = _auth.currentUser;
      if (user != null) {
        final messageData = {
          'senderId': user.uid,
          'video_id': message,
          'timestamp': Timestamp.now(),
        };
        await collection.add(messageData); // Add the message data to the DM collection
        print('Message sent successfully.');
      } else {
        throw FirebaseAuthException(message: 'User not authenticated', code: '');
      }
    } catch (e) {
      print('Failed to send message: $e');
    }
  }
}
