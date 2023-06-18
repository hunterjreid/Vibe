import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/get_dm_controller.dart';
import 'package:vibe/models/dm.dart';
import 'package:vibe/views/screens/search_user_screen.dart';
import 'direct_message_screen.dart'; 

class YourDMsScreen extends StatefulWidget {
  @override
  _YourDMsScreenState createState() => _YourDMsScreenState();
}

class _YourDMsScreenState extends State<YourDMsScreen> {
  final GetDMController dmController = Get.put(GetDMController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dmController.fetchDMs(authController.user.uid);
    print(authController.user.uid);
  }

 void navigateToSearchUser() {
    // Add the logic to navigate to the search user screen
    // when the plus icon is tapped
    // For example:
    Get.to(SearchUserScreen());
  }

  void navigateToConversation(String senderUID, String recipientUID) {
    Get.to(DirectMessageScreen(
      senderUID: senderUID,
      recipientUID: recipientUID,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DM Screen'),
        actions: [
    GestureDetector(
      onTap: navigateToSearchUser,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.add),
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
              'Direct Messages',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 16),
            Expanded(
              child: GetX<GetDMController>(
                init: dmController,
                builder: (controller) {

                  if (controller.dms.isEmpty) {
                    return Center(
                      child: Text("No DMs Found"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: controller.dms.length,
                      itemBuilder: (context, index) {
                        final dm = controller.dms[index];
                        return GestureDetector(
                          onTap: () => navigateToConversation(dm.participants[0], dm.participants[1]),
                          child: ListTile(
                            title: Text(dm.participants.join(', ')),
                            subtitle: Text(dm.messages.isNotEmpty ? "2"+dm.messages.last.text : ''),
                            trailing: Text(dm.messages.isNotEmpty ? "3"+dm.messages.last.sent.toString() : ''),
                          ),
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