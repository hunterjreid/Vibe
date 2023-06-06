import 'package:flutter/material.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/views/screens/profile_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileScreen(uid: authController.user.uid),
      ),
    );
  },
  child: CircleAvatar(
    radius: 30,
    backgroundImage: AssetImage('assets/profile_picture.jpg'),
  ),
),
SizedBox(width: 16),
GestureDetector(
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileScreen(uid: authController.user.uid),
      ),
    );
  },
  child: Text(
    'HUNTER',
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      fontFamily: 'MonaSansExtraBoldWide',
    ),
  ),
),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Perform search operation
                    print("Search button pressed");
                  },
                ),
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    // Perform notifications action
                    print("Notifications button pressed");
                  },
                ),
              ],
            ),
          ],
          bottom: TabBar(
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
    unselectedLabelColor: Color.fromARGB(255, 175, 45, 121), // Customize the color of unselected tabs
    labelColor: Color.fromARGB(255, 174, 0, 255), // Customize the color of the selected tab
    indicatorColor: Color.fromARGB(255, 40, 140, 233), // Customize the color of the tab indicator
  ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(28, 230, 142, 220),
                Color.fromARGB(29, 166, 25, 135),
              ],
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: TabBarView(
            children: [
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

              // Your Friends Tab
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.group),
                    Text(
                      'Your Friends Content',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'MonaSansExtraBoldWideItalic',
                      ),
                    ),
                  ],
                ),
              ),

              // Trending Tab
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.trending_up),
                    Text(
                      'Trending Content',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'MonaSansExtraBoldWideItalic',
                      ),
                    ),
                  ],
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
                        fontFamily: 'MonaSansExtraBoldWideItalic',
                      ),
                    ),
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
