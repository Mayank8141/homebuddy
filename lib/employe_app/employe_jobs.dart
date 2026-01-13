// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shimmer/shimmer.dart';
//
// class EmployeeJobsScreen extends StatefulWidget {
//   final String uid;
//   const EmployeeJobsScreen({super.key, required this.uid});
//
//   @override
//   State<EmployeeJobsScreen> createState() => _EmployeeJobsScreenState();
// }
//
// class _EmployeeJobsScreenState extends State<EmployeeJobsScreen> {
//   String selectedStatus = "Accepted";
//
//   // ================= SHIMMER =================
//   Widget _buildShimmerCard() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Container(
//                     height: 18,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Container(height: 14, color: Colors.white),
//             const SizedBox(height: 8),
//             Container(height: 14, width: 200, color: Colors.white),
//             const SizedBox(height: 20),
//             Container(
//               height: 50,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FD),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "My Jobs",
//           style: TextStyle(
//             color: Colors.black87,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             letterSpacing: 0.2,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, size: 20),
//           color: Colors.black87,
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Status Filter Chips
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 statusChip("Accepted"),
//                 statusChip("Started"),
//                 statusChip("Completed"),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//
//           // Jobs List
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection("booking_details")
//                   .where("employe_id", isEqualTo: widget.uid)
//                   .where("status", isEqualTo: selectedStatus)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return ListView.builder(
//                     padding: const EdgeInsets.all(20),
//                     itemCount: 3,
//                     itemBuilder: (context, index) => _buildShimmerCard(),
//                   );
//                 }
//
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(24),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[100],
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.work_outline_rounded,
//                             size: 64,
//                             color: Colors.grey[400],
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         Text(
//                           "No $selectedStatus jobs",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           "Jobs will appear here",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[500],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//
//                 return ListView.builder(
//                   physics: const BouncingScrollPhysics(),
//                   padding: const EdgeInsets.all(20),
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     final doc = snapshot.data!.docs[index];
//                     final data = doc.data() as Map<String, dynamic>;
//
//                     return JobCard(
//                       bookingId: doc.id,
//                       customerId: data["customer_id"],
//                       serviceId: data["service_id"],
//                       serviceDate: data["service_date"],
//                       problem: data["problem_description"] ?? "",
//                       status: data["status"],
//                       employeeId: widget.uid,
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget statusChip(String status) {
//     bool isSelected = selectedStatus == status;
//     return InkWell(
//       onTap: () => setState(() => selectedStatus = status),
//       borderRadius: BorderRadius.circular(20),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFF1ABC9C) : Colors.grey[100],
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: isSelected ? const Color(0xFF1ABC9C) : Colors.grey[300]!,
//             width: 1.5,
//           ),
//         ),
//         child: Text(
//           status,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.grey[700],
//             fontWeight: FontWeight.w600,
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// //////////////////////////////////////////////////////////////
// /// JOB CARD
// //////////////////////////////////////////////////////////////
// class JobCard extends StatelessWidget {
//   final String bookingId;
//   final String customerId;
//   final String serviceId;
//   final Timestamp serviceDate;
//   final String problem;
//   final String status;
//   final String employeeId;
//
//   const JobCard({
//     super.key,
//     required this.bookingId,
//     required this.customerId,
//     required this.serviceId,
//     required this.serviceDate,
//     required this.problem,
//     required this.status,
//     required this.employeeId,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// SERVICE + STATUS
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: FutureBuilder<DocumentSnapshot>(
//                     future: FirebaseFirestore.instance
//                         .collection("services")
//                         .doc(serviceId)
//                         .get(),
//                     builder: (context, snap) {
//                       if (!snap.hasData)
//                         return const Text(
//                           "Loading...",
//                           style: TextStyle(fontSize: 16),
//                         );
//                       return Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF1ABC9C).withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: const Icon(
//                               Icons.home_repair_service_rounded,
//                               color: Color(0xFF1ABC9C),
//                               size: 20,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Text(
//                               snap.data!["name"],
//                               style: const TextStyle(
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 statusBadge(status),
//               ],
//             ),
//
//             const SizedBox(height: 16),
//
//             /// CUSTOMER DETAILS
//             FutureBuilder<DocumentSnapshot>(
//               future: FirebaseFirestore.instance
//                   .collection("customer_detail")
//                   .doc(customerId)
//                   .get(),
//               builder: (context, snap) {
//                 if (!snap.hasData)
//                   return const Text(
//                     "Loading customer...",
//                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                   );
//                 final c = snap.data!;
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     infoRow(Icons.person_outline_rounded, c["name"]),
//                     const SizedBox(height: 10),
//                     infoRow(Icons.phone_outlined, c["phone"]),
//                     const SizedBox(height: 10),
//                     infoRow(Icons.location_on_rounded, c["address"]),
//                   ],
//                 );
//               },
//             ),
//
//             const SizedBox(height: 10),
//             infoRow(Icons.calendar_today_rounded, formatDate(serviceDate)),
//
//             if (problem.isNotEmpty) ...[
//               const SizedBox(height: 10),
//               infoRow(Icons.description_outlined, problem),
//             ],
//
//             const SizedBox(height: 20),
//
//             /// ACTION BUTTON
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: status == "Completed"
//                       ? Colors.grey[400]
//                       : const Color(0xFF1ABC9C),
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 onPressed: status == "Accepted"
//                     ? () => showAmountDialog(context)
//                     : status == "Started"
//                     ? () => completeJob()
//                     : null,
//                 child: Text(
//                   status == "Accepted"
//                       ? "Start Job"
//                       : status == "Started"
//                       ? "Complete Job"
//                       : "Completed",
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   ////////////////////////////////////////////////////////////
//   /// START JOB
//   ////////////////////////////////////////////////////////////
//   void showAmountDialog(BuildContext context) {
//     final TextEditingController amountCtrl = TextEditingController();
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         title: const Text(
//           "Enter Service Amount",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         content: TextField(
//           controller: amountCtrl,
//           keyboardType: TextInputType.number,
//           autofocus: true,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//           decoration: InputDecoration(
//             prefixText: "₹ ",
//             prefixStyle: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//             hintText: "Service charge only",
//             filled: true,
//             fillColor: Colors.grey[50],
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide.none,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide(color: Colors.grey[200]!),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: const BorderSide(
//                 color: Color(0xFF1ABC9C),
//                 width: 2,
//               ),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 20,
//               vertical: 16,
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               "Cancel",
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF1ABC9C),
//               foregroundColor: Colors.white,
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 24,
//                 vertical: 12,
//               ),
//             ),
//             child: const Text(
//               "Confirm",
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             onPressed: () async {
//               final serviceAmount = double.tryParse(amountCtrl.text.trim());
//
//               if (serviceAmount == null) return;
//
//               // ✅ CLOSE DIALOG IMMEDIATELY
//               Navigator.pop(context);
//
//               try {
//                 final empSnap = await FirebaseFirestore.instance
//                     .collection("employe_detail")
//                     .doc(employeeId)
//                     .get();
//
//                 final rawVisit = empSnap.data()?["visit_charge"] ?? 0;
//
//                 final double visitCharge = rawVisit is num
//                     ? rawVisit.toDouble()
//                     : double.tryParse(rawVisit.toString()) ?? 0;
//
//                 await FirebaseFirestore.instance
//                     .collection("booking_details")
//                     .doc(bookingId)
//                     .update({
//                   "status": "Started",
//                   "service_amount": serviceAmount,
//                   "visit_charge": visitCharge,
//                   "final_amount": serviceAmount + visitCharge,
//                   "started_at": Timestamp.now(),
//                 });
//               } catch (e) {
//                 debugPrint("❌ Start job error: $e");
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   ////////////////////////////////////////////////////////////
//   /// COMPLETE JOB + BILL + NOTIFICATION
//   ////////////////////////////////////////////////////////////
//   Future<void> completeJob() async {
//     try {
//       final bookingRef = FirebaseFirestore.instance
//           .collection("booking_details")
//           .doc(bookingId);
//
//       final bookingSnap = await bookingRef.get();
//       if (!bookingSnap.exists) return;
//
//       final booking = bookingSnap.data() as Map<String, dynamic>;
//
//       // 🔹 SAFE PARSING
//       final double serviceAmount = (booking["service_amount"] is num)
//           ? (booking["service_amount"] as num).toDouble()
//           : double.tryParse(booking["service_amount"]?.toString() ?? "0") ?? 0;
//
//       final double visitCharge = (booking["visit_charge"] is num)
//           ? (booking["visit_charge"] as num).toDouble()
//           : double.tryParse(booking["visit_charge"]?.toString() ?? "0") ?? 0;
//
//       final double totalAmount = serviceAmount + visitCharge;
//
//       // 🔥 CREATE BILL & GET BILL ID
//       final billRef =
//       FirebaseFirestore.instance.collection("bill_details").doc();
//
//       await billRef.set({
//         "bill_id": billRef.id,
//         "booking_id": bookingId,
//         "customer_id": customerId,
//         "employee_id": employeeId,
//         "service_id": serviceId,
//         "service_amount": serviceAmount,
//         "visit_charge": visitCharge,
//         "total_amount": totalAmount,
//         "payment_status": "Pending",
//         "created_at": Timestamp.now(),
//       });
//
//       // 🔔 SEND NOTIFICATION WITH bill_id
//       await FirebaseFirestore.instance.collection("notifications").add({
//         "receiver_id": customerId,
//         "receiver_type": "customer",
//         "sender_id": employeeId,
//         "sender_type": "employee",
//         "title": "Payment Pending",
//         "message": "Your service is completed. Please pay ₹$totalAmount",
//         "bill_id": billRef.id, // ✅ IMPORTANT
//         "booking_id": bookingId,
//         "is_read": false,
//         "created_at": Timestamp.now(),
//       });
//
//       // ✅ UPDATE BOOKING STATUS
//       await bookingRef.update({
//         "status": "Completed",
//         "completed_at": Timestamp.now(),
//       });
//     } catch (e) {
//       debugPrint("❌ Bill creation failed: $e");
//     }
//   }
//
//   ////////////////////////////////////////////////////////////
//   /// HELPERS
//   ////////////////////////////////////////////////////////////
//   Widget infoRow(IconData icon, String text) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, size: 18, color: Colors.grey[600]),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[700],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget statusBadge(String status) {
//     Color bg = status == "Started"
//         ? Colors.orange.shade100
//         : status == "Completed"
//         ? Colors.green.shade100
//         : const Color(0xFF1ABC9C).withOpacity(0.1);
//
//     Color textColor = status == "Started"
//         ? Colors.orange
//         : status == "Completed"
//         ? Colors.green
//         : const Color(0xFF1ABC9C);
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(
//           color: textColor,
//           fontWeight: FontWeight.w600,
//           fontSize: 13,
//         ),
//       ),
//     );
//   }
//
//   String formatDate(Timestamp t) {
//     final d = t.toDate();
//     return "${d.day}/${d.month}/${d.year} ${d.hour}:${d.minute.toString().padLeft(2, '0')}";
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';

class EmployeeJobsScreen extends StatefulWidget {
  final String uid;
  const EmployeeJobsScreen({super.key, required this.uid});

  @override
  State<EmployeeJobsScreen> createState() => _EmployeeJobsScreenState();
}

class _EmployeeJobsScreenState extends State<EmployeeJobsScreen> {
  String selectedStatus = "Accepted";

  Future<JobFullData> loadJobFullData(DocumentSnapshot doc) async {
    final booking = doc.data() as Map<String, dynamic>;

    final results = await Future.wait([
      FirebaseFirestore.instance
          .collection("services")
          .doc(booking["service_id"])
          .get(),

      FirebaseFirestore.instance
          .collection("customer_detail")
          .doc(booking["customer_id"])
          .get(),
    ]);

    return JobFullData(
      booking: booking,
      service: results[0].data() as Map<String, dynamic>,
      customer: results[1].data() as Map<String, dynamic>,
    );
  }


  // ================= SHIMMER =================
  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(height: 14, color: Colors.white),
            const SizedBox(height: 8),
            Container(height: 14, width: 200, color: Colors.white),
            const SizedBox(height: 20),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Jobs",
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
      body: Column(
        children: [
          // Status Filter Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                statusChip("Accepted"),
                statusChip("Started"),
                statusChip("Completed"),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Jobs List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("booking_details")
                  .where("employe_id", isEqualTo: widget.uid)
                  .where("status", isEqualTo: selectedStatus)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: 3,
                    itemBuilder: (context, index) => _buildShimmerCard(),
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
                            Icons.work_outline_rounded,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "No $selectedStatus jobs",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Jobs will appear here",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];

                    return FutureBuilder<JobFullData>(
                      future: loadJobFullData(doc),
                      builder: (context, snap) {
                        // 🔄 SHOW SHIMMER UNTIL EVERYTHING LOADS
                        if (!snap.hasData) {
                          return _buildShimmerCard();
                        }

                        final full = snap.data!;

                        return JobCard(
                          bookingId: doc.id,
                          customerId: full.booking["customer_id"],
                          serviceId: full.booking["service_id"],
                          serviceDate: full.booking["service_date"],
                          problem: full.booking["problem_description"] ?? "",
                          status: full.booking["status"],
                          employeeId: widget.uid,

                          // 🔥 PRELOADED DATA
                          serviceName: full.service["name"],
                          customerName: full.customer["name"],
                          customerPhone: full.customer["phone"],
                          customerAddress: full.customer["address"],
                        );
                      },
                    );
                  },
                );

              },
            ),
          ),
        ],
      ),
    );
  }

  Widget statusChip(String status) {
    bool isSelected = selectedStatus == status;
    return InkWell(
      onTap: () => setState(() => selectedStatus = status),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1ABC9C) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF1ABC9C) : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class JobFullData {
  final Map<String, dynamic> booking;
  final Map<String, dynamic> service;
  final Map<String, dynamic> customer;

  JobFullData({
    required this.booking,
    required this.service,
    required this.customer,
  });
}



//////////////////////////////////////////////////////////////
/// JOB CARD
//////////////////////////////////////////////////////////////
class JobCard extends StatelessWidget {
  final String bookingId;
  final String customerId;
  final String serviceId;
  final Timestamp serviceDate;
  final String problem;
  final String status;
  final String employeeId;
  final String serviceName;
  final String customerName;
  final String customerPhone;
  final String customerAddress;


  const JobCard({
    super.key,
    required this.bookingId,
    required this.customerId,
    required this.serviceId,
    required this.serviceDate,
    required this.problem,
    required this.status,
    required this.employeeId,
    required this.serviceName,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          _showBookingDetails(context);
        },
        child: Container(
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
              /// SERVICE + STATUS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
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
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  statusBadge(status),
                ],
              ),

              const SizedBox(height: 16),

              /// CUSTOMER DETAILS
              // FutureBuilder<DocumentSnapshot>(
              //   future: FirebaseFirestore.instance
              //       .collection("customer_detail")
              //       .doc(customerId)
              //       .get(),
              //   builder: (context, snap) {
              //     if (!snap.hasData)
              //       return const Text(
              //         "Loading customer...",
              //         style: TextStyle(fontSize: 14, color: Colors.grey),
              //       );
              //     final c = snap.data!;
              //     return Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         infoRow(Icons.person_outline_rounded, customerName),
              //         const SizedBox(height: 10),
              //         infoRow(Icons.phone_outlined, customerPhone),
              //         const SizedBox(height: 10),
              //         infoRow(Icons.location_on_rounded, customerAddress),
              //
              //       ],
              //     );
              //   },
              // ),

              const SizedBox(height: 10),
              infoRow(Icons.calendar_today_rounded, formatDate(serviceDate)),

              if (problem.isNotEmpty) ...[
                const SizedBox(height: 10),
                infoRow(Icons.description_outlined, problem),
              ],

              const SizedBox(height: 20),

              /// ACTION BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: status == "Completed"
                        ? Colors.grey[400]
                        : const Color(0xFF1ABC9C),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: status == "Accepted"
                      ? () => showAmountDialog(context)
                      : status == "Started"
                      ? () => completeJob()
                      : null,
                  child: Text(
                    status == "Accepted"
                        ? "Start Job"
                        : status == "Started"
                        ? "Complete Job"
                        : "Completed",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        )
    );
  }

  void _showBookingDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Booking Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // BODY
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _detailRow("Service", serviceName),
                      _detailRow("Customer", customerName),
                      _detailRow("Phone", customerPhone),
                      _detailRow("Address", customerAddress),
                      _detailRow("Date", formatDate(serviceDate)),
                      _detailRow("Status", status),

                      if (problem.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Text(
                          "Problem Description",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          problem,
                          style: TextStyle(
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// START JOB
  ////////////////////////////////////////////////////////////
  // void showAmountDialog(BuildContext context) {
  //   final TextEditingController amountCtrl = TextEditingController();
  //
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (_) => AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       title: const Text(
  //         "Enter Service Amount",
  //         style: TextStyle(
  //           fontWeight: FontWeight.bold,
  //           fontSize: 20,
  //         ),
  //       ),
  //       content: TextField(
  //         controller: amountCtrl,
  //         keyboardType: TextInputType.number,
  //         autofocus: true,
  //         style: const TextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.w600,
  //         ),
  //         decoration: InputDecoration(
  //           prefixText: "₹ ",
  //           prefixStyle: const TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.black87,
  //           ),
  //           hintText: "Service charge only",
  //           filled: true,
  //           fillColor: Colors.grey[50],
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(14),
  //             borderSide: BorderSide.none,
  //           ),
  //           enabledBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(14),
  //             borderSide: BorderSide(color: Colors.grey[200]!),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(14),
  //             borderSide: const BorderSide(
  //               color: Color(0xFF1ABC9C),
  //               width: 2,
  //             ),
  //           ),
  //           contentPadding: const EdgeInsets.symmetric(
  //             horizontal: 20,
  //             vertical: 16,
  //           ),
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text(
  //             "Cancel",
  //             style: TextStyle(
  //               color: Colors.grey[600],
  //               fontSize: 15,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: const Color(0xFF1ABC9C),
  //             foregroundColor: Colors.white,
  //             elevation: 0,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: 24,
  //               vertical: 12,
  //             ),
  //           ),
  //           child: const Text(
  //             "Confirm",
  //             style: TextStyle(
  //               fontSize: 15,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //           onPressed: () async {
  //             final serviceAmount = double.tryParse(amountCtrl.text.trim());
  //
  //             if (serviceAmount == null) return;
  //
  //             // ✅ CLOSE DIALOG IMMEDIATELY
  //             Navigator.pop(context);
  //
  //             try {
  //               final empSnap = await FirebaseFirestore.instance
  //                   .collection("employe_detail")
  //                   .doc(employeeId)
  //                   .get();
  //
  //               final rawVisit = empSnap.data()?["visit_charge"] ?? 0;
  //
  //               final double visitCharge = rawVisit is num
  //                   ? rawVisit.toDouble()
  //                   : double.tryParse(rawVisit.toString()) ?? 0;
  //
  //               await FirebaseFirestore.instance
  //                   .collection("booking_details")
  //                   .doc(bookingId)
  //                   .update({
  //                 "status": "Started",
  //                 "service_amount": serviceAmount,
  //                 "visit_charge": visitCharge,
  //                 "final_amount": serviceAmount + visitCharge,
  //                 "started_at": Timestamp.now(),
  //               });
  //             } catch (e) {
  //               debugPrint("❌ Start job error: $e");
  //             }
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }


  void showAmountDialog(BuildContext context) {
    final TextEditingController serviceCtrl = TextEditingController();
    bool? customerTookService;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "Start Job",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// STEP 1: ASK QUESTION
                  const Text(
                    "Did customer take service?",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customerTookService == true
                                ? const Color(0xFF1ABC9C)
                                : Colors.grey[200],
                            foregroundColor: customerTookService == true
                                ? Colors.white
                                : Colors.black87,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              customerTookService = true;
                            });
                          },
                          child: const Text("Yes"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customerTookService == false
                                ? Colors.redAccent
                                : Colors.grey[200],
                            foregroundColor: customerTookService == false
                                ? Colors.white
                                : Colors.black87,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              customerTookService = false;
                            });
                          },
                          child: const Text("No"),
                        ),
                      ),
                    ],
                  ),

                  /// STEP 2A: SERVICE AMOUNT
                  if (customerTookService == true) ...[
                    const SizedBox(height: 20),
                    const Text(
                      "Service Amount",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: serviceCtrl,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      decoration: InputDecoration(
                        prefixText: "₹ ",
                        hintText: "Enter service amount",
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],

                  /// STEP 2B: VISIT CHARGE INFO
                  if (customerTookService == false) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Customer did not take service.\nVisit charge will be applied automatically.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1ABC9C),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: customerTookService == null
                      ? null
                      : () async {
                    Navigator.pop(dialogContext);

                    try {
                      double serviceAmount = 0;
                      double visitCharge = 0;

                      if (customerTookService == true) {
                        serviceAmount =
                            double.tryParse(serviceCtrl.text.trim()) ?? 0;
                      } else {
                        // 🔥 AUTO FETCH VISIT CHARGE FROM EMPLOYEE
                        final empSnap = await FirebaseFirestore.instance
                            .collection("employe_detail")
                            .doc(employeeId)
                            .get();

                        final rawVisit =
                            empSnap.data()?["visit_charge"] ?? 0;

                        visitCharge = rawVisit is num
                            ? rawVisit.toDouble()
                            : double.tryParse(
                            rawVisit.toString()) ??
                            0;
                      }

                      await FirebaseFirestore.instance
                          .collection("booking_details")
                          .doc(bookingId)
                          .update({
                        "status": "Started",
                        "has_service": customerTookService,
                        "service_amount": serviceAmount,
                        "visit_charge": visitCharge,
                        "final_amount":
                        serviceAmount + visitCharge,
                        "started_at": Timestamp.now(),
                      });
                    } catch (e) {
                      debugPrint("❌ Start job error: $e");
                    }
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }


  ////////////////////////////////////////////////////////////
  /// COMPLETE JOB + BILL + NOTIFICATION
  ////////////////////////////////////////////////////////////
  Future<void> completeJob() async {
    try {
      final bookingRef = FirebaseFirestore.instance
          .collection("booking_details")
          .doc(bookingId);

      final bookingSnap = await bookingRef.get();
      if (!bookingSnap.exists) return;

      final booking = bookingSnap.data() as Map<String, dynamic>;

      // 🔹 SAFE PARSING
      final double serviceAmount = (booking["service_amount"] is num)
          ? (booking["service_amount"] as num).toDouble()
          : double.tryParse(booking["service_amount"]?.toString() ?? "0") ?? 0;

      final double visitCharge = (booking["visit_charge"] is num)
          ? (booking["visit_charge"] as num).toDouble()
          : double.tryParse(booking["visit_charge"]?.toString() ?? "0") ?? 0;

      final double totalAmount = serviceAmount + visitCharge;

      // 🔥 CREATE BILL & GET BILL ID
      final billRef =
      FirebaseFirestore.instance.collection("bill_details").doc();

      await billRef.set({
        "bill_id": billRef.id,
        "booking_id": bookingId,
        "customer_id": customerId,
        "employee_id": employeeId,
        "service_id": serviceId,
        "service_amount": serviceAmount,
        "visit_charge": visitCharge,
        "total_amount": totalAmount,
        "payment_status": "Pending",
        "created_at": Timestamp.now(),
      });

      // 🔔 SEND NOTIFICATION WITH bill_id
      await FirebaseFirestore.instance.collection("notifications").add({
        "receiver_id": customerId,
        "receiver_type": "customer",
        "sender_id": employeeId,
        "sender_type": "employee",
        "title": "Payment Pending",
        "message": "Your service is completed. Please pay ₹$totalAmount",
        "bill_id": billRef.id, // ✅ IMPORTANT
        "booking_id": bookingId,
        "is_read": false,
        "created_at": Timestamp.now(),
      });

      // ✅ UPDATE BOOKING STATUS
      await bookingRef.update({
        "status": "Completed",
        "completed_at": Timestamp.now(),
      });
    } catch (e) {
      debugPrint("❌ Bill creation failed: $e");
    }
  }

  ////////////////////////////////////////////////////////////
  /// HELPERS
  ////////////////////////////////////////////////////////////
  Widget infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget statusBadge(String status) {
    Color bg = status == "Started"
        ? Colors.orange.shade100
        : status == "Completed"
        ? Colors.green.shade100
        : const Color(0xFF1ABC9C).withOpacity(0.1);

    Color textColor = status == "Started"
        ? Colors.orange
        : status == "Completed"
        ? Colors.green
        : const Color(0xFF1ABC9C);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  String formatDate(Timestamp t) {
    final d = t.toDate();
    return "${d.day}/${d.month}/${d.year} ${d.hour}:${d.minute.toString().padLeft(2, '0')}";
  }
}