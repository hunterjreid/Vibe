import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/get_dm_controller.dart';
import 'package:vibe/views/screens/misc/search_user_screen.dart';
import 'direct_message_screen.dart';

class YourDMsScreen extends StatelessWidget {
  final GetDMController dmController = Get.put(GetDMController());

  void navigateToSearchUserScreen() {
    Get.to(SearchUserScreen());
  }

  void navigateToConversation(String senderUID, String recipientUID) {
    Get.to(() => DirectMessageScreen(
      senderUID: senderUID,
      recipientUID: recipientUID,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Direct Messages', style: TextStyle(fontFamily: 'MonaSansExtraBoldWideItalic')),
        actions: [
          GestureDetector(
            onTap: navigateToSearchUserScreen,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.add, color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Inbox',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                fontFamily: 'MonaSansExtraBoldWideItalic',
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GetX<GetDMController>(
                builder: (controller) {
                  if (controller.dms.isEmpty) {
                    return Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "No DMs Found",
        style: TextStyle(
          fontFamily: 'MonaSans',
          fontWeight: FontWeight.w400,
          fontSize: 24, // Adjust the font size as desired
        ),
      ),
      SizedBox(height: 16), // Add spacing between the texts
      Text(
        "Get started by clicking the '+' icon up the top",
        style: TextStyle(
          fontFamily: 'MonaSans',
          fontWeight: FontWeight.w400,
          fontSize: 16, // Adjust the font size as desired
        ),
      ),
    ],
  ),
);

                  } else {
                    return ListView.builder(
                      itemCount: controller.dms.length,
                      itemBuilder: (context, index) {
                        final dm = controller.dms[index];
                        final participants = dm.participants;
                        final senderUID = participants.contains(authController.user.uid)
                            ? authController.user.uid
                            : participants[0];
                        final recipientUID = participants.contains(authController.user.uid)
                            ? participants[0]
                            : participants[1];

                        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance.collection('users').doc(recipientUID).snapshots(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return ListTile(
                                title: Text(
                                  'Loading...',
                                  style: TextStyle(fontFamily: 'MonaSans', fontWeight: FontWeight.w400),
                                ),
                              );
                            }

                            final userData = userSnapshot.data?.data();
                            final profileImageUrl = userData?['profilePhoto'];
                            final profileName = userData?['name'];

                            final lastMessage = dm.messages.isNotEmpty ? dm.messages.last : null;
                            final lastMessageText = lastMessage != null ? lastMessage.text : 'No messages yet';
                            final lastMessageTime = lastMessage != null ? lastMessage.sent : null;
                            final formattedTime = lastMessageTime != null ? timeago.format(lastMessageTime) : '';

                            return GestureDetector(
                              onTap: () => navigateToConversation(senderUID, recipientUID),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(profileImageUrl),
                                ),
                                title: Text(
                                  profileName ?? '',
                                  style: TextStyle(fontFamily: 'MonaSans', fontWeight: FontWeight.w400),
                                ),
                                subtitle: Text(
                                  lastMessageText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'MonaSans',
                                  ),
                                ),
                                trailing: Text(
                                  formattedTime,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'MonaSans',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
