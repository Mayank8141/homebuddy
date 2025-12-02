import 'package:flutter/material.dart';

import 'admin_app/admin_login.dart';

class option_screen extends StatefulWidget {
  const option_screen({super.key});

  @override
  State<option_screen> createState() => _option_screenState();
}

class _option_screenState extends State<option_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Logo
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.design_services,
                      color: Color(0xFF0A64F9), size: 40),
                ),
                const SizedBox(height: 16),

                // App name and subtitle
                const Text(
                  "HomeBuddy",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Fast Service",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),

                const SizedBox(height: 40),
                const Text(
                  "Continue as",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 20),

                // Customer Card
                _roleCard(
                  context,
                  title: "Customer",
                  subtitle: "Book Services",
                  icon: Icons.person_outline,
                  bgColor: Colors.white,
                  iconBgColor: const Color(0xFFE9F0FF),
                  iconColor: const Color(0xFF0A64F9),
                  onTap: () {
                    // Navigate to customer login
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>CoustomerLogin()));
                  },
                ),
                const SizedBox(height: 16),

                // Driver Card
                _roleCard(
                  context,
                  title: "Service Provider",
                  subtitle: "Accept Service & earn money",
                  icon: Icons.cleaning_services,
                  bgColor: Colors.white,
                  iconBgColor: const Color(0xFFE8FFF2),
                  iconColor: const Color(0xFF00A86B),
                  onTap: () {
                    // Navigate to driver login
                  },
                ),
                const SizedBox(height: 30),

                // Features list
                Column(
                  children: const [
                    _FeatureItem(text: "Real-time tracking"),
                    _FeatureItem(text: "Secure payments"),
                    _FeatureItem(text: "24/7 support"),
                  ],
                ),
                const SizedBox(height: 30),

                // Terms text
                InkWell(
                  onTap: (){
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>admin_login()));
                  },
                  child: Text (
                    //"By continuing, you agree to our Terms & Privacy Policy",
                    "Continue as Admin",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _roleCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color bgColor,
        required Color iconBgColor,
        required Color iconColor,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 18, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;

  const _FeatureItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "• ",
            style: TextStyle(color: Colors.white, fontSize: 16  ),
          ),
          Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
