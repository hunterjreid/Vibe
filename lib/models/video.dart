//Video Model
import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String username; // Username of the video uploader
  String uid; // User ID of the video uploader
  String id; // Unique ID of the video
  List<dynamic> likes; // List of users who liked the video
  List<dynamic> commentBy; // List of users who commented on the video
  int commentCount; // Total count of comments on the video
  int shareCount; // Total count of shares of the video
  int views; // Total count of views of the video
  int musicUseCount; // Total count of times the video's music is used
  int savedCount; // Total count of times the video is saved
  String songName; // Name of the song used in the video
  String caption; // Caption for the video
  String caption2; // Additional caption for the video
  String caption3; // Additional caption for the video
  String videoUrl; // URL of the video
  String thumbnail; // URL of the video thumbnail
  String profilePhoto; // URL of the uploader's profile photo
  bool isFolderOpen; // Flag indicating if the video folder is open
  Timestamp timestamp; // Timestamp of when the video was created

  Video({
    required this.username,
    required this.uid,
    required this.id,
    required this.likes,
    required this.commentCount,
    required this.commentBy,
    required this.shareCount,
    required this.views,
    required this.songName,
    required this.caption,
    required this.caption2,
    required this.caption3,
    required this.videoUrl,
    required this.profilePhoto,
    required this.thumbnail,
    required this.musicUseCount,
    required this.savedCount,
    required this.timestamp,
    required this.isFolderOpen,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "profilePhoto": profilePhoto,
        "id": id,
        "likes": likes,
        "commentCount": commentCount,
        "shareCount": shareCount,
        "views": views,
        "commentBy": commentBy,
        "songName": songName,
        "caption": caption,
        "caption2": caption2,
        "caption3": caption3,
        "videoUrl": videoUrl,
        "thumbnail": thumbnail,
        "musicUseCount": musicUseCount,
        "savedCount": savedCount,
        "timestamp": timestamp,
        "isFolderOpen": isFolderOpen,
      };

  static Video fromSnap(DocumentSnapshot<Object?> snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Video(
      username: snapshot['username'], // Retrieve the username from the snapshot
      uid: snapshot['uid'], // Retrieve the user ID from the snapshot
      id: snapshot['id'], // Retrieve the video ID from the snapshot
      likes: snapshot['likes'], // Retrieve the likes from the snapshot
      commentCount: snapshot['commentCount'], // Retrieve the comment count from the snapshot
      shareCount: snapshot['shareCount'], // Retrieve the share count from the snapshot
      commentBy: snapshot['commentBy'] ?? [], // Retrieve the commentBy list or use an empty list if null
      views: snapshot['views'] ?? 0, // Retrieve the views or use 0 if null
      songName: snapshot['songName'] ?? '', // Retrieve the song name or use an empty string if null
      caption: snapshot['caption'] ?? '', // Retrieve the caption or use an empty string if null
      caption2: snapshot['caption2'] ?? '', // Retrieve caption2 or use an empty string if null
      caption3: snapshot['caption3'] ?? '', // Retrieve caption3 or use an empty string if null
      videoUrl: snapshot['videoUrl'] ?? '', // Retrieve the video URL or use an empty string if null
      profilePhoto: snapshot['profilePhoto'] ?? '', // Retrieve the profile photo URL or use an empty string if null
      thumbnail: snapshot['thumbnail'] ?? '', // Retrieve the thumbnail URL or use an empty string if null
      musicUseCount: snapshot['musicUseCount'] ?? 0, // Retrieve the music use count or use 0 if null
      savedCount: snapshot['savedCount'] ?? 0, // Retrieve the saved count or use 0 if null
      timestamp: snapshot['timestamp'], // Retrieve the timestamp from the snapshot
      isFolderOpen: false, // Set isFolderOpen to false by default
    );
  }

  static fromSnapshot(QueryDocumentSnapshot<Object?> doc) {}
}
