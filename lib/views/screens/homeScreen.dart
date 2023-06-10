import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe/controllers/video_controller.dart';
import 'package:vibe/views/screens/notification_screen.dart';
import 'package:vibe/views/screens/searchOld_screen.dart';
import 'package:vibe/views/screens/show_single_video.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VideoController _videoController = Get.put(VideoController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          automaticallyImplyLeading: false, // Remove the default back button
          titleSpacing: 0, // Remove the default padding around the title
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchOldScreen(),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    // Handle search submission
                  },
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Obx(
          () => GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: _videoController.videoList.length,
            itemBuilder: (context, index) {
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
                    _videoController.buildVideoThumbnail(index),
                    Positioned(
                      top: 8,
                      right: 8,
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
      ),
    );
  }
}
