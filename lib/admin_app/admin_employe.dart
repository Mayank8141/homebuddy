import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Import other screens
import 'admin_dashboard.dart';
import 'admin_users.dart';
import 'admin_services.dart';

class admin_employe_list extends StatefulWidget {
  const admin_employe_list({super.key});

  @override
  State<admin_employe_list> createState() => _admin_employe_listState();
}

class _admin_employe_listState extends State<admin_employe_list> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();

  int selectedIndex = 2; // Dashboard=0 | Users=1 | Employees=2 | Services=3

  // ================= Delete =================
  void deleteEmployee(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Employee"),
        content: Text("Are you sure you want to delete this employee?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _firestore.collection("employe_detail").doc(id).delete();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Employee deleted")));
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  // ================= Edit Modal =================
  void openEditEmployee(String id, Map<String, dynamic> data) {
    TextEditingController nameCtrl = TextEditingController(text: data["name"]);
    TextEditingController emailCtrl = TextEditingController(text: data["email"]);
    TextEditingController phoneCtrl = TextEditingController(text: data["phone"]);
    TextEditingController serviceCtrl = TextEditingController(text: data["service"]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Edit Employee", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close))
          ]),
          SizedBox(height: 10),

          field(nameCtrl, "Name"),
          SizedBox(height: 10),
          field(emailCtrl, "Email"),
          SizedBox(height: 10),
          field(phoneCtrl, "Phone"),
          SizedBox(height: 10),
          field(serviceCtrl, "Service/Role"),
          SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50), backgroundColor: Colors.blue),
            onPressed: () async {
              await _firestore.collection("employe_detail").doc(id).update({
                "name": nameCtrl.text.trim(),
                "email": emailCtrl.text.trim(),
                "phone": phoneCtrl.text.trim(),
                "service": serviceCtrl.text.trim(),
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Employee updated")));
            },
            child: Text("Save"),
          ),
          SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget field(TextEditingController c, String label) => TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    ),
  );

  // ================= List UI =================
  Widget buildEmployeeList() {
    return StreamBuilder(
      stream: _firestore.collection("employe_detail").snapshots(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;

        final filtered = docs.where((d) {
          final data = d.data() as Map<String, dynamic>;
          final name = (data["name"] ?? "").toString().toLowerCase();
          return name.contains(searchController.text.toLowerCase());
        }).toList();

        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (_, index) {
            final emp = filtered[index];
            final id = emp.id;
            final data = emp.data() as Map<String, dynamic>;

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
                  Icon(Icons.chevron_right),
                ]),
                SizedBox(height: 4),
                Text(data["email"] ?? ""),
                Text(data["phone"] ?? ""),
                SizedBox(height: 8),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("Join Date\n${getJoinDate()}", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text("Jobs\n${data["total_jobs"] ?? 0}", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text("Rating\n⭐ ${data["rating"] ?? "-"}", style: TextStyle(color: Colors.grey, fontSize: 12)),

                  Row(children: [
                    iconBtn(Icons.edit, Colors.blue, () => openEditEmployee(id, data)),
                    SizedBox(width: 8),
                    iconBtn(Icons.delete, Colors.red, () => deleteEmployee(id)),
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

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff4f5f9),

      appBar: AppBar(backgroundColor: Colors.blue, title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Admin Panel"),
          Text("Employee Management", style: TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      )),

      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Employee List", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            StreamBuilder(
              stream: _firestore.collection("employe_detail").snapshots(),
              builder: (_, s) {
                final total = s.hasData ? s.data!.docs.length : 0;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(.2), borderRadius: BorderRadius.circular(20)),
                  child: Text("$total Employees", style: TextStyle(color: Colors.blue)),
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
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(icon: Icon(Icons.search), hintText: "Search employee...", border: InputBorder.none),
            ),
          ),

          SizedBox(height: 10),
          Expanded(child: buildEmployeeList()),
        ]),
      ),

      // ================= Bottom Nav =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == selectedIndex) return;

          if (index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => admin_dashboard(uid: '',)));
          if (index == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => admin_user_list()));
          if (index == 2) return;
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
