import 'package:flutter/material.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/video_controller.dart';
import 'package:vibe/views/screens/comment_screen.dart';
import 'package:vibe/views/screens/profile_screen.dart';
import 'package:vibe/views/screens/usesong_screen.dart';
import 'package:vibe/views/widgets/circle_animation.dart';
import 'package:vibe/views/widgets/video_player_item.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';


class VideoScreen extends StatelessWidget {
  VideoScreen({Key? key}) : super(key: key);

  

  bool _isSaved = false;
  final VideoController videoController = Get.put(VideoController());

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

  buildMusicAlbum(BuildContext context, String profilePhoto) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UseSongScreen(),
      )),
      child: SizedBox(
        width: 60,
        height: 60,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(11),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Colors.grey,
                    Colors.white,
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Obx(() {
          final currentVideo =
              videoController.videoList[videoController.currentPage.value];

          return Text(
            currentVideo.caption,
            style: const TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
            ),
          );
        }),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Container(
          color: Color.fromARGB(255, 255, 255, 255),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'VIBE MENU 🔮⚡\nFEEL THE V I B E S\n© Hunter Reid\nYOOBEE ID: 270098454',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              buildMenuItem(
                title: 'Settings',
                gradientColors: [Colors.purple, Colors.blue],
                onTap: () {
                  // Handle Settings tap
                },
              ),
              buildMenuItem(
                title: 'Careers',
                gradientColors: [Colors.purple, Colors.blue],
                onTap: () {
                  // Handle Career Help tap
                },
              ),
              buildMenuItem(
                title: 'Help',
                gradientColors: [Colors.purple, Colors.blue],
                onTap: () {
                  // Handle Career Help tap
                },
              ),
              buildMenuItem(
                title: 'About Us',
                gradientColors: [Colors.purple, Colors.blue],
                onTap: () {
                  // Handle About Us tap
                },
              ),
    
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: Obx(() {
              return SingleChildScrollView(
                child: SizedBox(
                  height: size.height * .75,
                  child:PageView.builder(
  itemCount: videoController.videoList.length,
  controller: PageController(initialPage: 0, viewportFraction: 1),
  scrollDirection: Axis.vertical,
  onPageChanged: (index) {
    videoController.currentPage.value = index;
  },
  itemBuilder: (context, index) {
    final data = videoController.videoList[index];
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(5.0),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: VideoPlayerItem(
              videoUrl: data.videoUrl,
            ),
          ),
        ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 0,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfileScreen(
                                                            uid: data.uid),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                data.username,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              data.caption,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.music_note,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                                
                                                   InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UseSongScreen(),
      )),
      child: 
                                                Text(
                                                  data.songName,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                   )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      //  width: 100,
                                      // margin: EdgeInsets.only(top: size.height / 5),
                                      margin: EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfileScreen(
                                                              uid: data.uid),
                                                    ),
                                                  );
                                                },
                                                child: Column(
                                                  children: [
                                                    buildProfile(
                                                        data.profilePhoto),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () => videoController
                                                        .likeVideo(data.id),
                                                    child: Icon(
                                                      Icons.favorite,
                                                      size: 45,
                                                      color: data.likes
                                                              .contains(
                                                                  authController
                                                                      .user.uid)
                                                          ? Color.fromARGB(
                                                              255, 44, 113, 179)
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    data.likes.length
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () =>
                                                        Navigator.of(context)
                                                            .push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CommentScreen(
                                                          id: data.id,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Icon(
                                                      Icons.comment,
                                                      size: 45,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    data.commentCount
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      _showShareOptions(
                                                          context);
                                                    },
                                                    child: Icon(
                                                      Icons.share,
                                                      size: 45,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    data.shareCount.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "Video saved"),
                                                            content: Text(
                                                                "Your video has been saved to your saved folder."),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child:
                                                                    Text("OK"),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Icon(
                                                      _isSaved
                                                          ? Icons.folder_open
                                                          : Icons.folder,
                                                      size: 30,
                                                      color: _isSaved
                                                          ? Colors.purple
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "Save",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Icon(
                                                      Icons.upload,
                                                      size: 30,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "Repost",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          CircleAnimation(
                                            child: buildMusicAlbum(
                                                context, data.profilePhoto),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                        ],
                        
                      );
                      
                    },
                    
                  ),
                  
                ),
                
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required String title,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _showShareOptions(BuildContext context) {
    Share.share('Check out this video on vibe!', subject: 'Look what I made!');
  }
}
