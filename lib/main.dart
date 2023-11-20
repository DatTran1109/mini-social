import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mini_social/auth/auth.dart';
import 'package:mini_social/firebase_options.dart';
import 'package:mini_social/utils/theme/theme.dart';
import 'package:mini_social/utils/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      darkTheme: darkTheme,
      home: const Auth(),
    );
  }
}
