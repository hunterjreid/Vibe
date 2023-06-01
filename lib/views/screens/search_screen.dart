import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe/controllers/search_controller.dart';
import 'package:vibe/controllers/auth_controller.dart';
import 'package:vibe/models/user.dart';
import 'package:vibe/views/screens/add_video_screen.dart';
import 'package:vibe/views/screens/profile_screen.dart';
import 'package:vibe/constants.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);



    final SearchController searchController = Get.put(SearchController());


  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchController>(
      builder: (controller) {
        return DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: TextFormField(
                decoration: const InputDecoration(
                  filled: false,
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                onFieldSubmitted: (value) {
                  print("Search value: $value");
                  searchController.searchUser(value);
                },
              ),
              centerTitle: true,
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.home),
                    text: 'Home',
                  ),
                  Tab(
                    icon: Icon(Icons.explore),
                    text: 'Explore',
                  ),
                  Tab(
                    icon: Icon(Icons.favorite),
                    text: 'Favorites',
                  ),
                  Tab(
                    icon: Icon(Icons.person),
                    text: 'Profile',
                  ),
                  Tab(
                    icon: Icon(Icons.settings),
                    text: 'Settings',
                  ),
                ],
              ),
            ),
            body: searchController.searchedUsers.isEmpty
                ? Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFE68EDC),
                          Color(0xFFA61988),
                        ],
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: TabBarView(
                      children: [
                        // Home Tab
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.ac_unit),
                              Text(
                                'Home Content',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Button'),
                              ),
                            ],
                          ),
                        ),

                        // Explore Tab
                        Center(
                          child: GridView.count(
                            crossAxisCount: 4,
                            children: List.generate(18, (index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Item ${index + 1}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        // Favorites Tab
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite),
                              Text(
                                'Favorites Content',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Profile Tab
                        ListView.builder(
                          itemCount: searchController.searchedUsers.length,
                          itemBuilder: (context, index) {
                            User user = searchController.searchedUsers[index];
                              print("itemBuilder: $index");
                            if (user != null) {
                            
                              return InkWell(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileScreen(uid: user.uid),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    user.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container(); // or some other fallback widget
                            }
                          },
                        ),

                        // Settings Tab
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.settings),
                              Text(
                                'Settings Content',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              CheckboxListTile(
                                value: true,
                                onChanged: (value) {},
                                title: Text('Setting 1'),
                              ),
                              CheckboxListTile(
                                value: false,
                                onChanged: (value) {},
                                title: Text('Setting 2'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: searchController.searchedUsers.length,
                    itemBuilder: (context, index) {
                      User user = searchController.searchedUsers[index];
                      if (user != null) {
                        return InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(uid: user.uid),
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
                      } else {
                        return Container(); // or some other fallback widget
                      }
                    },
                  ),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(uid: authController.user.uid),
                    ),
                  ),
                  label: Text(
                    'View your profile',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  backgroundColor: Color(0xFFAF1388),
                ),
                SizedBox(width: 16),
                FloatingActionButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddVideoScreen(),
                    ),
                  ),
                  backgroundColor: Colors.black,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: Colors.purple,
                      width: 2.0,
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        );
      },
    );
  }
}
