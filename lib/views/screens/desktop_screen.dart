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

  final userSnapshot = await firestore.collection('users').doc(uid).get();

  final profilePhoto = userSnapshot['profilePhoto'] ?? '';
  final bio = userSnapshot['bio'] ?? 'Bio goes here';
  final website = userSnapshot['website'] ?? 'Website goes here';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      final randomColor1 = Colors.blue; // Replace with your desired colors
      final randomColor2 = Colors.green; // Replace with your desired colors

      return AlertDialog(
        title: Text('Profile'),
        content: Column(
          children: [
            Container(
              width: 500,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                gradient: LinearGradient(
                  colors: [
                    randomColor1,
                    randomColor2,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(profilePhoto),
            ),
            SizedBox(height: 10),
            Text(
              bio,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              website,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'UID: $uid',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
                  title: Text('What is this App?'),
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
                  title: Text('How can I access the full Version'),
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
                  title: Text('Extra'),
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
                  title: Text('Visit Support'),
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
        color: Color.fromARGB(255, 0, 0, 0),
        child: Center(
          child: Text(
            'This is a demo version, you can access the full app on the app store.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
            size: 30,
            color: Colors.white,
          ),
          title: Text(
            'Donate',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
            size: 30,
            color: Colors.white,
          ),
          title: Text(
            'GitHub Sponsor',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
            size: 30,
            color: Colors.white,
          ),
          title: Text(
            'Learn More',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
            size: 30,
            color: Colors.white,
          ),
          title: Text(
            'Sign Up for Wait List',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
            size: 30,
            color: Colors.white,
          ),
          title: Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
            size: 30,
            color: Colors.white,
          ),
          title: Text(
            'About',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
            size: 30,
            color: Colors.white,
          ),
          title: Text(
            'Help',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
            size: 30,
            color: Colors.white,
          ),
          title: Text(
            'Support Us',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
            size: 30,
            color: Colors.white,
          ),
          title: Text(
            'Join Waitlist',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
