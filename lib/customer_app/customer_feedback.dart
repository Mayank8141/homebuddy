import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackPage extends StatefulWidget {
  final String billId;
  final String bookingId;
  final String customerId;
  final String employeeId;

  const FeedbackPage({
    super.key,
    required this.billId,
    required this.bookingId,
    required this.customerId,
    required this.employeeId,
  });

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int rating = 0;
  final TextEditingController feedbackCtrl = TextEditingController();
  bool submitting = false;

  // --------------------------------------------------
  Future<void> submitFeedback() async {
    if (rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select rating")),
      );
      return;
    }

    setState(() => submitting = true);

    try {
      await FirebaseFirestore.instance
          .collection("feedback_details")
          .add({
        "bill_id": widget.billId,
        "booking_id": widget.bookingId,
        "customer_id": widget.customerId,
        "employee_id": widget.employeeId,
        "rating": rating,
        "feedback": feedbackCtrl.text.trim(),
        "created_at": Timestamp.now(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thank you for your feedback ❤️")),
      );

      Navigator.pop(context); // back to home / notifications
    } catch (e) {
      debugPrint("❌ Feedback error: $e");
    } finally {
      if (mounted) setState(() => submitting = false);
    }
  }

  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("Rate & Review"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "How was your service?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // ⭐ STAR RATING
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  iconSize: 40,
                  onPressed: () {
                    setState(() => rating = index + 1);
                  },
                  icon: Icon(
                    Icons.star,
                    color: rating > index
                        ? Colors.amber
                        : Colors.grey.shade400,
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // ✍ FEEDBACK
            TextField(
              controller: feedbackCtrl,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Write your feedback (optional)",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🚀 SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: submitting ? null : submitFeedback,
                child: submitting
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )
                    : const Text(
                  "Submit Feedback",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
