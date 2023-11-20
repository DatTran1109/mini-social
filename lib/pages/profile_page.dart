import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_social/components/profile_detail.dart';
import 'package:mini_social/components/profile_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('Users');
  final _controller = TextEditingController();

  void editField(String field) {
    showDialog(
        context: context,
        builder: (context) => ProfileDialog(
            onSave: () => saveProfileDetail(field),
            onCancel: () {
              Navigator.pop(context);
              _controller.clear();
            },
            controller: _controller,
            field: field));
  }

  void saveProfileDetail(String field) async {
    if (_controller.text.trim().isNotEmpty) {
      await userCollection
          .doc(_currentUser.email)
          .update({field: _controller.text.trim()});

      _controller.clear();
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(_currentUser.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data();

              return ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Icon(
                    Icons.person,
                    size: 72,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    _currentUser.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'My Detail',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  ProfileDetail(
                    text: userData?['username'],
                    sectionName: 'username',
                    onPressed: () => editField('username'),
                  ),
                  ProfileDetail(
                    text: userData?['bio'],
                    sectionName: 'bio',
                    onPressed: () => editField('bio'),
                  ),
                ],
              );
            } else {
              return Text('Error ${snapshot.hasError}');
            }
          },
        ));
  }
}
