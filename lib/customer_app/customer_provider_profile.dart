import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'customer_booking.dart';   // <-- ADD THIS IMPORT
import 'package:flutter/services.dart';


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

        // 🔥 STATUS BAR FIX
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,          // solid background
          statusBarIconBrightness: Brightness.dark, // ANDROID icons
          statusBarBrightness: Brightness.light, // IOS text/icons
        ),

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
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 5),
                      Text("${providerData["rating"]}", style: const TextStyle( color: Colors.black,fontWeight: FontWeight.w600)),
                      const SizedBox(width: 6),
                      // Text("• 234 reviews",
                      //     style: TextStyle(fontSize: 13, color: Colors.grey)),
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
                      infoRow("Ratings", "${providerData["rating"]}/ 5"),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            // ---------------- SKILLS ----------------
            // SectionCard(
            //   title: "Skills",
            //   child: Wrap(
            //     spacing: 8,
            //     runSpacing: 8,
            //     children: const [
            //       SkillChip("Pipe Fitting"),
            //       SkillChip("Leak Repairs"),
            //       SkillChip("Installation"),
            //     ],
            //   ),
            // ),
            //
            // const SizedBox(height: 18),

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
                      style: const TextStyle( color: Colors.black,
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
                color: Colors.black,
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
              const TextStyle( color: Colors.black,fontSize: 17, fontWeight: FontWeight.w700)),
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

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'customer_booking.dart';
// import 'package:flutter/services.dart';
//
// class ProviderFullProfile extends StatelessWidget {
//   final String providerId;
//   final String customerId;
//   final Map<String, dynamic> providerData;
//
//   const ProviderFullProfile({
//     super.key,
//     required this.customerId,
//     required this.providerId,
//     required this.providerData,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       extendBodyBehindAppBar: true,
//
//       appBar: AppBar(
//         elevation: 0,
//         // backgroundColor: Colors.transparent,
//         // systemOverlayStyle: const SystemUiOverlayStyle(
//         //   statusBarColor: Colors.transparent,
//         //   statusBarIconBrightness: Brightness.dark,
//         //   statusBarBrightness: Brightness.light,
//         // ),
//         // leading: Padding(
//         //   padding: const EdgeInsets.all(8.0),
//         //   child: Container(
//         //     decoration: BoxDecoration(
//         //       color: Colors.white,
//         //       shape: BoxShape.circle,
//         //       boxShadow: [
//         //         BoxShadow(
//         //           color: Colors.black.withOpacity(0.1),
//         //           blurRadius: 8,
//         //           offset: const Offset(0, 2),
//         //         ),
//         //       ],
//         //     ),
//         //     child: IconButton(
//         //       icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
//         //       onPressed: () => Navigator.pop(context),
//         //     ),
//         //   ),
//         // ),
//         // actions: [
//         //   Padding(
//         //     padding: const EdgeInsets.all(8.0),
//         //     child: Container(
//         //       decoration: BoxDecoration(
//         //         color: Colors.white,
//         //         shape: BoxShape.circle,
//         //         boxShadow: [
//         //           BoxShadow(
//         //             color: Colors.black.withOpacity(0.1),
//         //             blurRadius: 8,
//         //             offset: const Offset(0, 2),
//         //           ),
//         //         ],
//         //       ),
//         //       // child: IconButton(
//         //       //   icon: const Icon(Icons.share_outlined, color: Colors.black87, size: 20),
//         //       //   onPressed: () {},
//         //       // ),
//         //     ),
//         //   ),
//         //   const SizedBox(width: 8),
//         // ],
//       ),
//
//       body: Stack(
//         children: [
//           // Gradient Header Background
//           Container(
//             height: 280,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Colors.teal.shade400,
//                   Colors.teal.shade600,
//                 ],
//               ),
//             ),
//           ),
//
//           // Main Content
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 const SizedBox(height: 100),
//
//                 // Profile Card with Image
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(24),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.08),
//                           blurRadius: 20,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 24),
//
//                         // Profile Image with Badge
//                         Stack(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 border: Border.all(color: Colors.white, width: 4),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.teal.withOpacity(0.3),
//                                     blurRadius: 16,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: CircleAvatar(
//                                 radius: 56,
//                                 backgroundColor: Colors.grey.shade100,
//                                 backgroundImage: NetworkImage(
//                                   providerData["image"] == "" || providerData["image"] == null
//                                       ? "https://cdn-icons-png.flaticon.com/512/847/847969.png"
//                                       : providerData["image"],
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               right: 0,
//                               child: Container(
//                                 padding: const EdgeInsets.all(6),
//                                 decoration: BoxDecoration(
//                                   color: Colors.green,
//                                   shape: BoxShape.circle,
//                                   border: Border.all(color: Colors.white, width: 3),
//                                 ),
//                                 child: const Icon(Icons.check, color: Colors.white, size: 16),
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         const SizedBox(height: 16),
//
//                         // Name
//                         Text(
//                           providerData["name"],
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFF1A1F36),
//                             letterSpacing: -0.5,
//                           ),
//                         ),
//
//                         const SizedBox(height: 8),
//
//                         // Rating
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                           decoration: BoxDecoration(
//                             color: Colors.amber.shade50,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: const [
//                               Icon(Icons.star_rounded, color: Colors.amber, size: 20),
//                               SizedBox(width: 4),
//                               Text(
//                                 "4.8",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w700,
//                                   color: Color(0xFF1A1F36),
//                                 ),
//                               ),
//                               SizedBox(width: 4),
//                               Text(
//                                 "(234 reviews)",
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: Colors.grey,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         const SizedBox(height: 24),
//
//                         // Quick Stats
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               _buildStatItem(
//                                 Icons.work_outline_rounded,
//                                 "${providerData["experience"]}+",
//                                 "Years Exp.",
//                               ),
//                               Container(
//                                 width: 1,
//                                 height: 40,
//                                 color: Colors.grey.shade200,
//                               ),
//                               _buildStatItem(
//                                 Icons.check_circle_outline_rounded,
//                                 "150+",
//                                 "Jobs Done",
//                               ),
//                               Container(
//                                 width: 1,
//                                 height: 40,
//                                 color: Colors.grey.shade200,
//                               ),
//                               _buildStatItem(
//                                 Icons.thumb_up_alt_outlined,
//                                 "98%",
//                                 "Satisfied",
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         const SizedBox(height: 24),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // Service Details Section
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: FutureBuilder<DocumentSnapshot>(
//                     future: FirebaseFirestore.instance
//                         .collection("services")
//                         .doc(providerData["service_id"])
//                         .get(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return _buildShimmerCard();
//                       }
//
//                       if (!snapshot.hasData || !snapshot.data!.exists) {
//                         return const SizedBox.shrink();
//                       }
//
//                       return _ProfessionalSectionCard(
//                         icon: Icons.miscellaneous_services_rounded,
//                         iconColor: Colors.teal,
//                         title: "Service Details",
//                         child: Column(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Colors.teal.shade50,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Row(
//                                 children: const [
//                                   Icon(Icons.info_outline_rounded, color: Colors.teal, size: 20),
//                                   SizedBox(width: 8),
//                                   Expanded(
//                                     child: Text(
//                                       "Service charge may vary based on your specific requirements",
//                                       style: TextStyle(
//                                         fontSize: 13,
//                                         color: Colors.teal,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             _buildDetailRow(
//                               Icons.currency_rupee_rounded,
//                               "Visit Charge",
//                               "₹${providerData["visit_charge"]}",
//                               Colors.green,
//                             ),
//                             const Divider(height: 24),
//                             _buildDetailRow(
//                               Icons.workspace_premium_rounded,
//                               "Experience",
//                               "${providerData["experience"]} Years",
//                               Colors.orange,
//                             ),
//                             const Divider(height: 24),
//                             _buildDetailRow(
//                               Icons.star_rounded,
//                               "Rating",
//                               "4.8 / 5.0",
//                               Colors.amber,
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 // Skills Section
//                 // Padding(
//                 //   padding: const EdgeInsets.symmetric(horizontal: 20),
//                 //   child: _ProfessionalSectionCard(
//                 //     icon: Icons.lightbulb_outline_rounded,
//                 //     iconColor: Colors.purple,
//                 //     title: "Expertise & Skills",
//                 //     child: Wrap(
//                 //       spacing: 10,
//                 //       runSpacing: 10,
//                 //       children: const [
//                 //         _ProfessionalSkillChip("Pipe Fitting", Icons.plumbing_rounded),
//                 //         _ProfessionalSkillChip("Leak Repairs", Icons.water_drop_outlined),
//                 //         _ProfessionalSkillChip("Installation", Icons.build_rounded),
//                 //         _ProfessionalSkillChip("Maintenance", Icons.home_repair_service_rounded),
//                 //       ],
//                 //     ),
//                 //   ),
//                 // ),
//
//                 const SizedBox(height: 16),
//
//                 // Location Section
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: _ProfessionalSectionCard(
//                     icon: Icons.location_on_rounded,
//                     iconColor: Colors.red,
//                     title: "Service Location",
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.red.shade50,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: const Icon(Icons.location_on, color: Colors.red, size: 20),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Text(
//                             providerData["address"] ?? "No address available",
//                             style: const TextStyle(
//                               fontSize: 15,
//                               color: Color(0xFF4A5568),
//                               fontWeight: FontWeight.w500,
//                               height: 1.5,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 100),
//               ],
//             ),
//           ),
//         ],
//       ),
//
//       // Bottom Button
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, -5),
//             ),
//           ],
//         ),
//         child: SafeArea(
//           child: SizedBox(
//             height: 56,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal,
//                 foregroundColor: Colors.white,
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 shadowColor: Colors.teal.withOpacity(0.3),
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => BookingPage(
//                       customerId: customerId,
//                       employeId: providerData["uid"],
//                       serviceId: providerData["service_id"],
//                     ),
//                   ),
//                 );
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   Text(
//                     "Book Appointment",
//                     style: TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w600,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   Icon(Icons.arrow_forward_rounded, size: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatItem(IconData icon, String value, String label) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.teal, size: 24),
//         const SizedBox(height: 6),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF1A1F36),
//           ),
//         ),
//         const SizedBox(height: 2),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey.shade600,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDetailRow(IconData icon, String label, String value, Color color) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(icon, color: color, size: 20),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontSize: 15,
//               color: Color(0xFF4A5568),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF1A1F36),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildShimmerCard() {
//     return Container(
//       height: 150,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: const Center(
//         child: CircularProgressIndicator(color: Colors.teal),
//       ),
//     );
//   }
// }
//
// class _ProfessionalSectionCard extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor;
//   final String title;
//   final Widget child;
//
//   const _ProfessionalSectionCard({
//     required this.icon,
//     required this.iconColor,
//     required this.title,
//     required this.child,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: iconColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(icon, color: iconColor, size: 20),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF1A1F36),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           child,
//         ],
//       ),
//     );
//   }
// }
//
// class _ProfessionalSkillChip extends StatelessWidget {
//   final String text;
//   final IconData icon;
//
//   const _ProfessionalSkillChip(this.text, this.icon);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.teal.shade50, Colors.teal.shade100],
//         ),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.teal.shade200, width: 1),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: Colors.teal, size: 18),
//           const SizedBox(width: 6),
//           Text(
//             text,
//             style: const TextStyle(
//               color: Colors.teal,
//               fontWeight: FontWeight.w600,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
