import 'package:flutter/material.dart';
import 'package:vibe/controllers/search_controller.dart';
import 'package:get/get.dart';
import 'package:vibe/models/user.dart';
import 'package:vibe/views/screens/profile_screen.dart';
import 'package:vibe/constants.dart';

class SearchOldScreen extends StatelessWidget {
  SearchOldScreen({Key? key}) : super(key: key);

  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = isDarkTheme == false ? lightTheme : darkTheme;
    return Theme(
      data: themeData,
      child: Scaffold(
        appBar: AppBar(
          title: TextFormField(
            decoration: const InputDecoration(
              filled: false,
              hintText: 'Search',
              hintStyle: TextStyle(
                fontSize: 18,
                fontFamily: 'MonaSansExtraBoldWideItalic',
              ),
            ),
            onFieldSubmitted: (value) => searchController.searchUser(value),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          return searchController.searchedUsers.isEmpty
              ? Column(
                  children: [
                    const Center(
                      child: Text(
                        'Search for users!',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'MonaSansExtraBoldWideItalic',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  itemCount: searchController.searchedUsers.length,
                  itemBuilder: (context, index) {
                    User user = searchController.searchedUsers[index];
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(uid: user.uid),
                        ),
                      ),
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
                            fontFamily: 'MonaSansExtraBoldWideItalic',
                          ),
                        ),
                      ),
                    );
                  },
                );
        }),
      ),
    );
  }
}
