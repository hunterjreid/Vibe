import 'package:flutter/material.dart';
import 'package:vibe/controllers/search_controller.dart';
import 'package:get/get.dart';
import 'package:vibe/models/user.dart';
import 'package:vibe/views/screens/profile_screen.dart';
import 'package:vibe/constants.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 44, 113, 179),
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
          actions: [],
          centerTitle: true, // added this line to center the title
        ),
        body: searchController.searchedUsers.isEmpty
            ? Column(
                children: [
                  const Center(
                    child: Text(
                      'Search for users!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: Center(
          // added this Center widget to center the button
          child: TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(uid: authController.user.uid),
              ),
            ),
            child: const Text(
              'or View your profile here',
              style: TextStyle(
                fontSize: 26,
                color: Color.fromARGB(255, 175, 19, 136),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation
            .centerFloat, // added this line to position the button in the center
      );
    });
  }
}
