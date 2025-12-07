import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';
import 'admin_services.dart';
import 'admin_users.dart';
import 'admin_employe.dart';

class admin_dashboard extends StatefulWidget {
  const admin_dashboard({super.key});

  @override
  State<admin_dashboard> createState() => _admin_dashboardState();
}

class _admin_dashboardState extends State<admin_dashboard> {
  int selectedIndex = 0;

  // ---------- Navigation ----------
  void onTabTap(int index) {
    if (index == 0) return;

    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => admin_user_list()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => admin_employe_list()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => admin_services()));
    }
  }

  // ---------- Live Firebase Count Card ----------
  Widget statCard(
      String title,
      IconData icon,
      Color color,
      Stream<QuerySnapshot> stream,
      ) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        int count = snapshot.hasData ? snapshot.data!.docs.length : 0;

        return Container(
          height: 120,  // prevents Column overflow
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [color.withOpacity(.9), color.withOpacity(.65)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // prevents overflow
            children: [
              Icon(icon, color: Colors.white, size: 30),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "$count",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F4F7),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Admin Dashboard",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 2),
            Text("Home Service Management",
                style: TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Icon(Icons.person, color: Colors.blue.shade700),
          ),
          SizedBox(width: 15),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text("Admin Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Users"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => admin_user_list())),
            ),
            ListTile(
              leading: Icon(Icons.engineering),
              title: Text("Employees"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => admin_employe_list())),
            ),
            ListTile(
              leading: Icon(Icons.cleaning_services),
              title: Text("Services"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => admin_services())),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () => logout(context),   // ← Pass context here
            ),

          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------- LIVE COUNT CARDS ----------
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.25,
              children: [
                statCard("Total Users", Icons.people_alt, Colors.blue,
                    FirebaseFirestore.instance.collection("customer_detail").snapshots()),

                statCard("Providers", Icons.engineering, Colors.green,
                    FirebaseFirestore.instance.collection("employe_detail").snapshots()),

                statCard("Services", Icons.cleaning_services, Colors.deepPurple,
                    FirebaseFirestore.instance.collection("services").snapshots()),

                statCard("Bookings", Icons.calendar_month, Colors.orange,
                    FirebaseFirestore.instance.collection("orders").snapshots()), // if booking stored
              ],
            ),

            SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Recent Bookings",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("View All", style: TextStyle(color: Colors.blue)),
              ],
            ),

            SizedBox(height: 15),
            bookingTile("John Doe", "Cleaning", "Nov 28", "Completed", Colors.green),
            bookingTile("Jane Wilson", "Electrician", "Nov 29", "In Progress", Colors.blue),
          ],
        ),
      ),

      // ---------- Bottom Navigation ----------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTabTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Users"),
          BottomNavigationBarItem(icon: Icon(Icons.engineering), label: "Employee"),
          BottomNavigationBarItem(icon: Icon(Icons.cleaning_services), label: "Services"),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("role");     // remove role so next time login required
    await prefs.remove("email");    // optional
    await prefs.remove("uid");      // optional

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => login_screen()), // put your login page
          (route) => false,
    );
  }


  Widget bookingTile(String name, String type, String date, String status, Color statusColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: ListTile(
        leading: CircleAvatar(radius: 25, child: Icon(Icons.person)),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$type | $date"),
        trailing: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
