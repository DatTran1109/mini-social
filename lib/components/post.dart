import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_social/components/comment.dart';
import 'package:mini_social/components/comment_button.dart';
import 'package:mini_social/components/like_button.dart';
import 'package:mini_social/utils/formatter.dart';

class Post extends StatefulWidget {
  final String message;
  final String user;
  final String postID;
  final String time;
  final List<String> likes;
  final List<Map<String, dynamic>> comments;
  const Post({
    super.key,
    required this.message,
    required this.user,
    required this.postID,
    required this.likes,
    required this.time,
    required this.comments,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final _currentUser = FirebaseAuth.instance.currentUser;
  bool _isLiked = false;
  final _commentTextController = TextEditingController();

  void toggleLike() async {
    setState(() {
      _isLiked = !_isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postID);

    if (_isLiked) {
      await postRef.update({
        'Likes': FieldValue.arrayUnion([_currentUser!.email]),
      });
    } else {
      await postRef.update({
        'Likes': FieldValue.arrayRemove([_currentUser!.email])
      });
    }
  }

  void updateComment(String commentText) async {
    await FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postID)
        .update({
      'Comments': FieldValue.arrayUnion([
        {
          'CommentText': commentText,
          'CommentedBy': _currentUser!.email,
          "CommentTime": Timestamp.now(),
        }
      ]),
    });
  }

  void showCommentDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add comment'),
              content: TextField(
                controller: _commentTextController,
                autofocus: true,
                decoration:
                    const InputDecoration(hintText: 'Write comment here'),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      if (_commentTextController.text.isNotEmpty) {
                        updateComment(_commentTextController.text);
                        _commentTextController.clear();
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Post')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _commentTextController.clear();
                    },
                    child: const Text('Cancel')),
              ],
            ));
  }

  void deletePost() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete Post'),
              content: const Text('Are you sure you want to delete this post?'),
              actions: [
                TextButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('User Posts')
                          .doc(widget.postID)
                          .delete()
                          .then((value) => print('Post deleted'))
                          .catchError(
                              (error) => print('Failed to delete post $error'));
                      Navigator.pop(context);
                    },
                    child: const Text('Delete')),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ));
  }

  @override
  void initState() {
    super.initState();
    _isLiked = widget.likes.contains(_currentUser!.email);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.message),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(' * ', style: TextStyle(color: Colors.grey[400])),
                      Text(widget.time,
                          style: TextStyle(color: Colors.grey[400])),
                    ],
                  ),
                ],
              ),
              if (widget.user == _currentUser!.email)
                GestureDetector(
                    onTap: deletePost,
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.grey,
                    )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Like button
              Column(
                children: [
                  MyLikeButton(
                    isLiked: _isLiked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              // Comment button
              Column(
                children: [
                  CommentButton(
                    onTap: showCommentDialog,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.comments.length.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          // Comments
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.comments.length,
            itemBuilder: (context, index) {
              return Comment(
                  text: widget.comments[index]['CommentText'],
                  user: widget.comments[index]['CommentedBy'],
                  time: formatTimeStamp(widget.comments[index]['CommentTime']));
            },
          ),
        ],
      ),
    );
  }
}
