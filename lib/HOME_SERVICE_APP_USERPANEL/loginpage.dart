import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool passwordVisible = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: controller,
          curve: Curves.easeIn,
        ));

    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeOut),
        );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ⭐ Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Color(0xFFB3E5FC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // TOP RIGHT CIRCLE
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.20),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // BOTTOM LEFT CIRCLE
          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.20),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // ⭐ CENTER EVERYTHING VERTICALLY
          Center(
            child: FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      // ⭐ USER ICON
                      const Icon(
                        Icons.account_circle,
                        size: 120,
                        color: Colors.black87,
                      ),

                      const SizedBox(height: 40),

                      // ⭐ EMAIL FIELD – Blue Round Border
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle:
                            const TextStyle(color: Colors.black54),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 18),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                  color: Colors.lightBlue, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                  color: Colors.lightBlue, width: 2),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ⭐ PASSWORD FIELD – Round Border + Eye
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextField(
                          controller: passwordController,
                          obscureText: !passwordVisible,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle:
                            const TextStyle(color: Colors.black54),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 18),
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                  color: Colors.black45, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                  color: Colors.black45, width: 2),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ⭐ LOGIN BUTTON
                      SizedBox(
                        width: 160,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ⭐ Forgot Password
                      const Text(
                        "Forgot password?",
                        style: TextStyle(
                            color: Colors.black54, fontSize: 15),
                      ),

                      const SizedBox(height: 30),

                      // ⭐ Sign Up Now
                      const Text(
                        "Not a member? Sign up now",
                        style: TextStyle(
                            color: Colors.black54, fontSize: 16),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
