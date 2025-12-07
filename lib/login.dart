import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Screens
import 'package:homebuddy/customer_app/customer_home.dart';
import 'package:homebuddy/admin_app/admin_dashboard.dart';
import 'package:homebuddy/employe_app/employe_dashbord.dart';
import 'package:homebuddy/option_screen.dart';

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  bool passwordVisible = false;
  bool isLoading = false;

  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    checkLoggedUser(); // Auto Login here
  }

  // ================= AUTO LOGIN =================
  Future<void> checkLoggedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString("role");

    if (role != null) {
      if (role == "admin") goTo(admin_dashboard());
      else if (role == "employee") goTo(employe_deshbord_screen());
      else if (role == "customer") goTo(customer_home_screen());
    }
  }

  // ================= LOGIN FUNCTION =================
  Future<void> login() async {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      showSnack("Enter Email & Password");
      return;
    }

    setState(() => isLoading = true);

    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: emailCtrl.text.trim(),
          password: passwordCtrl.text.trim()
      );

      String uid = user.user!.uid;
      String email = emailCtrl.text.trim();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // ===== ADMIN CHECK =====
      var adminDoc = await _fireStore.collection("admin_details").doc(uid).get();

      if (!adminDoc.exists) {
        var adminQuery = await _fireStore
            .collection("admin_details")
            .where("email", isEqualTo: email)
            .get();

        if (adminQuery.docs.isNotEmpty) adminDoc = adminQuery.docs.first;
      }

      if (adminDoc.exists) {
        prefs.setString("role", "admin");
        goTo(admin_dashboard());
        return;
      }


// ===== EMPLOYEE CHECK =====
      var empDoc = await _fireStore.collection("employe_detail").doc(uid).get();

      if (!empDoc.exists) {
        var empQuery = await _fireStore
            .collection("employe_detail")
            .where("email", isEqualTo: email)
            .get();

        if (empQuery.docs.isNotEmpty) empDoc = empQuery.docs.first;
      }

      if (empDoc.exists) {
        prefs.setString("role", "employee");
        goTo(employe_deshbord_screen());
        return;
      }


// ===== CUSTOMER CHECK =====
      var custDoc = await _fireStore.collection("customer_detail").doc(uid).get();

      if (!custDoc.exists) {
        var custQuery = await _fireStore
            .collection("customer_detail")
            .where("email", isEqualTo: email)
            .get();

        if (custQuery.docs.isNotEmpty) custDoc = custQuery.docs.first;
      }

      if (custDoc.exists) {
        prefs.setString("role", "customer");
        goTo(customer_home_screen());
        return;
      }

      showSnack("No user found in any collection");


      showSnack("No user found in any collection");

    } catch (e) {
      showSnack(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ================= Navigation =================
  void goTo(Widget page) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  showSnack(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8ECF7),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Center(
                  child: Text("Welcome Back", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),

                SizedBox(height: 6),

                Center(child: Text("Login to continue", style: TextStyle(color: Colors.grey))),
                SizedBox(height: 35),

                label("Email Address"),
                inputField(controller: emailCtrl, hint: "example@gmail.com", icon: Icons.email_outlined, keyboard: TextInputType.emailAddress),
                SizedBox(height: 20),

                label("Password"),
                TextField(
                  controller: passwordCtrl,
                  obscureText: !passwordVisible,
                  decoration: inputDecoration(Icons.lock_outline, "Enter password").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => passwordVisible = !passwordVisible),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Login", style: TextStyle(fontSize: 17, color: Colors.white)),
                  ),
                ),

                SizedBox(height: 25),

                Center(
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => option_screen())),
                    child: Text("Don't have an account? Register", style: TextStyle(color: Colors.deepPurple, decoration: TextDecoration.underline)),
                  ),
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= Widgets =================
  Widget label(String text) => Text(text, style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600));
  Widget inputField({required TextEditingController controller, required String hint, required IconData icon, TextInputType keyboard = TextInputType.text}) {
    return TextField(controller: controller, keyboardType: keyboard, decoration: inputDecoration(icon, hint));
  }
  InputDecoration inputDecoration(IconData icon, String hint) => InputDecoration(
    prefixIcon: Icon(icon, color: Colors.deepPurple),
    hintText: hint,
    filled: true,
    fillColor: Color(0xFFF3F4F6),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
  );
}
