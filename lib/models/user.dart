import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String profilePhoto;
  String email;
  String uid;
  String website; // Added website field
  String bio; // Added bio field

  User({
    required this.name,
    required this.email,
    required this.uid,
    required this.profilePhoto,
    required this.website,
    required this.bio,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "profilePhoto": profilePhoto,
        "email": email,
        "uid": uid,
        "website": website,
        "bio": bio,
      };

static User fromSnap(DocumentSnapshot snap) {
  var snapshot = snap.data() as Map<String, dynamic>;
  return User(
    email: snapshot['email'] ?? '',
    profilePhoto: snapshot['profilePhoto'] ?? '',
    uid: snapshot['uid'] ?? '',
    name: snapshot['name'] ?? '',
    website: snapshot['website'] ?? '',
    bio: snapshot['bio'] ?? '',
  );
}

}