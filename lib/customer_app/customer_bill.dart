import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'customer_feedback.dart';

class BillPaymentPage extends StatefulWidget {
  final String billId;
  final String customerId;
  final String employeeId;

  const BillPaymentPage({
    super.key,
    required this.billId,
    required this.customerId,
    required this.employeeId,
  });

  @override
  State<BillPaymentPage> createState() => _BillPaymentPageState();
}

class _BillPaymentPageState extends State<BillPaymentPage> {
  bool loading = true;
  bool paying = false;

  Map<String, dynamic>? bill;
  Map<String, dynamic>? booking;
  Map<String, dynamic>? service;
  Map<String, dynamic>? employee;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  // --------------------------------------------------
  Future<void> fetchAllData() async {
    try {
      // 🔹 BILL
      final billSnap = await FirebaseFirestore.instance
          .collection("bill_details")
          .doc(widget.billId)
          .get();

      if (!billSnap.exists) return;

      bill = billSnap.data();
      final bookingId = bill!["booking_id"];
      final serviceId = bill!["service_id"];

      // 🔹 BOOKING
      final bookingSnap = await FirebaseFirestore.instance
          .collection("booking_details")
          .doc(bookingId)
          .get();

      booking = bookingSnap.data();

      // 🔹 SERVICE
      final serviceSnap = await FirebaseFirestore.instance
          .collection("services")
          .doc(serviceId)
          .get();

      service = serviceSnap.data();

      // 🔹 EMPLOYEE
      final empSnap = await FirebaseFirestore.instance
          .collection("employe_detail")
          .doc(widget.employeeId)
          .get();

      employee = empSnap.data();

      setState(() => loading = false);
    } catch (e) {
      debugPrint("❌ Bill fetch error: $e");
    }
  }

  // --------------------------------------------------
  // Future<void> payBill() async {
  //   setState(() => paying = true);
  //
  //   try {
  //     // ✅ UPDATE BILL STATUS
  //     await FirebaseFirestore.instance
  //         .collection("bill_details")
  //         .doc(widget.billId)
  //         .update({
  //       "payment_status": "Completed",
  //       "paid_at": Timestamp.now(),
  //     });
  //
  //     // 🔔 NOTIFY EMPLOYEE
  //     await FirebaseFirestore.instance.collection("notifications").add({
  //       "receiver_id": widget.employeeId,
  //       "receiver_type": "employee",
  //       "sender_id": widget.customerId,
  //       "sender_type": "customer",
  //       "title": "Payment Received",
  //       "message":
  //       "₹${bill!["total_amount"]} payment received for ${service?["name"] ?? "service"}",
  //       "bill_id": widget.billId,
  //       "is_read": false,
  //       "created_at": Timestamp.now(),
  //     });
  //
  //     if (!mounted) return;
  //
  //     // ✅ SUCCESS MESSAGE
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Payment Successful"),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //
  //     // ✅ AUTO GO BACK AFTER PAYMENT
  //     Future.delayed(const Duration(milliseconds: 500), () {
  //       if (mounted) {
  //         Navigator.pop(context); // go back to notifications
  //       }
  //     });
  //   } catch (e) {
  //     debugPrint("❌ Payment failed: $e");
  //   } finally {
  //     if (mounted) setState(() => paying = false);
  //   }
  // }

  Future<void> payBill() async {
    setState(() => paying = true);

    try {
      // ✅ UPDATE BILL STATUS
      await FirebaseFirestore.instance
          .collection("bill_details")
          .doc(widget.billId)
          .update({
        "payment_status": "Completed",
        "paid_at": Timestamp.now(),
      });

      // 🔔 NOTIFY EMPLOYEE
      await FirebaseFirestore.instance.collection("notifications").add({
        "receiver_id": widget.employeeId,
        "receiver_type": "employee",
        "sender_id": widget.customerId,
        "sender_type": "customer",
        "title": "Payment Received",
        "message":
        "₹${bill!["total_amount"]} payment received for ${service?["name"] ?? "service"}",
        "bill_id": widget.billId,
        "is_read": false,
        "created_at": Timestamp.now(),
      });

      if (!mounted) return;

      // ✅ GO TO FEEDBACK PAGE
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => FeedbackPage(
            billId: widget.billId,
            bookingId: bill!["booking_id"],
            employeeId: widget.employeeId,
            customerId: widget.customerId,
          ),
        ),
      );
    } catch (e) {
      debugPrint("❌ Payment failed: $e");
    } finally {
      if (mounted) setState(() => paying = false);
    }
  }


  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("Bill Details"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle("Service Details"),
            infoTile("Service", service?["name"]),
            infoTile("Provider", employee?["name"]),
            infoTile(
              "Service Date",
              formatDate(booking?["service_date"]),
            ),
            if ((booking?["problem_description"] ?? "").toString().isNotEmpty)
              infoTile(
                "Problem",
                booking?["problem_description"],
              ),

            const SizedBox(height: 20),

            sectionTitle("Bill Summary"),
            amountTile("Service Amount", bill?["service_amount"]),
            amountTile("Visit Charge", bill?["visit_charge"]),
            const Divider(height: 30),
            amountTile(
              "Total Amount",
              bill?["total_amount"],
              isTotal: true,
            ),

            const SizedBox(height: 10),
            statusChip(bill?["payment_status"]),

            const SizedBox(height: 30),

            if (bill?["payment_status"] == "Pending")
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: paying ? null : payBill,
                  child: paying
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                      : const Text(
                    "Pay Now",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget infoTile(String label, dynamic value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label,
                style:
                const TextStyle(color: Colors.grey, fontSize: 13)),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? "--",
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget amountTile(String label, dynamic value, {bool isTotal = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight:
                isTotal ? FontWeight.bold : FontWeight.w500,
              )),
          Text(
            "₹ ${value ?? 0}",
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: isTotal ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget statusChip(String status) {
    final isPaid = status == "Completed";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPaid ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPaid ? "Payment Completed" : "Payment Pending",
        style: TextStyle(
          color: isPaid ? Colors.green : Colors.orange,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6),
      ],
    );
  }

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return "--";
    return DateFormat("dd MMM yyyy, hh:mm a")
        .format(timestamp.toDate());
  }
}
