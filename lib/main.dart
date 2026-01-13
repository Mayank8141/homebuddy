

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'admin_app/admin_analytics.dart';
import 'admin_app/admin_bookings.dart';
import 'admin_app/admin_dashboard.dart';
import 'admin_app/admin_employe.dart';
import 'admin_app/admin_notification.dart';
import 'admin_app/admin_services.dart';
import 'admin_app/admin_users.dart';
import 'customer_app/customer_profile.dart';
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

/// 🔥 ADMIN ROOT WITH BOTTOM NAV
class AdminMain extends StatefulWidget {
  final String uid;
  const AdminMain({super.key, required this.uid});

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  int index = 0;

  Stream<int> adminUnreadNotificationCount() {
    final adminId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection("notifications")
        .where("receiver_id", isEqualTo: adminId)
        .where("receiver_type", isEqualTo: "admin")
        .where("is_read", isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildAdminDrawer(
        context: context,
        currentIndex: index,
        onTabChange: (i) => setState(() => index = i),
        onLogout: () => showLogoutConfirmation(context),
        adminName: "Admin",
        adminEmail: "admin@gmail.com",
        adminImage: "", // optional
      ),

      appBar: AppBar(
        title: Text(
          index == 0
              ? "Admin Dashboard"
              : index == 1
              ? "Users"
              : index == 2
              ? "Employees"
              : "Services",
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          StreamBuilder<int>(
            stream: adminUnreadNotificationCount(),
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;

              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminNotificationScreen(),
                        ),
                      );
                    },
                  ),
                  if (count > 0)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          count > 9 ? "9+" : "$count",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),


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
        onTap: (i) => setState(() => index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF16A68A),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Users"),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: "Employees"),
          BottomNavigationBarItem(icon: Icon(Icons.miscellaneous_services), label: "Services"),
        ],
      ),
    );

  }
}
Widget buildAdminDrawer({
  required BuildContext context,
  required int currentIndex,
  required Function(int) onTabChange,
  required VoidCallback onLogout,
  required String adminName,
  required String adminEmail,
  String adminImage = "",
}) {
  return Drawer(
    child: Column(
      children: [
        // ================= HEADER =================
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1ABC9C),
                Color(0xFF16A085),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: Colors.white,
                backgroundImage:
                adminImage.isNotEmpty ? NetworkImage(adminImage) : null,
                child: adminImage.isEmpty
                    ? const Icon(Icons.person, size: 40, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 12),
              Text(
                adminName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                adminEmail,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        // ================= MENU =================
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _drawerItem(
                icon: Icons.dashboard_rounded,
                title: "Dashboard",
                selected: currentIndex == 0,
                onTap: () {
                  Navigator.pop(context);
                  onTabChange(0);
                },
              ),
              _drawerItem(
                icon: Icons.people_rounded,
                title: "Users",
                selected: currentIndex == 1,
                onTap: () {
                  Navigator.pop(context);
                  onTabChange(1);
                },
              ),
              _drawerItem(
                icon: Icons.engineering_rounded,
                title: "Employees",
                selected: currentIndex == 2,
                onTap: () {
                  Navigator.pop(context);
                  onTabChange(2);
                },
              ),
              _drawerItem(
                icon: Icons.home_repair_service_rounded,
                title: "Services",
                selected: currentIndex == 3,
                onTap: () {
                  Navigator.pop(context);
                  onTabChange(3);
                },
              ),

              const Divider(height: 32),

              _drawerItem(
                icon: Icons.bar_chart_rounded,
                title: "Analytics",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminAnalyticsPage(),
                    ),
                  );
                },
              ),
              _drawerItem(
                icon: Icons.calendar_month_rounded,
                title: "Bookings",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminBookingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // ================= LOGOUT =================
        Padding(
          padding: const EdgeInsets.all(12),
          child: _drawerItem(
            icon: Icons.logout_rounded,
            title: "Logout",
            color: Colors.red,
            onTap: onLogout,
          ),
        ),
      ],
    ),
  );
}

Widget _drawerItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  bool selected = false,
  Color? color,
}) {
  final itemColor = color ??
      (selected ? const Color(0xFF1ABC9C) : Colors.black87);

  return ListTile(
    leading: Icon(icon, color: itemColor),
    title: Text(
      title,
      style: TextStyle(
        color: itemColor,
        fontWeight: selected ? FontWeight.bold : FontWeight.w600,
      ),
    ),
    selected: selected,
    selectedTileColor: const Color(0xFF1ABC9C).withOpacity(0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    onTap: onTap,
  );
}

void showLogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Confirm Logout",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to logout?",
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context); // close dialog
              await logout(context);  // perform logout
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

