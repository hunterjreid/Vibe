


  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/models/video.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;
  
  RxInt currentPage = 0.obs;


  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(firestore
        .collection('videos')
        .orderBy('timestamp',
            descending:
                true) // add this line to order by timestamp in descending order
        .snapshots()
        .map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(
          Video.fromSnap(element),
        );
      }
      return retVal;
    }));
  }

void likeVideo(String id) async {
  print(id);
  DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
  var uid = authController.user?.uid; // Add null check here

  if (doc.exists) { // Check if the document exists
    var likes = (doc.data() as Map<String, dynamic>)['likes'];
    if (likes != null && uid != null && likes.contains(uid)) {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  } else {
    // Handle the case when the document doesn't exist
    print('Document does not exist');
  }
}

Future<void> saveVideo(String id) async {
  print(id);
  DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
  var uid = authController.user?.uid; // Add null check here

  if (doc.exists) { // Check if the document exists
    var saves = (doc.data() as Map<String, dynamic>)['saves'];
    if (saves != null && uid != null && saves.contains(uid)) {
      await firestore.collection('videos').doc(id).update({
        'saves': FieldValue.arrayRemove([uid]),
      });
      print('Video un-saved');
    } else {
      await firestore.collection('videos').doc(id).update({
        'saves': FieldValue.arrayUnion([uid]),
      });
      print('Video saved');
    }
  } else {
    // Handle the case when the document doesn't exist
    print('Document does not exist');
  }
}

  Widget buildVideoThumbnail(int index) {
    return Image.network(
      videoList[index].thumbnail,
      fit: BoxFit.cover,
    );
  }

 
}

