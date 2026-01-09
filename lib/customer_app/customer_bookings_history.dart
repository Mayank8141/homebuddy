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


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: const Color(0xFF00BFA5),
                indicatorWeight: 3,
                labelColor: const Color(0xFF00BFA5),
                unselectedLabelColor: const Color(0xFF6B7280),
                labelStyle: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                onTap: (index) {
                  setState(() {
                    selectedStatus = ["All", "Pending", "Accepted", "Completed"][index];
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
          _buildBookingsList(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF00BFA5),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 16),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "My Bookings",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('booking_details')
                  .where('customer_id', isEqualTo: widget.userId)
                  .snapshots(),
              builder: (context, snapshot) {
                final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "$count Total Bookings",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('booking_details')
          .where('customer_id', isEqualTo: widget.userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildShimmerCard(),
              childCount: 3,
            ),
          );
        }

        if (snapshot.hasError) {
          return SliverFillRemaining(
            child: _buildErrorState(snapshot.error.toString()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SliverFillRemaining(
            child: _buildEmptyState(),
          );
        }

        var allBookings = snapshot.data!.docs;

        // Filter by selected status
        var filteredBookings = selectedStatus == "All"
            ? allBookings
            : allBookings.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return (data['status'] ?? 'Pending') == selectedStatus;
        }).toList();

        if (filteredBookings.isEmpty) {
          return SliverFillRemaining(
            child: _buildEmptyState(status: selectedStatus),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final data = filteredBookings[index].data() as Map<String, dynamic>;
                return _buildBookingCard(data, index);
              },
              childCount: filteredBookings.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> data, int index) {
    String status = data['status'] ?? 'Pending';

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header Section
            _buildCardHeader(data, status),

            const Divider(height: 1, color: Color(0xFFE5E7EB)),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildServiceInfo(data),
                  const SizedBox(height: 16),
                  _buildDateTimeSection(data),
                  if (data['problem_description'] != null &&
                      data['problem_description'].toString().isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildProblemSection(data),
                  ],
                  const SizedBox(height: 16),
                  //_buildStatusTimeline(status),
                ],
              ),
            ),

            // Action Section
            _buildActionSection(data, status),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(Map<String, dynamic> data, String status) {
    final statusConfig = _getStatusConfig(status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusConfig['bgColor'],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              statusConfig['icon'],
              color: statusConfig['color'],
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Booking ID",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data['booking_id'] ?? 'N/A',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1F36),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusConfig['color'],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: statusConfig['color'].withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              status,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceInfo(Map<String, dynamic> data) {
    final String? serviceId = data['service_id'];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF00BFA5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.home_repair_service_rounded,
              color: Color(0xFF00BFA5),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          /// 🔥 FETCH SERVICE NAME
          Expanded(
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('services')
                  .doc(serviceId)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text(
                    "Loading service...",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  );
                }

                if (!snapshot.data!.exists) {
                  return Text(
                    "Service not found",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  );
                }

                final serviceData =
                snapshot.data!.data() as Map<String, dynamic>;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Service Type",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      serviceData['name'] ?? "Service",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1F36),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          if (data['visit_charge'] != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Amount",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                Text(
                  "₹${data['visit_charge']}",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF00BFA5),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }


  Widget _buildDateTimeSection(Map<String, dynamic> data) {
    String formattedDate = "N/A";
    if (data['service_date'] != null) {
      try {
        final date = (data['service_date'] as Timestamp).toDate();
        formattedDate = DateFormat('MMM dd, yyyy').format(date);
      } catch (e) {
        formattedDate = "N/A";
      }
    }

    return Row(
      children: [
        Expanded(
          child: _buildInfoItem(
            Icons.calendar_today_rounded,
            "Date",
            formattedDate,
            const Color(0xFF3B82F6),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoItem(
            Icons.access_time_rounded,
            "Time",
            data['service_time'] ?? "N/A",
            const Color(0xFF8B5CF6),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1F36),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemSection(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: Color(0xFFEF4444),
              ),
              const SizedBox(width: 6),
              Text(
                "Problem Description",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data['problem_description'] ?? '',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF374151),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildStatusTimeline(String status) {
  //   final steps = ['Pending', 'Accepted', 'Completed'];
  //   final currentIndex = steps.indexOf(status);
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         "Booking Progress",
  //         style: GoogleFonts.inter(
  //           fontSize: 13,
  //           fontWeight: FontWeight.w700,
  //           color: const Color(0xFF6B7280),
  //         ),
  //       ),
  //       const SizedBox(height: 12),
  //       Row(
  //         children: List.generate(steps.length, (index) {
  //           final isActive = index <= currentIndex;
  //           final isLast = index == steps.length - 1;
  //
  //           return Expanded(
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: Column(
  //                     children: [
  //                       Container(
  //                         width: 32,
  //                         height: 32,
  //                         decoration: BoxDecoration(
  //                           color: isActive
  //                               ? const Color(0xFF00BFA5)
  //                               : const Color(0xFFE5E7EB),
  //                           shape: BoxShape.circle,
  //                           boxShadow: isActive ? [
  //                             BoxShadow(
  //                               color: const Color(0xFF00BFA5).withOpacity(0.3),
  //                               blurRadius: 8,
  //                               offset: const Offset(0, 2),
  //                             ),
  //                           ] : null,
  //                         ),
  //                         child: Center(
  //                           child: Icon(
  //                             isActive ? Icons.check_rounded : Icons.circle,
  //                             size: isActive ? 20 : 8,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 6),
  //                       Text(
  //                         steps[index],
  //                         style: GoogleFonts.inter(
  //                           fontSize: 11,
  //                           fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
  //                           color: isActive
  //                               ? const Color(0xFF00BFA5)
  //                               : const Color(0xFF9CA3AF),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 if (!isLast)
  //                   Expanded(
  //                     child: Container(
  //                       height: 2,
  //                       margin: const EdgeInsets.only(bottom: 24),
  //                       color: isActive
  //                           ? const Color(0xFF00BFA5)
  //                           : const Color(0xFFE5E7EB),
  //                     ),
  //                   ),
  //               ],
  //             ),
  //           );
  //         }),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildActionSection(Map<String, dynamic> data, String status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: const Border(
          top: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Row(
        children: [
          if (status == "Pending") ...[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Cancel booking
                  _showCancelDialog(data);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFEF4444),
                  side: const BorderSide(color: Color(0xFFEF4444)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.close_rounded, size: 18),
                label: Text(
                  "Cancel",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // View details
                _showBookingDetails(data);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFA5),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.visibility_rounded, size: 18),
              label: Text(
                "View Details",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (status == "Completed") ...[
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final providerId = data['employe_id'];

                  if (providerId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Provider not found")),
                    );
                    return;
                  }

                  // 🔥 FETCH PROVIDER DATA
                  final providerSnap = await FirebaseFirestore.instance
                      .collection("employe_detail")
                      .doc(providerId)
                      .get();

                  if (!providerSnap.exists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Provider profile not available")),
                    );
                    return;
                  }

                  final providerData = providerSnap.data()!;

                  // 🔥 NAVIGATE TO PROVIDER PROFILE
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProviderFullProfile(
                        customerId: widget.userId,
                        providerId: providerId,
                        providerData: providerData,
                      ),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.replay_rounded, size: 18),
                label: Text(
                  "Rebook",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 14,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 100,
                      height: 12,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({String? status}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF00BFA5).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today_rounded,
                size: 64,
                color: const Color(0xFF00BFA5).withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              status != null ? "No $status Bookings" : "No Bookings Yet",
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1F36),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              status != null
                  ? "You don't have any $status bookings at the moment."
                  : "Start booking services to see your history here.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFA5),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              icon: const Icon(Icons.add_rounded),
              label: Text(
                "Book a Service",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Color(0xFFEF4444),
            ),
            const SizedBox(height: 16),
            Text(
              "Oops! Something went wrong",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1F36),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return {
          'color': const Color(0xFF10B981),
          'bgColor': const Color(0xFFD1FAE5),
          'icon': Icons.check_circle_rounded,
        };
      case 'completed':
        return {
          'color': const Color(0xFF3B82F6),
          'bgColor': const Color(0xFFDBEAFE),
          'icon': Icons.task_alt_rounded,
        };
      case 'rejected':
      case 'cancelled':
        return {
          'color': const Color(0xFFEF4444),
          'bgColor': const Color(0xFFFEE2E2),
          'icon': Icons.cancel_rounded,
        };
      default: // Pending
        return {
          'color': const Color(0xFFF59E0B),
          'bgColor': const Color(0xFFFEF3C7),
          'icon': Icons.pending_rounded,
        };
    }
  }

  void _showCancelDialog(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Cancel Booking",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          "Are you sure you want to cancel this booking?",
          style: GoogleFonts.inter(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "No",
              style: GoogleFonts.inter(
                color: const Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle cancellation
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Booking cancelled successfully",
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: const Color(0xFFEF4444),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Yes, Cancel",
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDetails(Map<String, dynamic> data) {
    final bookingId = data['booking_id'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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

              final booking =
              snapshot.data!.data() as Map<String, dynamic>;

              return Column(
                children: [
                  // ───── HEADER ─────
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Booking Details",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  // ───── BODY ─────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _statusBanner(booking['status']),
                          const SizedBox(height: 20),

                          _infoCard(
                            icon: Icons.confirmation_number_rounded,
                            title: "Booking ID",
                            value: booking['booking_id'],
                          ),

                          _infoCard(
                            icon: Icons.calendar_today_rounded,
                            title: "Service Date",
                            value: _formatDate(booking['service_date']),
                          ),

                          _infoCard(
                            icon: Icons.access_time_rounded,
                            title: "Service Time",
                            value: booking['service_time'],
                          ),

                          _problemCard(booking['problem_description']),
                          const SizedBox(height: 24),

                          Text(
                            "Payment Summary",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),

                          _amountRow(
                            "Visit Charge",
                            booking['visit_charge'],
                          ),
                          _amountRow(
                            "Service Amount",
                            booking['service_amount'],
                          ),
                          _amountRow(
                            "Final Amount",
                            booking['final_amount'],
                            isTotal: true,
                          ),

                          if (booking['started_at'] != null) ...[
                            const SizedBox(height: 20),
                            _infoCard(
                              icon: Icons.play_circle_fill_rounded,
                              title: "Started At",
                              value:
                              _formatDateTime(booking['started_at']),
                            ),
                          ],

                          if (booking['completed_at'] != null)
                            _infoCard(
                              icon: Icons.check_circle_rounded,
                              title: "Completed At",
                              value: _formatDateTime(
                                  booking['completed_at']),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

}

Widget _statusBanner(String status) {
  final config = _getStatusConfig(status);

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      color: config['bgColor'],
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          config['icon'],
          color: config['color'],
        ),
        const SizedBox(width: 8),
        Text(
          status,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: config['color'],
          ),
        ),
      ],
    ),
  );
}


Map<String, dynamic> _getStatusConfig(String status) {
  switch (status.toLowerCase()) {
    case 'accepted':
      return {
        'color': const Color(0xFF10B981),
        'bgColor': const Color(0xFFD1FAE5),
        'icon': Icons.check_circle_rounded,
      };
    case 'completed':
      return {
        'color': const Color(0xFF3B82F6),
        'bgColor': const Color(0xFFDBEAFE),
        'icon': Icons.task_alt_rounded,
      };
    case 'rejected':
    case 'cancelled':
      return {
        'color': const Color(0xFFEF4444),
        'bgColor': const Color(0xFFFEE2E2),
        'icon': Icons.cancel_rounded,
      };
    default: // Pending
      return {
        'color': const Color(0xFFF59E0B),
        'bgColor': const Color(0xFFFEF3C7),
        'icon': Icons.pending_rounded,
      };
  }
}

Widget _infoCard({
  required IconData icon,
  required String title,
  required String value,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF00BFA5).withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF00BFA5)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _problemCard(String problem) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFFEF2F2),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFFECACA)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.report_problem_rounded,
                color: Color(0xFFEF4444)),
            SizedBox(width: 6),
            Text(
              "Problem Description",
              style: TextStyle(

                fontWeight: FontWeight.w800,
                color: Color(0xFFEF4444),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          problem,
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}

Widget _amountRow(String label, dynamic amount,
    {bool isTotal = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: isTotal ? 15 : 14,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
        Text(
          amount != null ? "₹$amount" : "Pending",
          style: GoogleFonts.inter(
            fontSize: isTotal ? 18 : 15,
            fontWeight: FontWeight.w900,
            color: isTotal
                ? const Color(0xFF00BFA5)
                : const Color(0xFF1A1F36),
          ),
        ),
      ],
    ),
  );
}



Widget _detailTile(String title, dynamic value) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value?.toString() ?? "-",
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1F36),
          ),
        ),
      ],
    ),
  );
}

String _formatDate(Timestamp ts) {
  return DateFormat("dd MMM yyyy").format(ts.toDate());
}

String _formatDateTime(Timestamp ts) {
  return DateFormat("dd MMM yyyy • hh:mm a").format(ts.toDate());
}


// Custom SliverPersistentHeaderDelegate for TabBar
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}