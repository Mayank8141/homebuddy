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
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> fadeAnim;
  late Animation<Offset> slideAnim;

  int bottomIndex = 0;

  @override
  void initState() {
    super.initState();

    animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    fadeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: animController, curve: Curves.easeIn));

    slideAnim = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: animController, curve: Curves.easeOut));

    animController.forward();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  //--------------------------------------------------------------------
  // UI START
  //--------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: FadeTransition(
        opacity: fadeAnim,
        child: SlideTransition(
          position: slideAnim,
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header(),
                  const SizedBox(height: 20),
                  categorySection(),
                  const SizedBox(height: 25),
                  trendingSection(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: bottomBar(),
    );
  }

  //--------------------------------------------------------------------
  // HEADER
  //--------------------------------------------------------------------
  Widget header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF00C6FF), Color(0xFF0072FF)]),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              topIcon(Icons.notifications_none),
              const SizedBox(width: 12),
              topIcon(Icons.person_outline),
            ],
          ),
          const SizedBox(height: 10),
          const Text("Hello, User 👋",
              style: TextStyle(fontSize: 18, color: Colors.white70)),
          const SizedBox(height: 3),
          const Text(
            "What do you need today?",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Search services...",
                        border: InputBorder.none),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: const [
              Icon(Icons.location_on, color: Colors.white, size: 20),
              SizedBox(width: 5),
              Text("Koramangala, Bangalore",
                  style: TextStyle(fontSize: 15, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------------
  // CATEGORY SECTION
  //--------------------------------------------------------------------
  Widget categorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Categories",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 15),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.90,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            categoryCard(Colors.pinkAccent, Icons.cleaning_services, "Cleaning"),
            categoryCard(Colors.lightBlueAccent, Icons.water_drop, "Plumber"),
            categoryCard(Colors.orangeAccent, Icons.electric_bolt, "Electrician"),
            categoryCard(Colors.amber, Icons.handyman, "Carpenter"),
            categoryCard(Colors.teal, Icons.air, "AC Repair"),
            categoryCard(Colors.purpleAccent, Icons.format_paint, "Painting"),
          ],
        ),
      ],
    );
  }

  //--------------------------------------------------------------------
  // TRENDING SECTION
  //--------------------------------------------------------------------
  Widget trendingSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Trending Services",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text("View All ↪", style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
        const SizedBox(height: 15),

        serviceCard("Deep Cleaning", "₹1,299", "4.8",
            "https://images.pexels.com/photos/28576625/pexels-photo-28576625.jpeg"),

        serviceCard("Electrical Repair", "₹499", "4.7",
            "https://images.pexels.com/photos/7286013/pexels-photo-7286013.jpeg"),

        serviceCard("Plumbing Fix", "₹699", "4.9",
            "https://media.istockphoto.com/id/911703434/photo/hands-of-plumber-with-a-wrench.jpg"),
      ],
    );
  }

  //--------------------------------------------------------------------
  // SMALL WIDGETS
  //--------------------------------------------------------------------
  Widget topIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  Widget categoryCard(Color bgColor, IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 10),
          FittedBox(
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget serviceCard(
      String title, String price, String rating, String imgUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(imgUrl,
                height: 65, width: 65, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 17),
                    Text(" $rating",
                        style: const TextStyle(color: Colors.black54)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(price,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () {},
            child: const Text("Book"),
          )
        ],
      ),
    );
  }

  //--------------------------------------------------------------------
  // ⭐⭐ NEW MOVING CIRCLE BOTTOM NAV ⭐⭐
  //--------------------------------------------------------------------
  Widget bottomBar() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(bottom: 15, left: 12, right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF003B73),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Moving circle highlight
          AnimatedAlign(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutBack,
            alignment: _circleAlignment(bottomIndex),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.50),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              bottomItem(Icons.home_outlined, 0),
              bottomItem(Icons.receipt_long, 1),
              bottomItem(Icons.add_location_alt, 2, isCenter: true),
              bottomItem(Icons.notifications_none, 3),
              bottomItem(Icons.person_outline, 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomItem(IconData icon, int index, {bool isCenter = false}) {
    bool active = bottomIndex == index;

    return GestureDetector(
      onTap: () => setState(() => bottomIndex = index),
      child: SizedBox(
        width: 55,
        height: 55,
        child: Icon(
          icon,
          size: isCenter ? 30 : 26,
          color: active ? Colors.white : Colors.white54,
        ),
      ),
    );
  }

  Alignment _circleAlignment(int index) {
    switch (index) {
      case 0:
        return const Alignment(-0.85, 0);
      case 1:
        return const Alignment(-0.40, 0);
      case 2:
        return const Alignment(0, 0);
      case 3:
        return const Alignment(0.40, 0);
      case 4:
        return const Alignment(0.85, 0);
      default:
        return Alignment.centerLeft;
    }
  }
}
