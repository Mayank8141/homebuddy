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
      home: const OnboardingMain(),
    );
  }
}

class OnboardingMain extends StatefulWidget {
  const OnboardingMain({super.key});

  @override
  State<OnboardingMain> createState() => _OnboardingMainState();
}

class _OnboardingMainState extends State<OnboardingMain>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int currentPage = 0;

  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller.forward();
  }

  void animatePageChange(int index) {
    setState(() {
      currentPage = index;
      controller.reset();
      controller.forward();
    });
  }

  void nextPage() {
    if (currentPage < 2) {
      _pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    } else {
      // LAST PAGE BUTTON (Get Started)
      // Navigate to Login or Home
      // For now, we just print:
      print("Get Started Pressed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

            /// ⭐ SKIP TOP RIGHT
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, top: 10),
                child: Text(
                  "Skip",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ⭐ PAGEVIEW (3 SCREENS)
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: animatePageChange,
                children: [
                  buildPage(
                    icon: Icons.search,
                    title: "Find trusted service experts instantly",
                    desc: "Connect with verified professionals for all your home service needs",
                  ),
                  buildPage(
                    icon: Icons.calendar_month,
                    title: "Book cleaners, plumbers, electricians and more",
                    desc: "Wide range of services available at your fingertips, anytime",
                  ),
                  buildPage(
                    icon: Icons.verified_user,
                    title: "Easy payments, fast support, real-time updates",
                    desc: "Secure transactions, instant support, and live service tracking",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ⭐ DOT INDICATORS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildDot(0),
                buildDot(1),
                buildDot(2),
              ],
            ),

            const SizedBox(height: 25),

            /// ⭐ NEXT / GET STARTED BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: nextPage,
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF00C6FF),
                          Color(0xFF0072FF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        currentPage == 2 ? "Get Started   >" : "Next   >",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// ⭐ ONE PAGE UI WIDGET
  Widget buildPage({required IconData icon, required String title, required String desc}) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// ICON CARD
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                icon,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 35),

            /// TITLE
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            /// DESCRIPTION
            Text(
              desc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ⭐ DOT INDICATOR WIDGET
  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: currentPage == index ? 22 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.blueAccent : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
