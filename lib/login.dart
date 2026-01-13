// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// // Screens (UPDATED TO RECEIVE UID)
// import '../customer_app/customer_home.dart';
// import '../admin_app/admin_dashboard.dart';
// import '../option_screen.dart';
// import '../main.dart';
// import 'email_verification_screen.dart';
//
// class login_screen extends StatefulWidget {
//   const login_screen({super.key});
//
//   @override
//   State<login_screen> createState() => _login_screenState();
// }
//
// class _login_screenState extends State<login_screen> {
//   bool passwordVisible = false;
//   bool isLoading = false;
//
//   final TextEditingController emailCtrl = TextEditingController();
//   final TextEditingController passwordCtrl = TextEditingController();
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   checkLoggedUser();
//   // }
//
//   // ---------------------- AUTO LOGIN ----------------------
//   // Future<void> checkLoggedUser() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String? role = prefs.getString("role");
//   //   String? uid = prefs.getString("uid");
//   //
//   //   if (role != null && uid != null) {
//   //     if (role == "admin") goTo(admin_dashboard(uid: uid));
//   //     else if (role == "employee") goTo(EmployeeMain(uid: uid));
//   //     else if (role == "customer") goTo(customer_home_screen(uid: uid));
//   //   }
//   // }
//
//   // ---------------------- LOGIN FUNCTION ----------------------
//   Future<void> login() async {
//     if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
//       showSnack("Enter Email & Password", Colors.orange);
//       return;
//     }
//
//     setState(() => isLoading = true);
//
//     try {
//       UserCredential user = await _auth.signInWithEmailAndPassword(
//         email: emailCtrl.text.trim(),
//         password: passwordCtrl.text.trim(),
//       );
//
//       if (!user.user!.emailVerified) {
//         await _auth.signOut();
//
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const EmailVerificationScreen()),
//         );
//         return;
//       }
//
//
//       String uid = user.user!.uid;
//       String email = emailCtrl.text.trim();
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//
//       // ========== ADMIN ==========
//       var admin = await _fireStore.collection("admin_details").doc(uid).get();
//       if (!admin.exists) {
//         var q = await _fireStore
//             .collection("admin_details")
//             .where("email", isEqualTo: email)
//             .get();
//         if (q.docs.isNotEmpty) admin = q.docs.first;
//       }
//       if (admin.exists) {
//         prefs.setString("role", "admin");
//         prefs.setString("uid", uid);
//         showSnack("Login successful!", Colors.green);
//         await Future.delayed(const Duration(milliseconds: 800));
//         goTo(admin_dashboard(uid: uid));
//         return;
//       }
//
//       // ========== EMPLOYEE ==========
//       var emp = await _fireStore.collection("employe_detail").doc(uid).get();
//       if (!emp.exists) {
//         var q = await _fireStore
//             .collection("employe_detail")
//             .where("email", isEqualTo: email)
//             .get();
//         if (q.docs.isNotEmpty) emp = q.docs.first;
//       }
//       // if (emp.exists) {
//       //   await prefs.setString("role", "employee");
//       //   await prefs.setString("uid", uid);
//       //
//       //   showSnack("Login successful!", Colors.green);
//       //   await Future.delayed(const Duration(milliseconds: 800));
//       //
//       //   goTo(EmployeeMain(uid: uid)); // ✅ ROOT SCREEN
//       //   return;
//       // }
//
//       if (emp.exists) {
//         // 🔐 EMAIL VERIFICATION CHECK
//         if (!user.user!.emailVerified) {
//           await _auth.signOut();
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const EmailVerificationScreen()),
//           );
//           return;
//         }
//
//         await prefs.setString("role", "employee");
//         await prefs.setString("uid", uid);
//
//         showSnack("Login successful!", Colors.green);
//         await Future.delayed(const Duration(milliseconds: 800));
//         goTo(EmployeeMain(uid: uid));
//         return;
//       }
//
//
//
//       // ========== CUSTOMER ==========
//       var cust = await _fireStore.collection("customer_detail").doc(uid).get();
//       if (!cust.exists) {
//         var q = await _fireStore
//             .collection("customer_detail")
//             .where("email", isEqualTo: email)
//             .get();
//         if (q.docs.isNotEmpty) cust = q.docs.first;
//       }
//       // if (cust.exists) {
//       //   prefs.setString("role", "customer");
//       //   prefs.setString("uid", uid);
//       //   showSnack("Login successful!", Colors.green);
//       //   await Future.delayed(const Duration(milliseconds: 800));
//       //   goTo(customer_home_screen(uid: uid));
//       //   return;
//       // }
//
//       if (cust.exists) {
//         // 🔐 EMAIL VERIFICATION CHECK
//         if (!user.user!.emailVerified) {
//           await _auth.signOut();
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const EmailVerificationScreen()),
//           );
//           return;
//         }
//
//         prefs.setString("role", "customer");
//         prefs.setString("uid", uid);
//
//         showSnack("Login successful!", Colors.green);
//         await Future.delayed(const Duration(milliseconds: 800));
//         goTo(customer_home_screen(uid: uid));
//         return;
//       }
//
//
//       showSnack("No user found in any collection", Colors.red);
//
//     } on FirebaseAuthException catch (e) {
//       String message;
//       switch (e.code) {
//         case 'user-not-found':
//           message = 'No user found with this email';
//           break;
//         case 'wrong-password':
//           message = 'Incorrect password';
//           break;
//         case 'invalid-email':
//           message = 'Invalid email address';
//           break;
//         case 'user-disabled':
//           message = 'This account has been disabled';
//           break;
//         default:
//           message = e.message ?? 'Login failed';
//       }
//       showSnack(message, Colors.red);
//     } catch (e) {
//       showSnack(e.toString(), Colors.red);
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   // ------------- NAVIGATION -------------
//   void goTo(Widget page) =>
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
//
//   void showSnack(String msg, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(
//               color == Colors.green
//                   ? Icons.check_circle
//                   : color == Colors.orange
//                   ? Icons.warning_amber_rounded
//                   : Icons.error_outline,
//               color: Colors.white,
//               size: 22,
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 msg,
//                 style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: color,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
//
//   // ========================== UI ==========================
//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.dark,
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 40),
//
//                   // Logo/Icon
//                   Center(
//                     child: Container(
//                       width: 100,
//                       height: 100,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             const Color(0xFF1ABC9C),
//                             const Color(0xFF16A085),
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xFF1ABC9C).withOpacity(0.3),
//                             blurRadius: 20,
//                             offset: const Offset(0, 8),
//                           ),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.lock_person_rounded,
//                         size: 45,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 40),
//
//                   // Welcome Text
//                   const Text(
//                     "Welcome Back!",
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                       letterSpacing: -0.5,
//                     ),
//                   ),
//
//                   const SizedBox(height: 8),
//
//                   Text(
//                     "Login to continue",
//                     style: TextStyle(
//
//                       fontSize: 16,
//                       color: Colors.grey[600],
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//
//                   const SizedBox(height: 50),
//
//                   // Email Field
//                   label("Email"),
//                   const SizedBox(height: 8),
//                   inputField(
//                     controller: emailCtrl,
//                     hint: "example@gmail.com",
//                     icon: Icons.email_outlined,
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Password Field
//                   label("Password"),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: passwordCtrl,
//                     obscureText: !passwordVisible,
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     decoration: inputDecoration(
//                       Icons.lock_outline_rounded,
//                       "Enter password",
//                     ).copyWith(
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           passwordVisible
//                               ? Icons.visibility_outlined
//                               : Icons.visibility_off_outlined,
//                           color: Colors.grey[600],
//                           size: 22,
//                         ),
//                         onPressed: () =>
//                             setState(() => passwordVisible = !passwordVisible),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 32),
//
//                   // Login Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: ElevatedButton(
//                       onPressed: isLoading ? null : login,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF1ABC9C),
//                         foregroundColor: Colors.white,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         disabledBackgroundColor: Colors.grey[300],
//                       ),
//                       child: isLoading
//                           ? const SizedBox(
//                         height: 24,
//                         width: 24,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2.5,
//                         ),
//                       )
//                           : const Text(
//                         "Login",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 30),
//
//                   // Register Link
//                   Center(
//                     child: GestureDetector(
//                       onTap: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => option_screen()),
//                       ),
//                       child: RichText(
//                         text: TextSpan(
//                           text: "Don't have an account? ",
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 15,
//                           ),
//                           children: const [
//                             TextSpan(
//                               text: "Register",
//                               style: TextStyle(
//                                 color: Color(0xFF1ABC9C),
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ---------------- Reusable UI Widgets ----------------
//   Widget label(String text) => Text(
//     text,
//     style: const TextStyle(
//       fontSize: 15,
//       fontWeight: FontWeight.w600,
//       color: Colors.black87,
//     ),
//   );
//
//   Widget inputField({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//   }) {
//     return TextField(
//       controller: controller,
//       style: const TextStyle(
//         color: Colors.black,
//         fontSize: 16,
//         fontWeight: FontWeight.w500,
//       ),
//       decoration: inputDecoration(icon, hint),
//     );
//   }
//
//   InputDecoration inputDecoration(IconData icon, String hint) => InputDecoration(
//     prefixIcon: Icon(icon, color: const Color(0xFF1ABC9C), size: 22),
//     hintText: hint,
//     hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
//     filled: true,
//     fillColor: Colors.grey[50],
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(16),
//       borderSide: BorderSide.none,
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(16),
//       borderSide: BorderSide(color: Colors.grey[200]!),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(16),
//       borderSide: const BorderSide(color: Color(0xFF1ABC9C), width: 2),
//     ),
//     contentPadding: const EdgeInsets.symmetric(
//       horizontal: 20,
//       vertical: 18,
//     ),
//   );
//
//   @override
//   void dispose() {
//     emailCtrl.dispose();
//     passwordCtrl.dispose();
//     super.dispose();
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Screens
import '../customer_app/customer_home.dart';
import '../admin_app/admin_dashboard.dart';
import '../option_screen.dart';
import '../main.dart';
import 'email_verification_screen.dart';

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

  // ================= LOGIN FUNCTION =================
  // Future<void> login() async {
  //   if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
  //     showSnack("Enter Email & Password", Colors.orange);
  //     return;
  //   }
  //
  //   setState(() => isLoading = true);
  //
  //   try {
  //     // 🔐 Firebase Login
  //     UserCredential user = await _auth.signInWithEmailAndPassword(
  //       email: emailCtrl.text.trim(),
  //       password: passwordCtrl.text.trim(),
  //     );
  //
  //     String uid = user.user!.uid;
  //     String email = emailCtrl.text.trim();
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //     // ================= ADMIN =================
  //     var admin = await _fireStore.collection("admin_details").doc(uid).get();
  //     if (!admin.exists) {
  //       var q = await _fireStore
  //           .collection("admin_details")
  //           .where("email", isEqualTo: email)
  //           .get();
  //       if (q.docs.isNotEmpty) admin = q.docs.first;
  //     }
  //
  //     if (admin.exists) {
  //       prefs.setString("role", "admin");
  //       prefs.setString("uid", uid);
  //
  //       showSnack("Admin login successful!", Colors.green);
  //       await Future.delayed(const Duration(milliseconds: 800));
  //       goTo(admin_dashboard(uid: uid));
  //       return;
  //     }
  //
  //     // ================= EMPLOYEE =================
  //     var emp = await _fireStore.collection("employe_detail").doc(uid).get();
  //     if (!emp.exists) {
  //       var q = await _fireStore
  //           .collection("employe_detail")
  //           .where("email", isEqualTo: email)
  //           .get();
  //       if (q.docs.isNotEmpty) emp = q.docs.first;
  //     }
  //
  //     if (emp.exists) {
  //       // 🔐 EMAIL VERIFICATION REQUIRED
  //       if (!user.user!.emailVerified) {
  //         await _auth.signOut();
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (_) => const EmailVerificationScreen(),
  //           ),
  //         );
  //         return;
  //       }
  //
  //       prefs.setString("role", "employee");
  //       prefs.setString("uid", uid);
  //
  //       showSnack("Login successful!", Colors.green);
  //       await Future.delayed(const Duration(milliseconds: 800));
  //       goTo(EmployeeMain(uid: uid));
  //       return;
  //     }
  //
  //     // ================= CUSTOMER =================
  //     var cust = await _fireStore.collection("customer_detail").doc(uid).get();
  //     if (!cust.exists) {
  //       var q = await _fireStore
  //           .collection("customer_detail")
  //           .where("email", isEqualTo: email)
  //           .get();
  //       if (q.docs.isNotEmpty) cust = q.docs.first;
  //     }
  //
  //     if (cust.exists) {
  //       // 🔐 EMAIL VERIFICATION REQUIRED
  //       if (!user.user!.emailVerified) {
  //         await _auth.signOut();
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (_) => const EmailVerificationScreen(),
  //           ),
  //         );
  //         return;
  //       }
  //
  //       prefs.setString("role", "customer");
  //       prefs.setString("uid", uid);
  //
  //       showSnack("Login successful!", Colors.green);
  //       await Future.delayed(const Duration(milliseconds: 800));
  //       goTo(customer_home_screen(uid: uid));
  //       return;
  //     }
  //
  //     showSnack("No user found in system", Colors.red);
  //
  //   } on FirebaseAuthException catch (e) {
  //     String message;
  //     switch (e.code) {
  //       case 'user-not-found':
  //         message = 'No user found with this email';
  //         break;
  //       case 'wrong-password':
  //         message = 'Incorrect password';
  //         break;
  //       case 'invalid-email':
  //         message = 'Invalid email address';
  //         break;
  //       case 'user-disabled':
  //         message = 'This account has been disabled';
  //         break;
  //       default:
  //         message = e.message ?? 'Login failed';
  //     }
  //     showSnack(message, Colors.red);
  //   } catch (e) {
  //     showSnack(e.toString(), Colors.red);
  //   } finally {
  //     setState(() => isLoading = false);
  //   }
  // }


  Future<void> login() async {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      showSnack("Enter Email & Password", Colors.orange);
      return;
    }

    setState(() => isLoading = true);

    try {
      // 🔐 Firebase Login
      UserCredential user = await _auth.signInWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      final firebaseUser = user.user!;
      final uid = firebaseUser.uid;
      final email = firebaseUser.email!;
      final prefs = await SharedPreferences.getInstance();

      // ================= ADMIN =================
      final adminDoc =
      await _fireStore.collection("admin_details").doc(uid).get();

      if (adminDoc.exists) {
        // 🚫 DO NOT CHECK EMAIL VERIFICATION FOR ADMIN
        await prefs.setString("role", "admin");
        await prefs.setString("uid", uid);

        showSnack("Admin login successful!", Colors.green);
        await Future.delayed(const Duration(milliseconds: 600));

        //goTo(admin_dashboard(uid: uid));

        goTo(AdminMain(uid: uid));

        return;
      }

      // ================= EMPLOYEE =================
      final empDoc =
      await _fireStore.collection("employe_detail").doc(uid).get();

      if (empDoc.exists) {
        // ✅ EMAIL VERIFICATION REQUIRED
        if (!firebaseUser.emailVerified) {
          await _auth.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const EmailVerificationScreen(),
            ),
          );
          return;
        }

        await prefs.setString("role", "employee");
        await prefs.setString("uid", uid);

        showSnack("Login successful!", Colors.green);
        await Future.delayed(const Duration(milliseconds: 600));

        goTo(EmployeeMain(uid: uid));
        return;
      }

      // ================= CUSTOMER =================
      final custDoc =
      await _fireStore.collection("customer_detail").doc(uid).get();

      if (custDoc.exists) {
        // ✅ EMAIL VERIFICATION REQUIRED
        if (!firebaseUser.emailVerified) {
          await _auth.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const EmailVerificationScreen(),
            ),
          );
          return;
        }

        await prefs.setString("role", "customer");
        await prefs.setString("uid", uid);

        showSnack("Login successful!", Colors.green);
        await Future.delayed(const Duration(milliseconds: 600));

        goTo(customer_home_screen(uid: uid));
        return;
      }

      // ❌ No role found
      await _auth.signOut();
      showSnack("No user found in system", Colors.red);

    } on FirebaseAuthException catch (e) {
      showSnack(e.message ?? "Login failed", Colors.red);
    } finally {
      setState(() => isLoading = false);
    }
  }




  // ================= NAVIGATION =================
  void goTo(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == Colors.green
                  ? Icons.check_circle
                  : color == Colors.orange
                  ? Icons.warning_amber_rounded
                  : Icons.error_outline,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Logo/Icon
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
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
                        Icons.lock_person_rounded,
                        size: 45,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Welcome Text
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Login to continue",
                    style: TextStyle(

                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Email Field
                  label("Email"),
                  const SizedBox(height: 8),
                  inputField(
                    controller: emailCtrl,
                    hint: "example@gmail.com",
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 20),

                  // Password Field
                  label("Password"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordCtrl,
                    obscureText: !passwordVisible,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: inputDecoration(
                      Icons.lock_outline_rounded,
                      "Enter password",
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey[600],
                          size: 22,
                        ),
                        onPressed: () =>
                            setState(() => passwordVisible = !passwordVisible),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1ABC9C),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Register Link
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => option_screen()),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                          ),
                          children: const [
                            TextSpan(
                              text: "Register",
                              style: TextStyle(
                                color: Color(0xFF1ABC9C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- Reusable UI Widgets ----------------
  Widget label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
  );

  Widget inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: inputDecoration(icon, hint),
    );
  }

  InputDecoration inputDecoration(IconData icon, String hint) => InputDecoration(
    prefixIcon: Icon(icon, color: const Color(0xFF1ABC9C), size: 22),
    hintText: hint,
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
      borderSide: const BorderSide(color: Color(0xFF1ABC9C), width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 18,
    ),
  );

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }
}
