import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  final String field;
  final Function()? onSave;
  final Function()? onCancel;
  final TextEditingController controller;
  const ProfileDialog(
      {super.key,
      required this.onSave,
      required this.onCancel,
      required this.controller,
      required this.field});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit $field'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(hintText: 'Enter new $field'),
      ),
      actions: [
        TextButton(onPressed: onSave, child: const Text('Save')),
        TextButton(onPressed: onCancel, child: const Text('Cancel')),
      ],
    );
  }
}
