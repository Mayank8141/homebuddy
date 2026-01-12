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

class EmployeeEarningsScreen extends StatefulWidget {
  final String uid;
  const EmployeeEarningsScreen({super.key, required this.uid});

  @override
  State<EmployeeEarningsScreen> createState() =>
      _EmployeeEarningsScreenState();
}

class _EmployeeEarningsScreenState extends State<EmployeeEarningsScreen> {
  String selectedFilter = "All";

  DateTime? customFromDate;
  DateTime? customToDate;

  // ================= DATE FILTER LOGIC =================
  bool _isWithinFilter(DateTime date) {
    final now = DateTime.now();

    if (selectedFilter == "All") return true;

    switch (selectedFilter) {
      case "Today":
        return DateUtils.isSameDay(date, now);

      case "Yesterday":
        final yesterday = now.subtract(const Duration(days: 1));
        return DateUtils.isSameDay(date, yesterday);

      case "Past Week":
        return date.isAfter(now.subtract(const Duration(days: 7)));

      case "Past Month":
        return date.isAfter(DateTime(now.year, now.month - 1, now.day));

      case "Past Year":
        return date.isAfter(DateTime(now.year - 1, now.month, now.day));

      case "Custom":
        if (customFromDate == null || customToDate == null) return false;
        return date.isAfter(customFromDate!) &&
            date.isBefore(customToDate!.add(const Duration(days: 1)));

      default:
        return true;
    }
  }

  // ================= DATE PICKER =================
  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          customFromDate = picked;
        } else {
          customToDate = picked;
        }
      });
    }
  }

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
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("bill_details")
            .where("employee_id", isEqualTo: widget.uid)
            .where("payment_status", isEqualTo: "Completed")
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allBills = snapshot.data!.docs;

          final filteredBills = allBills.where((doc) {
            final paidAt =
            (doc["paid_at"] as Timestamp?)?.toDate();
            if (paidAt == null) return false;
            return _isWithinFilter(paidAt);
          }).toList();

          double todayEarning = 0;
          double totalEarning = 0;

          for (var doc in filteredBills) {
            final data = doc.data() as Map<String, dynamic>;
            final amount = (data["total_amount"] as num).toDouble();
            totalEarning += amount;

            if (DateUtils.isSameDay(
                (data["paid_at"] as Timestamp).toDate(),
                DateTime.now())) {
              todayEarning += amount;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ================= FILTER =================
                _filterBar(),

                const SizedBox(height: 16),

                // ================= SUMMARY =================
                Row(
                  children: [
                    _summaryCard(
                        title: "Today",
                        amount: todayEarning,
                        color: Colors.green),
                    const SizedBox(width: 12),
                    _summaryCard(
                        title: "Total",
                        amount: totalEarning,
                        color: Colors.blue),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  "Completed Payments",
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                filteredBills.isEmpty
                    ? const Center(
                  child: Text(
                    "No earnings found",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredBills.length,
                  itemBuilder: (context, index) {
                    final data = filteredBills[index].data()
                    as Map<String, dynamic>;
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

  // ================= FILTER BAR =================
  Widget _filterBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: selectedFilter,
          items: const [
            DropdownMenuItem(value: "All", child: Text("All")),
            DropdownMenuItem(value: "Today", child: Text("Today")),
            DropdownMenuItem(value: "Yesterday", child: Text("Yesterday")),
            DropdownMenuItem(value: "Past Week", child: Text("Past Week")),
            DropdownMenuItem(value: "Past Month", child: Text("Past Month")),
            DropdownMenuItem(value: "Past Year", child: Text("Past Year")),
            DropdownMenuItem(value: "Custom", child: Text("Custom Range")),
          ],

          onChanged: (value) {
            setState(() {
              selectedFilter = value!;
            });
          },
          decoration: const InputDecoration(
            labelText: "Filter By",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),

        if (selectedFilter == "Custom") ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pickDate(isFrom: true),
                  child: Text(
                    customFromDate == null
                        ? "From Date"
                        : DateFormat("dd MMM yyyy")
                        .format(customFromDate!),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pickDate(isFrom: false),
                  child: Text(
                    customToDate == null
                        ? "To Date"
                        : DateFormat("dd MMM yyyy")
                        .format(customToDate!),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
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
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat("dd MMM yyyy, hh:mm a").format(paidDate),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _amountRow("Service Amount", data["service_amount"]),
          _amountRow("Visit Charge", data["visit_charge"]),
          const Divider(),
          _amountRow("Total Earned", data["total_amount"], bold: true),
        ],
      ),
    );
  }

  Widget _amountRow(String label, dynamic value,
      {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight:
                  bold ? FontWeight.bold : FontWeight.normal)),
          Text("₹$value",
              style: TextStyle(
                  fontWeight:
                  bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
