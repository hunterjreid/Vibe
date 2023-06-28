import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/profile_controller.dart';
import 'package:vibe/views/screens/video/comment_screen.dart';
import 'package:vibe/views/screens/misc/friendSearch_screen.dart';
import 'package:vibe/views/screens/profile/profile_screen.dart';
import 'package:vibe/views/screens/misc/use_this_sound_screen.dart';
import 'package:vibe/views/screens/profile/user_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:vibe/controllers/video_controller.dart';
import 'package:vibe/controllers/auth_controller.dart';
import 'package:vibe/models/video.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';

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
  final myVideos = await firestore.collection('videos').where('uid', isEqualTo: uid).get();
  final thumbnails = myVideos.docs.map((video) => video.data()['thumbnails']).whereType<List>().expand((e) => e).cast<String>().toList();
  likes = myVideos.docs.map((video) => (video.data()['likes'] as List).length).reduce((value, element) => value + element);

  // Retrieve follower and following count
  final followerDoc = await firestore.collection('users').doc(uid).collection('followers').get();
  followers = followerDoc.docs.length;

  final followingDoc = await firestore.collection('users').doc(uid).collection('following').get();
  following = followingDoc.docs.length;

  // Retrieve start and end colors
  final startColor = userData['startColor'] != null ? Color(int.parse(userData['startColor'])) : Colors.grey;
  final endColor = userData['endColor'] != null ? Color(int.parse(userData['endColor'])) : Colors.grey;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage: profilePhoto != null ? NetworkImage(profilePhoto) : null,
                  child: profilePhoto == null
                      ? Icon(
                          Icons.account_circle,
                          size: 80.0,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              Text(
                '@$username',
                style: TextStyle(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              Text(
                bio,
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              Text(
                website,
                style: TextStyle(
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'Likes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(likes.toString()),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Followers',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(followers.toString()),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Following',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(following.toString()),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Popular Videos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: FutureBuilder(
                  future: Future.wait(thumbnails.map((url) => precacheImage(NetworkImage(url), context))),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error loading thumbnails'));
                    }
                    return GridView.builder(
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
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  },
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
  for (int i = 0; i < 20; i++) {
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
        materialProgressColors: ChewieProgressColors(
          backgroundColor: Color.fromARGB(255, 40, 5, 165),
          bufferedColor: Color.fromARGB(255, 255, 255, 255),
        ),
        additionalOptions: (context) {
          return <OptionItem>[
            OptionItem(
              onTap: () => debugPrint('My option works!'),
              iconData: Icons.report,
              title: 'Report Video',
            ),
            OptionItem(
              onTap: () => debugPrint('Another option working!'),
              iconData: Icons.copy,
              title: 'Copy Link to Video',
            ),
          ];
        },
        allowedScreenSleep: false,
        overlay: Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black54,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Video Views: ${video.views}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Likes: ${video.likes.length}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Comments: ${video.commentCount}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Caption: ${video.caption}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Posted by: ${video.username}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
        title: Row(
          
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
      body: Row(
        children: [
          AnimatedContainer(
            color: Color.fromARGB(255, 0, 0, 0),
            duration: const Duration(milliseconds: 200),
            width: _isModalVisible ? 250 : 0,
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.search),
                  title: Text('What is this App?',
              style: const TextStyle(
                fontSize: 17,
                fontFamily: 'MonaSansExtraBoldWideItalic',
              ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('What is this App?'),
                          content: Text('This app is a social media platform.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                    title: Text('What is this App?',
              style: const TextStyle(
                fontSize: 17,
                fontFamily: 'MonaSansExtraBoldWideItalic',
              ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Accessing the Full Version'),
                          content: Text('To access the full version, you need to upgrade your account.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.create_new_folder),
                     title: Text('What is this App?',
              style: const TextStyle(
                fontSize: 17,
                fontFamily: 'MonaSansExtraBoldWideItalic',
              ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Accessing the Full Version'),
                          content: Text('To access the full version, you need to upgrade your account.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                     title: Text('Get Support',
              style: const TextStyle(
                fontSize: 17,
                fontFamily: 'MonaSansExtraBoldWideItalic',
              ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Visit Support'),
                          content: Text('Please visit our support page for assistance.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Close'),
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
                  ? Center(
                      child: CircularProgressIndicator(),
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
        height: MediaQuery.of(context).size.height * 0.75, // Set height to 75% of the available height
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
                data.username,
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
        // Handle donate action
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
