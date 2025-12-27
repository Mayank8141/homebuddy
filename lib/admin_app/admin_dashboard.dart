import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';
import 'admin_analytics.dart';
import 'admin_services.dart';
import 'admin_users.dart';
import 'admin_employe.dart';

class admin_dashboard extends StatefulWidget {
  const admin_dashboard({super.key, required String uid});

  @override
  State<admin_dashboard> createState() => _admin_dashboardState();
}

class _admin_dashboardState extends State<admin_dashboard> {
  int selectedIndex = 0;

  String adminName = "Admin";
  String adminEmail = "Loading...";
  String adminImage = "";
  bool isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    fetchAdminDetails();
  }

  // ================= FETCH ADMIN =================
  Future<void> fetchAdminDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var doc = await FirebaseFirestore.instance
        .collection("admin_details")
        .doc(uid)
        .get();

    if (doc.exists) {
      setState(() {
        adminName = doc["name"] ?? "Admin";
        adminEmail = doc["email"] ?? "admin@gmail.com";
        adminImage = doc["profile"] ?? "";
        isLoadingProfile = false;
      });
    } else {
      setState(() => isLoadingProfile = false);
    }
  }

  // ================= NAV =================
  void onTabTap(int index) {
    if (index == selectedIndex) return;

    setState(() => selectedIndex = index);

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => admin_user_list()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => admin_employe_list()),
      );
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => admin_services()),
      );
    }
  }

  // ================= SHIMMER LOADING =================
  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildShimmerBooking() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const CircleAvatar(radius: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 150,
                    height: 10,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= COUNT CARD =================
  Widget statCard(
      String title,
      IconData icon,
      Color color,
      Stream<QuerySnapshot> stream,
      ) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerCard();
        }

        int count = snapshot.hasData ? snapshot.data!.docs.length : 0;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.75)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ICON
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),

              // COUNT + TITLE
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$count",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28, // ⬇ reduced from 32
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  // ================= RECENT BOOKINGS =================
  Widget recentBookings() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("booking_details")
          .orderBy("booking_date", descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: List.generate(3, (_) => _buildShimmerBooking()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.inbox_rounded,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No recent bookings",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            return FutureBuilder(
              future: Future.wait([
                FirebaseFirestore.instance
                    .collection("customer_detail")
                    .doc(data["customer_id"])
                    .get(),
                FirebaseFirestore.instance
                    .collection("services")
                    .doc(data["service_id"])
                    .get(),
              ]),
              builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snap) {
                if (!snap.hasData) {
                  return _buildShimmerBooking();
                }

                final customerDoc = snap.data![0];
                final serviceDoc = snap.data![1];

                final customerName =
                customerDoc.exists ? customerDoc["name"] : "Customer";
                final serviceName =
                serviceDoc.exists ? serviceDoc["name"] : "Service";

                final status = data["status"] ?? "Pending";

                Color statusColor = status == "Completed"
                    ? const Color(0xFF10B981)
                    : status == "Cancelled"
                    ? const Color(0xFFEF4444)
                    : status == "Started"
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFF3B82F6);

                final date = (data["booking_date"] as Timestamp).toDate();

                return bookingTile(
                  customerName,
                  serviceName,
                  "${date.day}/${date.month}/${date.year}",
                  status,
                  statusColor,
                );
              },
            );
          }).toList(),
        );
      },
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Admin Dashboard",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 0.2,
              ),
            ),
            Text(
              "Home Service Management",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_rounded,
                  color: Colors.black87,
                ),
                onPressed: () {
                  // Navigate to notifications
                },
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ================= DRAWER =================
      drawer: Drawer(
        child: Column(
          children: [
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
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: adminImage.isNotEmpty
                              ? NetworkImage(adminImage)
                              : null,
                          child: adminImage.isEmpty
                              ? Icon(Icons.person, size: 40, color: Colors.grey[400])
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        adminName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        adminEmail,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  _buildDrawerItem(
                    icon: Icons.dashboard_rounded,
                    title: "Dashboard",
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    icon: Icons.people_rounded,
                    title: "Users",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => admin_user_list()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.engineering_rounded,
                    title: "Employees",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => admin_employe_list()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.cleaning_services_rounded,
                    title: "Services",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => admin_services()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.cleaning_services_rounded,
                    title: "Analitics",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AdminAnalyticsPage()),
                      );
                    },
                  ),
                  const Divider(height: 32),
                  _buildDrawerItem(
                    icon: Icons.settings_rounded,
                    title: "Settings",
                    onTap: () {
                      // Navigate to settings
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.help_outline_rounded,
                    title: "Help & Support",
                    onTap: () {
                      // Navigate to help
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: _buildDrawerItem(
                icon: Icons.logout_rounded,
                title: "Logout",
                color: Colors.red,
                onTap: () => logout(context),
              ),
            ),
          ],
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await fetchAdminDetails();
        },
        color: const Color(0xFF1ABC9C),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.15,
                children: [
                  statCard(
                    "Customers",
                    Icons.people_alt_rounded,
                    const Color(0xFF3B82F6),
                    FirebaseFirestore.instance
                        .collection("customer_detail")
                        .snapshots(),
                  ),
                  statCard(
                    "Providers",
                    Icons.engineering_rounded,
                    const Color(0xFF10B981),
                    FirebaseFirestore.instance
                        .collection("employe_detail")
                        .snapshots(),
                  ),
                  statCard(
                    "Services",
                    Icons.home_repair_service_rounded,
                    const Color(0xFF8B5CF6),
                    FirebaseFirestore.instance
                        .collection("services")
                        .snapshots(),
                  ),
                  statCard(
                    "Bookings",
                    Icons.calendar_month_rounded,
                    const Color(0xFFF59E0B),
                    FirebaseFirestore.instance
                        .collection("booking_details")
                        .snapshots(),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Recent Bookings Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Bookings",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 0.2,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all bookings
                    },
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        color: Color(0xFF1ABC9C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              recentBookings(),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: onTabTap,
            selectedItemColor: const Color(0xFF1ABC9C),
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Colors.transparent,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_rounded),
                label: "Users",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.engineering_rounded),
                label: "Providers",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_repair_service_rounded),
                label: "Services",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= DRAWER ITEM =================
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  // ================= LOGOUT =================
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => login_screen()),
          (route) => false,
    );
  }

  // ================= BOOKING TILE =================
  Widget bookingTile(
      String name,
      String service,
      String date,
      String status,
      Color color,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to booking details
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1ABC9C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Color(0xFF1ABC9C),
                    size: 24,
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
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$service • $date",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}