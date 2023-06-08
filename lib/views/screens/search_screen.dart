import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/profile_controller.dart';
import 'package:vibe/views/screens/notification_screen.dart';
import 'package:vibe/views/screens/profile_screen.dart';
import 'package:vibe/views/screens/searchOld_screen.dart';
import 'package:vibe/views/screens/settings_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

    final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SearchOldScreen(),
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(uid: authController.user.uid),
                      ),
                    );
                  },
              child: 
  
   CircleAvatar(
  radius: 16,
  backgroundImage: profileController.user['profilePhoto'] != null
      ? CachedNetworkImageProvider(profileController.user['profilePhoto'])
      : null,
  child: profileController.user['profilePhoto'] == null
      ? CircularProgressIndicator()
      : null,
),

     ),
              ],
            ),
             Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(8.0),
        ),
        child: profileController.user['name'] != null
  ? Text(
      profileController.user['name'],
      style: TextStyle(
        fontFamily: 'MonaSansExtraBoldWideItalic',
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
      ),
    )
  : CircularProgressIndicator(),
      ),
    ),
 
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.group, size: 24),
                      child: Text(
                        'Friends',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MonaSansExtraBoldWideItalic',
                        ),
                      ),
                    ),
                    Tab(
                      icon: Icon(Icons.explore, size: 24),
                      child: Text(
                        'Explore',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MonaSansExtraBoldWideItalic',
                        ),
                      ),
                    ),
                    Tab(
                      icon: Icon(Icons.trending_up, size: 24),
                      child: Text(
                        'Trending',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MonaSansExtraBoldWideItalic',
                        ),
                      ),
                    ),
                    Tab(
                      icon: Icon(Icons.favorite, size: 24),
                      child: Text(
                        'Favorites',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MonaSansExtraBoldWideItalic',
                        ),
                      ),
                    ),
                    Tab(
                      icon: Icon(Icons.file_copy, size: 24),
                      child: Text(
                        'Saved',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MonaSansExtraBoldWideItalic',
                        ),
                      ),
                    ),
                  ],
                  unselectedLabelColor: Color.fromARGB(255, 175, 45, 121),
                  labelColor: Color.fromARGB(255, 174, 0, 255),
                  indicatorColor: Color.fromARGB(255, 40, 140, 233),
                ),
              ),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(28, 255, 255, 255),
                Color.fromARGB(29, 58, 58, 58),
              ],
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: TabBarView(
            children: [
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.group,
                        size: 64,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Your Friends Content',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        child: Text('View Friends List'),
                      ),
                      SizedBox(height: 32),
                      Container(
                        height: 300,
                        width: double.infinity,
                        child: Placeholder(color: Colors.blueGrey,),
                      ),
                      SizedBox(height: 32),
                      Text(
                        'Your Friend Requests',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 200,
                        width: double.infinity,
                        child: Placeholder(),
                      ),
                      SizedBox(height: 32),
                      Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 400,
                        width: double.infinity,
                        child: Placeholder(),
                      ),
                      SizedBox(height: 32),
                      Text(
                        'Suggested Friends',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 200,
                        width: double.infinity,
                        child: Placeholder(),
                      ),
                      SizedBox(height: 32),
                      Text(
                        'Friend Activity',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 400,
                        width: double.infinity,
                        child: Placeholder(),
                      ),
                    ],
                  ),
                ),
              ),

              // Explore Tab
              Center(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(58, (index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Other persons video #${index + 1}',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'MonaSansExtraBoldWideItalic',
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              SingleChildScrollView(
                child:
                    // Trending Tab
                    Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 64,
                        color: Colors.orange,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Trending Content',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      // Placeholder for a carousel of trending videos
                      Container(
                        height: 200,
                        width: double.infinity,
                        child: Placeholder(),
                      ),
                      SizedBox(height: 32),
                      Text(
                        'Popular Posts',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      // Placeholder for a list of popular posts
                      Container(
                        height: 400,
                        width: double.infinity,
                        child: Placeholder(),
                      ),
                      SizedBox(height: 32),
                      Text(
                        'Trending Hashtags',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      // Placeholder for a grid of trending hashtags
                      Container(
                        height: 200,
                        width: double.infinity,
                        child: Placeholder(),
                      ),
                    ],
                  ),
                ),
              ),

              // Favorites Tab
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 64,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Favorites Content',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          labelText: 'Search',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          // Handle search functionality
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: () {
                        // Handle filter functionality
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),

              // Profile Tab
              Center(
                child: ListView.builder(
                  itemCount: 10, // Replace with the actual number of items in your list
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.video_file),
                      title: Text(
                        'Item $index',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Description of Item $index',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        // Handle item tap
                        print('Item $index tapped');
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

