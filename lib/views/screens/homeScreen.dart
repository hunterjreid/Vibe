import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe/controllers/video_controller.dart';
import 'package:vibe/controllers/search_controller.dart';
import 'package:vibe/models/user.dart';
import 'package:vibe/views/screens/show_single_video.dart';
import 'package:vibe/views/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final VideoController _videoController = Get.put(VideoController());
  final SearchController _searchController = Get.put(SearchController());
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchQueryController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchQueryController.addListener(_onSearchQueryChanged);
  }

  void _onSearchQueryChanged() {
    setState(() {
      if (_searchQueryController.text.isEmpty) {
        _isSearching = false;
        _searchController.searchedUsers.clear();
      } else {
        _isSearching = true;
        _performSearch(_searchQueryController.text);
      }
    });
  }

  void _performSearch(String query) {
    _searchController.searchUser(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  automaticallyImplyLeading: false,
  titleSpacing: 0,
  title: Row(
    children: [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          // Perform search action
        },
      ),
      Expanded(
        child: TextFormField(
          controller: _searchQueryController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(
              fontSize: 18,
              fontFamily: 'MonadsSans',
            ),
          ),
        ),
      ),
    ],
  ),
  actions: [
    IconButton(
      icon: Icon(Icons.notifications),
      onPressed: () {
        // Handle notifications
      },
    ),
  ],
), body: !_isSearching || _searchQueryController.text.isEmpty
          ? Center(
              child: Obx(
                () => GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: _videoController.videoList.length,
                  itemBuilder: (context, index) {
                    final reversedIndex =
                        _videoController.videoList.length - 1 - index;
                    final video = _videoController.videoList[reversedIndex];

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
                      child: Stack(
                        children: [
                          _videoController.buildVideoThumbnail(reversedIndex),
                          Positioned(
                            bottom: 0.0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.visibility,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '0',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          : Obx(
              () => _searchController.searchedUsers.isEmpty
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
                      itemCount: _searchController.searchedUsers.length,
                      itemBuilder: (context, index) {
                        User user = _searchController.searchedUsers[index];
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
                                fontFamily: 'MonaSansExtraBoldWideItalic',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
