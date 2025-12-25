import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingPage extends StatefulWidget {
  final String customerId;
  final String employeId;
  final String serviceId;

  const BookingPage({
    super.key,
    required this.customerId,
    required this.employeId,
    required this.serviceId,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController problemCtrl = TextEditingController();

  DateTime? selectedServiceDate;
  TimeOfDay? selectedServiceTime;

  bool isLoading = false;

  // SAFE MAPS
  Map<String, dynamic> employeeData = {};
  Map<String, dynamic> serviceData = {};

  @override
  void initState() {
    super.initState();
    fetchEmployeeAndService();
  }

  // --------------------------------------------------
  // FETCH EMPLOYEE & SERVICE
  // --------------------------------------------------
  Future<void> fetchEmployeeAndService() async {
    try {
      final empDoc = await FirebaseFirestore.instance
          .collection("employe_detail")
          .doc(widget.employeId)
          .get();

      final serviceDoc = await FirebaseFirestore.instance
          .collection("services")
          .doc(widget.serviceId)
          .get();

      setState(() {
        employeeData = empDoc.data() ?? {};
        serviceData = serviceDoc.data() ?? {};
      });
    } catch (e) {
      setState(() {
        employeeData = {};
        serviceData = {};
      });
    }
  }

  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Book Service",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- SERVICE INFO ----------------
            const Text(
              "Service",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            infoBox(
              "Service: ${serviceData['name'] ?? 'Not available'}",
              "Employee: ${employeeData['name'] ?? 'Not available'}",
              "Visit Charge: ₹${employeeData['visit_charge'] ?? '--'}",
            ),

            const SizedBox(height: 20),

            // ---------------- PROBLEM ----------------
            const Text(
              "Describe your problem",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: problemCtrl,
              maxLines: 4,
              decoration: inputBox("Explain what's wrong..."),
            ),

            const SizedBox(height: 25),

            // ---------------- DATE ----------------
            const Text(
              "Select Service Date",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: pickServiceDate,
              child: dateTimeBox(
                selectedServiceDate == null
                    ? "Choose date"
                    : "${selectedServiceDate!.day}-${selectedServiceDate!.month}-${selectedServiceDate!.year}",
                Icons.calendar_month,
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- TIME ----------------
            const Text(
              "Select Service Time",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: pickServiceTime,
              child: dateTimeBox(
                selectedServiceTime == null
                    ? "Choose time"
                    : selectedServiceTime!.format(context),
                Icons.access_time,
              ),
            ),

            const SizedBox(height: 30),

            // ---------------- BUTTON ----------------
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
                onPressed: isLoading ? null : saveBooking,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Confirm Booking",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // SAVE BOOKING + COMMON NOTIFICATION
  // --------------------------------------------------
  Future<void> saveBooking() async {
    if (problemCtrl.text.trim().isEmpty) {
      showMsg("Please describe your problem");
      return;
    }

    if (selectedServiceDate == null || selectedServiceTime == null) {
      showMsg("Please select date & time");
      return;
    }

    try {
      setState(() => isLoading = true);

      // BOOKING ID
      String bookingId =
          FirebaseFirestore.instance.collection("booking_details").doc().id;

      // SAVE BOOKING
      await FirebaseFirestore.instance
          .collection("booking_details")
          .doc(bookingId)
          .set({
        "booking_id": bookingId,
        "customer_id": widget.customerId,
        "employe_id": widget.employeId,
        "service_id": widget.serviceId,
        "booking_date": Timestamp.now(),
        "service_date": Timestamp.fromDate(selectedServiceDate!),
        "service_time":
        "${selectedServiceTime!.hour}:${selectedServiceTime!.minute}",
        "problem_description": problemCtrl.text.trim(),
        "status": "Pending",
      });

      // 🔔 SAVE COMMON NOTIFICATION
      String notificationId =
          FirebaseFirestore.instance.collection("notifications").doc().id;

      await FirebaseFirestore.instance
          .collection("notifications")
          .doc(notificationId)
          .set({
        "notification_id": notificationId,

        // RECEIVER
        "receiver_id": widget.employeId,
        "receiver_type": "employee",

        // SENDER
        "sender_id": widget.customerId,
        "sender_type": "customer",

        "booking_id": bookingId,
        "service_id": widget.serviceId,

        "title": "New Service Request",
        "message":
        "New booking request for ${serviceData['name'] ?? 'service'}",

        "is_read": false,
        "created_at": Timestamp.now(),
      });

      setState(() => isLoading = false);
      showMsg("Booking Successful!");
      Navigator.pop(context);

    } catch (e) {
      setState(() => isLoading = false);
      showMsg("Booking failed: $e");
    }
  }

  // --------------------------------------------------
  // HELPERS
  // --------------------------------------------------
  Widget infoBox(String l1, String l2, String l3) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l1, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(l2),
          const SizedBox(height: 6),
          Text(l3),
        ],
      ),
    );
  }

  InputDecoration inputBox(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
  );

  Widget dateTimeBox(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          Icon(icon, color: Colors.teal),
        ],
      ),
    );
  }

  Future<void> pickServiceDate() async {
    DateTime now = DateTime.now();
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      initialDate: now,
    );
    if (date != null) setState(() => selectedServiceDate = date);
  }

  Future<void> pickServiceTime() async {
    TimeOfDay? time =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) setState(() => selectedServiceTime = time);
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
