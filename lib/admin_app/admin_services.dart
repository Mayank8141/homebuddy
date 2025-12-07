import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Import navigation pages
import 'admin_dashboard.dart';
import 'admin_users.dart';
import 'admin_employe.dart';

class admin_services extends StatefulWidget {
  const admin_services({super.key});

  @override
  State<admin_services> createState() => _admin_servicesState();
}

class _admin_servicesState extends State<admin_services> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  int selectedIndex = 3;  // Dashboard=0, Users=1, Employees=2, Services=3

  // --------------------------- ADD SERVICE ---------------------------
  void openAddServiceModal() {
    nameController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Add Service",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
                onPressed: () => Navigator.pop(context), icon: Icon(Icons.close))
          ]),
          SizedBox(height: 10),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Service Name",
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) return;

              await _firestore.collection("services").add({
                "name": nameController.text.trim(),
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Service Added Successfully")));
            },
            style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blue),
            child: Text("Add"),
          ),
          SizedBox(height: 20),
        ]),
      ),
    );
  }

  // --------------------------- EDIT SERVICE ---------------------------
  void openEditServiceModal(String id, String name) {
    nameController.text = name;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Edit Service",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
                onPressed: () => Navigator.pop(context), icon: Icon(Icons.close))
          ]),
          SizedBox(height: 10),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Service Name",
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await _firestore.collection("services").doc(id).update({
                "name": nameController.text.trim(),
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Service Updated Successfully")));
            },
            style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.green),
            child: Text("Save"),
          ),
          SizedBox(height: 20),
        ]),
      ),
    );
  }

  // --------------------------- DELETE SERVICE ---------------------------
  void deleteService(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Service"),
        content: Text("Are you sure you want to delete this service?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _firestore.collection("services").doc(id).delete();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Service Deleted")));
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  // --------------------------- UI ---------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff4f5f9),

      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Admin Panel"),
          Text("Services Management",
              style: TextStyle(fontSize: 12, color: Colors.white70)),
        ]),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: openAddServiceModal,
        child: Icon(Icons.add),
      ),

      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Services",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            StreamBuilder(
              stream: _firestore.collection("services").snapshots(),
              builder: (_, s) {
                int total = s.hasData ? s.data!.docs.length : 0;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(.2),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text("$total Services",
                      style: TextStyle(color: Colors.blue)),
                );
              },
            ),
          ]),

          SizedBox(height: 10),

          // Search Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Search services...",
                  border: InputBorder.none),
            ),
          ),

          SizedBox(height: 10),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection("services").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                final docs = snapshot.data!.docs;

                // Search filter safe
                final filtered = docs.where((d) {
                  final data = d.data() as Map<String, dynamic>;
                  return (data["name"] ?? "")
                      .toString()
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (_, index) {
                    final data = filtered[index].data() as Map<String, dynamic>;
                    final id = filtered[index].id;
                    final name = data["name"] ?? "Unnamed Service";

                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(name,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          Row(children: [
                            iconButton(Icons.edit, Colors.blue,
                                    () => openEditServiceModal(id, name)),
                            SizedBox(width: 8),
                            iconButton(Icons.delete, Colors.red,
                                    () => deleteService(id)),
                          ])
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ]),
      ),

      // -------------------- Navigation bar --------------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          if (index == selectedIndex) return;

          if (index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => admin_dashboard()));
          if (index == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => admin_user_list()));
          if (index == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => admin_employe_list()));
          if (index == 3) return;

          setState(() => selectedIndex = index);
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Users"),
          BottomNavigationBarItem(icon: Icon(Icons.engineering), label: "Employee"),
          BottomNavigationBarItem(icon: Icon(Icons.cleaning_services), label: "Services"),
        ],
      ),
    );
  }

  Widget iconButton(icon, color, onTap) => InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: color.withOpacity(.15),
          borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 18, color: color),
    ),
  );
}
