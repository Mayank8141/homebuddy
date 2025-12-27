// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
//
// class EmployeeEarningsScreen extends StatelessWidget {
//   final String uid;
//   const EmployeeEarningsScreen({super.key, required this.uid});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF4F6FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "My Earnings",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("booking_details")
//             .where("employe_id", isEqualTo: uid)
//             .where("status", isEqualTo: "Completed")
//             .snapshots(),
//
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final bookings = snapshot.data!.docs;
//
//           double todayEarning = 0;
//           double totalEarning = 0;
//
//           DateTime today = DateTime.now();
//
//           for (var doc in bookings) {
//             final data = doc.data() as Map<String, dynamic>;
//             final amount = (data["amount"] ?? 0).toDouble();
//             final serviceDate = (data["service_date"] as Timestamp).toDate();
//
//             totalEarning += amount;
//
//             if (DateUtils.isSameDay(serviceDate, today)) {
//               todayEarning += amount;
//             }
//           }
//
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//                 // ================= SUMMARY =================
//                 Row(
//                   children: [
//                     _summaryCard(
//                       title: "Today",
//                       amount: todayEarning,
//                       color: Colors.green,
//                     ),
//                     const SizedBox(width: 12),
//                     _summaryCard(
//                       title: "Total",
//                       amount: totalEarning,
//                       color: Colors.blue,
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 24),
//
//                 const Text(
//                   "Completed Jobs",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 // ================= JOB LIST =================
//                 bookings.isEmpty
//                     ? const Center(
//                   child: Padding(
//                     padding: EdgeInsets.only(top: 40),
//                     child: Text(
//                       "No completed jobs yet",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                 )
//                     : ListView.builder(
//                   itemCount: bookings.length,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     final data =
//                     bookings[index].data() as Map<String, dynamic>;
//
//                     return _jobCard(data);
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   // ================= SUMMARY CARD =================
//   Widget _summaryCard({
//     required String title,
//     required double amount,
//     required Color color,
//   }) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(18),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12.withOpacity(0.05),
//               blurRadius: 12,
//             )
//           ],
//         ),
//         child: Column(
//           children: [
//             Text(
//               title,
//               style: const TextStyle(color: Colors.grey, fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "₹${amount.toStringAsFixed(0)}",
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ================= JOB CARD =================
//   Widget _jobCard(Map<String, dynamic> data) {
//     DateTime date = (data["service_date"] as Timestamp).toDate();
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12.withOpacity(0.04),
//             blurRadius: 10,
//           )
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 DateFormat("dd MMM yyyy").format(date),
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 data["service_name"] ?? "Service",
//                 style: const TextStyle(
//                   color: Colors.grey,
//                   fontSize: 13,
//                 ),
//               ),
//             ],
//           ),
//           Text(
//             "₹${(data["amount"] ?? 0)}",
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.green,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EmployeeEarningsScreen extends StatelessWidget {
  final String uid;
  const EmployeeEarningsScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Earnings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("bill_details")
            .where("employee_id", isEqualTo: uid)
            .where("payment_status", isEqualTo: "Completed")
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No earnings yet",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final bills = snapshot.data!.docs;

          double todayEarning = 0;
          double totalEarning = 0;

          final today = DateTime.now();

          for (var doc in bills) {
            final data = doc.data() as Map<String, dynamic>;

            final totalAmount = (data["total_amount"] is num)
                ? (data["total_amount"] as num).toDouble()
                : 0;

            final paidAt = (data["paid_at"] as Timestamp?)?.toDate();

            totalEarning += totalAmount;

            if (paidAt != null && DateUtils.isSameDay(paidAt, today)) {
              todayEarning += totalAmount;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ================= SUMMARY =================
                Row(
                  children: [
                    _summaryCard(
                      title: "Today",
                      amount: todayEarning,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 12),
                    _summaryCard(
                      title: "Total",
                      amount: totalEarning,
                      color: Colors.blue,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  "Completed Payments",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                /// ================= BILL LIST =================
                ListView.builder(
                  itemCount: bills.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final data =
                    bills[index].data() as Map<String, dynamic>;
                    return _billCard(data);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= SUMMARY CARD =================
  Widget _summaryCard({
    required String title,
    required double amount,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 12,
            )
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              "₹${amount.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= BILL CARD =================
  Widget _billCard(Map<String, dynamic> data) {
    final DateTime paidDate =
    (data["paid_at"] as Timestamp).toDate();

    final serviceAmount = data["service_amount"] ?? 0;
    final visitCharge = data["visit_charge"] ?? 0;
    final totalAmount = data["total_amount"] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.04),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat("dd MMM yyyy, hh:mm a").format(paidDate),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),

          _amountRow("Service Amount", serviceAmount),
          _amountRow("Visit Charge", visitCharge),

          const Divider(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Earned",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "₹$totalAmount",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _amountRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          Text(
            "₹$value",
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
