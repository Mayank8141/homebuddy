import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homebuddy/employe_app/employe_dashbord.dart';
import 'package:homebuddy/employe_app/employe_register.dart';

class employe_login_screen extends StatefulWidget {
  const employe_login_screen({super.key});

  @override
  State<employe_login_screen> createState() => _employe_login_screenState();
}

class _employe_login_screenState extends State<employe_login_screen> {
  bool passwordVisible = false;

  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword
        (email: emailCtrl.text.trim(), password: passwordCtrl.text.trim());
      String userId = userCredential.user!.uid;
      DocumentSnapshot userDoc = await _fireStore
          .collection('employe_detail')
          .doc(userId)
          .get();
      if (!userDoc.exists) {
        throw Exception("user Recorde Not Found");
      }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => employe_deshbord_screen()));
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())));
    }
  }

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
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Center(
                  child: Text(
                    "Welcome Back vvvvvvvvvvvvvvvvv",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 6),

                Center(
                  child: Text(
                    "Login to continue",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                SizedBox(height: 35),

                label("Email Address"),
                inputField(
                  controller: emailCtrl,
                  hint: "example@gmail.com",
                  icon: Icons.email_outlined,
                  keyboard: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),

                label("Password"),
                TextField(
                  controller: passwordCtrl,
                  obscureText: !passwordVisible,
                  decoration: inputDecoration(
                      Icons.lock_outline, "Enter password").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible ? Icons.visibility : Icons
                            .visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => passwordVisible = !passwordVisible);
                      },
                    ),
                  ),
                ),

                SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text("Forgot Password?",
                        style: TextStyle(color: Colors.deepPurple)),
                  ),
                ),

                SizedBox(height: 10),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: login,
                    child: Text("Login",
                        style: TextStyle(fontSize: 17, color: Colors.white)),
                  ),
                ),

                SizedBox(height: 25),
                Center(child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) =>
                          employe_register_screen()), // Change where needed
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.black87),
                      children: [
                        TextSpan(
                          text: "Register",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
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

  // -------------------- UI Helper Widgets --------------------

  Widget label(String text) =>
      Text(
        text,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87),
      );

  Widget inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: inputDecoration(icon, hint),
    );
  }

  InputDecoration inputDecoration(IconData icon, String hint) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.deepPurple),
      hintText: hint,
      filled: true,
      fillColor: Color(0xFFF3F4F6),
      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
