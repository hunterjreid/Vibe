import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/profile_controller.dart';
import 'package:vibe/views/screens/show_single_video.dart';
import 'package:vibe/views/screens/userSettings_screen.dart';
import 'direct_message_screen.dart';



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

Color generateRandomColor() {
  Random random = Random();
  int alpha = 255; // You can adjust the alpha value (transparency) if needed

  int red = random.nextInt(256); // Random red value between 0 and 255
  int green = random.nextInt(256); // Random green value between 0 and 255
  int blue = random.nextInt(256); // Random blue value between 0 and 255

  return Color.fromARGB(alpha, red, green, blue);
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());
  Color randomColor1 = generateRandomColor();
  Color randomColor2 = generateRandomColor();

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        if (controller.user.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black12,
            leading: const Icon(
              Icons.person_add_alt_1_outlined,
            ),
            actions: [
              if (widget.uid == authController.user.uid)
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserSettingsScreen(),
                      ),
                    );
                  },
                ),
              Icon(Icons.more_horiz),
            ],
            title: Text(
              controller.user['name'] + " (" + widget.uid + ")",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: SafeArea(
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
              placeholder: (context, url) =>
                  const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 15,
      ),
      const SizedBox(height: 10),
      Text(
        controller.user['bio'] ?? '', // Add null check and provide a default value
        style: const TextStyle(
          fontSize: 16,
             color: Colors.white,
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
                              color: Colors.black54,
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
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Followers',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              color: Colors.black54,
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
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Likes',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: 160,
                          height: 87,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (widget.uid ==
                                        authController.user.uid) {
                                      authController.signOut();
                                    } else {
                                      controller.followUser();
                                    }
                                  },
                                  child: Text(
                                    widget.uid == authController.user.uid
                                        ? 'Sign Out'
                                        : controller.user['isFollowing']
                                            ? 'Unfollow'
                                            : 'Follow',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
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
                                          builder: (context) =>
                                              DirectMessageScreen(
                                                  recipientUID: widget.uid),
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

                        // video list
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.user['thumbnails'].length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 5,
                          ),
                          itemBuilder: (context, index) {
                            String thumbnail =
                                controller.user['thumbnails'][index];
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
                  Text(
                    'This user has uploaded ${controller.user['thumbnails'].length} videos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the home screen
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Text(
                      'Go Back Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
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
