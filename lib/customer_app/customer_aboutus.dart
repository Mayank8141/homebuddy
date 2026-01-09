import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        // 🔥 THIS CONTROLS STATUS BAR
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white, // solid background
          statusBarIconBrightness: Brightness.dark, // ANDROID icons
          statusBarBrightness: Brightness.light, // IOS text/icons
        ),

        title: const Text(
          "About HomeBuddy",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: Colors.black87,
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header Section with Logo
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1ABC9C),
                    const Color(0xFF16A085),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      "assets/images/logo1.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "HomeBuddy",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      "Version 1.0.0",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // About Section
            _buildSection(
              title: "About HomeBuddy",
              child: const Text(
                "HomeBuddy is your trusted partner for all home service needs. "
                    "We connect you with verified and skilled service providers for "
                    "cleaning, repairs, maintenance, and more. Our platform ensures "
                    "quick, reliable, and professional services at your doorstep.",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
            ),

            // Features Section
            _buildSection(
              title: "Why Choose Us?",
              child: Column(
                children: [
                  _buildFeatureItem(
                    icon: Icons.verified_user_rounded,
                    title: "Verified Professionals",
                    description: "All service providers are background-checked and verified",
                  ),
                  _buildFeatureItem(
                    icon: Icons.flash_on_rounded,
                    title: "Fast Service",
                    description: "Get services scheduled at your convenience",
                  ),
                  _buildFeatureItem(
                    icon: Icons.star_rounded,
                    title: "Quality Assured",
                    description: "Guaranteed satisfaction with every service",
                  ),
                  _buildFeatureItem(
                    icon: Icons.payment_rounded,
                    title: "Secure Payment",
                    description: "Safe and secure payment options",
                  ),
                  _buildFeatureItem(
                    icon: Icons.support_agent_rounded,
                    title: "24/7 Support",
                    description: "Customer support available round the clock",
                  ),
                  _buildFeatureItem(
                    icon: Icons.location_on_rounded,
                    title: "Real-time Tracking",
                    description: "Track your service provider in real-time",
                  ),
                ],
              ),
            ),

            // Services Section
            _buildSection(
              title: "Our Services",
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildServiceChip("Cleaning"),
                  _buildServiceChip("Plumbing"),
                  _buildServiceChip("Electrical"),
                  _buildServiceChip("Gardning"),
                  _buildServiceChip("Painting"),
                  _buildServiceChip("AC Repair"),
                  // _buildServiceChip("Appliance Repair"),
                  // _buildServiceChip("Pest Control"),
                ],
              ),
            ),

            // Contact Section
            _buildSection(
              title: "Contact Us",
              child: Column(
                children: [
                  _buildContactItem(
                    icon: Icons.email_rounded,
                    title: "Email",
                    value: "support@homebuddy.com",
                    onTap: () => _launchUrl("mailto:support@homebuddy.com"),
                  ),
                  _buildContactItem(
                    icon: Icons.phone_rounded,
                    title: "Phone",
                    value: "+91 1234567890",
                    onTap: () => _launchUrl("tel:+911234567890"),
                  ),
                  _buildContactItem(
                    icon: Icons.language_rounded,
                    title: "Website",
                    value: "www.homebuddy.com",
                    onTap: () => _launchUrl("https://www.homebuddy.com"),
                  ),
                ],
              ),
            ),

            // Social Media Section
            // _buildSection(
            //   title: "Follow Us",
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       _buildSocialButton(
            //         icon: Icons.facebook,
            //         onTap: () => _launchUrl("https://facebook.com/homebuddy"),
            //       ),
            //       const SizedBox(width: 16),
            //       _buildSocialButton(
            //         icon: Icons.camera_alt,
            //         onTap: () => _launchUrl("https://instagram.com/homebuddy"),
            //       ),
            //       const SizedBox(width: 16),
            //       _buildSocialButton(
            //         icon: Icons.tiktok,
            //         onTap: () => _launchUrl("https://twitter.com/homebuddy"),
            //       ),
            //       const SizedBox(width: 16),
            //       _buildSocialButton(
            //         icon: Icons.language,
            //         onTap: () => _launchUrl("https://linkedin.com/company/homebuddy"),
            //       ),
            //     ],
            //   ),
            // ),

            // Legal Section
            // _buildSection(
            //   title: "Legal",
            //   child: Column(
            //     children: [
            //       _buildLegalItem(
            //         title: "Terms & Conditions",
            //         onTap: () {
            //           // Navigate to Terms page
            //         },
            //       ),
            //       _buildLegalItem(
            //         title: "Privacy Policy",
            //         onTap: () {
            //           // Navigate to Privacy page
            //         },
            //       ),
            //       _buildLegalItem(
            //         title: "Refund Policy",
            //         onTap: () {
            //           // Navigate to Refund page
            //         },
            //       ),
            //     ],
            //   ),
            // ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Text(
                    "Made with ❤️ in India",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "© 2024 HomeBuddy. All rights reserved.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1ABC9C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1ABC9C),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChip(String service) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1ABC9C).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF1ABC9C).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        service,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1ABC9C),
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1ABC9C).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF1ABC9C),
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1ABC9C).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF1ABC9C).withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF1ABC9C),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildLegalItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}