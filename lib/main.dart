

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'admin_app/admin_dashboard.dart';
import 'admin_app/admin_employe.dart';
import 'admin_app/admin_services.dart';
import 'admin_app/admin_users.dart';
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

class AdminMain extends StatefulWidget {
  final String uid;
  const AdminMain({super.key, required this.uid});

  @override
  _AdminMainState createState() => _AdminMainState();
}

class _AdminMainState extends State<EmployeeMain> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [
          admin_dashboard(uid: widget.uid),
          admin_user_list(),
          admin_employe_list(),
          admin_services(),
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
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "users"),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "providers"),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "services"),
          //BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

