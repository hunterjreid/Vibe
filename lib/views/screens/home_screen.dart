import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe/controllers/video_controller.dart';
import 'package:vibe/controllers/search_controller.dart';
import 'package:vibe/models/user.dart';
import 'package:vibe/views/screens/misc/notification_screen.dart';
import 'package:vibe/views/screens/misc/searchOld_screen.dart';

import 'package:vibe/views/screens/profile/profile_screen.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:vibe/views/screens/video/show_single_video.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final VideoController _videoController = Get.put(VideoController());
  final SearchController _searchController = Get.put(SearchController());
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _searchQueryController.dispose();
    _overlayEntry?.remove();
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

  Future<PaletteGenerator> generatePalette(String imageUrl) async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(NetworkImage(imageUrl));
    return paletteGenerator;
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchOldScreen(),
                  ),
                );
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          !_isSearching || _searchQueryController.text.isEmpty
              ? Obx(
                  () => GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                    ),
                    itemCount: _videoController.videoList.length,
                    itemBuilder: (context, index) {
                      final reversedIndex = _videoController.videoList.length - 1 - index;
                      final video = _videoController.videoList[index];

                      return FutureBuilder<PaletteGenerator>(
                        future: generatePalette(video.thumbnail),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final color = snapshot.data!.dominantColor!.color;
                            final averageColor = Color.fromRGBO(
                              color.red,
                              color.green,
                              color.blue,
                              0.1,
                            );

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
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: averageColor,
                                    ),
                                    child: Image.network(
                                      _videoController.videoList[index].thumbnail,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 8),
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.visibility,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            video.views.toString(),
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
                          } else {
                            return Container();
                            // Placeholder widget while loading palette
                          }
                        },
                      );
                    },
                  ),
                )
              : ListView.builder(
                  itemCount: _searchController.searchedUsers.length,
                  itemBuilder: (context, index) {
                    User user = _searchController.searchedUsers[index];
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
                ),
        ],
      ),
    );
  }
}
