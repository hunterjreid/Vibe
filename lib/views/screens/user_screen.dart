import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/profile_controller.dart';
import 'package:vibe/views/screens/createScreen.dart';
import 'package:vibe/views/screens/profile_screen.dart';
import 'package:vibe/views/screens/show_own_video_screen.dart';
import 'package:vibe/views/screens/show_single_video.dart';
import 'package:vibe/views/screens/userSettings_screen.dart';
import 'direct_message_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:math';
import 'dart:ui';

class UserScreen extends StatefulWidget {
  final String uid;

  const UserScreen({
    Key? key,
    required this.uid,
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

class _UserScreenState extends State<UserScreen>
    with SingleTickerProviderStateMixin {
  final ProfileController profileController = Get.put(ProfileController());
  late TabController _tabController;

   Color randomColor1 =  Colors.blue;
  Color randomColor2 = Color.fromARGB(255, 243, 33, 233);


  @override
  void initState() {
    super.initState();
    profileController.updateUserId(widget.uid);
    _tabController = TabController(length: 3, vsync: this);
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
      theme: themeData , // Apply dark theme
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
    
            bottom: TabBar(
              controller: _tabController, // Set the TabController
              labelColor:   Theme.of(context).colorScheme.onBackground,
      tabs: [
                  Tab(icon: Icon(Icons.verified_user)),
                  Tab(icon: Icon(Icons.explore)),
                  Tab(icon: Icon(Icons.notifications)),
                ],
            ),
            actions: [

              Icon(Icons.report),
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
                                    imageUrl: controller.user['profilePhoto'],
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
                              profileController.user['name'],
                              style: TextStyle(
                                fontFamily: 'MonaSansExtraBoldWideItalic',
                                fontSize: 42.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                             const SizedBox(height: 16.0),
                        ElevatedButton(
                          child: const Text('Create'),
                          onPressed: () {
                            // Handle navigation to create screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateScreen(),
                              ),
                            );
                          },
                        ),
                            const SizedBox(
                              height: 15,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              controller.user['bio'] ?? 'No bio set',
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
                                  controller.user['website'] ?? 'No website set',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
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
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Following',
                                      style: TextStyle(
                                        fontSize: 14,
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
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.background, // Choose your desired background color
      ),
      child: ElevatedButton(
        onPressed: () {
          controller.followUser();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          elevation: MaterialStateProperty.all<double>(0),
        ),
        child: Text(
          controller.user['isFollowing'] ? 'Unfollow' : 'Follow',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Choose your desired text color
          ),
        ),
      ),
    ),
    SizedBox(width: 8),
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
    color: Theme.of(context).colorScheme.background, // Choose your desired background color
      ),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DirectMessageScreen(
                recipientUID: widget.uid,
              ),
            ),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          elevation: MaterialStateProperty.all<double>(0),
        ),
        child: Text(
          'Send Direct Message',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Choose your desired text color
          ),
        ),
      ),
    ),
  ],
),

                                    if (widget.uid != authController.user.uid)
                            Container(
                              width: 160,
                              height: 87,
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                            
                                    InkWell(
                                      onTap: () {
                               
                                          controller.followUser();
                                      
                                      },
                                      child: Text(
                              
                                            controller.user['isFollowing']
                                                ? 'Unfollow'
                                                : 'Follow',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                               fontFamily: 'MonaSansExtraBoldWideItalic',
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    if (widget.uid != authController.user.uid)
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DirectMessageScreen(recipientUID: widget.uid),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'OPEN DIRECT MESSAGE',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
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
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShowOwnVideo(
                                          videoIndex: index,
                                        ),
                                      ),
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: thumbnail,
                                    fit: BoxFit.cover,
                                  ),
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
       Center(
  child: Text(
    'User\'s Long Description',
    // Replace 'User\'s Long Description' with the actual user's long description
    style: TextStyle(fontSize: 16),
  ),
),
              // Third tab view
            Center(
  child: ElevatedButton(
    onPressed: () {
      // Handle turn on push notifications button tap
    },
    child: Text('Turn On Push Notifications'),
  ),
),
            ],
          ),
           );
      },
      )
    );
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
