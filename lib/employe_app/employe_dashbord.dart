// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:homebuddy/employe_app/employe_notification.dart';
// // import 'package:homebuddy/employe_app/employe_requests.dart';
// // import 'package:homebuddy/employe_app/employe_jobs.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // import '../login.dart';
// //
// // class employe_deshbord_screen extends StatefulWidget {
// //   final String uid;
// //   const employe_deshbord_screen({super.key, required this.uid});
// //
// //   @override
// //   State<employe_deshbord_screen> createState() =>
// //       _employe_deshbord_screenState();
// // }
// //
// // class _employe_deshbord_screenState extends State<employe_deshbord_screen> {
// //   int selectedIndex = 0;
// //
// //   String employeeName = "";
// //   String serviceName = "";
// //   String profileImage = "";
// //   bool headerLoading = true;
// //
// //   int unreadCount = 0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchEmployeeAndService();
// //     listenUnreadNotifications();
// //   }
// //
// //   // ================= FETCH EMPLOYEE =================
// //   Future<void> fetchEmployeeAndService() async {
// //     final doc = await FirebaseFirestore.instance
// //         .collection("employe_detail")
// //         .doc(widget.uid)
// //         .get();
// //
// //     if (!doc.exists) return;
// //
// //     final data = doc.data()!;
// //     String tempService = "";
// //
// //     if (data["service_id"] != null) {
// //       final s = await FirebaseFirestore.instance
// //           .collection("services")
// //           .doc(data["service_id"])
// //           .get();
// //       if (s.exists) tempService = s["name"];
// //     }
// //
// //     setState(() {
// //       employeeName = data["name"] ?? "";
// //       profileImage = data["image"] ?? "";
// //       serviceName = tempService;
// //       headerLoading = false;
// //     });
// //   }
// //
// //   // ================= NOTIFICATION =================
// //   void listenUnreadNotifications() {
// //     FirebaseFirestore.instance
// //         .collection("notifications")
// //         .where("receiver_id", isEqualTo: widget.uid)
// //         .where("receiver_type", isEqualTo: "employee")
// //         .where("is_read", isEqualTo: false)
// //         .snapshots()
// //         .listen((snap) {
// //       if (!mounted) return;
// //       setState(() => unreadCount = snap.docs.length);
// //     });
// //   }
// //
// //   // ================= UI =================
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xffF4F6FA),
// //
// //       // ✅ BOTTOM NAV FIXED
// //
// //       body: CustomScrollView(
// //         slivers: [
// //           buildStickyHeader(),
// //           SliverToBoxAdapter(
// //             child: Column(
// //               children: [
// //                 const SizedBox(height: 16),
// //                 buildStatsRow(),
// //                 const SizedBox(height: 26),
// //                 buildSectionTitle("Today's Jobs"),
// //                 todayJobs(),
// //                 const SizedBox(height: 30),
// //
// //                 const SizedBox(height: 30),
// //               ],
// //             ),
// //           )
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // ================= TODAY JOBS =================
// //   Widget todayJobs() {
// //     final now = DateTime.now();
// //     final todayStart = DateTime(now.year, now.month, now.day);
// //     final todayEnd = todayStart.add(const Duration(days: 1));
// //
// //     return StreamBuilder<QuerySnapshot>(
// //       stream: FirebaseFirestore.instance
// //           .collection("booking_details")
// //           .where("employe_id", isEqualTo: widget.uid)
// //           .snapshots(),
// //       builder: (context, snap) {
// //         if (snap.connectionState == ConnectionState.waiting) {
// //           return const Padding(
// //             padding: EdgeInsets.all(18),
// //             child: CircularProgressIndicator(),
// //           );
// //         }
// //
// //         if (!snap.hasData || snap.data!.docs.isEmpty) {
// //           return const Padding(
// //             padding: EdgeInsets.all(18),
// //             child: Text(
// //               "No jobs for today",
// //               style: TextStyle(color: Colors.grey),
// //             ),
// //           );
// //         }
// //
// //         // 🔥 FILTER TODAY JOBS SAFELY
// //         final todayJobs = snap.data!.docs.where((doc) {
// //           final data = doc.data() as Map<String, dynamic>;
// //
// //           if (data["service_date"] == null) return false;
// //
// //           final DateTime serviceDate =
// //           (data["service_date"] as Timestamp).toDate();
// //
// //           return serviceDate.isAfter(todayStart) &&
// //               serviceDate.isBefore(todayEnd);
// //         }).toList();
// //
// //         if (todayJobs.isEmpty) {
// //           return const Padding(
// //             padding: EdgeInsets.all(18),
// //             child: Text(
// //               "No jobs for today",
// //               style: TextStyle(color: Colors.grey),
// //             ),
// //           );
// //         }
// //
// //         // 🔥 SORT: Started first, then by time
// //         todayJobs.sort((a, b) {
// //           final aData = a.data() as Map<String, dynamic>;
// //           final bData = b.data() as Map<String, dynamic>;
// //
// //           if (aData["status"] == "Started" &&
// //               bData["status"] != "Started") return -1;
// //           if (aData["status"] != "Started" &&
// //               bData["status"] == "Started") return 1;
// //
// //           final aDate =
// //           (aData["service_date"] as Timestamp).toDate();
// //           final bDate =
// //           (bData["service_date"] as Timestamp).toDate();
// //
// //           return aDate.compareTo(bDate);
// //         });
// //
// //         return Column(
// //           children: todayJobs.map((doc) {
// //             final d = doc.data() as Map<String, dynamic>;
// //             final date = (d["service_date"] as Timestamp).toDate();
// //
// //             return buildJobCard(
// //               title: d["service_name"] ?? "Service",
// //               customer: d["customer_name"] ?? "Customer",
// //               time:
// //               "${date.hour}:${date.minute.toString().padLeft(2, '0')}",
// //               price: "₹${d["final_amount"] ?? '--'}",
// //               location: d["customer_address"] ?? "",
// //             );
// //           }).toList(),
// //         );
// //       },
// //     );
// //   }
// //
// //   // ================= HEADER =================
// //   SliverAppBar buildStickyHeader() {
// //     return SliverAppBar(
// //       pinned: true,
// //       expandedHeight: 160,
// //       backgroundColor: Colors.transparent,
// //       flexibleSpace: Container(
// //         decoration: const BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: [Color(0xFF0052D4), Color(0xFF4364F7)],
// //           ),
// //           borderRadius: BorderRadius.only(
// //             bottomLeft: Radius.circular(30),
// //             bottomRight: Radius.circular(30),
// //           ),
// //         ),
// //         child: SafeArea(
// //           child: Padding(
// //             padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
// //             child: Row(
// //               children: [
// //                 CircleAvatar(
// //                   radius: 26,
// //                   backgroundColor: Colors.white,
// //                   child: CircleAvatar(
// //                     radius: 24,
// //                     backgroundImage: profileImage.isNotEmpty
// //                         ? NetworkImage(profileImage)
// //                         : null,
// //                     child: profileImage.isEmpty
// //                         ? const Icon(Icons.person,
// //                         color: Color(0xFF0052D4))
// //                         : null,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 14),
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const SizedBox(height: 15),
// //                     const Text("Good Morning 👋",
// //                         style: TextStyle(color: Colors.white70)),
// //                     const SizedBox(height: 6),
// //                     headerLoading
// //                         ? const CircularProgressIndicator(
// //                         color: Colors.white, strokeWidth: 2)
// //                         : Text(employeeName,
// //                         style: const TextStyle(
// //                             color: Colors.white,
// //                             fontSize: 22,
// //                             fontWeight: FontWeight.bold)),
// //                     if (serviceName.isNotEmpty)
// //                       Text(serviceName,
// //                           style: const TextStyle(
// //                               color: Colors.white70, fontSize: 13)),
// //                   ],
// //                 ),
// //                 const Spacer(),
// //                 Stack(
// //                   children: [
// //                     IconButton(
// //                       icon: Icon(
// //                         unreadCount > 0
// //                             ? Icons.notifications
// //                             : Icons.notifications_none,
// //                         color: Colors.white,
// //                       ),
// //                       onPressed: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (_) =>
// //                                 EmployeeNotificationPage(
// //                                     employeeId: widget.uid),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                     if (unreadCount > 0)
// //                       const Positioned(
// //                         right: 10,
// //                         top: 10,
// //                         child:
// //                         CircleAvatar(radius: 4, backgroundColor: Colors.red),
// //                       )
// //                   ],
// //                 )
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // ================= STATS =================
// //   Widget buildStatsRow() {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 18),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           statCard("Jobs", "3", Icons.work_outline),
// //           statCard("Earnings", "₹12.5k",
// //               Icons.account_balance_wallet_outlined),
// //           statCard("Rating", "4.8", Icons.star_outline),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget statCard(String label, String value, IconData icon) {
// //     return Container(
// //       width: 105,
// //       padding: const EdgeInsets.all(14),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(18),
// //         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
// //       ),
// //       child: Column(
// //         children: [
// //           Icon(icon, color: const Color(0xFF0052D4)),
// //           const SizedBox(height: 8),
// //           Text(value,
// //               style:
// //               const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //           Text(label,
// //               style: const TextStyle(fontSize: 12, color: Colors.grey)),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget buildSectionTitle(String title) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 18),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: const [
// //           Text("Today's Jobs",
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //           Text("View all",
// //               style: TextStyle(
// //                   color: Color(0xFF0052D4), fontWeight: FontWeight.w600)),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // ================= JOB CARD =================
// //   Widget buildJobCard({
// //     required String title,
// //     required String customer,
// //     required String time,
// //     required String price,
// //     required String location,
// //   }) {
// //     return Container(
// //       margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(18),
// //         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Text(title,
// //                   style:
// //                   const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
// //               Text(price,
// //                   style: const TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.green)),
// //             ],
// //           ),
// //           const SizedBox(height: 6),
// //           Text(customer),
// //           const SizedBox(height: 6),
// //           Row(children: [const Icon(Icons.access_time, size: 14), Text(time)]),
// //           const SizedBox(height: 6),
// //           Row(children: [
// //             const Icon(Icons.location_on, size: 14),
// //             Expanded(child: Text(location))
// //           ]),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// //   // ================= BOTTOM NAV =================
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:homebuddy/employe_app/employe_notification.dart';
// import 'package:homebuddy/employe_app/employe_requests.dart';
// import 'package:homebuddy/employe_app/employe_jobs.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../login.dart';
//
// class employe_deshbord_screen extends StatefulWidget {
//   final String uid;
//   const employe_deshbord_screen({super.key, required this.uid});
//
//   @override
//   State<employe_deshbord_screen> createState() =>
//       _employe_deshbord_screenState();
// }
//
// class _employe_deshbord_screenState extends State<employe_deshbord_screen> {
//   int selectedIndex = 0;
//
//   String employeeName = "";
//   String serviceName = "";
//   String profileImage = "";
//   bool headerLoading = true;
//
//   int unreadCount = 0;
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     fetchEmployeeAndService();
//     listenUnreadNotifications();
//   }
//
//   // ================= FETCH EMPLOYEE =================
//   Future<void> fetchEmployeeAndService() async {
//     final doc = await FirebaseFirestore.instance
//         .collection("employe_detail")
//         .doc(widget.uid)
//         .get();
//
//     if (!doc.exists) return;
//
//     final data = doc.data()!;
//     String tempService = "";
//
//     if (data["service_id"] != null) {
//       final s = await FirebaseFirestore.instance
//           .collection("services")
//           .doc(data["service_id"])
//           .get();
//       if (s.exists) tempService = s["name"];
//     }
//
//     setState(() {
//       employeeName = data["name"] ?? "";
//       profileImage = data["image"] ?? "";
//       serviceName = tempService;
//       headerLoading = false;
//     });
//   }
//
//   // ================= NOTIFICATION =================
//   void listenUnreadNotifications() {
//     FirebaseFirestore.instance
//         .collection("notifications")
//         .where("receiver_id", isEqualTo: widget.uid)
//         .where("receiver_type", isEqualTo: "employee")
//         .where("is_read", isEqualTo: false)
//         .snapshots()
//         .listen((snap) {
//       if (!mounted) return;
//       setState(() => unreadCount = snap.docs.length);
//     });
//   }
//
//   // ================= UI =================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FD),
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           buildStickyHeader(),
//           SliverToBoxAdapter(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 24),
//                 buildStatsRow(),
//                 const SizedBox(height: 32),
//                 buildSectionTitle("Today's Jobs"),
//                 const SizedBox(height: 16),
//                 todayJobs(),
//                 const SizedBox(height: 40),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   // ================= TODAY JOBS =================
//   Widget todayJobs() {
//     final now = DateTime.now();
//     final todayStart = DateTime(now.year, now.month, now.day);
//     final todayEnd = todayStart.add(const Duration(days: 1));
//
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection("booking_details")
//           .where("employe_id", isEqualTo: widget.uid)
//           .snapshots(),
//       builder: (context, snap) {
//         if (snap.connectionState == ConnectionState.waiting) {
//           return const Padding(
//             padding: EdgeInsets.all(24),
//             child: Center(
//               child: CircularProgressIndicator(
//                 color: Color(0xFF1ABC9C),
//               ),
//             ),
//           );
//         }
//
//         if (!snap.hasData || snap.data!.docs.isEmpty) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//             child: Center(
//               child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.work_outline_rounded,
//                       size: 48,
//                       color: Colors.grey[400],
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     "No jobs for today",
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey[600],
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Check back later for new assignments",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[500],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//
//         // 🔥 FILTER TODAY JOBS SAFELY
//         final todayJobs = snap.data!.docs.where((doc) {
//           final data = doc.data() as Map<String, dynamic>;
//
//           if (data["service_date"] == null) return false;
//
//           final DateTime serviceDate =
//           (data["service_date"] as Timestamp).toDate();
//
//           return serviceDate.isAfter(todayStart) &&
//               serviceDate.isBefore(todayEnd);
//         }).toList();
//
//         if (todayJobs.isEmpty) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//             child: Center(
//               child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.work_outline_rounded,
//                       size: 48,
//                       color: Colors.grey[400],
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     "No jobs for today",
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey[600],
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Check back later for new assignments",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[500],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//
//         // 🔥 SORT: Started first, then by time
//         todayJobs.sort((a, b) {
//           final aData = a.data() as Map<String, dynamic>;
//           final bData = b.data() as Map<String, dynamic>;
//
//           if (aData["status"] == "Started" && bData["status"] != "Started")
//             return -1;
//           if (aData["status"] != "Started" && bData["status"] == "Started")
//             return 1;
//
//           final aDate = (aData["service_date"] as Timestamp).toDate();
//           final bDate = (bData["service_date"] as Timestamp).toDate();
//
//           return aDate.compareTo(bDate);
//         });
//
//         return Column(
//           children: todayJobs.map((doc) {
//             final d = doc.data() as Map<String, dynamic>;
//             final date = (d["service_date"] as Timestamp).toDate();
//
//             return buildJobCard(
//               title: d["service_name"] ?? "Service",
//               customer: d["customer_name"] ?? "Customer",
//               time:
//               "${date.hour}:${date.minute.toString().padLeft(2, '0')}",
//               price: "₹${d["final_amount"] ?? '--'}",
//               location: d["customer_address"] ?? "",
//               status: d["status"] ?? "",
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
//
//   // ================= HEADER =================
//   SliverAppBar buildStickyHeader() {
//     return SliverAppBar(
//       pinned: true,
//       expandedHeight: 170,
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               const Color(0xFF1ABC9C),
//               const Color(0xFF16A085),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: const BorderRadius.only(
//             bottomLeft: Radius.circular(32),
//             bottomRight: Radius.circular(32),
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(3),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: CircleAvatar(
//                         radius: 26,
//                         backgroundImage: profileImage.isNotEmpty
//                             ? NetworkImage(profileImage)
//                             : null,
//                         backgroundColor: Colors.grey[200],
//                         child: profileImage.isEmpty
//                             ? Icon(
//                           Icons.person_rounded,
//                           color: Colors.grey[400],
//                           size: 28,
//                         )
//                             : null,
//                       ),
//                     ),
//                     const SizedBox(width: 14),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             "Good Morning 👋",
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.9),
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           headerLoading
//                               ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           )
//                               : Text(
//                             employeeName,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               letterSpacing: 0.2,
//                             ),
//                           ),
//                           if (serviceName.isNotEmpty) ...[
//                             const SizedBox(height: 4),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 10,
//                                 vertical: 4,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 serviceName,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                     Stack(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             shape: BoxShape.circle,
//                           ),
//                           child: IconButton(
//                             icon: Icon(
//                               unreadCount > 0
//                                   ? Icons.notifications_rounded
//                                   : Icons.notifications_none_rounded,
//                               color: Colors.white,
//                               size: 26,
//                             ),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => EmployeeNotificationPage(
//                                       employeeId: widget.uid),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         if (unreadCount > 0)
//                           Positioned(
//                             right: 8,
//                             top: 8,
//                             child: Container(
//                               padding: const EdgeInsets.all(4),
//                               decoration: const BoxDecoration(
//                                 color: Colors.red,
//                                 shape: BoxShape.circle,
//                               ),
//                               constraints: const BoxConstraints(
//                                 minWidth: 18,
//                                 minHeight: 18,
//                               ),
//                               child: Text(
//                                 unreadCount > 9 ? '9+' : '$unreadCount',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           )
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ================= STATS =================
//   Widget buildStatsRow() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         children: [
//           Expanded(child: statCard("Jobs", "3", Icons.work_outline_rounded)),
//           const SizedBox(width: 12),
//           Expanded(
//             child: statCard(
//               "Earnings",
//               "₹12.5k",
//               Icons.account_balance_wallet_outlined,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(child: statCard("Rating", "4.8", Icons.star_outline_rounded)),
//         ],
//       ),
//     );
//   }
//
//   Widget statCard(String label, String value, IconData icon) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: const Color(0xFF1ABC9C).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               color: const Color(0xFF1ABC9C),
//               size: 24,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//               letterSpacing: 0.2,
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               // Navigate to all jobs
//             },
//             child: Text(
//               "View all",
//               style: TextStyle(
//                 color: const Color(0xFF1ABC9C),
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ================= JOB CARD =================
//   Widget buildJobCard({
//     required String title,
//     required String customer,
//     required String time,
//     required String price,
//     required String location,
//     String status = "",
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(20),
//           onTap: () {
//             // Navigate to job details
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(18),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF1ABC9C).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         price,
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF1ABC9C),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Icon(Icons.person_outline_rounded,
//                         size: 16, color: Colors.grey[600]),
//                     const SizedBox(width: 6),
//                     Text(
//                       customer,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[700],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Icon(Icons.access_time_rounded,
//                         size: 16, color: Colors.grey[600]),
//                     const SizedBox(width: 6),
//                     Text(
//                       time,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Icon(Icons.location_on_rounded,
//                         size: 16, color: Colors.grey[600]),
//                     const SizedBox(width: 6),
//                     Expanded(
//                       child: Text(
//                         location,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[700],
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (status == "Started") ...[
//                   const SizedBox(height: 12),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.orange.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: Colors.orange.withOpacity(0.3),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: const [
//                         Icon(Icons.play_circle_outline,
//                             size: 16, color: Colors.orange),
//                         SizedBox(width: 6),
//                         Text(
//                           "In Progress",
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.orange,
//                           ),
//                         ),
//                       ],
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
// }






// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:homebuddy/employe_app/employe_notification.dart';
// import 'package:homebuddy/employe_app/employe_requests.dart';
// import 'package:homebuddy/employe_app/employe_jobs.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../login.dart';
//
// class employe_deshbord_screen extends StatefulWidget {
//   final String uid;
//   const employe_deshbord_screen({super.key, required this.uid});
//
//   @override
//   State<employe_deshbord_screen> createState() =>
//       _employe_deshbord_screenState();
// }
//
// class _employe_deshbord_screenState extends State<employe_deshbord_screen> {
//   int selectedIndex = 0;
//
//   String employeeName = "";
//   String serviceName = "";
//   String profileImage = "";
//   bool headerLoading = true;
//
//   int unreadCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchEmployeeAndService();
//     listenUnreadNotifications();
//   }
//
//   // ================= FETCH EMPLOYEE =================
//   Future<void> fetchEmployeeAndService() async {
//     final doc = await FirebaseFirestore.instance
//         .collection("employe_detail")
//         .doc(widget.uid)
//         .get();
//
//     if (!doc.exists) return;
//
//     final data = doc.data()!;
//     String tempService = "";
//
//     if (data["service_id"] != null) {
//       final s = await FirebaseFirestore.instance
//           .collection("services")
//           .doc(data["service_id"])
//           .get();
//       if (s.exists) tempService = s["name"];
//     }
//
//     setState(() {
//       employeeName = data["name"] ?? "";
//       profileImage = data["image"] ?? "";
//       serviceName = tempService;
//       headerLoading = false;
//     });
//   }
//
//   // ================= NOTIFICATION =================
//   void listenUnreadNotifications() {
//     FirebaseFirestore.instance
//         .collection("notifications")
//         .where("receiver_id", isEqualTo: widget.uid)
//         .where("receiver_type", isEqualTo: "employee")
//         .where("is_read", isEqualTo: false)
//         .snapshots()
//         .listen((snap) {
//       if (!mounted) return;
//       setState(() => unreadCount = snap.docs.length);
//     });
//   }
//
//   // ================= UI =================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF4F6FA),
//
//       // ✅ BOTTOM NAV FIXED
//
//       body: CustomScrollView(
//         slivers: [
//           buildStickyHeader(),
//           SliverToBoxAdapter(
//             child: Column(
//               children: [
//                 const SizedBox(height: 16),
//                 buildStatsRow(),
//                 const SizedBox(height: 26),
//                 buildSectionTitle("Today's Jobs"),
//                 todayJobs(),
//                 const SizedBox(height: 30),
//
//                 const SizedBox(height: 30),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   // ================= TODAY JOBS =================
//   Widget todayJobs() {
//     final now = DateTime.now();
//     final todayStart = DateTime(now.year, now.month, now.day);
//     final todayEnd = todayStart.add(const Duration(days: 1));
//
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection("booking_details")
//           .where("employe_id", isEqualTo: widget.uid)
//           .snapshots(),
//       builder: (context, snap) {
//         if (snap.connectionState == ConnectionState.waiting) {
//           return const Padding(
//             padding: EdgeInsets.all(18),
//             child: CircularProgressIndicator(),
//           );
//         }
//
//         if (!snap.hasData || snap.data!.docs.isEmpty) {
//           return const Padding(
//             padding: EdgeInsets.all(18),
//             child: Text(
//               "No jobs for today",
//               style: TextStyle(color: Colors.grey),
//             ),
//           );
//         }
//
//         // 🔥 FILTER TODAY JOBS SAFELY
//         final todayJobs = snap.data!.docs.where((doc) {
//           final data = doc.data() as Map<String, dynamic>;
//
//           if (data["service_date"] == null) return false;
//
//           final DateTime serviceDate =
//           (data["service_date"] as Timestamp).toDate();
//
//           return serviceDate.isAfter(todayStart) &&
//               serviceDate.isBefore(todayEnd);
//         }).toList();
//
//         if (todayJobs.isEmpty) {
//           return const Padding(
//             padding: EdgeInsets.all(18),
//             child: Text(
//               "No jobs for today",
//               style: TextStyle(color: Colors.grey),
//             ),
//           );
//         }
//
//         // 🔥 SORT: Started first, then by time
//         todayJobs.sort((a, b) {
//           final aData = a.data() as Map<String, dynamic>;
//           final bData = b.data() as Map<String, dynamic>;
//
//           if (aData["status"] == "Started" &&
//               bData["status"] != "Started") return -1;
//           if (aData["status"] != "Started" &&
//               bData["status"] == "Started") return 1;
//
//           final aDate =
//           (aData["service_date"] as Timestamp).toDate();
//           final bDate =
//           (bData["service_date"] as Timestamp).toDate();
//
//           return aDate.compareTo(bDate);
//         });
//
//         return Column(
//           children: todayJobs.map((doc) {
//             final d = doc.data() as Map<String, dynamic>;
//             final date = (d["service_date"] as Timestamp).toDate();
//
//             return buildJobCard(
//               title: d["service_name"] ?? "Service",
//               customer: d["customer_name"] ?? "Customer",
//               time:
//               "${date.hour}:${date.minute.toString().padLeft(2, '0')}",
//               price: "₹${d["final_amount"] ?? '--'}",
//               location: d["customer_address"] ?? "",
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
//
//   // ================= HEADER =================
//   SliverAppBar buildStickyHeader() {
//     return SliverAppBar(
//       pinned: true,
//       expandedHeight: 160,
//       backgroundColor: Colors.transparent,
//       flexibleSpace: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF0052D4), Color(0xFF4364F7)],
//           ),
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(30),
//             bottomRight: Radius.circular(30),
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 26,
//                   backgroundColor: Colors.white,
//                   child: CircleAvatar(
//                     radius: 24,
//                     backgroundImage: profileImage.isNotEmpty
//                         ? NetworkImage(profileImage)
//                         : null,
//                     child: profileImage.isEmpty
//                         ? const Icon(Icons.person,
//                         color: Color(0xFF0052D4))
//                         : null,
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 15),
//                     const Text("Good Morning 👋",
//                         style: TextStyle(color: Colors.white70)),
//                     const SizedBox(height: 6),
//                     headerLoading
//                         ? const CircularProgressIndicator(
//                         color: Colors.white, strokeWidth: 2)
//                         : Text(employeeName,
//                         style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold)),
//                     if (serviceName.isNotEmpty)
//                       Text(serviceName,
//                           style: const TextStyle(
//                               color: Colors.white70, fontSize: 13)),
//                   ],
//                 ),
//                 const Spacer(),
//                 Stack(
//                   children: [
//                     IconButton(
//                       icon: Icon(
//                         unreadCount > 0
//                             ? Icons.notifications
//                             : Icons.notifications_none,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) =>
//                                 EmployeeNotificationPage(
//                                     employeeId: widget.uid),
//                           ),
//                         );
//                       },
//                     ),
//                     if (unreadCount > 0)
//                       const Positioned(
//                         right: 10,
//                         top: 10,
//                         child:
//                         CircleAvatar(radius: 4, backgroundColor: Colors.red),
//                       )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ================= STATS =================
//   Widget buildStatsRow() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 18),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           statCard("Jobs", "3", Icons.work_outline),
//           statCard("Earnings", "₹12.5k",
//               Icons.account_balance_wallet_outlined),
//           statCard("Rating", "4.8", Icons.star_outline),
//         ],
//       ),
//     );
//   }
//
//   Widget statCard(String label, String value, IconData icon) {
//     return Container(
//       width: 105,
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: const Color(0xFF0052D4)),
//           const SizedBox(height: 8),
//           Text(value,
//               style:
//               const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           Text(label,
//               style: const TextStyle(fontSize: 12, color: Colors.grey)),
//         ],
//       ),
//     );
//   }
//
//   Widget buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 18),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: const [
//           Text("Today's Jobs",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           Text("View all",
//               style: TextStyle(
//                   color: Color(0xFF0052D4), fontWeight: FontWeight.w600)),
//         ],
//       ),
//     );
//   }
//
//   // ================= JOB CARD =================
//   Widget buildJobCard({
//     required String title,
//     required String customer,
//     required String time,
//     required String price,
//     required String location,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(title,
//                   style:
//                   const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//               Text(price,
//                   style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green)),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Text(customer),
//           const SizedBox(height: 6),
//           Row(children: [const Icon(Icons.access_time, size: 14), Text(time)]),
//           const SizedBox(height: 6),
//           Row(children: [
//             const Icon(Icons.location_on, size: 14),
//             Expanded(child: Text(location))
//           ]),
//         ],
//       ),
//     );
//   }
// }
//
//   // ================= BOTTOM NAV =================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homebuddy/employe_app/employe_notification.dart';
import 'package:homebuddy/employe_app/employe_requests.dart';
import 'package:homebuddy/employe_app/employe_jobs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../login.dart';

class employe_deshbord_screen extends StatefulWidget {
  final String uid;
  const employe_deshbord_screen({super.key, required this.uid});

  @override
  State<employe_deshbord_screen> createState() =>
      _employe_deshbord_screenState();
}

class _employe_deshbord_screenState extends State<employe_deshbord_screen>
    with TickerProviderStateMixin {
  int selectedIndex = 0;

  String employeeName = "";
  String serviceName = "";
  String profileImage = "";
  bool headerLoading = true;

  int unreadCount = 0;

  int totalJobs = 0;
  double totalEarnings = 0;
  double avgRating = 0;
  bool statsLoading = true;

  late AnimationController _statsAnimController;
  late AnimationController _headerAnimController;
  Animation<double> _fadeAnimation = const AlwaysStoppedAnimation(1.0);
  Animation<Offset> _slideAnimation =
  const AlwaysStoppedAnimation(Offset.zero);

  @override
  void initState() {
    super.initState();

    _statsAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _statsAnimController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _headerAnimController,
        curve: Curves.easeOut,
      ),
    );

    fetchEmployeeAndService();
    listenUnreadNotifications();
    fetchStats();
  }


  @override
  void dispose() {
    _statsAnimController.dispose();
    _headerAnimController.dispose();
    super.dispose();
  }

  Future<void> fetchStats() async {
    try {
      final jobsSnap = await FirebaseFirestore.instance
          .collection("booking_details")
          .where("employe_id", isEqualTo: widget.uid)
          .get();

      final billsSnap = await FirebaseFirestore.instance
          .collection("bill_details")
          .where("employee_id", isEqualTo: widget.uid)
          .where("payment_status", isEqualTo: "Completed")
          .get();

      double earningSum = 0;
      for (var doc in billsSnap.docs) {
        final data = doc.data();
        earningSum += (data["total_amount"] ?? 0).toDouble();
      }

      final feedbackSnap = await FirebaseFirestore.instance
          .collection("feedback_details")
          .where("employee_id", isEqualTo: widget.uid)
          .get();

      double ratingSum = 0;
      for (var doc in feedbackSnap.docs) {
        final data = doc.data();
        ratingSum += (data["rating"] ?? 0).toDouble();
      }

      final double calculatedRating = feedbackSnap.docs.isEmpty
          ? 0
          : ratingSum / feedbackSnap.docs.length;

      await FirebaseFirestore.instance
          .collection("employe_detail")
          .doc(widget.uid)
          .update({
        "rating": calculatedRating,
        "total_reviews": feedbackSnap.docs.length,
      });

      if (!mounted) return;

      setState(() {
        totalJobs = jobsSnap.docs.length;
        totalEarnings = earningSum;
        avgRating = calculatedRating;
        statsLoading = false;
      });
      _statsAnimController.forward();
    } catch (e) {
      debugPrint("❌ fetchStats error: $e");
      if (mounted) {
        setState(() {
          statsLoading = false;
        });
      }
    }
  }

  Future<void> fetchEmployeeAndService() async {
    final doc = await FirebaseFirestore.instance
        .collection("employe_detail")
        .doc(widget.uid)
        .get();

    if (!doc.exists) return;

    final data = doc.data()!;
    String tempService = "";

    if (data["service_id"] != null) {
      final s = await FirebaseFirestore.instance
          .collection("services")
          .doc(data["service_id"])
          .get();
      if (s.exists) tempService = s["name"];
    }

    setState(() {
      employeeName = data["name"] ?? "";
      profileImage = data["image"] ?? "";
      serviceName = tempService;
      headerLoading = false;
    });
    _headerAnimController.forward();
  }

  void listenUnreadNotifications() {
    FirebaseFirestore.instance
        .collection("notifications")
        .where("receiver_id", isEqualTo: widget.uid)
        .where("receiver_type", isEqualTo: "employee")
        .where("is_read", isEqualTo: false)
        .snapshots()
        .listen((snap) {
      if (!mounted) return;
      setState(() => unreadCount = snap.docs.length);
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          buildStickyHeader(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                buildStatsRow(),
                const SizedBox(height: 32),
                buildSectionTitle("Today's Schedule"),
                const SizedBox(height: 16),
                todayJobs(),
                const SizedBox(height: 40),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget todayJobs() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("booking_details")
          .where("employe_id", isEqualTo: widget.uid)
          .snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: const Color(0xFF00BFA5),
                  strokeWidth: 3,
                ),
              ),
            ),
          );
        }

        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return _noJobsUI();
        }

        final todayJobs = snap.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          if (data["service_date"] == null) return false;
          final serviceDate = (data["service_date"] as Timestamp).toDate();
          return !serviceDate.isBefore(todayStart) &&
              serviceDate.isBefore(todayEnd);
        }).toList();

        if (todayJobs.isEmpty) {
          return _noJobsUI();
        }

        todayJobs.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;

          if (aData["status"] == "Started" && bData["status"] != "Started")
            return -1;
          if (aData["status"] != "Started" && bData["status"] == "Started")
            return 1;

          final aDate = (aData["service_date"] as Timestamp).toDate();
          final bDate = (bData["service_date"] as Timestamp).toDate();

          return aDate.compareTo(bDate);
        });

        return Column(
          children: todayJobs.asMap().entries.map((entry) {
            final index = entry.key;
            final doc = entry.value;
            final d = doc.data() as Map<String, dynamic>;

            return TweenAnimationBuilder(
              duration: Duration(milliseconds: 300 + (index * 100)),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: FutureBuilder(
                future: Future.wait([
                  FirebaseFirestore.instance
                      .collection("services")
                      .doc(d["service_id"])
                      .get(),
                  FirebaseFirestore.instance
                      .collection("customer_detail")
                      .doc(d["customer_id"])
                      .get(),
                ]),
                builder:
                    (context, AsyncSnapshot<List<DocumentSnapshot>> snap) {
                  if (!snap.hasData) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: const Color(0xFF00BFA5),
                          ),
                        ),
                      ),
                    );
                  }

                  final serviceDoc = snap.data![0];
                  final customerDoc = snap.data![1];

                  final serviceName =
                  serviceDoc.exists ? serviceDoc["name"] : "Service";
                  final customerName =
                  customerDoc.exists ? customerDoc["name"] : "Customer";
                  final customerAddress =
                  customerDoc.exists ? customerDoc["address"] : "";

                  return buildJobCard(
                    title: serviceName,
                    customer: customerName,
                    time: d["service_time"] ?? "--",
                    location: customerAddress,
                    status: d["status"] ?? "",
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _noJobsUI() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF00BFA5).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_available_rounded,
              size: 48,
              color: const Color(0xFF00BFA5),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "All Clear for Today!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1D1E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "No scheduled jobs at the moment.\nEnjoy your free time!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar buildStickyHeader() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 150,
      collapsedHeight: 150,
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      flexibleSpace: Container(

        decoration: const BoxDecoration(

          gradient: LinearGradient(
            colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Hero(
                              tag: 'profile_${widget.uid}',
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundImage: profileImage.isNotEmpty
                                      ? NetworkImage(profileImage)
                                      : null,
                                  backgroundColor: Colors.grey[200],
                                  child: profileImage.isEmpty
                                      ? Icon(
                                    Icons.person_rounded,
                                    color: Colors.grey[400],
                                    size: 32,
                                  )
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${_getGreeting()} 👋",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  headerLoading
                                      ? Container(
                                    height: 24,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color:
                                      Colors.white.withOpacity(0.2),
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                  )
                                      : Text(
                                    employeeName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.2,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (serviceName.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.work_outline_rounded,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          const SizedBox(width: 6),
                                          Flexible(
                                            child: Text(
                                              serviceName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      unreadCount > 0
                                          ? Icons.notifications_active_rounded
                                          : Icons.notifications_none_rounded,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              EmployeeNotificationPage(
                                                  employeeId: widget.uid),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (unreadCount > 0)
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red.withOpacity(0.5),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 20,
                                        minHeight: 20,
                                      ),
                                      child: Text(
                                        unreadCount > 9 ? '9+' : '$unreadCount',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatsRow() {
    if (statsLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: List.generate(
            3,
                (index) => Expanded(
              child: Container(
                margin: EdgeInsets.only(left: index > 0 ? 12 : 0),
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: const Color(0xFF00BFA5),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "Job Complete",
                totalJobs.toString(),
                Icons.task_alt_rounded,
                const Color(0xFF00BFA5),
                0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                "Total Earnings",
                "₹${_formatNumber(totalEarnings)}",
                Icons.account_balance_wallet_rounded,
                const Color(0xFFFF9800),
                1,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                "Avg Rating",
                avgRating == 0 ? "--" : avgRating.toStringAsFixed(1),
                Icons.star_rounded,
                const Color(0xFFFFD700),
                2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(double number) {
    if (number >= 100000) {
      return "${(number / 100000).toStringAsFixed(1)}L";
    } else if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(1)}K";
    }
    return number.toStringAsFixed(0);
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutBack,
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1D1E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF00BFA5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1D1E),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmployeeJobsScreen(uid: widget.uid),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "View all",
                      style: TextStyle(
                        color: const Color(0xFF00BFA5),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: const Color(0xFF00BFA5),
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildJobCard({
    required String title,
    required String customer,
    required String time,
    required String location,
    String status = "",
  }) {
    final isInProgress = status == "Started";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isInProgress
            ? Border.all(color: const Color(0xFF00BFA5), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: isInProgress
                ? const Color(0xFF00BFA5).withOpacity(0.15)
                : Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EmployeeJobsScreen(uid: widget.uid),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1D1E),
                        ),
                      ),
                    ),
                    if (isInProgress)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00BFA5).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.play_circle_filled_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "In Progress",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildJobDetailRow(
                  Icons.person_rounded,
                  customer,
                  Colors.blue,
                ),
                const SizedBox(height: 10),
                _buildJobDetailRow(
                  Icons.access_time_rounded,
                  time,
                  Colors.orange,
                ),
                const SizedBox(height: 10),
                _buildJobDetailRow(
                  Icons.location_on_rounded,
                  location,
                  Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobDetailRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
  }
