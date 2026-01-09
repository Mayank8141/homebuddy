import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> with TickerProviderStateMixin {
 // final TextEditingController _searchController = TextEditingController();


  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }


  Widget _buildContactUsSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(1, 0, 1, 24),
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
          const Text(
            "Contact Us",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          _buildContactItem(
            icon: Icons.email_rounded,
            title: "Email",
            value: "support@homebuddy.com",
            onTap: () => _launchUrl("mailto:support@homebuddy.com"),
          ),

          _buildContactItem(
            icon: Icons.phone_rounded,
            title: "Phone",
            value: "+91 8849242748",
            onTap: () => _launchUrl("tel:+918849242748"),
          ),

          _buildContactItem(
            icon: Icons.language_rounded,
            title: "Website",
            value: "www.homebuddy.com",
            onTap: () => _launchUrl("https://www.homebuddy.com"),
          ),
        ],
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
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF00BFA5).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF00BFA5),
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


  String _searchQuery = '';
  late AnimationController _animController;

  final List<FaqCategory> _categories = [
    FaqCategory(
      title: "Getting Started",
      icon: Icons.rocket_launch_outlined,
      color: const Color(0xFF00BFA5),
      faqs: [
        FaqItem(
          question: "What is HomeBuddy?",
          answer:
          "HomeBuddy is your trusted home services marketplace that connects you with verified, skilled professionals for all your home maintenance needs. From plumbing and electrical work to cleaning and repairs, we ensure quality service delivery at your doorstep.",
        ),
        FaqItem(
          question: "How do I create an account?",
          answer:
          "Creating an account is simple! Download the HomeBuddy app, click 'Sign Up', enter your mobile number or email, verify with OTP, and complete your profile. You'll be ready to book services in under 2 minutes.",
        ),
        FaqItem(
          question: "Is HomeBuddy available in my area?",
          answer:
          "We're rapidly expanding across India! Enter your pincode in the app to check service availability in your area. We're currently operational in 50+ cities and adding new locations every month.",
        ),
      ],
    ),
    FaqCategory(
      title: "Booking & Services",
      icon: Icons.calendar_month_outlined,
      color: const Color(0xFF00BFA5),
      faqs: [
        FaqItem(
          question: "How do I book a service?",
          answer:
          "Booking is easy: (1) Select your required service category, (2) Browse through verified professionals and their ratings, (3) Choose your preferred date and time slot, (4) Provide service address and details, (5) Confirm booking. You'll receive instant confirmation with professional details.",
        ),
        FaqItem(
          question: "Can I book services for the same day?",
          answer:
          "Yes! We offer same-day service booking based on professional availability. Look for the 'Available Today' badge when browsing professionals. Emergency services are also available for urgent requirements.",
        ),
        FaqItem(
          question: "How do I reschedule or cancel a booking?",
          answer:
          "Go to 'My Bookings', select the booking you want to modify, and tap 'Reschedule' or 'Cancel'. Free cancellation is available up to 2 hours before the scheduled service. Cancellations made within 2 hours may incur a nominal fee.",
        ),
        FaqItem(
          question: "What if the professional doesn't show up?",
          answer:
          "Your satisfaction is our priority. If a professional doesn't arrive within 15 minutes of the scheduled time, you can cancel without any charges and receive a full refund. We'll also help you rebook with another professional immediately.",
        ),
      ],
    ),
    FaqCategory(
      title: "Payments & Pricing",
      icon: Icons.payments_outlined,
      color: const Color(0xFF00BFA5),
      faqs: [
        FaqItem(
          question: "How are service charges calculated?",
          answer:
          "Our pricing is transparent and competitive. Total charges include: (1) Base service charge as listed, (2) Visit fee (if applicable), (3) Material costs (for parts/consumables), (4) Applicable taxes. You'll see the estimated cost before booking, and final charges are confirmed before payment.",
        ),
        FaqItem(
          question: "What payment methods are accepted?",
          answer:
          "We accept all major payment methods: UPI (Google Pay, PhonePe, Paytm), Credit/Debit Cards, Net Banking, Wallets, and Cash on Delivery. All online payments are processed through secure, PCI-DSS compliant gateways.",
        ),
        FaqItem(
          question: "When do I need to make payment?",
          answer:
          "Payment is required after service completion and your satisfaction. The professional will share the final bill through the app. You can review the charges and pay using your preferred method. No advance payment is required for most services.",
        ),
        FaqItem(
          question: "Do you offer any discounts or offers?",
          answer:
          "Yes! We regularly run promotional offers, seasonal discounts, and referral bonuses. Check the 'Offers' section in the app for current deals. First-time users get special welcome discounts. Subscribe to notifications to never miss an offer!",
        ),
      ],
    ),
    FaqCategory(
      title: "Safety & Quality",
      icon: Icons.verified_user_outlined,
      color: const Color(0xFF00BFA5),
      faqs: [
        FaqItem(
          question: "Are service professionals verified?",
          answer:
          "Absolutely! Every professional on HomeBuddy undergoes a rigorous 3-step verification process: (1) Identity & address verification, (2) Skills & experience assessment, (3) Background check. We only onboard trusted, qualified professionals.",
        ),
        FaqItem(
          question: "What if I'm not satisfied with the service?",
          answer:
          "Your satisfaction is guaranteed! If you're unhappy with the service quality, report it within 24 hours. We offer free rework for quality issues. In case the issue persists, we provide full refunds or alternative solutions. Rate and review after every service to help us maintain quality.",
        ),
        FaqItem(
          question: "Is my personal information safe?",
          answer:
          "We take data privacy seriously. Your personal information is encrypted and stored securely. We never share your data with third parties without consent. Professionals only receive your name and service address. All in-app communication is monitored for safety.",
        ),
      ],
    ),
    FaqCategory(
      title: "Support & Assistance",
      icon: Icons.support_agent_outlined,
      color: const Color(0xFF00BFA5),
      faqs: [
        FaqItem(
          question: "How do I contact customer support?",
          answer:
          "We're here to help 24/7! Reach us via: (1) In-app chat support - instant responses, (2) Call our helpline: 1800-XXX-XXXX (toll-free), (3) Email: support@homebuddy.com, (4) Help Center in the app with detailed guides and FAQs.",
        ),
        FaqItem(
          question: "How long does it take to get support responses?",
          answer:
          "Our average response time is under 5 minutes for chat support and within 2 hours for email queries. For urgent issues during active bookings, we provide immediate assistance through priority support channels.",
        ),
        FaqItem(
          question: "Can I track my service professional?",
          answer:
          "Yes! Once your booking is confirmed and the professional is en route, you can track their real-time location in the app. You'll also receive notifications when they're nearby and when they arrive at your location.",
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    //_searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  List<FaqCategory> _getFilteredCategories() {
    if (_searchQuery.isEmpty) return _categories;

    return _categories
        .map((category) {
      final filteredFaqs = category.faqs
          .where((faq) =>
      faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          faq.answer.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();

      if (filteredFaqs.isEmpty) return null;

      return FaqCategory(
        title: category.title,
        icon: category.icon,
        color: category.color,
        faqs: filteredFaqs,
      );
    })
        .where((category) => category != null)
        .cast<FaqCategory>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = _getFilteredCategories();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1A1D1E)),
        title: const Text(
          "How can we help you?",
          style: TextStyle(
            color: Color(0xFF1A1D1E),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Header with Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Text(
                //   "How can we help you?",
                //   style: TextStyle(
                //     fontSize: 26,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.white,
                //   ),
                // ),
                // const SizedBox(height: 6),
                Text(
                  "Search or browse through our frequently asked questions",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                // const SizedBox(height: 20),
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  // child: TextField(
                  //   controller: _searchController,
                  //   onChanged: (value) {
                  //     setState(() => _searchQuery = value);
                  //   },
                  //   style: const TextStyle(fontSize: 15),
                  //   decoration: InputDecoration(
                  //     hintText: "Search FAQs...",
                  //     hintStyle: TextStyle(color: Colors.grey.shade500),
                  //     prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  //     suffixIcon: _searchQuery.isNotEmpty
                  //         ? IconButton(
                  //       icon: Icon(Icons.clear, color: Colors.grey.shade600),
                  //       onPressed: () {
                  //         _searchController.clear();
                  //         setState(() => _searchQuery = '');
                  //       },
                  //     )
                  //         : null,
                  //     border: InputBorder.none,
                  //     contentPadding: const EdgeInsets.symmetric(
                  //       horizontal: 16,
                  //       vertical: 16,
                  //     ),
                  //   ),
                  // ),
                ),
              ],
            ),
          ),

          // FAQ Content
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                ...filteredCategories.asMap().entries.map((entry) {
                  final index = entry.key;
                  final category = entry.value;

                  return FadeTransition(
                    opacity: Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: _animController,
                        curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
                      ),
                    ),
                    child: _CategorySection(category: category),
                  );
                }),

                // ✅ CONTACT US AT BOTTOM
                _buildContactUsSection(),
              ],
            ),
          ),

          //_buildContactUsSection(),
          // Contact Support Banner
         // _buildContactBanner(),
        ],
      ),
    );
  }

  // Widget _buildEmptyState() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(24),
  //           decoration: BoxDecoration(
  //             color: const Color(0xFF00BFA5).withOpacity(0.1),
  //             shape: BoxShape.circle,
  //           ),
  //           child: Icon(
  //             Icons.search_off_outlined,
  //             size: 64,
  //             color: const Color(0xFF00BFA5).withOpacity(0.6),
  //           ),
  //         ),
  //         const SizedBox(height: 24),
  //         const Text(
  //           "No results found",
  //           style: TextStyle(
  //             fontSize: 20,
  //             fontWeight: FontWeight.w600,
  //             color: Color(0xFF1A1D1E),
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           "Try different keywords or browse categories",
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.grey.shade600,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildContactBanner() {
  //   return Container(
  //     margin: const EdgeInsets.all(20),
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       gradient: const LinearGradient(
  //         colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: const Color(0xFF00BFA5).withOpacity(0.3),
  //           blurRadius: 12,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(14),
  //           decoration: BoxDecoration(
  //             color: Colors.white.withOpacity(0.2),
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: const Icon(
  //             Icons.headset_mic_outlined,
  //             color: Colors.white,
  //             size: 28,
  //           ),
  //         ),
  //         const SizedBox(width: 16),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text(
  //                 "Still need help?",
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 "Our support team is available 24/7",
  //                 style: TextStyle(
  //                   color: Colors.white.withOpacity(0.9),
  //                   fontSize: 13,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Material(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(10),
  //           child: InkWell(
  //             onTap: () {
  //               // Navigate to support
  //               HapticFeedback.lightImpact();
  //             },
  //             borderRadius: BorderRadius.circular(10),
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 18,
  //                 vertical: 10,
  //               ),
  //               child: const Text(
  //                 "Contact",
  //                 style: TextStyle(
  //                   color: Color(0xFF00BFA5),
  //                   fontWeight: FontWeight.w600,
  //                   fontSize: 14,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class _CategorySection extends StatelessWidget {
  final FaqCategory category;

  const _CategorySection({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00BFA5).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  category.icon,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1D1E),
                  ),
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              //   decoration: BoxDecoration(
              //     color: const Color(0xFF00BFA5).withOpacity(0.1),
              //     borderRadius: BorderRadius.circular(12),
              //     border: Border.all(
              //       color: const Color(0xFF00BFA5).withOpacity(0.3),
              //       width: 1,
              //     ),
              //   ),
              //   child: Text(
              //     "${category.faqs.length}",
              //     style: const TextStyle(
              //       color: Color(0xFF00BFA5),
              //       fontWeight: FontWeight.bold,
              //       fontSize: 13,
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 12),

          // FAQ Items
          ...category.faqs.map((faq) => _FaqItemWidget(faq: faq)).toList(),
        ],
      ),
    );
  }
}

class _FaqItemWidget extends StatefulWidget {
  final FaqItem faq;

  const _FaqItemWidget({required this.faq});

  @override
  State<_FaqItemWidget> createState() => _FaqItemWidgetState();
}

class _FaqItemWidgetState extends State<_FaqItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isExpanded ? const Color(0xFF00BFA5) : Colors.grey.shade200,
          width: _isExpanded ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _isExpanded
                ? const Color(0xFF00BFA5).withOpacity(0.15)
                : Colors.black.withOpacity(0.04),
            blurRadius: _isExpanded ? 12 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: const Color(0xFF00BFA5),
          collapsedIconColor: Colors.grey.shade600,
          onExpansionChanged: (expanded) {
            setState(() => _isExpanded = expanded);
            if (expanded) {
              HapticFeedback.lightImpact();
            }
          },
          title: Row(
            children: [
              if (_isExpanded)
                Container(
                  width: 4,
                  height: 20,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BFA5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              Expanded(
                child: Text(
                  widget.faq.question,
                  style: TextStyle(
                    color: _isExpanded ? const Color(0xFF00BFA5) : const Color(0xFF1A1D1E),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          children: [
            Container(
              height: 1,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00BFA5).withOpacity(0.3),
                    const Color(0xFF00BFA5).withOpacity(0.1),
                    const Color(0xFF00BFA5).withOpacity(0.3),
                  ],
                ),
              ),
            ),
            Text(
              widget.faq.answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FaqCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<FaqItem> faqs;

  FaqCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.faqs,
  });
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({
    required this.question,
    required this.answer,
  });
}