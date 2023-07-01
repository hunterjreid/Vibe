// Vibe - Find your Vibe
// Architected by Hunter Reid
//
//dependencies import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/models/video.dart';
import 'dart:core';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  RxInt currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(
        firestore.collection('videos').orderBy('timestamp', descending: true).snapshots().map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        print("added");
        retVal.add(
          Video.fromSnap(element),
        );
      }
      print(retVal);
      return retVal;
    }));
  }

  void addView(String id) async {
    print(id);
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();

    if (doc.exists) {
      int views = (doc.data() as Map<String, dynamic>)['views'] ?? 0;
      await firestore.collection('videos').doc(id).update({
        'views': views + 1,
      });

      // Create a notification for the view action
      _createNotification('Video View', 'You viewed video with ID:' + doc.id + '.');
    } else {
      print('Document does not exist');
    }
  }

  void likeVideo(String id) async {
    print(id);
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    var uid = authController.user?.uid;

    if (doc.exists) {
      var likes = (doc.data() as Map<String, dynamic>)['likes'];
      if (likes != null && uid != null && likes.contains(uid)) {
        await firestore.collection('videos').doc(id).update({
          'likes': FieldValue.arrayRemove([uid]),
        });

        // Create a notification for the unlike action
        _createNotification('Video Like', 'You unliked a video.');
      } else {
        await firestore.collection('videos').doc(id).update({
          'likes': FieldValue.arrayUnion([uid]),
        });

        // Create a notification for the like action
        _createNotification('Video Like', 'You liked a video.');
      }
    } else {
      print('Document does not exist');
    }
  }

  Future<void> saveVideo(String id) async {
    var uid = authController.user?.uid;

    if (uid != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('videos').doc(id).get();

      if (doc.exists) {
        var saves = (doc.data() as Map<String, dynamic>)['saves'];
        if (saves != null && saves.contains(uid)) {
          await FirebaseFirestore.instance.collection('videos').doc(id).update({
            'saves': FieldValue.arrayRemove([uid]),
          });

          // Create a notification for the unsave action
          _createNotification('Video Save', 'You unsaved a video.');
        } else {
          await FirebaseFirestore.instance.collection('videos').doc(id).update({
            'saves': FieldValue.arrayUnion([uid]),
          });

          // Create a notification for the save action
          _createNotification('Video Save', 'You saved a video.');
        }
      } else {
        print('Document does not exist');
      }
    }
  }

  Widget buildVideoThumbnail(int index) {
    return Image.network(
      videoList[index].thumbnail,
      fit: BoxFit.cover,
    );
  }

  void _createNotification(String title, String message) {
    var uid = authController.user?.uid;

    if (uid != null) {
      var notification = {
        'title': title,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      };

      firestore.collection('users').doc(uid).collection('notifications').add(notification);
    }
  }
}
