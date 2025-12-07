import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'admin_dashboard.dart';

class admin_login extends StatefulWidget {
  const admin_login({super.key});

  @override
  State<admin_login> createState() => _admin_loginState();
}

class _admin_loginState extends State<admin_login> {
  final TextEditingController _admin_email_controller = TextEditingController();
  final TextEditingController _admin_pass_controller = TextEditingController();

  bool _obscurePassword = true;

  Future<bool> validateAdminCredentials(String email, String password) async {
    try {
      final QuerySnapshot adminSnapshot = await FirebaseFirestore.instance
          .collection('admin_details')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (adminSnapshot.docs.isEmpty) return false;

      final adminData =
      adminSnapshot.docs.first.data() as Map<String, dynamic>;

      return adminData['password'] == password;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$e')));
      return false;
    }
  }

  Future<void> LoginAsAdmin() async {
    final email = _admin_email_controller.text.trim();
    final pass = _admin_pass_controller.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all details")),
      );
      return;
    }

    try {
      final isAdminValid = await validateAdminCredentials(email, pass);

      if (isAdminValid) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => admin_dashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE8EEF3),

      body: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                spreadRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Center(
                child: Text(
                  "Admin Login",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Email
              const Text(
                "Email Address",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _admin_email_controller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  hintText: "admin@example.com",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Password
              const Text(
                "Password",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _admin_pass_controller,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  hintText: "Enter your password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),

                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Remember me

              // Sign in button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: LoginAsAdmin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Center(
              //   child: TextButton(
              //     onPressed: () {},
              //     child: const Text(
              //       "Forgot Password?",
              //       style: TextStyle(
              //         color: Colors.black54,
              //         fontSize: 14,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
