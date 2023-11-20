import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_social/components/drawer.dart';
import 'package:mini_social/components/post.dart';
import 'package:mini_social/components/text_field.dart';
import 'package:mini_social/pages/profile_page.dart';
import 'package:mini_social/pages/setting_page.dart';
import 'package:mini_social/utils/formatter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _currentUser = FirebaseAuth.instance.currentUser;
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Mini Social'),
        centerTitle: true,
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
        onSettingTap: goToSettingPage,
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('User Posts')
                      .orderBy('TimeStamp', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List postList = snapshot.data!.docs;

                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: postList.length,
                        itemBuilder: (context, index) {
                          final post = postList[index];

                          return Post(
                            message: post['Message'],
                            user: post['UserEmail'],
                            postID: post.id,
                            likes: List<String>.from(post['Likes'] ?? []),
                            comments: List<Map<String, dynamic>>.from(
                                post['Comments'] ?? []),
                            time: formatTimeStamp(post['TimeStamp']),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error.toString()}'),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: MyTextField(
                        controller: _textController,
                        hintText: "Write something",
                        obscureText: false,
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: IconButton(
                          onPressed: postMessage, icon: const Icon(Icons.send)),
                    ))
              ],
            ),
          ),
          Text(
            "Logged in as ${_currentUser!.email}",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void postMessage() async {
    if (_textController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('User Posts').add({
        'UserEmail': _currentUser!.email,
        'Message': _textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
        'Comments': [],
      });

      setState(() {
        _textController.clear();
      });
    }
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  void goToSettingPage() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SettingPage()));
  }
}
