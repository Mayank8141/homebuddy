import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CleaningScreen(),
    );
  }
}

class CleaningScreen extends StatefulWidget {
  const CleaningScreen({super.key});

  @override
  State<CleaningScreen> createState() => _CleaningScreenState();
}

class _CleaningScreenState extends State<CleaningScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: fadeAnimation,
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Electrician",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "4 providers available",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              // FILTERS
              SizedBox(
                height: 45,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16),
                  children: [
                    filterChip("All", true),
                    filterChip("Top Rated", false),
                    filterChip("Nearby", false),
                    filterChip("Low Price", false),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // SCROLL LIST
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      providerCard(
                        name: "Rajesh Kumar",
                        exp: "8 years exp",
                        price: "₹499",
                        rating: "4.8",
                        imgUrl:
                        "https://images.pexels.com/photos/1212984/pexels-photo-1212984.jpeg",
                        tags: [
                          "Pipe Fitting",
                          "Leak Repairs",
                          "Bathroom Installation"
                        ],
                      ),

                      providerCard(
                        name: "Amit Sharma",
                        exp: "10 years exp",
                        price: "₹599",
                        rating: "4.9",
                        imgUrl:
                        "https://images.pexels.com/photos/532792/pexels-photo-532792.jpeg",
                        tags: ["Emergency Repairs", "Installation", "Maintenance"],
                      ),

                      providerCard(
                        name: "Suresh Reddy",
                        exp: "6 years exp",
                        price: "₹449",
                        rating: "4.7",
                        imgUrl:
                        "https://images.pexels.com/photos/102957/pexels-photo-102957.jpeg",
                        tags: ["Residential Work", "Quick Service", "Quality Work"],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget filterChip(String text, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? Colors.blue : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget providerCard({
    required String name,
    required String exp,
    required String price,
    required String rating,
    required String imgUrl,
    required List<String> tags,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imgUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exp,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$price /service",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Rating
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    Text(
                      rating,
                      style:
                      const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: tags
                .map((tag) => Chip(
              backgroundColor: Colors.blue.shade50,
              label: Text(tag,
                  style: const TextStyle(color: Colors.blue, fontSize: 12)),
            ))
                .toList(),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: Colors.grey),
              const SizedBox(width: 4),
              const Text("2.3 km away", style: TextStyle(color: Colors.grey)),
              const Spacer(),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Text(
                  "View Profile",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}