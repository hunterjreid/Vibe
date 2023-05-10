import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/views/widgets/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20),
          child: GNav(
            gap: 8,
            onTabChange: (index) {
              setState(() {
                pageIdx = index;
              });
            },
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            color: Color.fromARGB(255, 0, 0, 0),
            activeColor: Colors.black,
            tabBackgroundColor: Color.fromARGB(255, 250, 250, 250),
            tabs: [
              GButton(
                icon: Icons.explore,
                text: 'Feed',
              ),
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.create,
                text: 'Create',
              ),
            ],
          ),
        ),
      ),

      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: (idx) {
      //     setState(() {
      //       pageIdx = idx;
      //     });
      //   },
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: backgroundColor,
      //   selectedItemColor: Color.fromARGB(255, 214, 40, 147),
      //   unselectedItemColor: Colors.white,
      //   currentIndex: pageIdx,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home, size: 30),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search, size: 30),
      //       label: 'Search',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: CustomIcon(),
      //       label: '',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.message, size: 30),
      //       label: 'Messages',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person, size: 30),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
      body: pages[pageIdx],
    );
  }
}
