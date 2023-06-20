import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe/constants.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  Rx<String> _uid = "".obs;

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    if (_uid.value.isEmpty) {
      return;
    }

    List<String> thumbnails = [];
    var myVideos = await FirebaseFirestore.instance
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();

    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid.value).get();
    final userData = userDoc.data()! as dynamic;
    String name = userData['name'];
    String profilePhoto = userData['profilePhoto'];
    String bio = userData['bio'] ?? '';
    String website = userData['website'] ?? '';



    int likes = 0;
    int followers = 0;
    int following = 0;

    bool isFollowing = false;

    for (var item in myVideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }

    var followerDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();

    var followingDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();
    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    List<String> followersList =
        followerDoc.docs.map((doc) => doc.id).toList();
    List<String> followingList =
        followingDoc.docs.map((doc) => doc.id).toList();



    var followerSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get();

    if (followerSnapshot.exists) {
      isFollowing = true;
    } else {
      isFollowing = false;
    }

    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profilePhoto': profilePhoto,
      'name': name,
      'bio': bio,
      'website': website,
      'thumbnails': thumbnails,
      'followersList': followersList,
      'followingList': followingList,
    };

    update();
  }

    getProfileData() async {
    if (authController.user.uid.isEmpty) {
      return;
    }
    

    List<String> thumbnails = [];
    var myVideos = await FirebaseFirestore.instance
        .collection('videos')
        .where('uid', isEqualTo: authController.user.uid)
        .get();

    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(authController.user.uid).get();
    final userData = userDoc.data()! as dynamic;
    String name = userData['name'];
    String profilePhoto = userData['profilePhoto'];
    String bio = userData['bio'] ?? '';
    String website = userData['website'] ?? '';

Color startColor = userData['startColor'] != null
    ? Color(int.parse(userData['startColor']))
    : Colors.red;

Color endColor = userData['endColor'] != null
    ? Color(int.parse(userData['endColor']))
    : Colors.red;

    int likes = 0;
    int followers = 0;
    int following = 0;

    bool isFollowing = false;

    print('Start Color: $startColor');

    print('Start Color: $endColor');

    for (var item in myVideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }

    var followerDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();

    var followingDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();
    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    List<String> followersList =
        followerDoc.docs.map((doc) => doc.id).toList();
    List<String> followingList =
        followingDoc.docs.map((doc) => doc.id).toList();



    var followerSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get();

    if (followerSnapshot.exists) {
      isFollowing = true;
    } else {
      isFollowing = false;
    }

    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profilePhoto': profilePhoto,
      'name': name,
      'bio': bio,
      'website': website,
      'thumbnails': thumbnails,
      'followersList': followersList,
      'followingList': followingList,
      'startColor': startColor,
      'endColor':endColor

    };

    update();
  }



  void updateProfileColors(String startColor, String endColor) async {
    if (_uid.value.isEmpty) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .update({
      'startColor': startColor,
      'endColor': endColor,
    });

    _user.update((userData) {
      userData?.update('startColor', (_) => startColor, ifAbsent: () => startColor);
      userData?.update('endColor', (_) => endColor, ifAbsent: () => endColor);
    });

    update();
  }

  void updateProfilePhoto(String downloadUrl) async {
    if (_uid.value.isEmpty) {
      return;
    }

    await FirebaseFirestore.instance.collection('users').doc(_uid.value).update({
      'profilePhoto': downloadUrl,
    });

    _user.update((userData) {
      userData?.update('profilePhoto', (_) => downloadUrl, ifAbsent: () => downloadUrl);
    });

    update();
  }

  followUser() async {
    if (_uid.value.isEmpty) {
      return;
    }



    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get();

    if (!doc.exists) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .set({});

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .set({});

      _user.value.update(
        'followers',
        (value) => (int.parse(value) + 1).toString(),
      );
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .delete();

      _user.value.update(
        'followers',
        (value) => (int.parse(value) - 1).toString(),
      );
    }

    _user.value.update('isFollowing', (value) => !value);
    update();
  }
}
