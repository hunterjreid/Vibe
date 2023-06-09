import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/models/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  RxDouble progress = 0.0.obs;

  Future<File> _compressVideo(String videoPath) async {
    Get.snackbar(
      'Preparing Video',
      'Video is being compressed, Don\'t close or change this page',
    );

    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.Res640x480Quality,
    );

    Get.snackbar(
      'Compressing Done',
      'Video is done being compressed',
    );

    if (compressedVideo != null && compressedVideo.file != null) {
      return compressedVideo.file!;
    } else {
      throw Exception("Failed to compress video");
    }
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);

    // get file size before compression
    final originalFile = File(videoPath);
    final originalFileSize = await originalFile.length();

    // compress video
    final compressedFile = await _compressVideo(videoPath);

    UploadTask uploadTask = ref.putFile(
      compressedFile,
      // set metadata with original file size
      SettableMetadata(contentType: 'video/mp4', customMetadata: {
        'originalFileSize': originalFileSize.toString(),
      }),
    );

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      final double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100.0;
      this.progress.value = progress;
      print('Upload progress: ${progress.toStringAsFixed(2)}%');
    });

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // upload video
  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();
      // get id
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
        thumbnail: thumbnail,
        timestamp: Timestamp.now(),
      );
      // Save the video document to Firestore
      await firestore.collection('videos').add(video.toJson());

      Get.toNamed('/HomeScreen');
    } catch (e) {
      Get.snackbar(
        'Error Uploading Video',
        e.toString(),
      );
    }
  }
}
