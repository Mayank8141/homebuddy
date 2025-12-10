import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class customer_home_screen extends StatefulWidget {
  const customer_home_screen({super.key});

  @override
  State<customer_home_screen> createState() => _customer_home_screenState();
}

class _customer_home_screenState extends State<customer_home_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6FAFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // -----------------  Header -----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello, User 👋",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text("What do you need today?",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.notifications_none, size: 28),
                      const SizedBox(width: 12),
                      Icon(Icons.person_outline, size: 28),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // -----------------  Search Bar -----------------
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Search services...",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.teal),
                  const SizedBox(width: 5),
                  Text("Koramangala, Bangalore",
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ----------------- Offer Banner -----------------
              Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffFF4F86), Color(0xffFF006E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("25% OFF",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("On your first cleaning service",
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 10),
                      ),
                      onPressed: () {},
                      child: Text("Book Now"),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ----------------- Categories -----------------
              Text("Categories",
                style: GoogleFonts.poppins(
                    fontSize: 17, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 15),

              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  categoryCard(Icons.cleaning_services, "Cleaning", Colors.pink.shade100),
                  categoryCard(Icons.water_drop, "Plumber", Colors.blue.shade100),
                  categoryCard(Icons.flash_on, "Electrician", Colors.orange.shade100),
                  categoryCard(Icons.handyman, "Carpenter", Colors.yellow.shade200),
                  categoryCard(Icons.ac_unit, "AC Repair", Colors.teal.shade100),
                  categoryCard(Icons.format_paint, "Painting", Colors.purple.shade100),
                ],
              ),

              const SizedBox(height: 25),

              // ----------------- Trending Services -----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Trending Services",
                    style: GoogleFonts.poppins(
                        fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  Text("View All",
                    style: GoogleFonts.poppins(color: Colors.blue),
                  )
                ],
              ),
              const SizedBox(height: 15),

              trendingServiceCard(
                image: "https://picsum.photos/200",
                title: "Deep Cleaning",
                rating: "4.8",
                price: "₹299",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Category Item UI
  Widget categoryCard(icon, text, color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 22, backgroundColor: color, child: Icon(icon,color: Colors.black)),
          const SizedBox(height: 8),
          Text(text,
            style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  // Trending Service Card
  Widget trendingServiceCard({required String image, required String title, required String rating, required String price}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(image, width: 80, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text("⭐ $rating", style: GoogleFonts.poppins(fontSize: 13,color: Colors.grey[700])),
                Text(price, style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text("Book"),
          )
        ],
      ),
    );
  }
}
