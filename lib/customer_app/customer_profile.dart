import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class customer_profile extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String address;

  const customer_profile({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  @override
  State<customer_profile> createState() => _customer_profileState();
}

class _customer_profileState extends State<customer_profile> {

  late TextEditingController nameCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController addressCtrl;

  @override
  void initState() {
    super.initState();

    nameCtrl     = TextEditingController(text: widget.name);
    phoneCtrl    = TextEditingController(text: widget.phone);
    addressCtrl  = TextEditingController(text: widget.address);
  }

  // 🔥 Update in Firebase
  Future<void> updateProfile() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection("customer_detail").doc(uid).update({
      "name": nameCtrl.text,
      "phone": phoneCtrl.text,
      "address": addressCtrl.text,
    });

    Navigator.pop(context);
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profile Updated Successfully!")),
    );
  }

  // ========= Bottom Sheet for Edit =========
  void openEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(child: Text("Edit Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            SizedBox(height: 15),

            field("Name", nameCtrl),
            SizedBox(height: 12),

            field("Phone", phoneCtrl, type: TextInputType.phone),
            SizedBox(height: 12),

            field("Address", addressCtrl),
            SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff6C63FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Save Changes", style: TextStyle(color: Colors.white,fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // TextField UI
  Widget field(String label, TextEditingController ctrl, {TextInputType type = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 5),
        TextField(
          controller: ctrl,
          keyboardType: type,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FF),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff6C63FF), Color(0xff8A4DFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text("My Profile",
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
        child: Column(
          children: [

            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 63,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: const AssetImage("assets/images/user.png"),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xff6C63FF), Color(0xff8A4DFF)],
                      ),
                      boxShadow: [BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                      )],
                    ),
                    child: const Icon(Icons.camera_alt,size: 20,color: Colors.white),
                  )
                ],
              ),
            ),

            const SizedBox(height: 18),

            Text(nameCtrl.text,
                style: const TextStyle(fontSize: 23,fontWeight: FontWeight.bold,color: Color(0xff2F2F4F))),
            const SizedBox(height: 4),
            Text(widget.email,
                style: TextStyle(fontSize: 14,color: Colors.grey.shade600)),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(
                    color: Colors.black12,blurRadius: 12,offset: Offset(0,4)
                )],
              ),
              child: Column(
                children: [
                  profileTile(Icons.phone, "Phone", phoneCtrl.text),
                  divider(),
                  profileTile(Icons.location_on, "Address", addressCtrl.text),
                  divider(),
                  profileTile(Icons.verified_user, "Account Type", "Customer"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: openEditSheet,
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff6C63FF), Color(0xff8A4DFF)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text("Edit Profile",
                      style: TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextButton.icon(
              onPressed: (){},
              icon: const Icon(Icons.logout,color: Colors.red),
              label: const Text("Logout",
                style: TextStyle(color: Colors.red,fontSize: 16,fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileTile(IconData icon,String title,String value){
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.deepPurpleAccent.withOpacity(.15),
          child: Icon(icon,color: Color(0xff6C63FF),size: 22),
        ),
        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 13,color: Colors.grey,fontWeight: FontWeight.w500)),
              const SizedBox(height: 3),
              Text(value,
                  style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Color(0xff2F2F4F))),
            ],
          ),
        )
      ],
    );
  }

  Widget divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Container(
      height: 1,
      color: Colors.grey.shade300,
    ),
  );
}
