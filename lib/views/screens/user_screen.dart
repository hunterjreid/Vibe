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
import 'package:vibe/views/screens/your_dms_screen.dart';
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

class _UserScreenState extends State<UserScreen> with SingleTickerProviderStateMixin {
  final ProfileController profileController = Get.put(ProfileController());
  late TabController _tabController;
   List<Color> tabColors = [
    Colors.purple, // Leftmost color
    Colors.blue, // Rightmost color
    Colors.blue.withOpacity(0.5), // Middle color
  ];

  Color randomColor1 = Colors.blue;
  Color randomColor2 = Color.fromARGB(255, 243, 33, 233);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

// Update the colors when returning from the UserSettingsScreen
void _navigateToUserSettingsScreen() async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UserSettingsScreen(
        startColor: randomColor1,
        endColor: randomColor2,
        onSaveChanges: _updateColors,
      ),
    ),
  );
}


void _updateColors(Color startColor, Color endColor) {
  setState(() {
    randomColor1 = startColor;
    randomColor2 = endColor;
  });
}


// Navigate to the UserSettingsScreen and handle the returned colors


@override
void didChangeDependencies() {
  super.didChangeDependencies();


}

   void _tabControllerListener() {
    setState(() {}); // Update the state when the tab changes
  }


  @override
  void dispose() {
    _tabController.dispose();
     profileController.updateUserId(widget.uid);
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
            if (controller.user.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  controller: _tabController, // Set the TabController
                  labelColor: Theme.of(context).colorScheme.onBackground,
                  tabs: [
                    Tab(icon: Icon(Icons.person_2_outlined)),
                    Tab(icon: Icon(Icons.music_note)),
                    Tab(icon: Icon(Icons.save_outlined)),
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
  icon: Icon(Icons.edit_document),
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
                                ),       const SizedBox(height: 6.0),
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
                                  Icon(
      Icons.edit,
      color: Colors.blue,
    ),
                                Text(
                                  profileController.user['username'] ?? 'No bio set',
                                  
                                  style: TextStyle(
                                    fontFamily: 'MonaSansExtraBoldWideItalic',
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  
                                ),
                                const SizedBox(height: 6.0),
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
                                const SizedBox(height: 3),
                       
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background, // Choose your desired background color
                                      ),
                                   
                                    ),
                          
                                  ],
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
                 

      CreateScreen(),


    // Save the current date and time

                 
                  // Third tab view
    Column(
        children: [
             Text('YOUR SAVED VIDEOS!'),
          // Display the list of titles
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: titles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(titles[index]),
                );
              },
            ),
          ),
          // Display the saved date and time
          Text('Last updated: $currentTime'),
        ],
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
