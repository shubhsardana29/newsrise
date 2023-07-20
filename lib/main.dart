import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newsrise/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(NewsApp());
}


class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF111111), // Set the main background color
      ),
      home: SplashScreen(),
    );
  }
}


