import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/profile_controller.dart';
import 'package:vibe/controllers/video_controller.dart';
import 'package:vibe/views/screens/profile/direct_message_screen.dart';

import 'package:vibe/views/screens/profile/show_own_video_screen.dart';

import 'package:palette_generator/palette_generator.dart';
import 'package:vibe/views/screens/video/show_single_video.dart';



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibe/views/screens/profile/user_screen.dart';
import 'dart:math';
import 'dart:ui';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
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

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  final ProfileController profileController = Get.put(ProfileController());
  late TabController _tabController;

  Color randomColor1 = Colors.blue;
  Color randomColor2 = Color.fromARGB(255, 243, 33, 233);

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(widget.uid);
    _tabController = TabController(length: 2, vsync: this);
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
            if (controller.user.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                bottom: TabBar(
                  controller: _tabController, // Set the TabController
                  labelColor: Theme.of(context).colorScheme.surface,
                  tabs: [
                    Tab(icon: Icon(Icons.person_2_outlined)),
                    Tab(icon: Icon(Icons.more)),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.report),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Report Profile'),
                            content: Text('Are you sure you want to report this profile?'),
                            actions: <Widget>[
                              ElevatedButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                child: Text('Report'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // ...
                                  // Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DirectMessageScreen(
                            recipientUID: widget.uid,
                            senderUID: authController.user.uid,
                          ),
                        ),
                      );
                    },
                  ),
                ],
                title: Text(
                  controller.user['name'],
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
                          if (widget.uid == authController.user.uid)
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const UserScreen()),
                                );
                              },
                              child: Text('You are viewing your own profile'),
                            ),
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
                                            randomColor1,
                                            randomColor2,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                    ),
                                    ClipOval(
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: profileController.user['profilePhoto'],
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
                                const SizedBox(height: 6.0),
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
                                              profileController.user['followersList'],
                                            );
                                          },
                                          child: Text(
                                            profileController.user['followers'],
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
                                          controller.user['thumbnails'].length.toString(),
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
                                  profileController.user['name'] ?? 'No bio set',
                                  style: TextStyle(
                                    fontFamily: 'MonaSansExtraBoldWideItalic',
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  controller.user['bio'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.link,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      controller.user['website'] ?? '',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                if (widget.uid != authController.user.uid)
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            controller.followUser();
                                          },
                                          child: Container(
                                            width: 120,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: controller.user['isFollowing']
                                                    ? [Colors.red, Colors.pink]
                                                    : [
                                                        Color.fromARGB(255, 41, 104, 43),
                                                        Color.fromARGB(255, 74, 110, 33)
                                                      ],
                                              ),
                                              border: Border.all(),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Text(
                                                controller.user['isFollowing'] ? 'Unfollow' : 'Follow',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'MonaSansExtraBoldWideItalic',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(
                                  height: 25,
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
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Second tab view
                  Center(
                    child: Text(profileController.user['longBio']),
                  ),
                  // Third tab view
                ],
              ),
            );
          },
        ));
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

  Future<PaletteGenerator> generatePalette(String imageUrl) async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(NetworkImage(imageUrl));
    return paletteGenerator;
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
