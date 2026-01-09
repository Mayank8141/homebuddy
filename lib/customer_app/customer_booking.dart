import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

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

  Map<String, dynamic> employeeData = {};
  Map<String, dynamic> serviceData = {};

  @override
  void initState() {
    super.initState();
    fetchEmployeeAndService();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        // elevation: 0,
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //   statusBarColor: Colors.transparent,
        //   statusBarIconBrightness: Brightness.dark,
        //   statusBarBrightness: Brightness.light,
        // ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          // Gradient Header
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.teal.shade400,
                  Colors.teal.shade600,
                ],
              ),
            ),
          ),

          // Main Content
          Column(
            children: [
              const SizedBox(height: 100),

              // Header Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.teal.shade400, Colors.teal.shade600],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.event_note_rounded, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Book Your Service",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1F36),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Schedule a convenient time",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Scrollable Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service Info Card
                      _buildSectionCard(
                        icon: Icons.miscellaneous_services_rounded,
                        iconColor: Colors.blue,
                        title: "Service Details",
                        child: Column(
                          children: [
                            _buildInfoRow(
                              Icons.build_rounded,
                              "Service",
                              serviceData['name'] ?? 'Not available',
                              Colors.blue,
                            ),
                            const Divider(height: 20),
                            _buildInfoRow(
                              Icons.person_rounded,
                              "Provider",
                              employeeData['name'] ?? 'Not available',
                              Colors.purple,
                            ),
                            const Divider(height: 20),
                            _buildInfoRow(
                              Icons.currency_rupee_rounded,
                              "Visit Charge",
                              "₹${employeeData['visit_charge'] ?? '--'}",
                              Colors.green,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Problem Description
                      _buildSectionCard(
                        icon: Icons.description_rounded,
                        iconColor: Colors.orange,
                        title: "Describe Your Problem",
                        child: TextField(
                          controller: problemCtrl,
                          maxLines: 4,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF1A1F36),
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: "Explain what's wrong in detail...",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.teal, width: 2),
                            ),
                            contentPadding: const EdgeInsets.all(14),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Date & Time Selection
                      _buildSectionCard(
                        icon: Icons.calendar_month_rounded,
                        iconColor: Colors.red,
                        title: "Schedule Appointment",
                        child: Column(
                          children: [
                            // Date Picker
                            InkWell(
                              onTap: pickServiceDate,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selectedServiceDate != null
                                        ? Colors.teal
                                        : Colors.grey.shade200,
                                    width: selectedServiceDate != null ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.calendar_today_rounded, color: Colors.red, size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Service Date",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            selectedServiceDate == null
                                                ? "Select a date"
                                                : "${selectedServiceDate!.day} ${_getMonthName(selectedServiceDate!.month)}, ${selectedServiceDate!.year}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: selectedServiceDate != null
                                                  ? const Color(0xFF1A1F36)
                                                  : Colors.grey.shade400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                      color: Colors.grey.shade400,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Time Picker
                            InkWell(
                              onTap: pickServiceTime,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selectedServiceTime != null
                                        ? Colors.teal
                                        : Colors.grey.shade200,
                                    width: selectedServiceTime != null ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.access_time_rounded, color: Colors.orange, size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Service Time",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            selectedServiceTime == null
                                                ? "Select a time"
                                                : selectedServiceTime!.format(context),
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: selectedServiceTime != null
                                                  ? const Color(0xFF1A1F36)
                                                  : Colors.grey.shade400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                      color: Colors.grey.shade400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      // Bottom Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
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
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadowColor: Colors.teal.withOpacity(0.3),
              ),
              onPressed: isLoading ? null : saveBooking,
              child: isLoading
                  ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.check_circle_rounded, size: 22),
                  SizedBox(width: 8),
                  Text(
                    "Confirm Booking",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1F36),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1F36),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  Future<void> saveBooking() async {
    if (problemCtrl.text.trim().isEmpty) {
      showMsg("Please describe your problem", isError: true);
      return;
    }

    if (selectedServiceDate == null || selectedServiceTime == null) {
      showMsg("Please select date & time", isError: true);
      return;
    }

    try {
      setState(() => isLoading = true);

      String bookingId =
          FirebaseFirestore.instance.collection("booking_details").doc().id;

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

      String notificationId =
          FirebaseFirestore.instance.collection("notifications").doc().id;

      await FirebaseFirestore.instance
          .collection("notifications")
          .doc(notificationId)
          .set({
        "notification_id": notificationId,
        "receiver_id": widget.employeId,
        "receiver_type": "employee",
        "sender_id": widget.customerId,
        "sender_type": "customer",
        "booking_id": bookingId,
        "service_id": widget.serviceId,
        "title": "New Service Request",
        "message": "New booking request for ${serviceData['name'] ?? 'service'}",
        "is_read": false,
        "created_at": Timestamp.now(),
      });

      setState(() => isLoading = false);
      showMsg("Booking confirmed successfully!", isError: false);

      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) Navigator.pop(context);

    } catch (e) {
      setState(() => isLoading = false);
      showMsg("Booking failed: $e", isError: true);
    }
  }

  Future<void> pickServiceDate() async {
    DateTime now = DateTime.now();
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      initialDate: selectedServiceDate ?? now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1A1F36),
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) setState(() => selectedServiceDate = date);
  }

  Future<void> pickServiceTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedServiceTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1A1F36),
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) setState(() => selectedServiceTime = time);
  }

  void showMsg(String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline_rounded : Icons.check_circle_rounded,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade400 : Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: Duration(seconds: isError ? 3 : 2),
      ),
    );
  }
}