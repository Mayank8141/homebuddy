import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'customer_booking.dart';   // <-- ADD THIS IMPORT

class ProviderFullProfile extends StatelessWidget {
  final String providerId;
  final String customerId;

  final Map<String, dynamic> providerData;

  const ProviderFullProfile({
    super.key,
    required this.customerId,
    required this.providerId,
    required this.providerData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          providerData["name"],
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- PROFILE CARD ----------------
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.07),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: NetworkImage(
                      providerData["image"] == "" || providerData["image"] == null
                          ? "https://cdn-icons-png.flaticon.com/512/847/847969.png"
                          : providerData["image"],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    providerData["name"],
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 5),
                      Text("4.8", style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(width: 6),
                      Text("• 234 reviews",
                          style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ---------------- SERVICE DETAILS ----------------
            SectionCard(
              title: "Service Details",
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("services")
                    .doc(providerData["service_id"])
                    .get(),

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading...", style: TextStyle(color: Colors.grey));
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Text("Service data not found",
                        style: TextStyle(color: Colors.red));
                  }

                  var service = snapshot.data!.data() as Map<String, dynamic>;
                  String amount = service["amount"].toString();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Service Cahrge as per Your service",style: TextStyle(fontSize: 15,color: Colors.teal)),

                      const SizedBox(height: 8),
                      infoRow("Visit charge", "₹${providerData["visit_charge"]}"),
                      const SizedBox(height: 8),
                      infoRow("Experience", "${providerData["experience"]} Years"),
                      const SizedBox(height: 8),
                      infoRow("Ratings", "4.8 / 5"),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            // ---------------- SKILLS ----------------
            SectionCard(
              title: "Skills",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  SkillChip("Pipe Fitting"),
                  SkillChip("Leak Repairs"),
                  SkillChip("Installation"),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ---------------- LOCATION ----------------
            SectionCard(
              title: "Location",
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, size: 18, color: Colors.red),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      providerData["address"] ?? "No address",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ---------------- BOOK NOW BUTTON ----------------
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                // ---------------- GO TO BOOKING PAGE ----------------
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingPage(
                        customerId: customerId,        // replace with user UID
                        employeId: providerData["uid"],               // provider
                        serviceId: providerData["service_id"],
                      ),
                    ),
                  );
                },

                child: const Text(
                  "Book Now",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ---------------- Helper UI ----------------
  Widget infoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 15, color: Colors.grey)),
        Text(value,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ---------------- SECTION CARD ----------------
class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ---------------- SKILL CHIP ----------------
class SkillChip extends StatelessWidget {
  final String text;
  const SkillChip(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xffE8F7F4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.w500),
      ),
    );
  }
}
