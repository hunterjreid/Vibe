import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/profile_controller.dart';
import 'package:vibe/views/screens/create_screen.dart';
import 'package:vibe/views/screens/profile/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibe/views/screens/profile/show_own_video_screen.dart';
import 'package:vibe/views/screens/profile/userSettings_screen.dart';
import 'package:vibe/views/screens/profile/your_dms_screen.dart';
import 'package:vibe/views/screens/video/show_more_video.dart';
import 'package:vibe/views/screens/video/show_single_video.dart';
import 'direct_message_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'dart:math';
import 'dart:ui';
import 'package:iconsax/iconsax.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

ThemeData themeData = isDarkTheme == false ? lightTheme : darkTheme;

Color generateRandomColor() {
  Random random = Random();
  int alpha = 255; // You can adjust the alpha value (transparency) if needed

  int red = random.nextInt(256); // Random red value between 0 and 255
  int green = random.nextInt(256); // Random green value between 0 and 255
  int blue = random.nextInt(256); // Random blue value between 0 and 255

  return Color.fromARGB(alpha, red, green, blue);
}

class _UserScreenState extends State<UserScreen> with SingleTickerProviderStateMixin {
  final ProfileController profileController = Get.put(ProfileController());
  late TabController _tabController;
  List<Color> tabColors = [
    Colors.purple, // Leftmost color
    Colors.blue, // Rightmost color
    Colors.blue.withOpacity(0.5), // Middle color
  ];

  Color startColor = Color.fromARGB(0, 0, 0, 0);
  Color endColor = Color.fromARGB(0, 121, 113, 120);

  Future<void> _refreshData() async {
    // Add your refresh logic here, such as fetching new data
    await profileController.getProfileData();
    // ...

    // Update the colors using the _updateColors method
    _updateColors(
      profileController.user['startColor'],
      profileController.user['endColor'],
    );
  }

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(authController.user.uid);
    _fetchUserProfile(); // Fetch user profile data

    _tabController = TabController(length: 3, vsync: this);
  }

  void _fetchUserProfile() async {
    await profileController.getProfileData();

    print(profileController.user['startColor']);

    // Check if startColor and endColor are null, then set them to red
    if (profileController.user['startColor'] == null) {
      profileController.user['startColor'] = Color.fromARGB(0, 244, 67, 54);
    }
    if (profileController.user['endColor'] == null) {
      profileController.user['endColor'] = Color.fromARGB(0, 244, 67, 54);
    }

    // Set the colors using the _updateColors method
    _updateColors(
      profileController.user['startColor'],
      profileController.user['endColor'],
    );
  }

// Update the colors when returning from the UserSettingsScreen
  void _navigateToUserSettingsScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserSettingsScreen(
          startColor: startColor,
          endColor: endColor,
          onSaveChanges: _updateColors,
        ),
      ),
    );
  }

  void _updateColors(Color startColor1, Color endColor1) async {
    setState(() {
      startColor = startColor1;
      endColor = endColor1;
    });
  }

// Navigate to the UserSettingsScreen and handle the returned colors

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUserProfile(); // Fetch user profile data
  }

  void _tabControllerListener() {
    setState(() {}); // Update the state when the tab changes
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = isDarkTheme == false ? lightTheme : darkTheme;
    print(isDarkTheme);

    Color _getTabIndicatorColor() {
      // Calculate the interpolation factor based on the current tab index
      double factor = (_tabController.index % 2) / 2.0;
      // Interpolate between the leftmost and rightmost colors
      return Color.lerp(tabColors[0], tabColors[1], factor)!;
    }

    DateTime currentTime = DateTime.now();

    // Placeholder list of titles
    List<String> titles = [
      "Video you saved Title 1",
      "Video you saved Title 2",
      "Video you saved Title 3",
      "Video you saved Title 4",
      "Video you saved Title 5",
    ];
    if (isDarkTheme == null) {
      // Fallback theme in case of null value
      themeData = ThemeData.light();
    }

    return MaterialApp(
        theme: themeData, // Apply dark theme
        debugShowCheckedModeBanner: false,
        home: GetBuilder<ProfileController>(
          init: ProfileController(),
          builder: (controller) {
            // print(controller.user['startColor']);

            //

            return Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  controller: _tabController, // Set the TabController
                  labelColor: Theme.of(context).colorScheme.onBackground,
                  tabs: [
                    Tab(icon: Icon(Icons.person_2_outlined)),
                    Tab(icon: Icon(Icons.music_note_outlined)),
                    Tab(icon: Icon(Icons.recommend_outlined)),
                  ],
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: _getTabIndicatorColor(), // Get the color based on the current tab
                      width: 3.0,
                    ),
                    insets: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      _navigateToUserSettingsScreen();
                    },
                    icon: Icon(Iconsax.more_2),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => YourDMsScreen()),
                      );
                    },
                    icon: Icon(Icons.inbox_outlined),
                  ),
                ],
                title: Text(
                  "Your Profile",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: TabBarView(
                controller: _tabController, // Set the TabController
                children: [
                  // First tab view
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            child: Column(
                              children: [
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
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundImage: NetworkImage(controller.user['profilePhoto'] ?? ''),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  controller.user['name'] ?? 'No name set',
                                  style: TextStyle(
                                    fontFamily: 'MonaSansExtraBoldWideItalic',
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _showFollowingPopup(
                                              context,
                                              controller.user['followingList'],
                                            );
                                          },
                                          child: Text(
                                            controller.user['following'],
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'MonaSansExtraBoldWideItalic',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        const Text(
                                          'Following',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'MonaSansExtraBoldWideItalic',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 1,
                                      height: 15,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _showFollowerPopup(
                                              context,
                                              controller.user['followersList'],
                                            );
                                          },
                                          child: Text(
                                            controller.user['followers'],
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'MonaSansExtraBoldWideItalic',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        const Text(
                                          'Followers',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'MonaSansExtraBoldWideItalic',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 1,
                                      height: 15,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          profileController.user['thumbnails'].length.toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'MonaSansExtraBoldWideItalic',
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        const Text(
                                          'Videos',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'MonaSansExtraBoldWideItalic',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 1,
                                      height: 15,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          controller.user['likes'],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'MonaSansExtraBoldWideItalic',
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        const Text(
                                          'Likes',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'MonaSansExtraBoldWideItalic',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  controller.user['bio'] != null ? controller.user['bio'] : 'No bio set',
                                  style: TextStyle(
                                    fontFamily: 'MonaSansExtraBoldWideItalic',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  controller.user['username'] != null ? controller.user['username'] : 'No username set',
                                  style: TextStyle(
                                    fontFamily: 'MonaSansExtraBoldWideItalic',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.link,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            controller.user['website'] != null
                                                ? controller.user['website']
                                                : 'No website set',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context).colorScheme.background,
                                      ),
                                    ),
                                  ],
                                ),
                                if (controller.user['thumbnails'].isEmpty)
                                  Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Center(
                                      child: Text(
                                        'You have no posts! Get started by clicking the music icon in the top middle of your screen! or swipe left',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.user['thumbnails'].length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 5,
                                  ),
                                  itemBuilder: (context, index) {
                                    String thumbnail = controller.user['thumbnails'][index];

                                    // Reverse the order of thumbnails by accessing them from the end of the list
                                    // String reversedThumbnail = controller.user['thumbnails'][controller.user['thumbnails'].length - 1 - index];
                                    return FutureBuilder<PaletteGenerator>(
                                      future: generatePalette(thumbnail),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final color = snapshot.data!.dominantColor!.color;
                                          final averageColor = Color.fromRGBO(
                                            color.red,
                                            color.green,
                                            color.blue,
                                            0.1,
                                          );

                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ShowSingleVideo(
                                                    videoIndex: index,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Stack(
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: averageColor,
                                                  ),
                                                  child: Image.network(
                                                    controller.user['thumbnails'][index],
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Container();
                                          // Placeholder widget while loading palette
                                        }
                                      },
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Second tab view

                  CreateScreen(),

                  // Save the current date and time
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Trending Videos',
                          style: TextStyle(
                            fontFamily: 'MonaSansExtraBoldWideItalic',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('videos')
                              .where('saves', arrayContains: profileController.user['uid'])
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text('No videos found.'),
                              );
                            } else {
                              // Extract the list of video titles from the snapshot
                              List<String> videoTitles = snapshot.data!.docs.map((doc) => doc['id'] as String).toList();

                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: videoTitles.length,
                                itemBuilder: (context, index) {
                                  final videoId = videoTitles[index];
                                  final videoData = snapshot.data!.docs.firstWhere(
                                    (doc) => doc['id'] == videoId,
                                  );

                                  final thumbnailUrl = videoData['thumbnail'] as String;
                                  final caption = videoData['caption'] as String;

                                  return ListTile(
                                    leading: Image.network(thumbnailUrl),
                                    title: Text(
                                      caption.isNotEmpty ? caption : 'This video has no caption',
                                    ),
                                    onTap: () {
                                      // Open single video with the videoId
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ShowMoreVideo(
                                            videoId: videoId,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Text('Last updated: $currentTime'),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ));
  }

  Future<PaletteGenerator> generatePalette(String imageUrl) async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(NetworkImage(imageUrl));
    return paletteGenerator;
  }

  void _showFollowingPopup(BuildContext context, List<String> followingList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Following'),
          content: SingleChildScrollView(
            child: Column(
              children: followingList.map((user) {
                return ListTile(
                  title: Text(user),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(uid: user),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showFollowerPopup(BuildContext context, List<String> followersList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Followers'),
          content: SingleChildScrollView(
            child: Column(
              children: followersList.map((user) {
                return ListTile(
                  title: Text(user),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(uid: user),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
