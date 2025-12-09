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
      home: const RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  bool passwordVisible = false;

  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(seconds: 2), vsync: this);

    fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: controller,
          curve: Curves.easeIn,
        ));

    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
            .animate(CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
        ));

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
          // 🌟 BACKGROUND GRADIENT
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Color(0xFFB3E5FC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 🌟 TRANSPARENT BLUE SHAPES
          Positioned(
            top: -130,
            right: -90,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -120,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.20),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 🌟 ANIMATED CONTENT
          Center(
            child: SingleChildScrollView(
              child: FadeTransition(
                opacity: fadeAnimation,
                child: SlideTransition(
                  position: slideAnimation,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // ⭐ ICON LOGO
                      const CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 50, color: Colors.blue),
                      ),

                      const SizedBox(height: 20),

                      // ⭐ FORM CARD
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 35),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Create Account",
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "Please enter your correct information.",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                              const SizedBox(height: 25),

                              _buildIconField(Icons.person, "Name",
                                  nameController),
                              const SizedBox(height: 15),

                              _buildIconField(Icons.email, "Email",
                                  emailController),
                              const SizedBox(height: 15),

                              _buildIconField(Icons.phone, "Phone No",
                                  phoneController,
                                  keyboard: TextInputType.phone),
                              const SizedBox(height: 15),

                              _buildIconField(Icons.home, "Address",
                                  addressController),
                              const SizedBox(height: 15),

                              _buildPasswordField(
                                Icons.lock,
                                "Password",
                                passwordController,
                                passwordVisible,
                                    () => setState(() =>
                                passwordVisible = !passwordVisible),
                              ),

                              const SizedBox(height: 25),

                              // REGISTER BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text("REGISTER",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                ),
                              ),
                            ],
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
        ],
      ),
    );
  }

  // ⭐ TEXT FIELD WITH ICON
  Widget _buildIconField(IconData icon, String label,
      TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }

  // ⭐ PASSWORD FIELD WITH ICON + EYE BUTTON
  Widget _buildPasswordField(IconData icon, String label,
      TextEditingController controller, bool visible, VoidCallback toggle) {
    return TextField(
      controller: controller,
      obscureText: !visible,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        suffixIcon: IconButton(
          icon: Icon(
              visible ? Icons.visibility : Icons.visibility_off,
              color: Colors.blueAccent),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }
}
