import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:vibe/models/user.dart';

class GetDMController extends GetxController {
  final Rx<List<String>> _dmUsers = Rx<List<String>>([]);

  List<String> get dmUsers => _dmUsers.value;

  Future<void> fetchDMUsers(String userId) async {
    _dmUsers.bindStream(
      FirebaseFirestore.instance
          .collection('dms')
          .where('participants', arrayContains: userId)
          .snapshots()
          .asyncMap<List<String>>((QuerySnapshot query) async {
        List<String> users = [];
        for (var doc in query.docs) {
          final participants = doc['participants'] as List<dynamic>;
          final otherUserId = participants.firstWhere((id) => id != userId);
          users.add(otherUserId as String);
        }
        print(users);
        return users;
      }),
    );
  }
}
