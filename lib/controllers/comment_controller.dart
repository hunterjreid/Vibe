import 'package:cloud_firestore/cloud_firestore.dart'; // Importing the cloud_firestore package for Firestore database operations
import 'package:get/get.dart'; // Importing the get package for state management
import 'package:vibe/constants.dart'; // Importing the constants.dart file from the vibe package
import 'package:vibe/models/comment.dart'; // Importing the comment.dart file from the vibe/models directory

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]); // Creating a reactive variable to hold the comments
  List<Comment> get comments => _comments.value; // Getter to access the value of comments

  String _postId = ""; // Variable to store the post ID

  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  getComment() async {
    _comments.bindStream(
      firestore.collection('videos').doc(_postId).collection('comments').snapshots().map(
        (QuerySnapshot query) { // Mapping the QuerySnapshot to a List of Comment objects
          List<Comment> retValue = [];
          for (var element in query.docs) {
            retValue.add(Comment.fromSnap(element)); // Creating a Comment object from each document snapshot and adding it to the list
          }
          return retValue;
        },
      ),
    );
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await firestore.collection('users').doc(authController.user.uid).get(); // Getting the user document
        var allDocs = await firestore.collection('videos').doc(_postId).collection('comments').get(); // Getting all comment documents for the post
        int len = allDocs.docs.length; // Length of the comments list

        Comment comment = Comment(
          username: (userDoc.data()! as dynamic)['name'],
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          likes: [],
          profilePhoto: (userDoc.data()! as dynamic)['profilePhoto'],
          uid: authController.user.uid,
          id: 'Comment $len',
        );

        await firestore.collection('videos').doc(_postId).collection('comments').doc('Comment $len').set(
              comment.toJson(), // Adding the comment as a new document in the 'comments' collection
            );

        // Update commentBy array with user's ID
        await firestore.collection('videos').doc(_postId).collection('comments').doc('Comment $len').update({
          'commentBy': FieldValue.arrayUnion([authController.user.uid]), // Adding the user's ID to the 'commentBy' field in the comment document
        });

        DocumentSnapshot doc = await firestore.collection('videos').doc(_postId).get(); // Getting the post document
        await firestore.collection('videos').doc(_postId).update({
          'commentCount': (doc.data()! as dynamic)['commentCount'] + 1, // Incrementing the commentCount field in the post document
        });

        // Create a notification for the comment
        String videoOwnerId = (doc.data()! as dynamic)['uid']; // Getting the ID of the video owner
        String currentUserId = authController.user.uid;
        if (videoOwnerId != currentUserId) {
          String notificationId =
              await _createNotification(videoOwnerId, 'Comment', 'You have a new comment on your video.'); // Creating a notification for the video owner
          // Update the video owner's notifications field with the new notification ID
          await firestore.collection('users').doc(videoOwnerId).update({
            'notifications': FieldValue.arrayUnion([notificationId]), // Adding the new notification ID to the video owner's notifications list
          });
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error While Commenting',
        e.toString(),
      );
    }
  }

  likeComment(String id) async {
    var uid = authController.user.uid;
    DocumentSnapshot doc = await firestore.collection('videos').doc(_postId).collection('comments').doc(id).get(); // Getting the comment document

    if ((doc.data()! as dynamic)['likes'].contains(uid)) { // Checking if the user has already liked the comment
      await firestore.collection('videos').doc(_postId).collection('comments').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]), // Removing the user's ID from the 'likes' array field in the comment document
      });
    } else {
      await firestore.collection('videos').doc(_postId).collection('comments').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]), // Adding the user's ID to the 'likes' array field in the comment document
      });
    }
  }

  Future<String> _createNotification(String userId, String title, String message) async {
    var notification = {
      'title': title,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    };

    var notificationRef = await firestore.collection('notifications').add(notification); // Adding the notification document to the 'notifications' collection
    return notificationRef.id; // Returning the ID of the new notification document
  }
}
