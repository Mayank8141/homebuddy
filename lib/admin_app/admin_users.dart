import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'admin_dashboard.dart';
import 'admin_employe.dart';
import 'admin_services.dart';
import 'package:intl/intl.dart';

class admin_user_list extends StatefulWidget {
  const admin_user_list({super.key});

  @override
  State<admin_user_list> createState() => _admin_user_listState();
}

class _admin_user_listState extends State<admin_user_list> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController searchController = TextEditingController();

  int selectedIndex = 1; // ← Users tab selected (Dashboard=0, Users=1)

  // ---------------- Delete User ----------------
  void deleteUserPopup(String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete User"),
          content: Text("Are you sure you want to delete this user?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await _firestore.collection("customer_detail").doc(userId).delete();
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("User deleted successfully")));
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // ---------------- Edit User ----------------
  void openEditUserModal(String userId, Map<String, dynamic> userData) {
    TextEditingController nameController = TextEditingController(text: userData["name"]);
    TextEditingController emailController = TextEditingController(text: userData["email"]);
    TextEditingController phoneController = TextEditingController(text: userData["phone"]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20, right: 20, top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Edit User", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close))
            ]),

            SizedBox(height: 10),
            field(nameController, "Name"),
            SizedBox(height: 10),
            field(emailController, "Email"),
            SizedBox(height: 10),
            field(phoneController, "Phone"),
            SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50), backgroundColor: Colors.blue),
              onPressed: () async {
                await _firestore.collection("customer_detail").doc(userId).update({
                  "name": nameController.text.trim(),
                  "email": emailController.text.trim(),
                  "phone": phoneController.text.trim(),
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User updated successfully")));
              },
              child: Text("Save"),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget field(TextEditingController c, String name) => TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: name,
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
    ),
  );

  // ---------------- User List with Search ----------------
  Widget buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('customer_detail').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        final users = snapshot.data!.docs;

        final filtered = users.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final name = (data["name"] ?? "").toString().toLowerCase();
          final query = searchController.text.toLowerCase();
          return name.contains(query);
        }).toList();

        if (filtered.isEmpty) return Center(child: Text("No matching users found"));

        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final user = filtered[index];
            final id = user.id;
            final data = user.data() as Map<String, dynamic>;

            String getJoinDate() {
              final date = data["created_at"]; // or "join_date" if you saved it as join_date
              if (date is Timestamp) {
                return DateFormat("dd MMM yyyy").format(date.toDate());
              }
              return "--";
            }

            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(data["name"] ?? "Unknown", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Icon(Icons.chevron_right)
                ]),
                SizedBox(height: 4),
                Text(data["email"] ?? ""), Text(data["phone"] ?? ""),
                SizedBox(height: 8),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("Join Date\n${getJoinDate()}", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text("Bookings\n${data["total_bookings"] ?? "0"}", style: TextStyle(fontSize: 12, color: Colors.grey)),

                  Row(children: [
                    iconBtn(Icons.edit, Colors.blue, () => openEditUserModal(id, data)),
                    SizedBox(width: 10),
                    iconBtn(Icons.delete, Colors.red, () => deleteUserPopup(id)),
                  ])
                ])
              ]),
            );
          },
        );
      },
    );
  }

  Widget iconBtn(icon, color, onTap) => InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(color: color.withOpacity(.15), borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 18, color: color),
    ),
  );

  // =============================== UI ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff4f5f9),

      appBar: AppBar(backgroundColor: Colors.blue, title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Admin Panel"),
          Text("User Management", style: TextStyle(fontSize: 12, color: Colors.white70))
        ],
      )),

      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Users", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            StreamBuilder(
              stream: _firestore.collection('customer_detail').snapshots(),
              builder: (context, s) {
                final total = s.hasData ? s.data!.docs.length : 0;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(.2), borderRadius: BorderRadius.circular(20)),
                  child: Text("$total Users", style: TextStyle(color: Colors.blue)),
                );
              },
            ),
          ]),

          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: TextField(
              controller: searchController,
              onChanged: (v) => setState(() {}),
              decoration: InputDecoration(icon: Icon(Icons.search), hintText: "Search user...", border: InputBorder.none),
            ),
          ),

          SizedBox(height: 10),
          Expanded(child: buildUserList()),
        ]),
      ),

      // ---------------- Bottom Navigation ----------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == selectedIndex) return;

          if (index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => admin_dashboard(uid: '',)));
          if (index == 1) return;
          if (index == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => admin_employe_list()));
          if (index == 3) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => admin_services()));

          setState(() => selectedIndex = index);
        },

        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Users"),
          BottomNavigationBarItem(icon: Icon(Icons.engineering), label: "Employees"),
          BottomNavigationBarItem(icon: Icon(Icons.cleaning_services), label: "Services"),
        ],
      ),
    );
  }
}
