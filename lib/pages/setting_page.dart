import 'package:flutter/material.dart';
import 'package:mini_social/utils/theme/theme.dart';
import 'package:mini_social/utils/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    _isSwitched = Provider.of<ThemeProvider>(context).themeData == darkTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Setting'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.only(left: 50, top: 25, right: 50),
        padding:
            const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Dark mode'),
          Switch(
            activeColor: Colors.green,
            value: _isSwitched,
            onChanged: (value) => Provider.of<ThemeProvider>(
              context,
              listen: false,
            ).toggleTheme(),
          ),
        ]),
      ),
    );
  }
}
