import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String username;
  String uid;
  String id;
  List<dynamic> likes;
  List<dynamic> commentBy;
  int commentCount;
  int shareCount;
  int views;
  int musicUseCount;
  int savedCount;
  String songName;
  String caption;
  String caption2;
  String caption3;
  String videoUrl;
  String thumbnail;
  String profilePhoto;
   bool isFolderOpen;
  Timestamp timestamp;

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
    required this.isFolderOpen
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
      username: snapshot['username'],
      uid: snapshot['uid'],
      id: snapshot['id'],
      likes: snapshot['likes'],
      commentCount: snapshot['commentCount'],
      shareCount: snapshot['shareCount'],
      commentBy: snapshot['commentBy'] ?? [],
      views: snapshot['views'] ?? 0,
      songName: snapshot['songName'] ?? '',
      caption: snapshot['caption'] ?? '',
      caption2: snapshot['caption2'] ?? '',
      caption3: snapshot['caption3'] ?? '',
      videoUrl: snapshot['videoUrl'] ?? '',
      profilePhoto: snapshot['profilePhoto'] ?? '',
      thumbnail: snapshot['thumbnail'] ?? '',
      musicUseCount: snapshot['musicUseCount'] ?? 0,
      savedCount: snapshot['savedCount'] ?? 0,
      timestamp: snapshot['timestamp'],
          isFolderOpen:false,
    );
  }

  static fromSnapshot(QueryDocumentSnapshot<Object?> doc) {}
}
