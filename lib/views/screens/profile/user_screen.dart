import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/profile_controller.dart';
import 'package:vibe/views/screens/create_screen.dart';
import 'package:vibe/views/screens/profile/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibe/views/screens/profile/show_own_video_screen.dart';
import 'package:vibe/views/screens/profile/user_settings_screen.dart';
import 'package:vibe/views/screens/profile/your_dms_screen.dart';
import 'package:vibe/views/screens/video/show_video.dart';
import 'package:vibe/views/screens/video/show_single_video.dart';
import 'direct_message_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'dart:math';
import 'dart:ui';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class UserScreen extends StatefulWidget {
  const UserScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}
ThemeData themeData = isDarkTheme == false ? lightTheme : darkTheme;
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
    await profileController.getProfileData();
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
    // Check if startColor and endColor are null, then set them to grey
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

// Fetch user profile data on change
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUserProfile(); 
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
    String timeAgo = DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime);
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
        theme: themeData, 
        debugShowCheckedModeBanner: false,
        home: GetBuilder<ProfileController>(
          init: ProfileController(),
          builder: (controller) {
            return Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  controller: _tabController, 
                  labelColor: Theme.of(context).colorScheme.onBackground,
                  tabs: [
                    Tab(icon: Icon(Icons.person_2_outlined)),
                    Tab(
                      icon: Icon(FontAwesomeIcons.music),
                    ),
                    Tab(
                      icon: Icon(FontAwesomeIcons.thumbsUp),
                    ),
                  ],
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: _getTabIndicatorColor(), // Get the color based on the current tab
                      width: 3.0,
                    ),
                    insets: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
                leading: IconButton(
                  onPressed: () {
                    _openAnalyticsDialog();
                  },
                  icon: Icon(FontAwesomeIcons.chartLine),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      _navigateToUserSettingsScreen();
                    },
                    icon: Icon(FontAwesomeIcons.cogs),
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
                    fontFamily: 'MonaSans',
                    fontSize: 22.0,
                  ),
                ),
              ),
              body: TabBarView(
                controller: _tabController,
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
                                          if (controller.user['website'] != null &&
                                              controller.user['website'].isNotEmpty)
                                            Icon(
                                              Icons.link,
                                              color: Colors.blue,
                                            ),
                                          SizedBox(width: 4),
                                          if (controller.user['website'] != null &&
                                              controller.user['website'].isNotEmpty)
                                            Text(
                                              controller.user['website'] ?? '',
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
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 18.0),
                        child: Image.asset(
                          'assets/images/trending.png',
                          // width: 200,
                          // height: 200,
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
                                      style: TextStyle(
                                        fontFamily: 'MonaSansExtraBoldWideItalic',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: caption.isNotEmpty ? FontStyle.italic : FontStyle.normal,
                                        color: caption.isNotEmpty ? Colors.grey[300] : Colors.grey[800],
                                      ),
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
                        child: Text('Last updated: $timeAgo', style: TextStyle(fontFamily: 'MonaSans')),
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

  void _openAnalyticsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          content: Container(
            width: double.maxFinite,
            height: 300, // Adjust the height as needed
            child: Column(
              children: [
                Text(
                  'Profile views in last 24 hours',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'MonaSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: charts.LineChart(
                    _createSampleData(), // Replace with your own data
                    animate: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      LinearSales(0, 0),
      LinearSales(1, 0),
      LinearSales(2, 0),
      LinearSales(3, 0),
      LinearSales(4, 0),
      LinearSales(5, 0),
      LinearSales(6, 0),
      LinearSales(7, 0),
      LinearSales(8, 0),
      LinearSales(9, 0),
      LinearSales(10, 0),
      LinearSales(11, 0),
      LinearSales(12, 3),
      LinearSales(13, 4),
      LinearSales(14, 5),
      LinearSales(15, 0),
      LinearSales(16, 0),
      LinearSales(17, 0),
      LinearSales(18, 0),
      LinearSales(19, 0),
      LinearSales(20, 0),
      LinearSales(21, 0),
      LinearSales(22, 0),
      LinearSales(23, 0),
      LinearSales(24, 0),
    ];

    return [
      charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      ),
    ];
  }
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
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
