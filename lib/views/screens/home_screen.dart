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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 2),
          child: GNav(
            gap: 8,
            onTabChange: (index) {
              setState(() {
                pageIdx = index;
              });
            },
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            color: Color.fromARGB(255, 0, 0, 0),
            activeColor: Color.fromARGB(255, 0, 0, 0),
            tabBackgroundColor: Color.fromARGB(255, 240, 240, 240),
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
      body: pages[pageIdx],
    );
  }
}
