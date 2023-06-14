import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/search_controller.dart';
import 'package:vibe/models/user.dart';
import 'package:vibe/views/screens/profile_screen.dart';

import 'package:vibe/controllers/share_video_dm_controller.dart';
import 'direct_message_screen.dart';

class FriendSearchPage extends StatelessWidget {
  final SearchController searchController = SearchController();
  final ShareVideoDMController shareVideoDMController = ShareVideoDMController();

  final String videoId;

  FriendSearchPage({Key? key, required this.videoId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          decoration: const InputDecoration(
            filled: false,
            hintText: 'Search',
            hintStyle: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          onFieldSubmitted: (value) => searchController.searchUser(value),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (searchController.searchedUsers.isEmpty) {
          return Column(
            children: [
              const Center(
                child: Text(
                  'Search for person to share video too..',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        } else {
          return ListView.builder(
            itemCount: searchController.searchedUsers.length,
            itemBuilder: (context, index) {
              User user = searchController.searchedUsers[index];
              return InkWell(
                onTap: () {
                  print(videoId);
                  shareVideoDMController.sendMessage(user.uid, videoId);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DirectMessageScreen(recipientUID: user.uid, senderUID: authController.user.uid,),
                    ),
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      user.profilePhoto,
                    ),
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
