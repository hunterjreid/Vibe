import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String username;
  String comment;
  final datePublished; // It's recommended to specify the type explicitly

  List likes; // It's recommended to specify the type explicitly
  String profilePhoto;
  String uid;
  String id;

  Comment({
    required this.username, // The username is required for creating a comment
    required this.comment, // The comment content is required
    required this.datePublished, // The date of publishing is required
    required this.likes, // The list of likes is required
    required this.profilePhoto, // The profile photo is required
    required this.uid, // The user ID is required
    required this.id, // The comment ID is required
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'comment': comment,
        'datePublished': datePublished,
        'likes': likes,
        'profilePhoto': profilePhoto,
        'uid': uid,
        'id': id,
      };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
      username: snapshot['username'], // Retrieve the username from the snapshot
      comment: snapshot['comment'], // Retrieve the comment from the snapshot
      datePublished: snapshot['datePublished'], // Retrieve the date from the snapshot
      likes: snapshot['likes'], // Retrieve the likes from the snapshot
      profilePhoto: snapshot['profilePhoto'], // Retrieve the profile photo from the snapshot
      uid: snapshot['uid'], // Retrieve the user ID from the snapshot
      id: snapshot['id'], // Retrieve the comment ID from the snapshot
    );
  }
}
