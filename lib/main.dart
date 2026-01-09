// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:homebuddy/splash_screen.dart';
//
// import 'firebase_options.dart';   // This file is auto-generated after firebase setup
// import 'login.dart';
// import 'option_screen.dart';     // First screen of your app
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();  // important for async firebase
//
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform, // Firebase config
//   );
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'HomeBuddy',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         useMaterial3: true,
//       ),
//       home: const SplashScreen(),   // Landing page
//     );
//   }
// }
//


// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:homebuddy/employe_app/employe_profile.dart';
//
// import 'auth_wrapper.dart';
// import 'employe_app/employe_dashbord.dart';
// import 'employe_app/employe_jobs.dart';
// import 'employe_app/employe_requests.dart';
// import 'employe_app/employee_earnings.dart';
// import 'firebase_options.dart';
// import 'splash_screen.dart';
//
// // employee screens
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:firebase_core/firebase_core.dart';
//
// import 'firebase_options.dart';
// import 'splash_screen.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   // 🔥 Enable edge-to-edge & dynamic system colors
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//
//   runApp(const MyApp());
//
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor:Colors.white,
//       statusBarIconBrightness: Brightness.dark,
//       statusBarBrightness: Brightness.light,
//     ),
//   );
//
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'HomeBuddy',
//
//       // 🔥 Light Theme
//       theme: ThemeData(
//         useMaterial3: true,
//         brightness: Brightness.light,
//
//         inputDecorationTheme: const InputDecorationTheme(
//           filled: true,
//           fillColor: Color(0xFFF5F5F5),
//           labelStyle: TextStyle(color: Colors.black87),
//           hintStyle: TextStyle(color: Colors.grey),
//         ),
//
//         textTheme: const TextTheme(
//           bodyMedium: TextStyle(color: Colors.black),
//         ),
//
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           systemOverlayStyle: SystemUiOverlayStyle(
//             statusBarColor: Colors.transparent,
//             statusBarIconBrightness: Brightness.dark,
//             statusBarBrightness: Brightness.light,
//           ),
//         ),
//       ),
//
//       darkTheme: ThemeData(
//         useMaterial3: true,
//         brightness: Brightness.dark,
//
//         inputDecorationTheme: const InputDecorationTheme(
//           filled: true,
//           fillColor: Color(0xFF1E1E1E),
//           labelStyle: TextStyle(color: Colors.white),
//           hintStyle: TextStyle(color: Colors.grey),
//         ),
//
//         textTheme: const TextTheme(
//           bodyMedium: TextStyle(color: Colors.white),
//         ),
//
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           systemOverlayStyle: SystemUiOverlayStyle(
//             statusBarColor: Colors.transparent,
//             statusBarIconBrightness: Brightness.light,
//             statusBarBrightness: Brightness.dark,
//           ),
//         ),
//       ),
//
//       // 🔥 Auto switch with system theme
//       themeMode: ThemeMode.system,
//
//       home: const SplashScreen(),
//     );
//   }
// }
//
// /// 🔥 EMPLOYEE ROOT WITH BOTTOM NAV
// class EmployeeMain extends StatefulWidget {
//   final String uid;
//   const EmployeeMain({super.key, required this.uid});
//
//   @override
//   State<EmployeeMain> createState() => _EmployeeMainState();
// }
//
// class _EmployeeMainState extends State<EmployeeMain> {
//   int index = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: index,
//         children: [
//           employe_deshbord_screen(uid: widget.uid),
//           EmployeeRequestsScreen(uid: widget.uid),
//           EmployeeJobsScreen(uid: widget.uid),
//           EmployeeEarningsScreen(uid: widget.uid),
//           EmployeProfile(uid: widget.uid)
//         ],
//       ),
//
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: index,
//         backgroundColor: Colors.white,
//         selectedItemColor: const Color(0xFF1ABC9C),
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         onTap: (i) => setState(() => index = i),
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Requests"),
//           BottomNavigationBarItem(icon: Icon(Icons.work), label: "Jobs"),
//           BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Earnings"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'splash_screen.dart';
import 'employe_app/employe_dashbord.dart';
import 'employe_app/employe_requests.dart';
import 'employe_app/employe_jobs.dart';
import 'employe_app/employee_earnings.dart';
import 'employe_app/employe_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔥 Edge-to-edge with WHITE status bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
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

      // ✅ FORCE LIGHT THEME ONLY
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,

        scaffoldBackgroundColor: const Color(0xFFF8F9FD),

        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF5F5F5),
          labelStyle: TextStyle(color: Colors.black87),
          hintStyle: TextStyle(color: Colors.grey),
        ),

        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ❌ REMOVE darkTheme & themeMode
      home: const SplashScreen(),
    );
  }
}

/// 🔥 EMPLOYEE ROOT WITH BOTTOM NAV
class EmployeeMain extends StatefulWidget {
  final String uid;
  const EmployeeMain({super.key, required this.uid});

  @override
  State<EmployeeMain> createState() => _EmployeeMainState();
}

class _EmployeeMainState extends State<EmployeeMain> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [
          employe_deshbord_screen(uid: widget.uid),
          EmployeeRequestsScreen(uid: widget.uid),
          EmployeeJobsScreen(uid: widget.uid),
          EmployeeEarningsScreen(uid: widget.uid),
          EmployeProfile(uid: widget.uid),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1ABC9C),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Requests"),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "Jobs"),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Earnings"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
