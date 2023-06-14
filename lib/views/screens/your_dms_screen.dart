import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/get_dm_controller.dart';
import 'package:vibe/models/dm.dart';


class YourDMsScreen extends StatefulWidget {
  @override
  _YourDMsScreenState createState() => _YourDMsScreenState();
}

class _YourDMsScreenState extends State<YourDMsScreen> {
  final GetDMController dmController = Get.put(GetDMController());

  @override
  void initState() {
    super.initState();
    dmController.fetchDMs(authController.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DM Screen'),
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
              child: GetBuilder<GetDMController>(
                builder: (controller) {
                  if (controller.dms.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: controller.dms.length,
                      itemBuilder: (context, index) {
                        final dm = controller.dms[index];
                        return ListTile(
                          title: Text(dm.participants.first),
                          subtitle: Text(dm.messages[0].toString()),
                          trailing: Text(dm.messages[1].toString()),
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
