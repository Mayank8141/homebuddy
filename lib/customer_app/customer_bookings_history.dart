// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class BookingHistoryScreen extends StatelessWidget {
//   final String userId;
//
//   const BookingHistoryScreen({super.key, required this.userId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF6FAFF),
//       appBar: AppBar(
//         title: const Text("My Bookings"),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//       ),
//
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('booking_details')
//             .where('customer_id', isEqualTo: userId)
//             .snapshots(), // 🔥 REMOVED orderBy
//
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (snapshot.hasError) {
//             return Center(
//               child: Text("Error: ${snapshot.error}"),
//             );
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text("No bookings found"),
//             );
//           }
//
//           final bookings = snapshot.data!.docs;
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: bookings.length,
//             itemBuilder: (context, index) {
//               final data = bookings[index].data() as Map<String, dynamic>;
//               return bookingCard(data);
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   // ================= BOOKING CARD =================
//   Widget bookingCard(Map<String, dynamic> data) {
//     String status = data['status'] ?? 'Pending';
//
//     Color statusColor = status == "Accepted"
//         ? Colors.green
//         : status == "Rejected"
//         ? Colors.red
//         : Colors.orange;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           // STATUS
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Booking ID",
//                 style: GoogleFonts.poppins(
//                   fontSize: 13,
//                   color: Colors.grey,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   status,
//                   style: GoogleFonts.poppins(
//                     fontSize: 12,
//                     color: statusColor,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 6),
//
//           Text(
//             data['booking_id'] ?? '',
//             style: GoogleFonts.poppins(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//
//           const Divider(height: 24),
//
//           rowItem(
//             "Service Date",
//             data['service_date'] != null
//                 ? (data['service_date'] as Timestamp)
//                 .toDate()
//                 .toString()
//                 .split(" ")
//                 .first
//                 : "N/A",
//           ),
//
//           rowItem("Service Time", data['service_time'] ?? "N/A"),
//
//           const SizedBox(height: 10),
//
//           Text(
//             "Problem",
//             style: GoogleFonts.poppins(
//               fontSize: 13,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             data['problem_description'] ?? "",
//             style: GoogleFonts.poppins(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget rowItem(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: GoogleFonts.poppins(
//               fontSize: 13,
//               color: Colors.grey,
//             ),
//           ),
//           Text(
//             value,
//             style: GoogleFonts.poppins(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
//
// import 'customer_provider_profile.dart';
//
// class BookingHistoryScreen extends StatefulWidget {
//   final String userId;
//
//   const BookingHistoryScreen({super.key, required this.userId});
//
//   @override
//   State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
// }
//
// class _BookingHistoryScreenState extends State<BookingHistoryScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String selectedStatus = "All";
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFB),
//       body: CustomScrollView(
//         slivers: [
//           _buildAppBar(),
//           SliverPersistentHeader(
//             pinned: true,
//             delegate: _SliverTabBarDelegate(
//               TabBar(
//                 controller: _tabController,
//                 isScrollable: true,
//                 indicatorColor: const Color(0xFF00BFA5),
//                 indicatorWeight: 3,
//                 labelColor: const Color(0xFF00BFA5),
//                 unselectedLabelColor: const Color(0xFF6B7280),
//                 labelStyle: GoogleFonts.inter(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                 ),
//                 unselectedLabelStyle: GoogleFonts.inter(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 onTap: (index) {
//                   setState(() {
//                     selectedStatus = ["All", "Pending", "Accepted", "Completed"][index];
//                   });
//                 },
//                 tabs: const [
//                   Tab(text: "All"),
//                   Tab(text: "Pending"),
//                   Tab(text: "Accepted"),
//                   Tab(text: "Completed"),
//                 ],
//               ),
//             ),
//           ),
//           _buildBookingsList(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAppBar() {
//     return SliverAppBar(
//       expandedHeight: 120,
//       floating: false,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: const Color(0xFF00BFA5),
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
//         onPressed: () => Navigator.pop(context),
//       ),
//       flexibleSpace: FlexibleSpaceBar(
//         centerTitle: true,
//         titlePadding: const EdgeInsets.only(bottom: 16),
//         title: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               "My Bookings",
//               style: GoogleFonts.inter(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 4),
//             StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('booking_details')
//                   .where('customer_id', isEqualTo: widget.userId)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
//                 return Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     "$count Total Bookings",
//                     style: GoogleFonts.inter(
//                       fontSize: 12,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBookingsList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('booking_details')
//           .where('customer_id', isEqualTo: widget.userId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return SliverList(
//             delegate: SliverChildBuilderDelegate(
//                   (context, index) => _buildShimmerCard(),
//               childCount: 3,
//             ),
//           );
//         }
//
//         if (snapshot.hasError) {
//           return SliverFillRemaining(
//             child: _buildErrorState(snapshot.error.toString()),
//           );
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return SliverFillRemaining(
//             child: _buildEmptyState(),
//           );
//         }
//
//         var allBookings = snapshot.data!.docs;
//
//         // Filter by selected status
//         var filteredBookings = selectedStatus == "All"
//             ? allBookings
//             : allBookings.where((doc) {
//           final data = doc.data() as Map<String, dynamic>;
//           return (data['status'] ?? 'Pending') == selectedStatus;
//         }).toList();
//
//         if (filteredBookings.isEmpty) {
//           return SliverFillRemaining(
//             child: _buildEmptyState(status: selectedStatus),
//           );
//         }
//
//         return SliverPadding(
//           padding: const EdgeInsets.all(20),
//           sliver: SliverList(
//             delegate: SliverChildBuilderDelegate(
//                   (context, index) {
//                 final data = filteredBookings[index].data() as Map<String, dynamic>;
//                 return _buildBookingCard(data, index);
//               },
//               childCount: filteredBookings.length,
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildBookingCard(Map<String, dynamic> data, int index) {
//     String status = data['status'] ?? 'Pending';
//
//     return TweenAnimationBuilder(
//       duration: Duration(milliseconds: 300 + (index * 100)),
//       tween: Tween<double>(begin: 0, end: 1),
//       builder: (context, double value, child) {
//         return Transform.translate(
//           offset: Offset(0, 30 * (1 - value)),
//           child: Opacity(
//             opacity: value,
//             child: child,
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: const Color(0xFFE5E7EB)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.06),
//               blurRadius: 15,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             // Header Section
//             _buildCardHeader(data, status),
//
//             const Divider(height: 1, color: Color(0xFFE5E7EB)),
//
//             // Content Section
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildServiceInfo(data),
//                   const SizedBox(height: 16),
//                   _buildDateTimeSection(data),
//                   if (data['problem_description'] != null &&
//                       data['problem_description'].toString().isNotEmpty) ...[
//                     const SizedBox(height: 16),
//                     _buildProblemSection(data),
//                   ],
//                   const SizedBox(height: 16),
//                   //_buildStatusTimeline(status),
//                 ],
//               ),
//             ),
//
//             // Action Section
//             _buildActionSection(data, status),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCardHeader(Map<String, dynamic> data, String status) {
//     final statusConfig = _getStatusConfig(status);
//
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: statusConfig['bgColor'],
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Icon(
//               statusConfig['icon'],
//               color: statusConfig['color'],
//               size: 24,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Booking ID",
//                   style: GoogleFonts.inter(
//                     fontSize: 12,
//                     color: const Color(0xFF6B7280),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   data['booking_id'] ?? 'N/A',
//                   style: GoogleFonts.inter(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                     color: const Color(0xFF1A1F36),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: statusConfig['color'],
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: statusConfig['color'].withOpacity(0.3),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Text(
//               status,
//               style: GoogleFonts.inter(
//                 fontSize: 13,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildServiceInfo(Map<String, dynamic> data) {
//     final String? serviceId = data['service_id'];
//
//     return Container(
//       padding: const EdgeInsets.all(14),
//       // decoration: BoxDecoration(
//       //   color: const Color(0xFFF9FAFB),
//       //   borderRadius: BorderRadius.circular(12),
//       //   border: Border.all(color: const Color(0xFFE5E7EB)),
//       // ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: const Color(0xFF00BFA5).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(
//               Icons.home_repair_service_rounded,
//               color: Color(0xFF00BFA5),
//               size: 24,
//             ),
//           ),
//           const SizedBox(width: 12),
//
//           /// 🔥 FETCH SERVICE NAME
//           Expanded(
//             child: FutureBuilder<DocumentSnapshot>(
//               future: FirebaseFirestore.instance
//                   .collection('services')
//                   .doc(serviceId)
//                   .get(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Text(
//                     "Loading service...",
//                     style: GoogleFonts.inter(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   );
//                 }
//
//                 if (!snapshot.data!.exists) {
//                   return Text(
//                     "Service not found",
//                     style: GoogleFonts.inter(
//                       fontSize: 14,
//                       color: Colors.red,
//                     ),
//                   );
//                 }
//
//                 final serviceData =
//                 snapshot.data!.data() as Map<String, dynamic>;
//
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Service Type",
//                       style: GoogleFonts.inter(
//                         fontSize: 12,
//                         color: const Color(0xFF6B7280),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       serviceData['name'] ?? "Service",
//                       style: GoogleFonts.inter(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                         color: const Color(0xFF1A1F36),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//
//           if (data['visit_charge'] != null)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   "Amount",
//                   style: GoogleFonts.inter(
//                     fontSize: 11,
//                     color: const Color(0xFF6B7280),
//                   ),
//                 ),
//                 Text(
//                   "₹${data['visit_charge']}",
//                   style: GoogleFonts.inter(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w800,
//                     color: const Color(0xFF00BFA5),
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
//
//
//   Widget _buildDateTimeSection(Map<String, dynamic> data) {
//     String formattedDate = "N/A";
//     if (data['service_date'] != null) {
//       try {
//         final date = (data['service_date'] as Timestamp).toDate();
//         formattedDate = DateFormat('MMM dd, yyyy').format(date);
//       } catch (e) {
//         formattedDate = "N/A";
//       }
//     }
//
//     return Row(
//       children: [
//         Expanded(
//           child: _buildInfoItem(
//             Icons.calendar_today_rounded,
//             "Date",
//             formattedDate,
//             const Color(0xFF3B82F6),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildInfoItem(
//             Icons.access_time_rounded,
//             "Time",
//             data['service_time'] ?? "N/A",
//             const Color(0xFF8B5CF6),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInfoItem(IconData icon, String label, String value, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       // decoration: BoxDecoration(
//       //   color: color.withOpacity(0.08),
//       //   borderRadius: BorderRadius.circular(12),
//       //   border: Border.all(color: color.withOpacity(0.2)),
//       // ),
//       child: Row(
//         children: [
//           Icon(icon, color: color, size: 20),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: GoogleFonts.inter(
//                     fontSize: 11,
//                     color: const Color(0xFF6B7280),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   value,
//                   style: GoogleFonts.inter(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                     color: const Color(0xFF1A1F36),
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProblemSection(Map<String, dynamic> data) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFEF2F2),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFFECACA)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Icon(
//                 Icons.info_outline_rounded,
//                 size: 18,
//                 color: Color(0xFFEF4444),
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 "Problem Description",
//                 style: GoogleFonts.inter(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                   color: const Color(0xFFEF4444),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             data['problem_description'] ?? '',
//             style: GoogleFonts.inter(
//               fontSize: 14,
//               color: const Color(0xFF374151),
//               height: 1.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Widget _buildStatusTimeline(String status) {
//   //   final steps = ['Pending', 'Accepted', 'Completed'];
//   //   final currentIndex = steps.indexOf(status);
//   //
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       Text(
//   //         "Booking Progress",
//   //         style: GoogleFonts.inter(
//   //           fontSize: 13,
//   //           fontWeight: FontWeight.w700,
//   //           color: const Color(0xFF6B7280),
//   //         ),
//   //       ),
//   //       const SizedBox(height: 12),
//   //       Row(
//   //         children: List.generate(steps.length, (index) {
//   //           final isActive = index <= currentIndex;
//   //           final isLast = index == steps.length - 1;
//   //
//   //           return Expanded(
//   //             child: Row(
//   //               children: [
//   //                 Expanded(
//   //                   child: Column(
//   //                     children: [
//   //                       Container(
//   //                         width: 32,
//   //                         height: 32,
//   //                         decoration: BoxDecoration(
//   //                           color: isActive
//   //                               ? const Color(0xFF00BFA5)
//   //                               : const Color(0xFFE5E7EB),
//   //                           shape: BoxShape.circle,
//   //                           boxShadow: isActive ? [
//   //                             BoxShadow(
//   //                               color: const Color(0xFF00BFA5).withOpacity(0.3),
//   //                               blurRadius: 8,
//   //                               offset: const Offset(0, 2),
//   //                             ),
//   //                           ] : null,
//   //                         ),
//   //                         child: Center(
//   //                           child: Icon(
//   //                             isActive ? Icons.check_rounded : Icons.circle,
//   //                             size: isActive ? 20 : 8,
//   //                             color: Colors.white,
//   //                           ),
//   //                         ),
//   //                       ),
//   //                       const SizedBox(height: 6),
//   //                       Text(
//   //                         steps[index],
//   //                         style: GoogleFonts.inter(
//   //                           fontSize: 11,
//   //                           fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
//   //                           color: isActive
//   //                               ? const Color(0xFF00BFA5)
//   //                               : const Color(0xFF9CA3AF),
//   //                         ),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                 ),
//   //                 if (!isLast)
//   //                   Expanded(
//   //                     child: Container(
//   //                       height: 2,
//   //                       margin: const EdgeInsets.only(bottom: 24),
//   //                       color: isActive
//   //                           ? const Color(0xFF00BFA5)
//   //                           : const Color(0xFFE5E7EB),
//   //                     ),
//   //                   ),
//   //               ],
//   //             ),
//   //           );
//   //         }),
//   //       ),
//   //     ],
//   //   );
//   // }
//
//   Widget _buildActionSection(Map<String, dynamic> data, String status) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF9FAFB),
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(20),
//           bottomRight: Radius.circular(20),
//         ),
//         border: const Border(
//           top: BorderSide(color: Color(0xFFE5E7EB)),
//         ),
//       ),
//       child: Row(
//         children: [
//           if (status == "Pending") ...[
//             Expanded(
//               child: OutlinedButton.icon(
//                 onPressed: () {
//                   // Cancel booking
//                   _showCancelDialog(data);
//                 },
//                 style: OutlinedButton.styleFrom(
//                   foregroundColor: const Color(0xFFEF4444),
//                   side: const BorderSide(color: Color(0xFFEF4444)),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//                 icon: const Icon(Icons.close_rounded, size: 18),
//                 label: Text(
//                   "Cancel",
//                   style: GoogleFonts.inter(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//           ],
//           Expanded(
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 // View details
//                 _showBookingDetails(data);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF00BFA5),
//                 foregroundColor: Colors.white,
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//               ),
//               icon: const Icon(Icons.visibility_rounded, size: 18),
//               label: Text(
//                 "View Details",
//                 style: GoogleFonts.inter(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ),
//           if (status == "Completed") ...[
//             const SizedBox(width: 12),
//             Expanded(
//               child: ElevatedButton.icon(
//                 onPressed: () async {
//                   final providerId = data['employe_id'];
//
//                   if (providerId == null) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Provider not found")),
//                     );
//                     return;
//                   }
//
//                   // 🔥 FETCH PROVIDER DATA
//                   final providerSnap = await FirebaseFirestore.instance
//                       .collection("employe_detail")
//                       .doc(providerId)
//                       .get();
//
//                   if (!providerSnap.exists) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Provider profile not available")),
//                     );
//                     return;
//                   }
//
//                   final providerData = providerSnap.data()!;
//
//                   // 🔥 NAVIGATE TO PROVIDER PROFILE
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => ProviderFullProfile(
//                         customerId: widget.userId,
//                         providerId: providerId,
//                         providerData: providerData,
//                       ),
//                     ),
//                   );
//                 },
//
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF8B5CF6),
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//                 icon: const Icon(Icons.replay_rounded, size: 18),
//                 label: Text(
//                   "Rebook",
//                   style: GoogleFonts.inter(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildShimmerCard() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       height: 14,
//                       color: Colors.grey[300],
//                     ),
//                     const SizedBox(height: 8),
//                     Container(
//                       width: 100,
//                       height: 12,
//                       color: Colors.grey[300],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState({String? status}) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(40),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF00BFA5).withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.calendar_today_rounded,
//                 size: 64,
//                 color: const Color(0xFF00BFA5).withOpacity(0.5),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Text(
//               status != null ? "No $status Bookings" : "No Bookings Yet",
//               style: GoogleFonts.inter(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w700,
//                 color: const Color(0xFF1A1F36),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               status != null
//                   ? "You don't have any $status bookings at the moment."
//                   : "Start booking services to see your history here.",
//               textAlign: TextAlign.center,
//               style: GoogleFonts.inter(
//                 fontSize: 14,
//                 color: const Color(0xFF6B7280),
//                 height: 1.5,
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: () => Navigator.pop(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF00BFA5),
//                 foregroundColor: Colors.white,
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//               ),
//               icon: const Icon(Icons.add_rounded),
//               label: Text(
//                 "Book a Service",
//                 style: GoogleFonts.inter(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorState(String error) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(40),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.error_outline_rounded,
//               size: 64,
//               color: Color(0xFFEF4444),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               "Oops! Something went wrong",
//               style: GoogleFonts.inter(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//                 color: const Color(0xFF1A1F36),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               error,
//               textAlign: TextAlign.center,
//               style: GoogleFonts.inter(
//                 fontSize: 14,
//                 color: const Color(0xFF6B7280),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Map<String, dynamic> _getStatusConfig(String status) {
//     switch (status.toLowerCase()) {
//       case 'accepted':
//         return {
//           'color': const Color(0xFF10B981),
//           'bgColor': const Color(0xFFD1FAE5),
//           'icon': Icons.check_circle_rounded,
//         };
//       case 'completed':
//         return {
//           'color': const Color(0xFF3B82F6),
//           'bgColor': const Color(0xFFDBEAFE),
//           'icon': Icons.task_alt_rounded,
//         };
//       case 'rejected':
//       case 'cancelled':
//         return {
//           'color': const Color(0xFFEF4444),
//           'bgColor': const Color(0xFFFEE2E2),
//           'icon': Icons.cancel_rounded,
//         };
//       default: // Pending
//         return {
//           'color': const Color(0xFFF59E0B),
//           'bgColor': const Color(0xFFFEF3C7),
//           'icon': Icons.pending_rounded,
//         };
//     }
//   }
//
//   void _showCancelDialog(Map<String, dynamic> data) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Text(
//           "Cancel Booking",
//           style: GoogleFonts.inter(
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         content: Text(
//           "Are you sure you want to cancel this booking?",
//           style: GoogleFonts.inter(fontSize: 15),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               "No",
//               style: GoogleFonts.inter(
//                 color: const Color(0xFF6B7280),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               // Handle cancellation
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(
//                     "Booking cancelled successfully",
//                     style: GoogleFonts.inter(fontWeight: FontWeight.w500),
//                   ),
//                   backgroundColor: const Color(0xFFEF4444),
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFEF4444),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             child: Text(
//               "Yes, Cancel",
//               style: GoogleFonts.inter(fontWeight: FontWeight.w700),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showBookingDetails(Map<String, dynamic> data) {
//     final bookingId = data['booking_id'];
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.8,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//           ),
//           child: StreamBuilder<DocumentSnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('booking_details')
//                 .doc(bookingId)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//
//               final booking =
//               snapshot.data!.data() as Map<String, dynamic>;
//
//               return Column(
//                 children: [
//                   // ───── HEADER ─────
//                   Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             "Booking Details",
//                             style: GoogleFonts.inter(
//                               color: Colors.black,
//                               fontSize: 22,
//                               fontWeight: FontWeight.w800,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () => Navigator.pop(context),
//                           icon: const Icon(Icons.close),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const Divider(height: 1),
//
//                   // ───── BODY ─────
//                   Expanded(
//                     child: SingleChildScrollView(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _statusBanner(booking['status']),
//                           const SizedBox(height: 20),
//
//                           _infoCard(
//                             icon: Icons.confirmation_number_rounded,
//                             title: "Booking ID",
//                             value: booking['booking_id'],
//                           ),
//
//                           _infoCard(
//                             icon: Icons.calendar_today_rounded,
//                             title: "Service Date",
//                             value: _formatDate(booking['service_date']),
//                           ),
//
//                           _infoCard(
//                             icon: Icons.access_time_rounded,
//                             title: "Service Time",
//                             value: booking['service_time'],
//                           ),
//
//                           _problemCard(booking['problem_description']),
//                           const SizedBox(height: 24),
//
//                           Text(
//                             "Payment Summary",
//                             style: GoogleFonts.inter(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w800,
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//
//                           _amountRow(
//                             "Visit Charge",
//                             booking['visit_charge'],
//                           ),
//                           _amountRow(
//                             "Service Amount",
//                             booking['service_amount'],
//                           ),
//                           _amountRow(
//                             "Final Amount",
//                             booking['final_amount'],
//                             isTotal: true,
//                           ),
//
//                           if (booking['started_at'] != null) ...[
//                             const SizedBox(height: 20),
//                             _infoCard(
//                               icon: Icons.play_circle_fill_rounded,
//                               title: "Started At",
//                               value:
//                               _formatDateTime(booking['started_at']),
//                             ),
//                           ],
//
//                           if (booking['completed_at'] != null)
//                             _infoCard(
//                               icon: Icons.check_circle_rounded,
//                               title: "Completed At",
//                               value: _formatDateTime(
//                                   booking['completed_at']),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
// }
//
// Widget _statusBanner(String status) {
//   final config = _getStatusConfig(status);
//
//   return Container(
//     padding: const EdgeInsets.symmetric(vertical: 14),
//     decoration: BoxDecoration(
//       color: config['bgColor'],
//       borderRadius: BorderRadius.circular(16),
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(
//           config['icon'],
//           color: config['color'],
//         ),
//         const SizedBox(width: 8),
//         Text(
//           status,
//           style: GoogleFonts.inter(
//             fontSize: 16,
//             fontWeight: FontWeight.w800,
//             color: config['color'],
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
//
// Map<String, dynamic> _getStatusConfig(String status) {
//   switch (status.toLowerCase()) {
//     case 'accepted':
//       return {
//         'color': const Color(0xFF10B981),
//         'bgColor': const Color(0xFFD1FAE5),
//         'icon': Icons.check_circle_rounded,
//       };
//     case 'completed':
//       return {
//         'color': const Color(0xFF3B82F6),
//         'bgColor': const Color(0xFFDBEAFE),
//         'icon': Icons.task_alt_rounded,
//       };
//     case 'rejected':
//     case 'cancelled':
//       return {
//         'color': const Color(0xFFEF4444),
//         'bgColor': const Color(0xFFFEE2E2),
//         'icon': Icons.cancel_rounded,
//       };
//     default: // Pending
//       return {
//         'color': const Color(0xFFF59E0B),
//         'bgColor': const Color(0xFFFEF3C7),
//         'icon': Icons.pending_rounded,
//       };
//   }
// }
//
// Widget _infoCard({
//   required IconData icon,
//   required String title,
//   required String value,
// }) {
//   return Container(
//     margin: const EdgeInsets.only(bottom: 14),
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: const Color(0xFFF9FAFB),
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(color: const Color(0xFFE5E7EB)),
//     ),
//     child: Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: const Color(0xFF00BFA5).withOpacity(0.12),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(icon, color: const Color(0xFF00BFA5)),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: GoogleFonts.inter(
//                   fontSize: 12,
//                   color: const Color(0xFF6B7280),
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: GoogleFonts.inter(
//                   color: Colors.black,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _problemCard(String problem) {
//   return Container(
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: const Color(0xFFFEF2F2),
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(color: const Color(0xFFFECACA)),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: const [
//             Icon(Icons.report_problem_rounded,
//                 color: Color(0xFFEF4444)),
//             SizedBox(width: 6),
//             Text(
//               "Problem Description",
//               style: TextStyle(
//
//                 fontWeight: FontWeight.w800,
//                 color: Color(0xFFEF4444),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Text(
//           problem,
//           style: GoogleFonts.inter(
//             color: Colors.black,
//             fontSize: 14,
//             height: 1.5,
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _amountRow(String label, dynamic amount,
//     {bool isTotal = false}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 6),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.inter(
//             color: Colors.black,
//             fontSize: isTotal ? 15 : 14,
//             fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
//           ),
//         ),
//         Text(
//           amount != null ? "₹$amount" : "Pending",
//           style: GoogleFonts.inter(
//             fontSize: isTotal ? 18 : 15,
//             fontWeight: FontWeight.w900,
//             color: isTotal
//                 ? const Color(0xFF00BFA5)
//                 : const Color(0xFF1A1F36),
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
//
//
// Widget _detailTile(String title, dynamic value) {
//   return Container(
//     margin: const EdgeInsets.only(bottom: 12),
//     padding: const EdgeInsets.all(14),
//     decoration: BoxDecoration(
//       color: const Color(0xFFF9FAFB),
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(color: const Color(0xFFE5E7EB)),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: GoogleFonts.inter(
//             fontSize: 12,
//             color: const Color(0xFF6B7280),
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value?.toString() ?? "-",
//           style: GoogleFonts.inter(
//             fontSize: 15,
//             fontWeight: FontWeight.w700,
//             color: const Color(0xFF1A1F36),
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// String _formatDate(Timestamp ts) {
//   return DateFormat("dd MMM yyyy").format(ts.toDate());
// }
//
// String _formatDateTime(Timestamp ts) {
//   return DateFormat("dd MMM yyyy • hh:mm a").format(ts.toDate());
// }
//
//
// // Custom SliverPersistentHeaderDelegate for TabBar
// class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
//   final TabBar _tabBar;
//
//   _SliverTabBarDelegate(this._tabBar);
//
//   @override
//   double get minExtent => _tabBar.preferredSize.height;
//
//   @override
//   double get maxExtent => _tabBar.preferredSize.height;
//
//   @override
//   Widget build(
//       BuildContext context,
//       double shrinkOffset,
//       bool overlapsContent,
//       ) {
//     return Container(
//       color: Colors.white,
//       child: _tabBar,
//     );
//   }
//
//   @override
//   bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
//     return false;
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../services/bill_pdf_service.dart';
import 'customer_provider_profile.dart';

class BookingHistoryScreen extends StatefulWidget {
  final String userId;

  const BookingHistoryScreen({super.key, required this.userId});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedStatus = "All";
  bool _isLoading = true;

  List<QueryDocumentSnapshot> _allBookings = [];
  Map<String, String> _serviceNames = {};




  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAllData();
  }


  Future<void> _loadAllData() async {
    try {
      // 1️⃣ Fetch bookings
      final bookingSnap = await FirebaseFirestore.instance
          .collection('booking_details')
          .where('customer_id', isEqualTo: widget.userId)
          .get();

      final bookings = bookingSnap.docs;

      // Sort by date
      bookings.sort((a, b) {
        final aDate = (a.data() as Map<String, dynamic>)['service_date'];
        final bDate = (b.data() as Map<String, dynamic>)['service_date'];

        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        if (aDate is! Timestamp || bDate is! Timestamp) return 0;

        return bDate.toDate().compareTo(aDate.toDate());
      });

      // 2️⃣ Collect service IDs
      final serviceIds = bookings
          .map((e) => (e.data() as Map<String, dynamic>)['service_id'])
          .where((id) => id != null)
          .toSet();

      // 3️⃣ Fetch services
      final Map<String, String> services = {};

      for (final id in serviceIds) {
        final snap = await FirebaseFirestore.instance
            .collection('services')
            .doc(id)
            .get();

        if (snap.exists) {
          services[id] = (snap.data()!['name'] ?? "Service").toString();
        }
      }

      if (!mounted) return;

      setState(() {
        _allBookings = bookings;
        _serviceNames = services;
        _isLoading = false; // 🔥 UI unlocks ONLY HERE
      });
    } catch (e) {
      debugPrint("Load error: $e");

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }




  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF4CAF50); // Green
      case 'accepted':
        return const Color(0xFF2196F3); // Blue
      case 'pending':
        return const Color(0xFFFFA726); // Yellow/Orange
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1A1D1E), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Bookings",
          style: TextStyle(
            color: Color(0xFF1A1D1E),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: const Color(0xFF00BFA5),
              indicatorWeight: 2,
              labelColor: const Color(0xFF00BFA5),
              unselectedLabelColor: const Color(0xFF9CA3AF),
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              onTap: (index) {
                HapticFeedback.selectionClick();
                setState(() {
                  selectedStatus =
                  ["All", "Pending", "Accepted", "Completed"][index];
                });
              },
              tabs: const [
                Tab(text: "All"),
                Tab(text: "Pending"),
                Tab(text: "Accepted"),
                Tab(text: "Completed"),
              ],
            ),
          ),
        ),
      ),
      body: _buildBookingsList(),
    );
  }

  // Widget _buildBookingsList() {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance
  //         .collection('booking_details')
  //         .where('customer_id', isEqualTo: widget.userId)
  //         //.orderBy('service_date', descending: true)
  //         .snapshots(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(
  //           child: CircularProgressIndicator(
  //             color: const Color(0xFF00BFA5),
  //             strokeWidth: 2.5,
  //           ),
  //         );
  //       }
  //
  //       if (snapshot.hasError) {
  //         return _buildEmptyState(
  //           icon: Icons.error_outline,
  //           title: "Something went wrong",
  //           subtitle: "Please try again later",
  //         );
  //       }
  //
  //       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //         return _buildEmptyState(
  //           icon: Icons.event_note_outlined,
  //           title: "No bookings yet",
  //           subtitle: "Your booking history will appear here",
  //         );
  //       }
  //
  //       //var allBookings = snapshot.data!.docs;
  //
  //       var allBookings = snapshot.data!.docs.toList();
  //
  //       allBookings.sort((a, b) {
  //         final aData = a.data() as Map<String, dynamic>;
  //         final bData = b.data() as Map<String, dynamic>;
  //
  //         final aDate = aData['service_date'];
  //         final bDate = bData['service_date'];
  //
  //         if (aDate == null && bDate == null) return 0;
  //         if (aDate == null) return 1;
  //         if (bDate == null) return -1;
  //
  //         return (bDate as Timestamp)
  //             .toDate()
  //             .compareTo((aDate as Timestamp).toDate());
  //       });
  //
  //
  //       var filteredBookings = selectedStatus == "All"
  //           ? allBookings
  //           : allBookings.where((doc) {
  //         final data = doc.data() as Map<String, dynamic>;
  //         return (data['status'] ?? 'Pending') == selectedStatus;
  //       }).toList();
  //
  //       if (filteredBookings.isEmpty) {
  //         return _buildEmptyState(
  //           icon: Icons.event_busy_outlined,
  //           title: "No $selectedStatus bookings",
  //           subtitle: "You don't have any $selectedStatus bookings",
  //         );
  //       }
  //
  //       return ListView.separated(
  //         padding: const EdgeInsets.symmetric(vertical: 16),
  //         physics: const BouncingScrollPhysics(),
  //         itemCount: filteredBookings.length,
  //         separatorBuilder: (context, index) => const Divider(
  //           height: 1,
  //           indent: 20,
  //           endIndent: 20,
  //         ),
  //         itemBuilder: (context, index) {
  //           final data =
  //           filteredBookings[index].data() as Map<String, dynamic>;
  //           return _buildBookingItem(data);
  //         },
  //       );
  //     },
  //   );
  // }

  Widget _buildBookingsList() {
    if (_isLoading) {
      return _buildShimmerList(); // 🔥 ONLY shimmer
    }

    if (_allBookings.isEmpty) {
      return _buildEmptyState(
        icon: Icons.event_note_outlined,
        title: "No bookings yet",
        subtitle: "Your booking history will appear here",
      );
    }

    final filteredBookings = selectedStatus == "All"
        ? _allBookings
        : _allBookings.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return (data['status'] ?? 'Pending') == selectedStatus;
    }).toList();

    if (filteredBookings.isEmpty) {
      return _buildEmptyState(
        icon: Icons.event_busy_outlined,
        title: "No $selectedStatus bookings",
        subtitle: "You don't have any $selectedStatus bookings",
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: filteredBookings.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final data =
        filteredBookings[index].data() as Map<String, dynamic>;
        return _buildBookingItem(data);
      },
    );
  }




  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 20, width: 80, decoration: _shimmerBox()),
                const SizedBox(height: 12),
                Container(height: 16, width: double.infinity, decoration: _shimmerBox()),
                const SizedBox(height: 8),
                Container(height: 14, width: 150, decoration: _shimmerBox()),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(height: 14, width: 80, decoration: _shimmerBox()),
                    const Spacer(),
                    Container(height: 18, width: 60, decoration: _shimmerBox()),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _shimmerBox() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    );
  }


  Widget _buildBookingItem(Map<String, dynamic> data) {
    final status = data['status'] ?? 'Pending';
    final statusColor = _getStatusColor(status);

    /// 🔥 FIX: Normalize service_id (String or DocumentReference)
    final rawServiceId = data['service_id'];
    final String? serviceId = rawServiceId is String
        ? rawServiceId
        : rawServiceId is DocumentReference
        ? rawServiceId.id
        : null;

    final String serviceName =
    serviceId != null ? (_serviceNames[serviceId] ?? "") : "";

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        _showBookingDetails(data);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row - Status and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  _formatDate(data['service_date']),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ✅ Service Name (NO FutureBuilder, NO loading text)
            Text(
              serviceName.isNotEmpty ? serviceName : " ",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1D1E),
              ),
            ),

            const SizedBox(height: 8),

            // Booking ID
            Text(
              "Booking #${data['booking_id']}",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 12),

            // Time and Amount Row
            Row(
              children: [
                Icon(Icons.access_time_rounded,
                    size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Text(
                  data['service_time'] ?? "--",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (data['visit_charge'] != null) ...[
                  Text(
                    "₹${data['visit_charge']}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF00BFA5),
                    ),
                  ),
                ],
              ],
            ),

            // Action Buttons for Completed
            if (status == "Completed") ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _showBookingDetails(data);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF00BFA5),
                        side: const BorderSide(color: Color(0xFF00BFA5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        "View Details",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        HapticFeedback.lightImpact();
                        final providerId = data['employe_id'];

                        if (providerId == null) {
                          _showSnackBar("Provider not found");
                          return;
                        }

                        final providerSnap = await FirebaseFirestore.instance
                            .collection("employe_detail")
                            .doc(providerId)
                            .get();

                        if (!providerSnap.exists) {
                          _showSnackBar("Provider profile not available");
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProviderFullProfile(
                              customerId: widget.userId,
                              providerId: providerId,
                              providerData: providerSnap.data()!,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BFA5),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        "Book Again",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Cancel button for Pending
            if (status == "Pending") ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _showCancelDialog(data);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    "Cancel Booking",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }


  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF00BFA5).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: const Color(0xFF00BFA5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1D1E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Cancel Booking",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          "Are you sure you want to cancel this booking?",
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "No",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar("Booking cancelled successfully", isError: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Yes, Cancel",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDetails(Map<String, dynamic> data) {
    final bookingId = data['booking_id'];
    final status = data['status'] ?? 'Pending';
    final statusColor = _getStatusColor(status);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('booking_details')
                .doc(bookingId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final booking = snapshot.data!.data() as Map<String, dynamic>;

              return Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Booking Details",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1D1E),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),

                  // Body
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status Badge
                          // Status Badge (FULL WIDTH)
                          Container(
                            width: double.infinity, // ✅ full width
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: statusColor.withOpacity(0.3),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ),


                          const SizedBox(height: 24),

                          // Details List
                          _detailRow("Booking ID", booking['booking_id']),
                          _detailRow(
                            "Service Date",
                            _formatDate(booking['service_date']),
                          ),
                          _detailRow("Service Time", booking['service_time']),

                          if (booking['problem_description'] != null &&
                              booking['problem_description']
                                  .toString()
                                  .isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Text(
                              "Problem Description",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              booking['problem_description'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                                height: 1.5,
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 16),

                          // Payment Summary
                          const Text(
                            "Payment Summary",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1D1E),
                            ),
                          ),
                          const SizedBox(height: 16),

                          _amountRow("Visit Charge", booking['visit_charge']),
                          _amountRow(
                              "Service Amount", booking['service_amount']),
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),
                          _amountRow("Total Amount", booking['final_amount'],
                              isTotal: true),

                          if (booking['started_at'] != null) ...[
                            const SizedBox(height: 24),
                            _detailRow(
                              "Started At",
                              _formatDateTime(booking['started_at']),
                            ),
                          ],

                          if (booking['completed_at'] != null)
                            _detailRow(
                              "Completed At",
                              _formatDateTime(booking['completed_at']),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (status == "Completed")
                    _downloadBillButton(bookingId, booking),
                ],
              );
            },
          ),
        );
      },
    );
  }


  Widget _downloadBillButton(String bookingId, Map<String, dynamic> booking) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.download_rounded),
          label: const Text(
            "Download Bill",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00BFA5),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            await _downloadBill(bookingId, booking);
          },
        ),
      ),
    );
  }

  Future<void> _downloadBill(
      String bookingId,
      Map<String, dynamic> booking,
      ) async {
    try {
      // 1️⃣ Fetch bill
      final billQuery = await FirebaseFirestore.instance
          .collection('bill_details')
          .where('booking_id', isEqualTo: bookingId)
          .limit(1)
          .get();

      if (billQuery.docs.isEmpty) {
        _showSnackBar("Bill not found", isError: true);
        return;
      }

      final bill = billQuery.docs.first.data();


      // 2️⃣ Fetch service
      Map<String, dynamic>? service;
      if (booking['service_id'] != null) {
        final serviceSnap = await FirebaseFirestore.instance
            .collection('services')
            .doc(booking['service_id'])
            .get();
        if (serviceSnap.exists) service = serviceSnap.data();
      }

      // 3️⃣ Fetch employee
      Map<String, dynamic>? employee;
      if (booking['employe_id'] != null) {
        final empSnap = await FirebaseFirestore.instance
            .collection('employe_detail')
            .doc(booking['employe_id'])
            .get();
        if (empSnap.exists) employee = empSnap.data();
      }

      // 4️⃣ Generate PDF
      await BillPdfService.generateAndOpenPdf(
        billId: bookingId,
        bill: bill,
        booking: booking,
        service: service,
        employee: employee,
      );
    } catch (e) {
      _showSnackBar("Failed to download bill", isError: true);
    }
  }


  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1D1E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountRow(String label, dynamic amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 15 : 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              color: isTotal ? const Color(0xFF1A1D1E) : Colors.grey.shade700,
            ),
          ),
          Text(
            amount != null ? "₹$amount" : "--",
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: FontWeight.w700,
              color: isTotal ? const Color(0xFF00BFA5) : const Color(0xFF1A1D1E),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : const Color(0xFF00BFA5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  String _formatDate(Timestamp? ts) {
    if (ts == null) return "--";
    return DateFormat("dd MMM yyyy").format(ts.toDate());
  }

  String _formatDateTime(Timestamp ts) {
    return DateFormat("dd MMM yyyy, hh:mm a").format(ts.toDate());
  }
}