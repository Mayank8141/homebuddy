// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class EmployeeRequestsScreen extends StatefulWidget {
//   final String uid;
//   const EmployeeRequestsScreen({super.key, required this.uid});
//
//   @override
//   State<EmployeeRequestsScreen> createState() =>
//       _EmployeeRequestsScreenState();
// }
//
// class _EmployeeRequestsScreenState extends State<EmployeeRequestsScreen> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF4F6FA),
//
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: const Text(
//           "Service Requests",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w700,
//             fontSize: 18,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//
//       // 🔥 FETCH REQUESTS FROM FIRESTORE
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("booking_details")
//             .where("employe_id", isEqualTo: widget.uid)
//             .where("status", isEqualTo: "Pending")
//             .snapshots(),
//
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No Requests Found",
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             );
//           }
//
//           final bookings = snapshot.data!.docs;
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(18),
//             itemCount: bookings.length,
//             itemBuilder: (context, index) {
//               final booking = bookings[index];
//
//               return requestCard(
//                 bookingId: booking.id,
//                 customerId: booking["customer_id"],
//                 serviceId: booking["service_id"],
//                 time: booking["service_date"]
//                     .toDate()
//                     .toString()
//                     .substring(0, 16),
//                 problem: booking["problem_description"] ?? "",
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   // ============================================================
//   // REQUEST CARD
//   // ============================================================
//   Widget requestCard({
//     required String bookingId,
//     required String customerId,
//     required String serviceId,
//     required String time,
//     required String problem,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 18),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 8),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           /// 🔥 SERVICE NAME
//           FutureBuilder<DocumentSnapshot>(
//             future: FirebaseFirestore.instance
//                 .collection("services")
//                 .doc(serviceId)
//                 .get(),
//             builder: (context, serviceSnap) {
//               if (serviceSnap.connectionState == ConnectionState.waiting) {
//                 return const Text("Loading service...");
//               }
//
//               if (!serviceSnap.hasData || !serviceSnap.data!.exists) {
//                 return const Text(
//                   "Service not found",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 );
//               }
//
//               final data =
//               serviceSnap.data!.data() as Map<String, dynamic>;
//               final serviceName =
//                   data["name"] ?? data["service_name"] ?? "Unknown Service";
//
//               return Text(
//                 serviceName,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                 ),
//               );
//             },
//           ),
//
//           const SizedBox(height: 6),
//
//           /// 🔥 CUSTOMER NAME
//           FutureBuilder<DocumentSnapshot>(
//             future: FirebaseFirestore.instance
//                 .collection("customer_detail")
//                 .doc(customerId)
//                 .get(),
//             builder: (context, customerSnap) {
//               if (customerSnap.connectionState == ConnectionState.waiting) {
//                 return const Text("Loading customer...");
//               }
//
//               if (!customerSnap.hasData || !customerSnap.data!.exists) {
//                 return const Text("Customer not found");
//               }
//
//               final data =
//               customerSnap.data!.data() as Map<String, dynamic>;
//               final customerName = data["name"] ?? "Unknown Customer";
//
//               return Text(
//                 customerName,
//                 style: const TextStyle(fontSize: 14),
//               );
//             },
//           ),
//
//           const SizedBox(height: 8),
//
//           Row(
//             children: [
//               const Icon(Icons.access_time, size: 15, color: Colors.grey),
//               const SizedBox(width: 6),
//               Text(
//                 time,
//                 style: const TextStyle(fontSize: 13, color: Colors.grey),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 6),
//
//           /// 🔥 LOCATION
//           FutureBuilder<DocumentSnapshot>(
//             future: FirebaseFirestore.instance
//                 .collection("customer_detail")
//                 .doc(customerId)
//                 .get(),
//             builder: (context, customerSnap) {
//               if (!customerSnap.hasData || !customerSnap.data!.exists) {
//                 return const SizedBox();
//               }
//
//               final data =
//               customerSnap.data!.data() as Map<String, dynamic>;
//               final location = data["address"] ?? "Unknown Address";
//
//               return Row(
//                 children: [
//                   const Icon(Icons.location_on,
//                       size: 15, color: Colors.grey),
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: Text(
//                       location,
//                       style: const TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//
//           const SizedBox(height: 6),
//
//           Row(
//             children: [
//               const Icon(Icons.report_problem,
//                   size: 15, color: Colors.grey),
//               const SizedBox(width: 6),
//               Expanded(
//                 child: Text(
//                   problem,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 14),
//           Divider(color: Colors.grey.shade300),
//
//           Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton(
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Colors.red,
//                     side: const BorderSide(color: Colors.red),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: () {
//                     FirebaseFirestore.instance
//                         .collection("booking_details")
//                         .doc(bookingId)
//                         .update({"status": "Rejected"});
//                   },
//                   child: const Text("Reject"),
//                 ),
//               ),
//
//               const SizedBox(width: 12),
//
//               Expanded(
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF0052D4),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: () {
//                     FirebaseFirestore.instance
//                         .collection("booking_details")
//                         .doc(bookingId)
//                         .update({"status": "Accepted"});
//                   },
//                   child: const Text(
//                     "Accept",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeRequestsScreen extends StatefulWidget {
  final String uid;
  const EmployeeRequestsScreen({super.key, required this.uid});

  @override
  State<EmployeeRequestsScreen> createState() =>
      _EmployeeRequestsScreenState();
}

class _EmployeeRequestsScreenState extends State<EmployeeRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Service Requests",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: Colors.black87,
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // 🔥 FETCH REQUESTS FROM FIRESTORE
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("booking_details")
            .where("employe_id", isEqualTo: widget.uid)
            .where("status", isEqualTo: "Pending")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1ABC9C),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.inbox_rounded,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "No Requests Found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You're all caught up!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];

              return requestCard(
                bookingId: booking.id,
                customerId: booking["customer_id"],
                serviceId: booking["service_id"],
                time: booking["service_date"]
                    .toDate()
                    .toString()
                    .substring(0, 16),
                problem: booking["problem_description"] ?? "",
              );
            },
          );
        },
      ),
    );
  }

  // ============================================================
  // REQUEST CARD
  // ============================================================
  Widget requestCard({
    required String bookingId,
    required String customerId,
    required String serviceId,
    required String time,
    required String problem,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 SERVICE NAME
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("services")
                  .doc(serviceId)
                  .get(),
              builder: (context, serviceSnap) {
                if (serviceSnap.connectionState == ConnectionState.waiting) {
                  return Row(
                    children: [
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Loading service...",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  );
                }

                if (!serviceSnap.hasData || !serviceSnap.data!.exists) {
                  return const Text(
                    "Service not found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  );
                }

                final data = serviceSnap.data!.data() as Map<String, dynamic>;
                final serviceName =
                    data["name"] ?? data["service_name"] ?? "Unknown Service";

                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1ABC9C).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.home_repair_service_rounded,
                        color: Color(0xFF1ABC9C),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        serviceName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            /// 🔥 CUSTOMER NAME
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("customer_detail")
                  .doc(customerId)
                  .get(),
              builder: (context, customerSnap) {
                if (customerSnap.connectionState == ConnectionState.waiting) {
                  return Row(
                    children: [
                      SizedBox(
                        height: 14,
                        width: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Loading customer...",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  );
                }

                if (!customerSnap.hasData || !customerSnap.data!.exists) {
                  return Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Customer not found",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  );
                }

                final data = customerSnap.data!.data() as Map<String, dynamic>;
                final customerName = data["name"] ?? "Unknown Customer";

                return Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      customerName,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 12),

            /// 🔥 TIME
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 18,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// 🔥 LOCATION
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("customer_detail")
                  .doc(customerId)
                  .get(),
              builder: (context, customerSnap) {
                if (!customerSnap.hasData || !customerSnap.data!.exists) {
                  return const SizedBox();
                }

                final data = customerSnap.data!.data() as Map<String, dynamic>;
                final location = data["address"] ?? "Unknown Address";

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            if (problem.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      problem,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 20),

            /// 🔥 ACTION BUTTONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red.shade400, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("booking_details")
                          .doc(bookingId)
                          .update({"status": "Rejected"});
                    },
                    child: const Text(
                      "Reject",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1ABC9C),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      // Update booking
                      await FirebaseFirestore.instance
                          .collection("booking_details")
                          .doc(bookingId)
                          .update({"status": "Accepted"});

                      // Create CUSTOMER notification
                      final notificationId =
                          FirebaseFirestore.instance.collection("notifications").doc().id;

                      await FirebaseFirestore.instance
                          .collection("notifications")
                          .doc(notificationId)
                          .set({
                        "notification_id": notificationId,
                        "booking_id": bookingId,
                        "service_id": serviceId,

                        // 🔔 CUSTOMER RECEIVES
                        "receiver_id": customerId,
                        "receiver_type": "customer",

                        // EMPLOYEE SENDS
                        "sender_id": widget.uid,
                        "sender_type": "employeee", // match your DB for now

                        "title": "Booking Accepted",
                        "message": "Your service request has been accepted",

                        "is_read": false,
                        "created_at": Timestamp.now(),
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Request Accepted")),
                      );
                    },


                    child: const Text(
                      "Accept",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}