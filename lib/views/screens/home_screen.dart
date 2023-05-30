import 'package:flutter/material.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/views/widgets/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 0;
  int feedNotificationCount = 2; // Notification count for Feed
  int homeNotificationCount = 4; // Notification count for Home

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.black,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          child: 
          
          
          
          
          
          
          BottomNavigationBar(
            backgroundColor: Color.fromRGBO(253, 252, 252, 1),
            selectedItemColor: Color.fromARGB(255, 0, 0, 0),
            unselectedItemColor: Color.fromARGB(255, 0, 0, 0),
         selectedLabelStyle: TextStyle(
    fontWeight: FontWeight.w400,
       fontFamily: 'MonaSansExtraBoldWideItalic',
  ),
  unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
     fontFamily: 'MonaSans',
  ),
            currentIndex: pageIdx,
            onTap: (index) {
              setState(() {
                pageIdx = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    Icon(
                      Icons.animation_rounded,
                      size: 38, // Adjust the icon size here
                    ),
                    if (feedNotificationCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                              color: Color.fromARGB(255, 245, 34, 19),
                          ),
                          child: Text(
                            
                            feedNotificationCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,

                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Feed',
                
              ),
              BottomNavigationBarItem(
          


                icon: Stack(
                  children: [
                    Icon(
                      Icons.home,
                      size: 38, // Adjust the icon size here
                    ),
                    if (homeNotificationCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 245, 34, 19),
                          ),
                          child: Text(
                            homeNotificationCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.create,
                  size: 38, // Adjust the icon size here
                ),
                label: 'Create',
              ),
            ],
          ),
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
        ),
      ),
      body: pages[pageIdx],
    );
  }
}
