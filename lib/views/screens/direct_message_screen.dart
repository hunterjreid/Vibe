import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe/controllers/get_dm_controller.dart';
import 'package:vibe/models/dm.dart';

class DirectMessageScreen extends StatefulWidget {
  final String senderUID; // UID of the sender user
  final String recipientUID; // UID of the recipient user

  DirectMessageScreen({
    required this.senderUID,
    required this.recipientUID,
  });

  @override
  _DirectMessageScreenState createState() => _DirectMessageScreenState();
}

class _DirectMessageScreenState extends State<DirectMessageScreen> {
  final GetDMController dmController = Get.put(GetDMController());

  @override
  void initState() {
    super.initState();
    dmController.fetchDMs(widget.senderUID);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Direct Messages'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GetX<GetDMController>(
              init: dmController,
              builder: (controller) {
                if (controller.dms.isEmpty) {
                  return Container(); // Empty container when no DMs are available
                } else {
                  final dm = controller.dms.firstWhere(
                    (dm) =>
                        (dm.participants.contains(widget.senderUID) &&
                            dm.participants.contains(widget.recipientUID)) ||
                        (dm.participants.contains(widget.recipientUID) &&
                            dm.participants.contains(widget.senderUID)),
                    orElse: () => DM(participants: [], messages: []),
                  );

                  return ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: dm.messages.length,
                    itemBuilder: (context, index) {
                      final message = dm.messages[index];
                      final isCurrentUser = message.senderUID == widget.senderUID;

                      return Align(
                        alignment: isCurrentUser ? Alignment.topRight : Alignment.topLeft,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: isCurrentUser ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Divider(), // Optional divider to separate chat area and chat bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dmController.textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                    onSubmitted: (value) {
                      dmController.sendMessage(widget.senderUID, widget.recipientUID, value);
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    String message = dmController.textEditingController.text;
                    dmController.sendMessage(widget.senderUID, widget.recipientUID, message);
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
