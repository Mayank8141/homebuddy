import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'main.dart'; // EmployeeMain
import 'admin_app/admin_dashboard.dart';
import 'customer_app/customer_home.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<Widget> _decideStartScreen() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();

    if (user == null) {
      return const login_screen();
    }

    final role = prefs.getString("role");
    final uid = prefs.getString("uid") ?? user.uid;

    if (role == "admin") {
      return admin_dashboard(uid: uid);
    }
    if (role == "employee") {
      return EmployeeMain(uid: uid);
    }
    if (role == "customer") {
      return customer_home_screen(uid: uid);
    }

    // ❌ invalid role → logout
    await FirebaseAuth.instance.signOut();
    await prefs.clear();
    return const login_screen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _decideStartScreen(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data!;
      },
    );
  }
}
