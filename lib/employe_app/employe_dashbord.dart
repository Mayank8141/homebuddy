import 'package:flutter/material.dart';

class employe_deshbord_screen extends StatefulWidget {
  const employe_deshbord_screen({super.key});

  @override
  State<employe_deshbord_screen> createState() => _employe_deshbord_screenState();
}

class _employe_deshbord_screenState extends State<employe_deshbord_screen> {
  bool isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      bottomNavigationBar: buildBottomNavBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(),
            const SizedBox(height: 10),
            buildOnlineCard(),
            const SizedBox(height: 15),
            buildScheduleTitle(),
            buildJobCard(
              title: "Electrical Repair",
              customer: "Rajesh Kumar",
              time: "10:00 AM",
              price: "₹800",
              location: "MG Road, Sector 14",
            ),
            buildJobCard(
              title: "AC Installation",
              customer: "Priya Sharma",
              time: "2:00 PM",
              price: "₹2,500",
              location: "Nehru Place, Block C",
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------
  // 🔵 HEADER SECTION
  // ---------------------------------------------------------------
  Widget buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: const BoxDecoration(
        color: Color(0xFF0066FF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          const Text(
            "Good Morning",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 2),
          const Text(
            "Amit Singh",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Electrician • ID: EMP2045",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildStatBox(Icons.work, "3", "Today's\nJobs"),
              buildStatBox(Icons.currency_rupee, "₹12,500", "This\nWeek"),
              buildStatBox(Icons.star, "4.8", "Rating"),
              buildStatBox(Icons.check_circle, "147", "Completed"),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildStatBox(IconData icon, String value, String label) {
    return Container(
      width: 70,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // 🟢 ONLINE STATUS CARD
  // ---------------------------------------------------------------
  Widget buildOnlineCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.circle, color: Colors.green, size: 14),
              SizedBox(width: 10),
              Text(
                "You're Online",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          Switch(
            value: isOnline,
            activeColor: Colors.green,
            onChanged: (v) {
              setState(() {
                isOnline = v;
              });
            },
          )
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // 📅 TODAY'S SCHEDULE
  // ---------------------------------------------------------------
  Widget buildScheduleTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Today's Schedule",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(
            "View All",
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // 📦 JOB CARD DESIGN
  // ---------------------------------------------------------------
  Widget buildJobCard({
    required String title,
    required String customer,
    required String time,
    required String price,
    required String location,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                price,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(customer, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 10),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  time,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on,
                  size: 16, color: Colors.grey),
              const SizedBox(width: 5),
              Text(location,
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066FF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Start Job"),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call, color: Colors.blue),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz, color: Colors.blue),
              ),
            ],
          )
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // 🔻 BOTTOM NAVIGATION BAR
  // ---------------------------------------------------------------
  Widget buildBottomNavBar() {
    return BottomNavigationBar(
      selectedItemColor: const Color(0xFF0066FF),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.assignment), label: "Requests"),
        BottomNavigationBarItem(
            icon: Icon(Icons.work), label: "My Jobs"),
        BottomNavigationBarItem(
            icon: Icon(Icons.wallet), label: "Earnings"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
