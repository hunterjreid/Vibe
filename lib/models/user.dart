import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name; // Name of the user
  String profilePhoto; // URL to the user's profile photo
  String email; // Email address of the user
  String uid; // Unique identifier (ID) of the user

  User({
    required this.name, // The name is required when creating a User object
    required this.email, // The email is required
    required this.uid, // The user ID is required
    required this.profilePhoto, // The profile photo URL is required
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "profilePhoto": profilePhoto,
        "email": email,
        "uid": uid,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      email: snapshot['email'], // Retrieve the email from the snapshot
      profilePhoto: snapshot['profilePhoto'], // Retrieve the profile photo URL from the snapshot
      uid: snapshot['uid'], // Retrieve the user ID from the snapshot
      name: snapshot['name'], // Retrieve the name from the snapshot
    );
  }
}
