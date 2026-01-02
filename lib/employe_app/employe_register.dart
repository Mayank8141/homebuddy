import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../login.dart';

class employe_register_screen extends StatefulWidget {
  const employe_register_screen({super.key});

  @override
  State<employe_register_screen> createState() =>
      _employe_register_screenState();
}

class _employe_register_screenState extends State<employe_register_screen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool loading = false;
  bool _obscurePassword = true;


  // ================= ADMIN NOTIFICATION =================
  Future<void> notifyAdminNewProvider({
    required String providerId,
    required String providerName,
  }) async {
    final adminSnapshot =
    await _firestore.collection("admin_details").get();

    for (var admin in adminSnapshot.docs) {
      final docRef = _firestore.collection("notifications").doc();

      await docRef.set({
        "notification_id": docRef.id,
        "title": "New Provider Registered",
        "message": "$providerName has registered as a service provider",
        "receiver_id": admin.id,
        "receiver_type": "admin",
        "sender_id": providerId,
        "sender_type": "employee",
        "is_read": false,
        "created_at": FieldValue.serverTimestamp(),
      });
    }
  }



  // ================= USERNAME CHECK =================
  Future<bool> isUsernameAvailable(String name) async {
    final snap = await _firestore
        .collection("employe_detail")
        .where("name", isEqualTo: name.trim())
        .limit(1)
        .get();

    return snap.docs.isEmpty;
  }

  Future<void> register() async {
    if (nameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        passwordCtrl.text.length < 6) {
      showSnack(
        passwordCtrl.text.length < 6
            ? "Password must be at least 6 characters"
            : "Please fill all fields",
        Colors.orange,
        Icons.warning_amber_rounded,
      );
      return;
    }

    // ✅ GMAIL ONLY VALIDATION
    if (!emailCtrl.text.trim().toLowerCase().endsWith("@gmail.com")) {
      showSnack(
        "Only gmail.com email is allowed",
        Colors.red,
        Icons.error_outline,
      );
      return;
    }

    setState(() => loading = true);

    try {
      // ✅ USERNAME AVAILABILITY CHECK
      final available = await isUsernameAvailable(nameCtrl.text);
      if (!available) {
        showSnack(
          "Username already available",
          Colors.red,
          Icons.error_outline,
        );
        setState(() => loading = false);
        return;
      }

      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      await _firestore.collection("employe_detail").doc(cred.user!.uid).set({
        "uid": cred.user!.uid,
        "name": nameCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "profileCompleted": false,
        "createdAt": Timestamp.now(),
      });
      //  SEND NOTIFICATION TO ADMIN
      await notifyAdminNewProvider(
        providerId: cred.user!.uid,
        providerName: nameCtrl.text.trim(),
      );

      if (mounted) {
        showSnack(
          "Account created successfully!",
          Colors.green,
          Icons.check_circle,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => login_screen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'Password is too weak';
          break;
        case 'email-already-in-use':
          message = 'Email is already registered';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        default:
          message = e.message ?? 'Registration failed';
      }

      showSnack(message, Colors.red, Icons.error_outline);
    } catch (e) {
      showSnack(e.toString(), Colors.red, Icons.error_outline);
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  // ================= COMMON SNACK =================
  void showSnack(String text, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(text)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ================= IMPROVED UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Back Button with styled container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 32),

                // Header with better typography
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Sign up to get started",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 40),

                // Enhanced circular avatar with gradient and shadow
                Center(
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1ABC9C),
                          const Color(0xFF16A085),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1ABC9C).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Styled TextField - Full Name
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    hintText: "Enter your full name",
                    prefixIcon: const Icon(Icons.person_outline_rounded, size: 22),
                    labelStyle: TextStyle(color: Colors.grey[600], fontSize: 15),
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF1ABC9C),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Styled TextField - Email
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "yourname@gmail.com",
                    prefixIcon: const Icon(Icons.email_outlined, size: 22),
                    labelStyle: TextStyle(color: Colors.grey[600], fontSize: 15),
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF1ABC9C),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Styled TextField - Password
                TextField(
                  controller: passwordCtrl,
                  obscureText: _obscurePassword,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Minimum 6 characters",
                    prefixIcon: const Icon(Icons.lock_outline_rounded, size: 22),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey[600],
                        size: 22,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    labelStyle: TextStyle(color: Colors.grey[600], fontSize: 15),
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF1ABC9C),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Enhanced Create Account Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: loading ? null : register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1ABC9C),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                    child: loading
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                        : const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => login_screen()),
                      ),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Color(0xFF1ABC9C),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Terms & Privacy
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "By signing up, you agree to our\nTerms of Service and Privacy Policy",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }
}