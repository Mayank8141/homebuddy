// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';
// import 'customer_feedback.dart';
//
// import 'package:open_filex/open_filex.dart';
// import 'dart:io';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:path_provider/path_provider.dart';
//
//
//
// class BillPaymentPage extends StatefulWidget {
//   final String billId;
//   final String customerId;
//   final String employeeId;
//
//   const BillPaymentPage({
//     super.key,
//     required this.billId,
//     required this.customerId,
//     required this.employeeId,
//   });
//
//   @override
//   State<BillPaymentPage> createState() => _BillPaymentPageState();
// }
//
// class _BillPaymentPageState extends State<BillPaymentPage> {
//   bool loading = true;
//   bool paying = false;
//
//   Map<String, dynamic>? bill;
//   Map<String, dynamic>? booking;
//   Map<String, dynamic>? service;
//   Map<String, dynamic>? employee;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchAllData();
//   }
//
//   // --------------------------------------------------
//   Future<void> fetchAllData() async {
//     try {
//       // 🔹 BILL
//       final billSnap = await FirebaseFirestore.instance
//           .collection("bill_details")
//           .doc(widget.billId)
//           .get();
//
//       if (!billSnap.exists) return;
//
//       bill = billSnap.data();
//       final bookingId = bill!["booking_id"];
//       final serviceId = bill!["service_id"];
//
//       // 🔹 BOOKING
//       final bookingSnap = await FirebaseFirestore.instance
//           .collection("booking_details")
//           .doc(bookingId)
//           .get();
//
//       booking = bookingSnap.data();
//
//       // 🔹 SERVICE
//       final serviceSnap = await FirebaseFirestore.instance
//           .collection("services")
//           .doc(serviceId)
//           .get();
//
//       service = serviceSnap.data();
//
//       // 🔹 EMPLOYEE
//       final empSnap = await FirebaseFirestore.instance
//           .collection("employe_detail")
//           .doc(widget.employeeId)
//           .get();
//
//       employee = empSnap.data();
//
//       setState(() => loading = false);
//     } catch (e) {
//       debugPrint("❌ Bill fetch error: $e");
//     }
//   }
//
//   // --------------------------------------------------
//   // Future<void> payBill() async {
//   //   setState(() => paying = true);
//   //
//   //   try {
//   //     // ✅ UPDATE BILL STATUS
//   //     await FirebaseFirestore.instance
//   //         .collection("bill_details")
//   //         .doc(widget.billId)
//   //         .update({
//   //       "payment_status": "Completed",
//   //       "paid_at": Timestamp.now(),
//   //     });
//   //
//   //     // 🔔 NOTIFY EMPLOYEE
//   //     await FirebaseFirestore.instance.collection("notifications").add({
//   //       "receiver_id": widget.employeeId,
//   //       "receiver_type": "employee",
//   //       "sender_id": widget.customerId,
//   //       "sender_type": "customer",
//   //       "title": "Payment Received",
//   //       "message":
//   //       "₹${bill!["total_amount"]} payment received for ${service?["name"] ?? "service"}",
//   //       "bill_id": widget.billId,
//   //       "is_read": false,
//   //       "created_at": Timestamp.now(),
//   //     });
//   //
//   //     if (!mounted) return;
//   //
//   //     // ✅ SUCCESS MESSAGE
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(
//   //         content: Text("Payment Successful"),
//   //         backgroundColor: Colors.green,
//   //       ),
//   //     );
//   //
//   //     // ✅ AUTO GO BACK AFTER PAYMENT
//   //     Future.delayed(const Duration(milliseconds: 500), () {
//   //       if (mounted) {
//   //         Navigator.pop(context); // go back to notifications
//   //       }
//   //     });
//   //   } catch (e) {
//   //     debugPrint("❌ Payment failed: $e");
//   //   } finally {
//   //     if (mounted) setState(() => paying = false);
//   //   }
//   // }
//
//   Future<void> payBill() async {
//     setState(() => paying = true);
//
//     try {
//       // ✅ UPDATE BILL STATUS
//       await FirebaseFirestore.instance
//           .collection("bill_details")
//           .doc(widget.billId)
//           .update({
//         "payment_status": "Completed",
//         "paid_at": Timestamp.now(),
//       });
//
//       // 🔔 NOTIFY EMPLOYEE
//       await FirebaseFirestore.instance.collection("notifications").add({
//         "receiver_id": widget.employeeId,
//         "receiver_type": "employee",
//         "sender_id": widget.customerId,
//         "sender_type": "customer",
//         "title": "Payment Received",
//         "message":
//         "₹${bill!["total_amount"]} payment received for ${service?["name"] ?? "service"}",
//         "bill_id": widget.billId,
//         "is_read": false,
//         "created_at": Timestamp.now(),
//       });
//
//       if (!mounted) return;
//
//       // ✅ GO TO FEEDBACK PAGE
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => FeedbackPage(
//             billId: widget.billId,
//             bookingId: bill!["booking_id"],
//             employeeId: widget.employeeId,
//             customerId: widget.customerId,
//           ),
//         ),
//       );
//     } catch (e) {
//       debugPrint("❌ Payment failed: $e");
//     } finally {
//       if (mounted) setState(() => paying = false);
//     }
//   }
//
//
//   // --------------------------------------------------
//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),
//
//         // 🔥 STATUS BAR FIX
//         systemOverlayStyle: const SystemUiOverlayStyle(
//           statusBarColor: Colors.white,            // status bar background
//           statusBarIconBrightness: Brightness.dark, // ANDROID icons
//           statusBarBrightness: Brightness.light,   // IOS text/icons
//         ),
//
//         title: const Text(
//           "Bill Details",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             sectionTitle("Service Details"),
//             infoTile("Service", service?["name"]),
//             infoTile("Provider", employee?["name"]),
//             infoTile(
//               "Service Date",
//               formatDate(booking?["service_date"]),
//             ),
//             if ((booking?["problem_description"] ?? "").toString().isNotEmpty)
//               infoTile(
//                 "Problem",
//                 booking?["problem_description"],
//               ),
//
//             const SizedBox(height: 20),
//
//             sectionTitle("Bill Summary"),
//             amountTile("Service Amount", bill?["service_amount"]),
//             amountTile("Visit Charge", bill?["visit_charge"]),
//             const Divider(height: 30),
//             amountTile(
//               "Total Amount",
//               bill?["total_amount"],
//               isTotal: true,
//             ),
//
//             const SizedBox(height: 10),
//             statusChip(bill?["payment_status"]),
//
//             const SizedBox(height: 20),
//
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton.icon(
//                 icon: const Icon(Icons.picture_as_pdf),
//                 label: const Text(
//                   "Download / Print Bill",
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                 ),
//                 onPressed: downloadBillPdf,
//               ),
//             ),
//
//
//             const SizedBox(height: 30),
//
//             if (bill?["payment_status"] == "Pending")
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                   ),
//                   onPressed: paying ? null : payBill,
//                   child: paying
//                       ? const CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 2,
//                   )
//                       : const Text(
//                     "Pay Now",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> downloadBillPdf() async {
//     try {
//       final pdf = pw.Document();
//
//       pdf.addPage(
//         pw.Page(
//           pageFormat: PdfPageFormat.a4,
//           margin: const pw.EdgeInsets.all(24),
//           build: (context) {
//             return pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 // HEADER
//                 pw.Text(
//                   "SERVICE BILL",
//                   style: pw.TextStyle(
//                     fontSize: 24,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//
//                 pw.SizedBox(height: 20),
//
//                 pw.Text("Bill ID: ${widget.billId}"),
//                 pw.Text("Service: ${service?["name"] ?? "--"}"),
//                 pw.Text("Provider: ${employee?["name"] ?? "--"}"),
//                 pw.Text(
//                   "Service Date: ${formatDate(booking?["service_date"])}",
//                 ),
//
//                 pw.SizedBox(height: 20),
//                 pw.Divider(),
//
//                 // BILL TABLE
//                 pw.Table.fromTextArray(
//                   headers: const ["Description", "Amount"],
//                   data: [
//                     [
//                       "Service Amount",
//                       "₹ ${bill?["service_amount"] ?? 0}"
//                     ],
//                     [
//                       "Visit Charge",
//                       "₹ ${bill?["visit_charge"] ?? 0}"
//                     ],
//                   ],
//                 ),
//
//                 pw.SizedBox(height: 20),
//
//                 pw.Align(
//                   alignment: pw.Alignment.centerRight,
//                   child: pw.Text(
//                     "Total: ₹ ${bill?["total_amount"] ?? 0}",
//                     style: pw.TextStyle(
//                       fontSize: 18,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                 ),
//
//                 pw.SizedBox(height: 20),
//
//                 pw.Text(
//                   "Payment Status: ${bill?["payment_status"]}",
//                   style: pw.TextStyle(
//                     color: bill?["payment_status"] == "Completed"
//                         ? PdfColors.green
//                         : PdfColors.orange,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//
//                 pw.Spacer(),
//
//                 pw.Center(
//                   child: pw.Text(
//                     "Thank you for choosing our service!",
//                     style: pw.TextStyle(fontSize: 12),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       );
//
//       // ✅ SAVE FILE (ANDROID SAFE LOCATION)
//       final directory = await getApplicationDocumentsDirectory();
//       final file =
//       File("${directory.path}/Bill_${widget.billId}.pdf");
//
//       await file.writeAsBytes(await pdf.save());
//
//       // ✅ OPEN PDF
//       await OpenFilex.open(file.path);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Failed to generate bill PDF"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//
//
//   // --------------------------------------------------
//   Widget sectionTitle(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: Colors.black,
//           fontSize: 17,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
//
//   Widget infoTile(String label, dynamic value) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(14),
//       decoration: cardDecoration(),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Text(label,
//                 style:
//                 const TextStyle(color: Colors.grey, fontSize: 13)),
//           ),
//           Expanded(
//             child: Text(
//               value?.toString() ?? "--",
//               textAlign: TextAlign.right,
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget amountTile(String label, dynamic value, {bool isTotal = false}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(14),
//       decoration: cardDecoration(),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label,
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: isTotal ? 16 : 14,
//                 fontWeight:
//                 isTotal ? FontWeight.bold : FontWeight.w500,
//               )),
//           Text(
//             "₹ ${value ?? 0}",
//             style: TextStyle(
//               fontSize: isTotal ? 18 : 14,
//               fontWeight: FontWeight.bold,
//               color: isTotal ? Colors.green : Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget statusChip(String status) {
//     final isPaid = status == "Completed";
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: isPaid ? Colors.green.shade100 : Colors.orange.shade100,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         isPaid ? "Payment Completed" : "Payment Pending",
//         style: TextStyle(
//           color: isPaid ? Colors.green : Colors.orange,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
//
//   BoxDecoration cardDecoration() {
//     return BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(14),
//       boxShadow: const [
//         BoxShadow(color: Colors.black12, blurRadius: 6),
//       ],
//     );
//   }
//
//   String formatDate(Timestamp? timestamp) {
//     if (timestamp == null) return "--";
//     return DateFormat("dd MMM yyyy, hh:mm a")
//         .format(timestamp.toDate());
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';
// import 'customer_feedback.dart';
// import 'package:open_filex/open_filex.dart';
// import 'dart:io';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:path_provider/path_provider.dart';
//
// class BillPaymentPage extends StatefulWidget {
//   final String billId;
//   final String customerId;
//   final String employeeId;
//
//   const BillPaymentPage({
//     super.key,
//     required this.billId,
//     required this.customerId,
//     required this.employeeId,
//   });
//
//   @override
//   State<BillPaymentPage> createState() => _BillPaymentPageState();
// }
//
// class _BillPaymentPageState extends State<BillPaymentPage> with SingleTickerProviderStateMixin {
//   bool loading = true;
//   bool paying = false;
//
//   Map<String, dynamic>? bill;
//   Map<String, dynamic>? booking;
//   Map<String, dynamic>? service;
//   Map<String, dynamic>? employee;
//
//   late AnimationController _animationController;
//   Animation<double> _fadeAnimation = const AlwaysStoppedAnimation(1.0);
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//     _fadeAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     );
//     fetchAllData();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   Future<void> fetchAllData() async {
//     try {
//       final billSnap = await FirebaseFirestore.instance
//           .collection("bill_details")
//           .doc(widget.billId)
//           .get();
//
//       if (!billSnap.exists) return;
//
//       bill = billSnap.data();
//       final bookingId = bill!["booking_id"];
//       final serviceId = bill!["service_id"];
//
//       final bookingSnap = await FirebaseFirestore.instance
//           .collection("booking_details")
//           .doc(bookingId)
//           .get();
//
//       booking = bookingSnap.data();
//
//       final serviceSnap = await FirebaseFirestore.instance
//           .collection("services")
//           .doc(serviceId)
//           .get();
//
//       service = serviceSnap.data();
//
//       final empSnap = await FirebaseFirestore.instance
//           .collection("employe_detail")
//           .doc(widget.employeeId)
//           .get();
//
//       employee = empSnap.data();
//
//       setState(() => loading = false);
//       _animationController.forward();
//     } catch (e) {
//       debugPrint("❌ Bill fetch error: $e");
//     }
//   }
//
//   Future<void> payBill() async {
//     setState(() => paying = true);
//
//     try {
//       await FirebaseFirestore.instance
//           .collection("bill_details")
//           .doc(widget.billId)
//           .update({
//         "payment_status": "Completed",
//         "paid_at": Timestamp.now(),
//       });
//
//       await FirebaseFirestore.instance.collection("notifications").add({
//         "receiver_id": widget.employeeId,
//         "receiver_type": "employee",
//         "sender_id": widget.customerId,
//         "sender_type": "customer",
//         "title": "Payment Received",
//         "message":
//         "₹${bill!["total_amount"]} payment received for ${service?["name"] ?? "service"}",
//         "bill_id": widget.billId,
//         "is_read": false,
//         "created_at": Timestamp.now(),
//       });
//
//       if (!mounted) return;
//
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => FeedbackPage(
//             billId: widget.billId,
//             bookingId: bill!["booking_id"],
//             employeeId: widget.employeeId,
//             customerId: widget.customerId,
//           ),
//         ),
//       );
//     } catch (e) {
//       debugPrint("❌ Payment failed: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: const [
//                 Icon(Icons.error_outline_rounded, color: Colors.white),
//                 SizedBox(width: 12),
//                 Text("Payment failed. Please try again."),
//               ],
//             ),
//             backgroundColor: Colors.red.shade400,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           ),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => paying = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return Scaffold(
//         backgroundColor: const Color(0xFFF8FAFC),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 width: 50,
//                 height: 50,
//                 child: CircularProgressIndicator(
//                   color: Colors.teal,
//                   strokeWidth: 3,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "Loading bill details...",
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: Colors.grey.shade600,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     final isPaid = bill?["payment_status"] == "Completed";
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       extendBodyBehindAppBar: true,
//
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         systemOverlayStyle: const SystemUiOverlayStyle(
//           statusBarColor: Colors.transparent,
//           statusBarIconBrightness: Brightness.light,
//           statusBarBrightness: Brightness.dark,
//         ),
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.95),
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.15),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(50),
//                 onTap: () => Navigator.pop(context),
//                 child: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1F36), size: 18),
//               ),
//             ),
//           ),
//         ),
//       ),
//
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Stack(
//           children: [
//             // Gradient Header
//             Container(
//               height: 280,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: isPaid
//                       ? [const Color(0xFF00897B), const Color(0xFF00695C)]
//                       : [const Color(0xFFFF6F00), const Color(0xFFE65100)],
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   Positioned(
//                     top: -50,
//                     right: -50,
//                     child: Container(
//                       width: 200,
//                       height: 200,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white.withOpacity(0.05),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Main Content
//             SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 100),
//
//                   // Receipt Header Card
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24),
//                     child: Container(
//                       padding: const EdgeInsets.all(28),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(24),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.08),
//                             blurRadius: 30,
//                             offset: const Offset(0, 15),
//                             spreadRadius: -5,
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           // Icon
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: isPaid
//                                     ? [Colors.green.shade400, Colors.green.shade600]
//                                     : [Colors.orange.shade400, Colors.orange.shade600],
//                               ),
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: (isPaid ? Colors.green : Colors.orange).withOpacity(0.3),
//                                   blurRadius: 20,
//                                   offset: const Offset(0, 8),
//                                 ),
//                               ],
//                             ),
//                             child: Icon(
//                               isPaid ? Icons.check_circle_rounded : Icons.receipt_long_rounded,
//                               color: Colors.white,
//                               size: 48,
//                             ),
//                           ),
//
//                           const SizedBox(height: 20),
//
//                           Text(
//                             isPaid ? "Payment Completed" : "Payment Pending",
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.w800,
//                               color: isPaid ? Colors.green : Colors.orange,
//                               letterSpacing: -0.5,
//                             ),
//                           ),
//
//                           const SizedBox(height: 8),
//
//                           Text(
//                             "Bill ID: ${widget.billId.substring(0, 8).toUpperCase()}",
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.grey.shade600,
//                               fontWeight: FontWeight.w600,
//                               letterSpacing: 1,
//                             ),
//                           ),
//
//                           const SizedBox(height: 24),
//
//                           // Total Amount
//                           Container(
//                             padding: const EdgeInsets.all(20),
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade50,
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(color: Colors.grey.shade200),
//                             ),
//                             child: Column(
//                               children: [
//                                 Text(
//                                   "Total Amount",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.grey.shade600,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   "₹${bill?["total_amount"] ?? 0}",
//                                   style: const TextStyle(
//                                     fontSize: 42,
//                                     fontWeight: FontWeight.w900,
//                                     color: Color(0xFF1A1F36),
//                                     letterSpacing: -1.5,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 24),
//
//                   // Service Details
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24),
//                     child: _BillSectionCard(
//                       icon: Icons.miscellaneous_services_rounded,
//                       iconColor: Colors.blue,
//                       title: "Service Details",
//                       child: Column(
//                         children: [
//                           _BillInfoRow(
//                             Icons.build_rounded,
//                             "Service Name",
//                             service?["name"] ?? "--",
//                           ),
//                           const SizedBox(height: 12),
//                           _BillInfoRow(
//                             Icons.person_rounded,
//                             "Service Provider",
//                             employee?["name"] ?? "--",
//                           ),
//                           const SizedBox(height: 12),
//                           _BillInfoRow(
//                             Icons.calendar_today_rounded,
//                             "Service Date",
//                             formatDate(booking?["service_date"]),
//                           ),
//                           if ((booking?["problem_description"] ?? "").toString().isNotEmpty) ...[
//                             const SizedBox(height: 16),
//                             Container(
//                               padding: const EdgeInsets.all(14),
//                               decoration: BoxDecoration(
//                                 color: Colors.blue.shade50,
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(color: Colors.blue.shade100),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Icon(Icons.description_rounded, color: Colors.blue.shade700, size: 18),
//                                       const SizedBox(width: 8),
//                                       Text(
//                                         "Problem Description",
//                                         style: TextStyle(
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w700,
//                                           color: Colors.blue.shade900,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     booking?["problem_description"] ?? "",
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey.shade700,
//                                       fontWeight: FontWeight.w500,
//                                       height: 1.4,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Bill Breakdown
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24),
//                     child: _BillSectionCard(
//                       icon: Icons.receipt_rounded,
//                       iconColor: Colors.purple,
//                       title: "Bill Breakdown",
//                       child: Column(
//                         children: [
//                           _BillAmountRow(
//                             "Service Charge",
//                             bill?["service_amount"],
//                             Icons.handyman_rounded,
//                           ),
//                           const SizedBox(height: 12),
//                           _BillAmountRow(
//                             "Visit Charge",
//                             bill?["visit_charge"],
//                             Icons.directions_car_rounded,
//                           ),
//                           const SizedBox(height: 16),
//                           Container(
//                             height: 1,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Colors.grey.shade200,
//                                   Colors.grey.shade400,
//                                   Colors.grey.shade200,
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [Colors.green.shade50, Colors.teal.shade50],
//                               ),
//                               borderRadius: BorderRadius.circular(14),
//                               border: Border.all(color: Colors.green.shade200),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.all(8),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(10),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.green.withOpacity(0.2),
//                                             blurRadius: 8,
//                                             offset: const Offset(0, 2),
//                                           ),
//                                         ],
//                                       ),
//                                       child: Icon(Icons.payments_rounded, color: Colors.green.shade700, size: 20),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     const Text(
//                                       "Total Payable",
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w700,
//                                         color: Color(0xFF1A1F36),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Text(
//                                   "₹${bill?["total_amount"] ?? 0}",
//                                   style: TextStyle(
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.w900,
//                                     color: Colors.green.shade700,
//                                     letterSpacing: -0.5,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 120),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//
//       // Bottom Actions
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 20,
//               offset: const Offset(0, -5),
//             ),
//           ],
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Download/Print Button
//                 SizedBox(
//                   height: 52,
//                   width: double.infinity,
//                   child: OutlinedButton.icon(
//                     icon: const Icon(Icons.download_rounded, size: 20),
//                     label: const Text(
//                       "Download / Print Bill",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: Colors.blue,
//                       side: const BorderSide(color: Colors.blue, width: 2),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                     ),
//                     onPressed: downloadBillPdf,
//                   ),
//                 ),
//
//                 if (!isPaid) ...[
//                   const SizedBox(height: 12),
//                   // Pay Now Button
//                   SizedBox(
//                     height: 56,
//                     width: double.infinity,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFF00C853), Color(0xFF00E676)],
//                         ),
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.green.withOpacity(0.4),
//                             blurRadius: 15,
//                             offset: const Offset(0, 8),
//                           ),
//                         ],
//                       ),
//                       child: Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(16),
//                           onTap: paying ? null : payBill,
//                           child: Center(
//                             child: paying
//                                 ? const SizedBox(
//                               width: 24,
//                               height: 24,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2.5,
//                               ),
//                             )
//                                 : Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: const [
//                                 Icon(Icons.payments_rounded, color: Colors.white, size: 22),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   "Pay Now",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.white,
//                                     letterSpacing: 0.3,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> downloadBillPdf() async {
//     try {
//       final pdf = pw.Document();
//
//       pdf.addPage(
//         pw.Page(
//           pageFormat: PdfPageFormat.a4,
//           margin: const pw.EdgeInsets.all(24),
//           build: (context) {
//             return pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Text(
//                   "SERVICE BILL",
//                   style: pw.TextStyle(
//                     fontSize: 24,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//                 pw.SizedBox(height: 20),
//                 pw.Text("Bill ID: ${widget.billId}"),
//                 pw.Text("Service: ${service?["name"] ?? "--"}"),
//                 pw.Text("Provider: ${employee?["name"] ?? "--"}"),
//                 pw.Text("Service Date: ${formatDate(booking?["service_date"])}"),
//                 pw.SizedBox(height: 20),
//                 pw.Divider(),
//                 pw.Table.fromTextArray(
//                   headers: const ["Description", "Amount"],
//                   data: [
//                     ["Service Amount", "₹ ${bill?["service_amount"] ?? 0}"],
//                     ["Visit Charge", "₹ ${bill?["visit_charge"] ?? 0}"],
//                   ],
//                 ),
//                 pw.SizedBox(height: 20),
//                 pw.Align(
//                   alignment: pw.Alignment.centerRight,
//                   child: pw.Text(
//                     "Total: ₹ ${bill?["total_amount"] ?? 0}",
//                     style: pw.TextStyle(
//                       fontSize: 18,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 pw.SizedBox(height: 20),
//                 pw.Text(
//                   "Payment Status: ${bill?["payment_status"]}",
//                   style: pw.TextStyle(
//                     color: bill?["payment_status"] == "Completed"
//                         ? PdfColors.green
//                         : PdfColors.orange,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//                 pw.Spacer(),
//                 pw.Center(
//                   child: pw.Text(
//                     "Thank you for choosing our service!",
//                     style: pw.TextStyle(fontSize: 12),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       );
//
//       final directory = await getApplicationDocumentsDirectory();
//       final file = File("${directory.path}/Bill_${widget.billId}.pdf");
//       await file.writeAsBytes(await pdf.save());
//       await OpenFilex.open(file.path);
//
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: const [
//                 Icon(Icons.check_circle_rounded, color: Colors.white),
//                 SizedBox(width: 12),
//                 Text("Bill downloaded successfully!"),
//               ],
//             ),
//             backgroundColor: Colors.green.shade400,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           ),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: const [
//               Icon(Icons.error_outline_rounded, color: Colors.white),
//               SizedBox(width: 12),
//               Text("Failed to generate PDF"),
//             ],
//           ),
//           backgroundColor: Colors.red.shade400,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//     }
//   }
//
//   String formatDate(Timestamp? timestamp) {
//     if (timestamp == null) return "--";
//     return DateFormat("dd MMM yyyy, hh:mm a").format(timestamp.toDate());
//   }
// }
//
// class _BillSectionCard extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor;
//   final String title;
//   final Widget child;
//
//   const _BillSectionCard({
//     required this.icon,
//     required this.iconColor,
//     required this.title,
//     required this.child,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(22),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//             spreadRadius: -5,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [iconColor.withOpacity(0.1), iconColor.withOpacity(0.2)],
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, color: iconColor, size: 22),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: Color(0xFF1A1F36),
//                   letterSpacing: -0.3,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 18),
//           child,
//         ],
//       ),
//     );
//   }
// }
//
// class _BillInfoRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//
//   const _BillInfoRow(this.icon, this.label, this.value);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, size: 18, color: Colors.grey.shade600),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             label,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade600,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         Flexible(
//           child: Text(
//             value,
//             textAlign: TextAlign.right,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF1A1F36),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _BillAmountRow extends StatelessWidget {
//   final String label;
//   final dynamic amount;
//   final IconData icon;
//
//   const _BillAmountRow(this.label, this.amount, this.icon);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Icon(icon, size: 18, color: Colors.grey.shade600),
//             const SizedBox(width: 10),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 15,
//                 color: Colors.grey.shade700,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//         Text(
//           "₹${amount ?? 0}",
//           style: const TextStyle(
//             fontSize: 17,
//             fontWeight: FontWeight.w800,
//             color: Color(0xFF1A1F36),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';
// import 'customer_feedback.dart';
//
// import 'package:open_filex/open_filex.dart';
// import 'dart:io';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:path_provider/path_provider.dart';
//
// class BillPaymentPage extends StatefulWidget {
//   final String billId;
//   final String customerId;
//   final String employeeId;
//
//   const BillPaymentPage({
//     super.key,
//     required this.billId,
//     required this.customerId,
//     required this.employeeId,
//   });
//
//   @override
//   State<BillPaymentPage> createState() => _BillPaymentPageState();
// }
//
// class _BillPaymentPageState extends State<BillPaymentPage> with SingleTickerProviderStateMixin {
//   bool loading = true;
//   bool paying = false;
//   bool downloading = false;
//
//   Map<String, dynamic>? bill;
//   Map<String, dynamic>? booking;
//   Map<String, dynamic>? service;
//   Map<String, dynamic>? employee;
//
//   late AnimationController _animController;
//   late Animation<double> _fadeAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//     _fadeAnimation = CurvedAnimation(
//       parent: _animController,
//       curve: Curves.easeInOut,
//     );
//     fetchAllData();
//   }
//
//   @override
//   void dispose() {
//     _animController.dispose();
//     super.dispose();
//   }
//
//   Future<void> fetchAllData() async {
//     try {
//       final billSnap = await FirebaseFirestore.instance
//           .collection("bill_details")
//           .doc(widget.billId)
//           .get();
//
//       if (!billSnap.exists) return;
//
//       bill = billSnap.data();
//       final bookingId = bill!["booking_id"];
//       final serviceId = bill!["service_id"];
//
//       final bookingSnap = await FirebaseFirestore.instance
//           .collection("booking_details")
//           .doc(bookingId)
//           .get();
//
//       booking = bookingSnap.data();
//
//       final serviceSnap = await FirebaseFirestore.instance
//           .collection("services")
//           .doc(serviceId)
//           .get();
//
//       service = serviceSnap.data();
//
//       final empSnap = await FirebaseFirestore.instance
//           .collection("employe_detail")
//           .doc(widget.employeeId)
//           .get();
//
//       employee = empSnap.data();
//
//       setState(() => loading = false);
//       _animController.forward();
//     } catch (e) {
//       debugPrint("❌ Bill fetch error: $e");
//     }
//   }
//
//   Future<void> payBill() async {
//     HapticFeedback.mediumImpact();
//     setState(() => paying = true);
//
//     try {
//       await FirebaseFirestore.instance
//           .collection("bill_details")
//           .doc(widget.billId)
//           .update({
//         "payment_status": "Completed",
//         "paid_at": Timestamp.now(),
//       });
//
//       await FirebaseFirestore.instance.collection("notifications").add({
//         "receiver_id": widget.employeeId,
//         "receiver_type": "employee",
//         "sender_id": widget.customerId,
//         "sender_type": "customer",
//         "title": "Payment Received",
//         "message":
//         "₹${bill!["total_amount"]} payment received for ${service?["name"] ?? "service"}",
//         "bill_id": widget.billId,
//         "is_read": false,
//         "created_at": Timestamp.now(),
//       });
//
//       if (!mounted) return;
//
//       HapticFeedback.heavyImpact();
//
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => FeedbackPage(
//             billId: widget.billId,
//             bookingId: bill!["booking_id"],
//             employeeId: widget.employeeId,
//             customerId: widget.customerId,
//           ),
//         ),
//       );
//     } catch (e) {
//       debugPrint("❌ Payment failed: $e");
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Row(
//             children: [
//               Icon(Icons.error_outline, color: Colors.white),
//               SizedBox(width: 12),
//               Text("Payment failed. Please try again."),
//             ],
//           ),
//           backgroundColor: Colors.red.shade600,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//     } finally {
//       if (mounted) setState(() => paying = false);
//     }
//   }
//
//   Future<void> downloadBillPdf() async {
//     HapticFeedback.lightImpact();
//     setState(() => downloading = true);
//
//     try {
//       final pdf = pw.Document();
//
//       pdf.addPage(
//         pw.Page(
//           pageFormat: PdfPageFormat.a4,
//           margin: const pw.EdgeInsets.all(32),
//           build: (context) {
//             return pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//
//                 /// HEADER
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children: [
//                     pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Text(
//                           "HomeBuddy",
//                           style: pw.TextStyle(
//                             fontSize: 26,
//                             fontWeight: pw.FontWeight.bold,
//                             color: PdfColors.green800,
//                           ),
//                         ),
//                         pw.SizedBox(height: 4),
//                         pw.Text(
//                           "Home Services Invoice",
//                           style: pw.TextStyle(
//                             fontSize: 12,
//                             color: PdfColors.grey700,
//                           ),
//                         ),
//                       ],
//                     ),
//                     pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.end,
//                       children: [
//                         pw.Text("Invoice #${widget.billId}"),
//                         pw.Text(
//                           "Date: ${formatDate(bill?["paid_at"] ?? bill?["created_at"])}",
//                           style: pw.TextStyle(fontSize: 10),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//
//                 pw.SizedBox(height: 20),
//                 pw.Divider(),
//
//                 /// CUSTOMER & PROVIDER
//                 pw.SizedBox(height: 16),
//                 pw.Row(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Expanded(
//                       child: pw.Column(
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.Text(
//                             "Customer Details",
//                             style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           ),
//                           pw.SizedBox(height: 6),
//                           pw.Text("Customer ID: ${widget.customerId}"),
//                           pw.Text(
//                             "Service Date: ${formatDate(booking?["service_date"])}",
//                           ),
//                         ],
//                       ),
//                     ),
//                     pw.Expanded(
//                       child: pw.Column(
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.Text(
//                             "Service Provider",
//                             style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           ),
//                           pw.SizedBox(height: 6),
//                           pw.Text("Name: ${employee?["name"] ?? "--"}"),
//                           pw.Text("Service: ${service?["name"] ?? "--"}"),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 pw.SizedBox(height: 20),
//
//                 /// BILL TABLE
//                 pw.Text(
//                   "Billing Summary",
//                   style: pw.TextStyle(
//                     fontSize: 14,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//                 pw.SizedBox(height: 10),
//
//                 pw.Table(
//                   border: pw.TableBorder.all(color: PdfColors.grey300),
//                   columnWidths: {
//                     0: const pw.FlexColumnWidth(3),
//                     1: const pw.FlexColumnWidth(1),
//                   },
//                   children: [
//                     _tableRow("Description", "Amount", isHeader: true),
//                     _tableRow(
//                       "Service Charge",
//                       "₹ ${bill?["service_amount"] ?? 0}",
//                     ),
//                     _tableRow(
//                       "Visit Charge",
//                       "₹ ${bill?["visit_charge"] ?? 0}",
//                     ),
//                   ],
//                 ),
//
//                 pw.SizedBox(height: 16),
//
//                 /// TOTAL
//                 pw.Align(
//                   alignment: pw.Alignment.centerRight,
//                   child: pw.Container(
//                     padding: const pw.EdgeInsets.all(12),
//                     decoration: pw.BoxDecoration(
//                       color: PdfColors.green50,
//                       borderRadius: pw.BorderRadius.circular(6),
//                     ),
//                     child: pw.Text(
//                       "Total Amount: ₹ ${bill?["total_amount"] ?? 0}",
//                       style: pw.TextStyle(
//                         fontSize: 16,
//                         fontWeight: pw.FontWeight.bold,
//                         color: PdfColors.green800,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 pw.SizedBox(height: 16),
//
//                 /// PAYMENT STATUS
//                 pw.Text(
//                   "Payment Status: ${bill?["payment_status"]}",
//                   style: pw.TextStyle(
//                     fontSize: 12,
//                     fontWeight: pw.FontWeight.bold,
//                     color: bill?["payment_status"] == "Completed"
//                         ? PdfColors.green
//                         : PdfColors.orange,
//                   ),
//                 ),
//
//                 pw.Spacer(),
//
//                 /// FOOTER
//                 pw.Divider(),
//                 pw.SizedBox(height: 8),
//                 pw.Center(
//                   child: pw.Text(
//                     "Thank you for choosing HomeBuddy – Reliable Home Services",
//                     style: pw.TextStyle(
//                       fontSize: 10,
//                       color: PdfColors.grey600,
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       );
//
//       final directory = await getApplicationDocumentsDirectory();
//       final file = File("${directory.path}/HomeBuddy_Invoice_${widget.billId}.pdf");
//       await file.writeAsBytes(await pdf.save());
//       await OpenFilex.open(file.path);
//
//       if (!mounted) return;
//       HapticFeedback.mediumImpact();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text("Invoice downloaded successfully"),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Failed to generate invoice"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       if (mounted) setState(() => downloading = false);
//     }
//   }
//
//   /// TABLE ROW HELPER
//   pw.TableRow _tableRow(String left, String right, {bool isHeader = false}) {
//     return pw.TableRow(
//       decoration: isHeader
//           ? const pw.BoxDecoration(color: PdfColors.grey200)
//           : null,
//       children: [
//         pw.Padding(
//           padding: const pw.EdgeInsets.all(8),
//           child: pw.Text(
//             left,
//             style: pw.TextStyle(
//               fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
//             ),
//           ),
//         ),
//         pw.Padding(
//           padding: const pw.EdgeInsets.all(8),
//           child: pw.Text(
//             right,
//             textAlign: pw.TextAlign.right,
//             style: pw.TextStyle(
//               fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return Scaffold(
//         backgroundColor: const Color(0xFFF8F9FD),
//         body: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const CircularProgressIndicator(strokeWidth: 3),
//               const SizedBox(height: 16),
//               Text(
//                 "Loading bill details...",
//                 style: TextStyle(
//                   color: Colors.grey.shade600,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     final isPending = bill?["payment_status"] == "Pending";
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FD),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Color(0xFF1A1D1E)),
//         systemOverlayStyle: const SystemUiOverlayStyle(
//           statusBarColor: Colors.white,
//           statusBarIconBrightness: Brightness.dark,
//           statusBarBrightness: Brightness.light,
//         ),
//         title: const Text(
//           "Bill Details",
//           style: TextStyle(
//             color: Color(0xFF1A1D1E),
//             fontWeight: FontWeight.w600,
//             fontSize: 18,
//           ),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Container(
//             height: 1,
//             color: Colors.grey.shade200,
//           ),
//         ),
//       ),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               // Status Banner
//               _buildStatusBanner(isPending),
//
//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Service Details Card
//                     _buildServiceCard(),
//
//                     const SizedBox(height: 16),
//
//                     // Bill Summary Card
//                     _buildBillSummaryCard(),
//
//                     const SizedBox(height: 20),
//
//                     // Download Button
//                     _buildDownloadButton(),
//
//                     const SizedBox(height: 16),
//
//                     // Payment Button
//                     if (isPending) _buildPaymentButton(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatusBanner(bool isPending) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: isPending
//               ? [const Color(0xFFFFA726), const Color(0xFFFF9800)]
//               : [const Color(0xFF66BB6A), const Color(0xFF4CAF50)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Column(
//         children: [
//           Icon(
//             isPending ? Icons.pending_outlined : Icons.check_circle_outline,
//             color: Colors.white,
//             size: 48,
//           ),
//           const SizedBox(height: 12),
//           Text(
//             isPending ? "Payment Pending" : "Payment Completed",
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           if (isPending) ...[
//             const SizedBox(height: 6),
//             Text(
//               "Please complete the payment to proceed",
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.9),
//                 fontSize: 13,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildServiceCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
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
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF2196F3).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(
//                     Icons.design_services_outlined,
//                     color: Color(0xFF2196F3),
//                     size: 24,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 const Text(
//                   "Service Details",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1A1D1E),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(height: 1),
//           _buildDetailRow(Icons.work_outline, "Service", service?["name"]),
//           _buildDetailRow(Icons.person_outline, "Provider", employee?["name"]),
//           _buildDetailRow(
//             Icons.calendar_today_outlined,
//             "Service Date",
//             formatDate(booking?["service_date"]),
//           ),
//           if ((booking?["problem_description"] ?? "").toString().isNotEmpty)
//             _buildDetailRow(
//               Icons.description_outlined,
//               "Problem",
//               booking?["problem_description"],
//               isMultiline: true,
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBillSummaryCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
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
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF4CAF50).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(
//                     Icons.receipt_long_outlined,
//                     color: Color(0xFF4CAF50),
//                     size: 24,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 const Text(
//                   "Bill Summary",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1A1D1E),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(height: 1),
//           _buildAmountRow("Service Amount", bill?["service_amount"]),
//           _buildAmountRow("Visit Charge", bill?["visit_charge"]),
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             height: 1,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.grey.shade200,
//                   Colors.grey.shade300,
//                   Colors.grey.shade200,
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: const Color(0xFF4CAF50).withOpacity(0.05),
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(16),
//                 bottomRight: Radius.circular(16),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Total Amount",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1A1D1E),
//                   ),
//                 ),
//                 Text(
//                   "₹ ${bill?["total_amount"] ?? 0}",
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF4CAF50),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(IconData icon, String label, dynamic value,
//       {bool isMultiline = false}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: Colors.grey.shade100),
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment:
//         isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
//         children: [
//           Icon(icon, size: 20, color: Colors.grey.shade600),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value?.toString() ?? "--",
//                   style: const TextStyle(
//                     color: Color(0xFF1A1D1E),
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAmountRow(String label, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               color: Colors.grey.shade700,
//               fontSize: 15,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Text(
//             "₹ ${value ?? 0}",
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1A1D1E),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDownloadButton() {
//     return Material(
//       elevation: 0,
//       borderRadius: BorderRadius.circular(14),
//       child: InkWell(
//         onTap: downloading ? null : downloadBillPdf,
//         borderRadius: BorderRadius.circular(14),
//         child: Container(
//           height: 56,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: const Color(0xFF2196F3), width: 2),
//           ),
//           child: Center(
//             child: downloading
//                 ? const SizedBox(
//               height: 24,
//               width: 24,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2.5,
//                 valueColor:
//                 AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
//               ),
//             )
//                 : const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.download_outlined,
//                   color: Color(0xFF2196F3),
//                   size: 22,
//                 ),
//                 SizedBox(width: 10),
//                 Text(
//                   "Download Bill PDF",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF2196F3),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPaymentButton() {
//     return Material(
//       elevation: 4,
//       shadowColor: const Color(0xFF4CAF50).withOpacity(0.3),
//       borderRadius: BorderRadius.circular(14),
//       child: InkWell(
//         onTap: paying ? null : payBill,
//         borderRadius: BorderRadius.circular(14),
//         child: Ink(
//           height: 56,
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//             ),
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child: Center(
//             child: paying
//                 ? const SizedBox(
//               height: 24,
//               width: 24,
//               child: CircularProgressIndicator(
//                 color: Colors.white,
//                 strokeWidth: 2.5,
//               ),
//             )
//                 : const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.payment, color: Colors.white, size: 22),
//                 SizedBox(width: 10),
//                 Text(
//                   "Pay Now",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   String formatDate(Timestamp? timestamp) {
//     if (timestamp == null) return "--";
//     return DateFormat("dd MMM yyyy, hh:mm a").format(timestamp.toDate());
//   }
// }



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'customer_feedback.dart';

import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:homebuddy/services/bill_pdf_service.dart';






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

class _BillPaymentPageState extends State<BillPaymentPage> with SingleTickerProviderStateMixin {
  bool loading = true;
  bool paying = false;
  bool downloading = false;

  Map<String, dynamic>? bill;
  Map<String, dynamic>? booking;
  Map<String, dynamic>? service;
  Map<String, dynamic>? employee;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    fetchAllData();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> fetchAllData() async {
    try {
      final billSnap = await FirebaseFirestore.instance
          .collection("bill_details")
          .doc(widget.billId)
          .get();

      if (!billSnap.exists) return;

      bill = billSnap.data();
      final bookingId = bill!["booking_id"];
      final serviceId = bill!["service_id"];

      final bookingSnap = await FirebaseFirestore.instance
          .collection("booking_details")
          .doc(bookingId)
          .get();

      booking = bookingSnap.data();

      final serviceSnap = await FirebaseFirestore.instance
          .collection("services")
          .doc(serviceId)
          .get();

      service = serviceSnap.data();

      final empSnap = await FirebaseFirestore.instance
          .collection("employe_detail")
          .doc(widget.employeeId)
          .get();

      employee = empSnap.data();

      setState(() => loading = false);
      _animController.forward();
    } catch (e) {
      debugPrint("❌ Bill fetch error: $e");
    }
  }

  Future<void> payBill() async {
    HapticFeedback.mediumImpact();
    setState(() => paying = true);

    try {
      await FirebaseFirestore.instance
          .collection("bill_details")
          .doc(widget.billId)
          .update({
        "payment_status": "Completed",
        "paid_at": Timestamp.now(),
      });

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

      HapticFeedback.heavyImpact();

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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Text("Payment failed. Please try again."),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      if (mounted) setState(() => paying = false);
    }
  }

  // Future<void> downloadBillPdf() async {
  //   HapticFeedback.lightImpact();
  //   setState(() => downloading = true);
  //
  //   try {
  //     // ✅ Load fonts (IMPORTANT: both regular & bold)
  //     final regularFont = pw.Font.ttf(
  //       await rootBundle.load(
  //         "assets/fonts/Roboto/static/Roboto-Regular.ttf",
  //       ),
  //     );
  //
  //     final boldFont = pw.Font.ttf(
  //       await rootBundle.load(
  //         "assets/fonts/Roboto/static/Roboto-Bold.ttf",
  //       ),
  //     );
  //
  //     final pdf = pw.Document();
  //
  //     pdf.addPage(
  //       pw.Page(
  //         pageFormat: PdfPageFormat.a4,
  //         margin: const pw.EdgeInsets.all(32),
  //         build: (context) {
  //           return pw.Theme(
  //             data: pw.ThemeData.withFont(
  //               base: regularFont,
  //               bold: boldFont,
  //             ),
  //             child: pw.Column(
  //               crossAxisAlignment: pw.CrossAxisAlignment.start,
  //               children: [
  //
  //                 /// HEADER
  //                 pw.Row(
  //                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     pw.Column(
  //                       crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                       children: [
  //                         pw.Text(
  //                           "HomeBuddy",
  //                           style: pw.TextStyle(
  //                             fontSize: 26,
  //                             fontWeight: pw.FontWeight.bold,
  //                             color: PdfColors.green800,
  //                           ),
  //                         ),
  //                         pw.SizedBox(height: 4),
  //                         pw.Text(
  //                           "Home Services Invoice",
  //                           style: pw.TextStyle(
  //                             fontSize: 12,
  //                             color: PdfColors.grey700,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     pw.Column(
  //                       crossAxisAlignment: pw.CrossAxisAlignment.end,
  //                       children: [
  //                         pw.Text("Invoice ID",
  //                             style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //                         pw.Text(widget.billId),
  //                         pw.SizedBox(height: 4),
  //                         pw.Text(
  //                           "Date: ${formatDate(bill?["paid_at"] ?? bill?["created_at"])}",
  //                           style: const pw.TextStyle(fontSize: 10),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //
  //                 pw.SizedBox(height: 20),
  //                 pw.Divider(),
  //
  //                 /// CUSTOMER & PROVIDER
  //                 pw.SizedBox(height: 16),
  //                 pw.Row(
  //                   crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                   children: [
  //                     pw.Expanded(
  //                       child: pw.Column(
  //                         crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                         children: [
  //                           pw.Text(
  //                             "Customer Details",
  //                             style: pw.TextStyle(
  //                               fontWeight: pw.FontWeight.bold,
  //                               fontSize: 12,
  //                             ),
  //                           ),
  //                           pw.SizedBox(height: 6),
  //                           pw.Text("Customer ID: ${widget.customerId}"),
  //                           pw.Text(
  //                             "Service Date: ${formatDate(booking?["service_date"])}",
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     pw.Expanded(
  //                       child: pw.Column(
  //                         crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                         children: [
  //                           pw.Text(
  //                             "Service Provider",
  //                             style: pw.TextStyle(
  //                               fontWeight: pw.FontWeight.bold,
  //                               fontSize: 12,
  //                             ),
  //                           ),
  //                           pw.SizedBox(height: 6),
  //                           pw.Text("Name: ${employee?["name"] ?? "--"}"),
  //                           pw.Text("Service: ${service?["name"] ?? "--"}"),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //
  //                 pw.SizedBox(height: 20),
  //
  //                 /// BILL TABLE
  //                 pw.Text(
  //                   "Billing Summary",
  //                   style: pw.TextStyle(
  //                     fontSize: 14,
  //                     fontWeight: pw.FontWeight.bold,
  //                   ),
  //                 ),
  //                 pw.SizedBox(height: 10),
  //
  //                 pw.Table(
  //                   border: pw.TableBorder.all(color: PdfColors.grey300),
  //                   columnWidths: {
  //                     0: const pw.FlexColumnWidth(3),
  //                     1: const pw.FlexColumnWidth(1),
  //                   },
  //                   children: [
  //                     _pdfTableRow("Description", "Amount", isHeader: true),
  //                     _pdfTableRow(
  //                       "Service Charge",
  //                       "₹ ${bill?["service_amount"] ?? 0}",
  //                     ),
  //                     _pdfTableRow(
  //                       "Visit Charge",
  //                       "₹ ${bill?["visit_charge"] ?? 0}",
  //                     ),
  //                   ],
  //                 ),
  //
  //                 pw.SizedBox(height: 16),
  //
  //                 /// TOTAL (₹ FIXED HERE ✅)
  //                 pw.Align(
  //                   alignment: pw.Alignment.centerRight,
  //                   child: pw.Container(
  //                     padding: const pw.EdgeInsets.all(12),
  //                     decoration: pw.BoxDecoration(
  //                       color: PdfColors.green50,
  //                       borderRadius: pw.BorderRadius.circular(6),
  //                     ),
  //                     child: pw.Text(
  //                       "Total Amount: ₹ ${bill?["total_amount"] ?? 0}",
  //                       style: pw.TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: pw.FontWeight.bold,
  //                         color: PdfColors.green800,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //
  //                 pw.SizedBox(height: 16),
  //
  //                 /// PAYMENT STATUS
  //                 pw.Text(
  //                   "Payment Status: ${bill?["payment_status"]}",
  //                   style: pw.TextStyle(
  //                     fontSize: 12,
  //                     fontWeight: pw.FontWeight.bold,
  //                     color: bill?["payment_status"] == "Completed"
  //                         ? PdfColors.green
  //                         : PdfColors.orange,
  //                   ),
  //                 ),
  //
  //                 pw.Spacer(),
  //
  //                 /// FOOTER
  //                 pw.Divider(),
  //                 pw.SizedBox(height: 8),
  //                 pw.Center(
  //                   child: pw.Text(
  //                     "Thank you for choosing HomeBuddy – Reliable Home Services",
  //                     style: pw.TextStyle(
  //                       fontSize: 10,
  //                       color: PdfColors.grey600,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       ),
  //     );
  //
  //     final directory = await getApplicationDocumentsDirectory();
  //     final file = File(
  //       "${directory.path}/HomeBuddy_Invoice_${widget.billId}.pdf",
  //     );
  //
  //     await file.writeAsBytes(await pdf.save());
  //     await OpenFilex.open(file.path);
  //
  //     if (!mounted) return;
  //     HapticFeedback.mediumImpact();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Invoice downloaded successfully"),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } catch (e, s) {
  //     debugPrint("PDF ERROR: $e");
  //     debugPrint("STACKTRACE: $s");
  //
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Failed to generate invoice"),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   } finally {
  //     if (mounted) setState(() => downloading = false);
  //   }
  // }


  /// TABLE ROW HELPER
  pw.TableRow _pdfTableRow(String left, String right, {bool isHeader = false}) {
    return pw.TableRow(
      decoration:
      isHeader ? const pw.BoxDecoration(color: PdfColors.grey200) : null,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            left,
            style: pw.TextStyle(
              fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            right,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(strokeWidth: 3),
              const SizedBox(height: 16),
              Text(
                "Loading bill details...",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final isPending = bill?["payment_status"] == "Pending";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1A1D1E)),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: const Text(
          "Bill Details",
          style: TextStyle(
            color: Color(0xFF1A1D1E),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Status Banner
              _buildStatusBanner(isPending),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Details Card
                    _buildServiceCard(),

                    const SizedBox(height: 16),

                    // Bill Summary Card
                    _buildBillSummaryCard(),

                    const SizedBox(height: 20),

                    // Download Button
                    _buildDownloadButton(),

                    const SizedBox(height: 16),

                    // Payment Button
                    if (isPending) _buildPaymentButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBanner(bool isPending) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPending
              ? [const Color(0xFFFFA726), const Color(0xFFFF9800)]
              : [const Color(0xFF66BB6A), const Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Icon(
            isPending ? Icons.pending_outlined : Icons.check_circle_outline,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            isPending ? "Payment Pending" : "Payment Completed",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isPending) ...[
            const SizedBox(height: 6),
            Text(
              "Please complete the payment to proceed",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.design_services_outlined,
                    color: Color(0xFF2196F3),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  "Service Details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1D1E),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildDetailRow(Icons.work_outline, "Service", service?["name"]),
          _buildDetailRow(Icons.person_outline, "Provider", employee?["name"]),
          _buildDetailRow(
            Icons.calendar_today_outlined,
            "Service Date",
            formatDate(booking?["service_date"]),
          ),
          if ((booking?["problem_description"] ?? "").toString().isNotEmpty)
            _buildDetailRow(
              Icons.description_outlined,
              "Problem",
              booking?["problem_description"],
              isMultiline: true,
            ),
        ],
      ),
    );
  }

  Widget _buildBillSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.receipt_long_outlined,
                    color: Color(0xFF4CAF50),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  "Bill Summary",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1D1E),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildAmountRow("Service Amount", bill?["service_amount"]),
          _buildAmountRow("Visit Charge", bill?["visit_charge"]),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade200,
                  Colors.grey.shade300,
                  Colors.grey.shade200,
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1D1E),
                  ),
                ),
                Text(
                  "₹ ${bill?["total_amount"] ?? 0}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, dynamic value,
      {bool isMultiline = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value?.toString() ?? "--",
                  style: const TextStyle(
                    color: Color(0xFF1A1D1E),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "₹ ${value ?? 0}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1D1E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton() {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        // ✅ IMPORTANT FIX: wrap method in () {}
        onTap: downloading
            ? null
            : () async {
          setState(() => downloading = true);

          try {
            await BillPdfService.generateAndOpenPdf(
              billId: widget.billId,
              bill: bill!,
              booking: booking,
              service: service,
              employee: employee,
            );

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Invoice downloaded successfully"),
                backgroundColor: Colors.green,
              ),
            );
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed to generate invoice"),
                backgroundColor: Colors.red,
              ),
            );
          } finally {
            if (mounted) setState(() => downloading = false);
          }
        },

        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF2196F3),
              width: 2,
            ),
          ),
          child: Center(
            child: downloading
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF2196F3),
                ),
              ),
            )
                : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.download_outlined,
                  color: Color(0xFF2196F3),
                  size: 22,
                ),
                SizedBox(width: 10),
                Text(
                  "Download Bill PDF",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildPaymentButton() {
    return Material(
      elevation: 4,
      shadowColor: const Color(0xFF4CAF50).withOpacity(0.3),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: paying ? null : payBill,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: paying
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
                : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.payment, color: Colors.white, size: 22),
                SizedBox(width: 10),
                Text(
                  "Pay Now",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return "--";
    return DateFormat("dd MMM yyyy, hh:mm a").format(timestamp.toDate());
  }
}