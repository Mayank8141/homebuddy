import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homebuddy/admin_app/admin_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';
import 'admin_services.dart';
import 'admin_users.dart';
import 'admin_employe.dart';

class admin_dashboard extends StatefulWidget {
  const admin_dashboard({super.key, required String uid});

  @override
  State<admin_dashboard> createState() => _admin_dashboardState();
}

class _admin_dashboardState extends State<admin_dashboard> {
  int selectedIndex = 0;

  String adminName = "Admin";
  String adminEmail = "Loading...";
  String adminImage = "";

  @override
  void initState() {
    super.initState();
    fetchAdminDetails();
  }

  Future<void> fetchAdminDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var doc = await FirebaseFirestore.instance.collection("admin_details").doc(uid).get();
    if (doc.exists) {
      setState(() {
        adminName = doc["name"] ?? "Admin";
        adminEmail = doc["email"] ?? "";
        adminImage = doc["profile"] ?? "";
      });
    }
  }

  // ---------------- NAV ----------------
  void onTabTap(int index) {
    if (index == 0) return;
    if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (_) => admin_user_list()));
    if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (_) => admin_employe_list()));
    if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (_) => admin_services()));
  }

  // ---------------- COUNT CARD ----------------
  Widget statCard(String title, IconData icon, Color color, Stream<QuerySnapshot> stream) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        int count = snapshot.hasData ? snapshot.data!.docs.length : 0;

        return Container(
          height: 120,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [color.withOpacity(.9), color.withOpacity(.65)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [BoxShadow(color: color.withOpacity(.3), blurRadius: 10, offset: Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Text("$count", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // ---------------- MAIN UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F4F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Admin Dashboard", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
            Text("Home Service Management", style: TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),

      ),

      // --------- DRAWER WITH EDIT PROFILE ---------
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(adminName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              accountEmail: Text(adminEmail),

              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: adminImage.isNotEmpty ? NetworkImage(adminImage) : null,
                child: adminImage.isEmpty ? Icon(Icons.person, size: 40, color: Colors.blue) : null,
              ),

              otherAccountsPictures: [
                InkWell(
                  onTap: () => editProfile(context),
                  child:  Icon(Icons.edit, color: Colors.white, size: 20),
                  ),

              ],
              decoration: BoxDecoration(color: Colors.blueAccent),
            ),

            ListTile(
              leading: Icon(Icons.people),
              title: Text("Users"),
              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>admin_user_list())),
            ),
            ListTile(
              leading: Icon(Icons.engineering),
              title: Text("Employees"),
              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>admin_employe_list())),
            ),
            ListTile(
              leading: Icon(Icons.cleaning_services),
              title: Text("Services"),
              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>admin_services())),
            ),
            ListTile(
              leading: Icon(Icons.analytics_outlined),
              title: Text("Analytics"),
              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>AdminAnalyticsPage())),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: ()=> logout(context),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.25,
              children: [
                statCard("Users", Icons.people_alt, Colors.blue,
                    FirebaseFirestore.instance.collection("customer_detail").snapshots()),
                statCard("Providers", Icons.engineering, Colors.green,
                    FirebaseFirestore.instance.collection("employe_detail").snapshots()),
                statCard("Services", Icons.cleaning_services, Colors.deepPurple,
                    FirebaseFirestore.instance.collection("services").snapshots()),
                statCard("Bookings", Icons.calendar_month, Colors.orange,
                    FirebaseFirestore.instance.collection("orders").snapshots()),
              ],
            ),

            SizedBox(height: 25),
            Text("Recent Bookings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),

            bookingTile("John Doe", "Cleaning", "Nov 28", "Completed", Colors.green),
            SizedBox(height: 10),
            bookingTile("Jane Wilson", "Electrician", "Nov 29", "Pending", Colors.blue),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTabTap,
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

  // ============== EDIT PROFILE SHEET ==============
  void editProfile(BuildContext context) {
    TextEditingController nameCtrl = TextEditingController(text: adminName);
    TextEditingController emailCtrl = TextEditingController(text: adminEmail);
    TextEditingController imgCtrl = TextEditingController(text: adminImage);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text("Edit Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),

            TextField(controller: nameCtrl, decoration: InputDecoration(labelText: "Name")),
            SizedBox(height: 10),

            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: "Email")),
            SizedBox(height: 10),

            TextField(controller: imgCtrl, decoration: InputDecoration(labelText: "Profile Image URL")),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                String uid = FirebaseAuth.instance.currentUser!.uid;

                await FirebaseFirestore.instance.collection("admin_details").doc(uid).update({
                  "name": nameCtrl.text.trim(),
                  "email": emailCtrl.text.trim(),
                  "profile": imgCtrl.text.trim(),
                });

                setState(() {
                  adminName = nameCtrl.text;
                  adminEmail = emailCtrl.text;
                  adminImage = imgCtrl.text;
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Updated Successfully")));
              },
              child: Text("Save Changes"),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ============== LOGOUT ==============
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => login_screen()), (route) => false);
  }

  Widget bookingTile(String name, String type, String date, String status, Color color) {
    return ListTile(
      leading: CircleAvatar(child: Icon(Icons.person)),
      title: Text(name),
      subtitle: Text("$type • $date"),
      trailing: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
