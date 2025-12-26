import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'customer_amployee_servicelist.dart';

class CustomerCategoriesPage extends StatelessWidget {
  final String customerId;
  const CustomerCategoriesPage({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "All Categories",
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("services").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final services = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: services.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final service = services[index];
                final data = _getCategoryData(service["name"]);

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CustomerServiceList(
                          serviceId: service.id,
                          title: service["name"],
                          customerId: customerId,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: data['color'],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            data['icon'],
                            color: data['iconColor'],
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            service["name"],
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF374151),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // SAME ICON LOGIC AS HOME
  Map<String, dynamic> _getCategoryData(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case "cleaning":
        return {
          'icon': Icons.cleaning_services_rounded,
          'color': const Color(0xFFFCE4EC),
          'iconColor': const Color(0xFFE91E63),
        };
      case "electrician":
        return {
          'icon': Icons.electric_bolt_rounded,
          'color': const Color(0xFFFFF3E0),
          'iconColor': const Color(0xFFFF9800),
        };
      case "plumber":
        return {
          'icon': Icons.water_drop_rounded,
          'color': const Color(0xFFE3F2FD),
          'iconColor': const Color(0xFF2196F3),
        };
      case "carpenter":
        return {
          'icon': Icons.handyman_rounded,
          'color': const Color(0xFFFFF9C4),
          'iconColor': const Color(0xFFFBC02D),
        };
      case "ac repair":
        return {
          'icon': Icons.ac_unit_rounded,
          'color': const Color(0xFFE0F2F1),
          'iconColor': const Color(0xFF009688),
        };
      case "painting":
        return {
          'icon': Icons.format_paint_rounded,
          'color': const Color(0xFFF3E5F5),
          'iconColor': const Color(0xFF9C27B0),
        };
      case "gardening":
        return {
          'icon': Icons.local_florist,
          'color': const Color(0xFFF3E5F5),
          'iconColor': const Color(0xFF9C27B0),
        };
      default:
        return {
          'icon': Icons.home_repair_service_rounded,
          'color': const Color(0xFFF5F5F5),
          'iconColor': const Color(0xFF757575),
        };
    }
  }
}
