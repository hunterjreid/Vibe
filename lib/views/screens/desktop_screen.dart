// ------------------------------
//  Hunter Reid 2023 ⓒ
//  Vibe Find your Vibes
//
//  desktop_screen.dart
//

//dependencies import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:vibe/controllers/video_controller.dart';
import 'package:vibe/controllers/auth_controller.dart';
import 'package:vibe/models/video.dart';
import 'package:video_player/video_player.dart';

//desktop_screen.dart//This screen is for web app

class WebAppScreen extends StatefulWidget {
  @override
  _WebAppScreenState createState() => _WebAppScreenState();
}

class _WebAppScreenState extends State<WebAppScreen> {
  final VideoController videoController = Get.put(VideoController());

  AuthController authController = Get.put(AuthController());
  List<VideoPlayerController> videoControllers = [];
  List<ChewieController> chewieControllers = [];
  bool _isLoading = true;
  bool _isModalVisible = true;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      waitForValidVideoRange();
    });
  }

  bool hasValidVideoRange() {
    return videoController.videoList.isNotEmpty;
  }

  void waitForValidVideoRange() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (hasValidVideoRange()) {
        preloadVideos();
      } else {
        waitForValidVideoRange();
      }
    });
  }

  void openProfilePopup(BuildContext context, String uid) async {
    final firestore = FirebaseFirestore.instance;

    // Retrieve user data
    final userDoc = await firestore.collection('users').doc(uid).get();
    final userData = userDoc.data()! as dynamic;

    final name = userData['name'];
    final profilePhoto = userData['profilePhoto'];
    final bio = userData['bio'] ?? '';
    final website = userData['website'] ?? '';
    final username = userData['username'];
    final longBio = userData['longBio'] ?? 'This user hasn\'t set up their long bio yet';

    int likes = 0;
    int followers = 0;
    int following = 0;

    // Retrieve user videos and thumbnails
    final myVideos = await FirebaseFirestore.instance.collection('videos').where('uid', isEqualTo: uid).get();
    final thumbnails = myVideos.docs.map((video) => video.data()['thumbnail']).whereType<String>().toList();
    likes = myVideos.docs
        .map((video) => (video.data()['likes'] as List).length)
        .reduce((value, element) => value + element);

    // Retrieve follower and following count
    final followerDoc = await firestore.collection('users').doc(uid).collection('followers').get();
    followers = followerDoc.docs.length;

    final followingDoc = await firestore.collection('users').doc(uid).collection('following').get();
    following = followingDoc.docs.length;

    print(thumbnails);

    // Retrieve start and end colors
    final startColor =
        userData['startColor'] != null ? Color(int.parse(userData['startColor'])) : Color.fromARGB(255, 0, 81, 255);
    final endColor =
        userData['endColor'] != null ? Color(int.parse(userData['endColor'])) : Color.fromARGB(255, 221, 15, 228);

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: 600.0,
            height: 600.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200.0,
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 120.0),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                          textStyle: TextStyle(fontSize: 16.0),
                          backgroundColor: Color.fromARGB(0, 128, 128, 128),
                        ),
                        child: Text(
                          'Take me to the app!',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 255, 0, 212),
                            fontFamily: 'MonaSansExtraBoldWideItalic',
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                          textStyle: TextStyle(fontSize: 16.0),
                          backgroundColor: Color.fromARGB(0, 167, 138, 138),
                        ),
                        child: Text(
                          'Learn more',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 0, 247, 255),
                            fontFamily: 'MonaSansExtraBoldWideItalic',
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                          textStyle: TextStyle(fontSize: 16.0),
                          backgroundColor: Colors.black,
                        ),
                        child: Text(
                          'Get vibe to like, comment and remix!',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 24, 115, 201),
                            fontFamily: 'MonaSansExtraBoldWideItalic',
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.e_mobiledata_outlined),
                          Icon(Icons.tag_faces),
                          Icon(Icons.dangerous_rounded),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 500,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  gradient: LinearGradient(
                                    colors: [
                                      startColor,
                                      endColor,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              ),
                              ClipOval(
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: profilePhoto,
                                  height: 90,
                                  width: 90,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => const Icon(
                                    Icons.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32.0,
                              fontFamily: 'MonaSansExtraBoldWideItalic',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '$username',
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'MonaSansExtraBoldWideItalic',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            bio,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'MonaSans',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            website,
                            style: TextStyle(
                              color: Colors.blue,
                              fontFamily: 'MonaSans',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.thumb_up,
                                    size: 24.0,
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Likes',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      fontFamily: 'MonaSansExtraBoldWideItalic',
                                    ),
                                  ),
                                  Text(
                                    likes.toString(),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'MonaSans',
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(
                                    Icons.people,
                                    size: 24.0,
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Followers',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      fontFamily: 'MonaSans',
                                    ),
                                  ),
                                  Text(
                                    followers.toString(),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'MonaSans',
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(
                                    Icons.group,
                                    size: 24.0,
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Following',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      fontFamily: 'MonaSansExtraBoldWideItalic',
                                    ),
                                  ),
                                  Text(
                                    following.toString(),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'MonaSans',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            'Videos',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              fontFamily: 'MonaSansExtraBoldWideItalic',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10.0),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                            ),
                            itemCount: thumbnails.length,
                            itemBuilder: (context, index) {
                              return Image.network(
                                thumbnails[index],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.e_mobiledata_outlined),
                              Icon(Icons.tag_faces),
                              Icon(Icons.dangerous_rounded),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void preloadVideos() async {
    for (int i = 0; i < 9; i++) {
      final Video video = videoController.videoList[i];
      final VideoPlayerController videoPlayerController = VideoPlayerController.network(video.videoUrl);

      await videoPlayerController.initialize();

      videoController.addView(videoController.videoList[i].id);

      videoControllers.add(videoPlayerController);

      chewieControllers.add(
        ChewieController(
          videoPlayerController: videoPlayerController,
          showControlsOnInitialize: false,
          autoPlay: true,
          looping: true,
          showControls: false,
          allowedScreenSleep: false,
          overlay: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 40,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.visibility,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 4), SizedBox(width: 4.0), SizedBox(width: 4.0),
                        Text(
                          video.views.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),

                        SizedBox(width: 4.0), SizedBox(width: 4.0), SizedBox(width: 4.0),
                        Text(
                          'Likes: ${video.likes.length}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'MonaSansExtraBoldWideItalic',
                          ),
                        ),
                        SizedBox(width: 4.0),
                        SizedBox(width: 4.0),
                        Text(
                          'Comments: ${video.commentCount}',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'MonaSans',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '✨🤍 Caption: ${video.caption}',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'MonaSansExtraBoldWideItalic',
                            color: Colors.white,
                          ),
                        ),
                        // Text(
                        //   'Posted by: ${video.username}',
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    for (final controller in videoControllers) {
      controller.dispose();
    }
    for (final controller in chewieControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _refreshing = true;
    });

    setState(() {
      _refreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 50,
                  width: 50,
                ),
              ),
              Text(
                'Vibe',
                style: const TextStyle(
                  fontSize: 38,
                  fontFamily: 'MonaSansExtraBoldWideItalic',
                ),
              ),
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _isModalVisible ? 250 : 0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF000000), Color(0xFF333333)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView(
              children: [
                ListTile(
                  tileColor: Colors.black,
                  leading: Icon(Icons.mood),
                  title: Text(
                    'What is this App?',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'MonaSansExtraBoldWideItalic',
                      color:  Color.fromARGB(255, 0, 81, 255),

       
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.black,
                          title: Row(
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'What is this App?',
                                style: TextStyle(
                                  fontFamily: 'MonaSansExtraBoldWideItalic',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          content: Container(
                            constraints: BoxConstraints(maxWidth: 600),
                            child: Text(
                              'This app is a social media platform. It allows users to upload their favorite music and quick videos to express themselves and show off their creativity. \n\n Vibe aims to foster a tight-knit community where users can interact, collaborate on cool projects, and connect with others who share similar interests and hobbies. The platform stands out with its awesome features, such as music and video uploads, creative endeavors, and the ability to meet like-minded people who are all about good vibes. Vibe takes security seriously and employs the latest technology and cybersecurity measures to ensure a safe and reliable experience for its users. Users can connect with others on Vibe, meet new people, and collaborate on exciting projects. The platform also offers opportunities for users to monetize their content through sponsored collaborations, advertising partnerships, and merchandise sales. \n\nDiscovering new content on Vibe is easy with personalized recommendations, trending sections, and user-curated playlists. Vibe is accessible on smartphones, tablets, and computers, making it convenient to engage with the platform anytime, anywhere. If you have any more questions or need help, don\'t hesitate to reach out to the Vibe team. They are here to assist you and ensure you have the best experience on the platform.',
                              style: TextStyle(
                                fontFamily: 'MonaSansExtraBoldWideItalic',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Close', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  tileColor: Colors.black,
                  leading: Icon(FontAwesomeIcons.question),
                  title: Text(
                    'Why was Vibe made?',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'MonaSansExtraBoldWideItalic',
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.black,
                          title: Row(
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Why was Vibe made?',
                                style: TextStyle(
                                  fontFamily: 'MonaSansExtraBoldWideItalic',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          content: Container(
                            constraints: BoxConstraints(maxWidth: 600),
                            child: Text(
                              'Vibe was made to provide users with a platform to express themselves creatively and connect with like-minded individuals. It aims to foster a vibrant and inclusive community where users can share their passions, collaborate on projects, and spread good vibes. The platform offers various features and opportunities for users to explore their creativity, monetize their content, and discover new and exciting experiences. By creating Vibe, the developers wanted to empower individuals to unleash their creativity, connect with others, and have a platform that celebrates their unique talents and passions.',
                              style: TextStyle(
                                fontFamily: 'MonaSansExtraBoldWideItalic',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Close', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  tileColor: Colors.black,
                  leading: Icon(FontAwesomeIcons.info),
                  title: Text(
                    'How do I Vibe?',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'MonaSansExtraBoldWideItalic',
                      color:  Color.fromARGB(255, 221, 15, 228),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.black,
                          title: Row(
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'How do I Vibe?',
                                style: TextStyle(
                                  fontFamily: 'MonaSansExtraBoldWideItalic',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          content: Text(
                            'To access the full version, you need to upgrade your account.',
                            style: TextStyle(
                              fontFamily: 'MonaSansExtraBoldWideItalic',
                              color: Colors.white,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Close', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  tileColor: Colors.black,
                  leading: Icon(FontAwesomeIcons.personWalking),
                  title: Text(
                    'Get Support',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'MonaSansExtraBoldWideItalic',
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.black,
                          title: Row(
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Get Support',
                                style: TextStyle(
                                  fontFamily: 'MonaSansExtraBoldWideItalic',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          content: Text(
                            'Please visit our support page for assistance.',
                            style: TextStyle(
                              fontFamily: 'MonaSansExtraBoldWideItalic',
                              color: Colors.white,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Close', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: VisibilityDetector(
              key: Key('videosVisibilityKey'),
              onVisibilityChanged: (visibilityInfo) {
                if (visibilityInfo.visibleFraction == 1.0) {
                  videoController.addView(videoController.videoList[0].id);
                }
              },
              child: _isLoading
                  ? Container(
                      width: 300,
                      height: 300,
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        itemCount: videoController.videoList.length,
                        itemBuilder: (context, index) {
                          final Video video = videoController.videoList[index];
                          final data = videoController.videoList[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.75,
                                  child: Chewie(
                                    controller: chewieControllers[index],
                                  ),
                                ),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print(data.uid);
                                      openProfilePopup(context, data.uid);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.black,
                                      minimumSize: Size(100, 0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.account_circle,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Posted by ' + data.username,
                                          style: TextStyle(
                                            fontFamily: 'MonaSans',
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            'This is a demo version, you can access the full app on the app store.',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'MonaSans',
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(0, 1, 1, 1),
        width: MediaQuery.of(context).size.width * 0.35,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_image.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [
              SizedBox(height: 46.0),
              Image.asset(
                'assets/images/logo.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 16.0),
              ListTile(
                leading: Icon(
                  Icons.favorite,
                  size: 40,
                  color: Colors.white,
                ),
                title: Text(
                  'Donate',
                  style: TextStyle(
                    fontFamily: 'MonaSansExtraBoldWideItalic',
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // Handle HERE! - Todo
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.code,
                  size: 40,
                  color: Colors.white,
                ),
                title: Text(
                  'GitHub Sponsor',
                  style: TextStyle(
                    fontFamily: 'MonaSansExtraBoldWideItalic',
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // Handle GitHub sponsor action
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.info,
                  size: 40,
                  color: Colors.white,
                ),
                title: Text(
                  'Learn More',
                  style: TextStyle(
                    fontFamily: 'MonaSansExtraBoldWideItalic',
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // Handle learn more action
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.person_add,
                  size: 40,
                  color: Colors.white,
                ),
                title: Text(
                  'Sign Up for Wait List',
                  style: TextStyle(
                    fontFamily: 'MonaSansExtraBoldWideItalic',
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // Handle sign up for wait list action
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  size: 40,
                  color: Colors.white,
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: 'MonaSansExtraBoldWideItalic',
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // Handle settings action
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.info,
                  size: 40,
                  color: Colors.white,
                ),
                title: Text(
                  'About',
                  style: TextStyle(
                    fontFamily: 'MonaSansExtraBoldWideItalic',
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // Handle "About" action
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.help,
                  size: 40,
                  color: Colors.white,
                ),
                title: Text(
                  'Help',
                  style: TextStyle(
                    fontFamily: 'MonaSansExtraBoldWideItalic',
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // Handle "Help" action
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.favorite,
                  size: 40,
                  color: Colors.white,
                ),
                title: Text(
                  'Support Us',
                  style: TextStyle(
                    fontFamily: 'MonaSansExtraBoldWideItalic',
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // Handle "Support Us" action
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.person_add,
                  size: 40,
                  color: Colors.white,
                ),
                title: Text(
                  'Join Waitlist',
                  style: TextStyle(
                    fontFamily: 'MonaSansExtraBoldWideItalic',
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // Handle "Join Waitlist" action
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
