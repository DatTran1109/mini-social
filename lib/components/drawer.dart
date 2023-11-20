import 'package:flutter/material.dart';
import 'package:mini_social/components/drawer_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final Function()? onProfileTap;
  final Function()? onSettingTap;
  final Function()? onSignOut;
  const MyDrawer({
    super.key,
    required this.onProfileTap,
    required this.onSignOut,
    required this.onSettingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(children: [
        const DrawerHeader(
            child: Icon(
          Icons.person,
          size: 64,
        )),
        DrawerListTile(
          icon: Icons.home,
          text: 'H O M E',
          ontap: () => Navigator.pop(context),
        ),
        DrawerListTile(
          icon: Icons.person,
          text: 'P R O F I L E',
          ontap: onProfileTap,
        ),
        DrawerListTile(
          icon: Icons.settings,
          text: 'S E T T I N G',
          ontap: onSettingTap,
        ),
        DrawerListTile(
          icon: Icons.logout,
          text: 'L O G O U T',
          ontap: onSignOut,
        ),
      ]),
    );
  }
}
