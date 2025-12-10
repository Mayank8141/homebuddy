import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    checkLoggedUser();
  }

  // ========================================= AUTO LOGIN =========================================
  Future<void> checkLoggedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString("role");

    if (role != null) {
      if (role == "admin") goTo(admin_dashboard());
      else if (role == "employee") goTo(employe_deshbord_screen());
      else if (role == "customer") goTo(customer_home_screen());
    }
  }

  // ========================================= LOGIN FUNCTION =====================================
  Future<void> login() async {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      showSnack("Enter Email & Password");
      return;
    }

    setState(() => isLoading = true);

    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      String uid = user.user!.uid;
      String email = emailCtrl.text.trim();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // ------------------ ADMIN ------------------
      var admin = await _fireStore.collection("admin_details").doc(uid).get();
      if (!admin.exists) {
        var q = await _fireStore.collection("admin_details").where("email", isEqualTo: email).get();
        if (q.docs.isNotEmpty) admin = q.docs.first;
      }
      if (admin.exists) {
        prefs.setString("role", "admin");
        goTo(admin_dashboard());
        return;
      }

      // ------------------ EMPLOYEE ------------------
      var emp = await _fireStore.collection("employe_detail").doc(uid).get();
      if (!emp.exists) {
        var q = await _fireStore.collection("employe_detail").where("email", isEqualTo: email).get();
        if (q.docs.isNotEmpty) emp = q.docs.first;
      }
      if (emp.exists) {
        prefs.setString("role", "employee");
        goTo(employe_deshbord_screen());
        return;
      }

      // ------------------ CUSTOMER ------------------
      var cust = await _fireStore.collection("customer_detail").doc(uid).get();
      if (!cust.exists) {
        var q = await _fireStore.collection("customer_detail").where("email", isEqualTo: email).get();
        if (q.docs.isNotEmpty) cust = q.docs.first;
      }
      if (cust.exists) {
        prefs.setString("role", "customer");
        goTo(customer_home_screen());
        return;
      }

      showSnack("No user found in any collection");

    } catch (e) {
      showSnack(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Navigation
  void goTo(Widget page) =>
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));

  showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  // ========================================= UI =========================================
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(         // <-- STATUS BAR ADDED HERE
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,               // Change color if needed
        statusBarIconBrightness: Brightness.dark,         // Light/Dark based on BG
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFEEF1F7),

        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const Text(
                  "Welcome Back!",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                Text("Login to continue",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 15)),

                const SizedBox(height: 40),

                Align(alignment: Alignment.centerLeft, child: label("Email")),
                inputField(controller: emailCtrl, hint: "example@gmail.com", icon: Icons.email_outlined),
                const SizedBox(height: 20),

                Align(alignment: Alignment.centerLeft, child: label("Password")),
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

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),

                const SizedBox(height: 30),

                InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => option_screen())),
                  child: const Text(
                    "Don't have an account? Register",
                    style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w500),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------- Widgets --------
  Widget label(String text) => Text(text,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600));

  Widget inputField({required TextEditingController controller, required String hint, required IconData icon}) {
    return TextField(
      controller: controller,
      decoration: inputDecoration(icon, hint),
    );
  }

  InputDecoration inputDecoration(IconData icon, String hint) => InputDecoration(
    prefixIcon: Icon(icon, color: Colors.deepPurple),
    hintText: hint,
    filled: true,
    fillColor: const Color(0xFFF6F6F8),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.deepPurple)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
  );
}
