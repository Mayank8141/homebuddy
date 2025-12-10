import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:homebuddy/splash_screen.dart';

import 'firebase_options.dart';   // This file is auto-generated after firebase setup
import 'login.dart';
import 'option_screen.dart';     // First screen of your app

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // important for async firebase

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase config
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HomeBuddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SplashScreen(),   // Landing page
    );
  }
}
