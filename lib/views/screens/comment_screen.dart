import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/comment_controller.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentScreen extends StatelessWidget {
  final String id;
  CommentScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final TextEditingController _commentController = TextEditingController();
  final CommentController commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    commentController.updatePostId(id);

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final commentCount = commentController.comments.length;
          return Text(
            'This video has $commentCount comment${commentCount != 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        }),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: size.height - 100,
              child: Obx(() => ListView.builder(
                    itemCount: commentController.comments.length,
                    itemBuilder: (context, index) {
                      final comment = commentController.comments[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: NetworkImage(comment.profilePhoto),
                        ),
                        title: Row(
                          children: [
                            Text(
                              "${comment.username}  ",
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'MonaSans',
                              ),
                            ),
                            Text(
                              comment.comment,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'MonaSansExtraBoldWideItalic',
                              ),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              tago.format(
                                comment.datePublished.toDate(),
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${comment.likes.length} comment likes',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontFamily: 'MonaSansExtraBoldWideItalic',
                              ),
                            ),
                          ],
                        ),
                        trailing: InkWell(
                          onTap: () => commentController.likeComment(comment.id),
                          child: Icon(
                            Icons.favorite,
                            size: 25,
                            color: comment.likes.contains(authController.user.uid)
                                ? Colors.pinkAccent
                                : Colors.white,
                          ),
                        ),
                      );
                    },
                  )),
            ),
          ),
          ListTile(
            title: TextFormField(
              controller: _commentController,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'MonaSansExtraBoldWideItalic',
              ),
              decoration: const InputDecoration(
                labelText: 'Comment',
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 114, 111, 112),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 129, 113, 118),
                  ),
                ),
              ),
            ),
            trailing: TextButton(
              onPressed: () => commentController.postComment(_commentController.text),
              child: const Text(
                'Comment!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'MonaSansExtraBoldWideItalic',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
