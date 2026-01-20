// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:shimmer/shimmer.dart';
// //
// // import 'admin_dashboard.dart';
// // import 'admin_employe.dart';
// // import 'admin_services.dart';
// //
// // class admin_user_list extends StatefulWidget {
// //   const admin_user_list({super.key});
// //
// //   @override
// //   State<admin_user_list> createState() => _admin_user_listState();
// // }
// //
// // class _admin_user_listState extends State<admin_user_list> {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final TextEditingController searchController = TextEditingController();
// //
// //   int selectedIndex = 1;
// //
// //   // ================= SHIMMER =================
// //   Widget _buildShimmerCard() {
// //     return Shimmer.fromColors(
// //       baseColor: Colors.grey[300]!,
// //       highlightColor: Colors.grey[100]!,
// //       child: Container(
// //         margin: const EdgeInsets.only(bottom: 12),
// //         padding: const EdgeInsets.all(20),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(16),
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               children: [
// //                 const CircleAvatar(radius: 24),
// //                 const SizedBox(width: 16),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Container(
// //                         width: double.infinity,
// //                         height: 14,
// //                         color: Colors.white,
// //                       ),
// //                       const SizedBox(height: 8),
// //                       Container(
// //                         width: 150,
// //                         height: 12,
// //                         color: Colors.white,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 16),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Container(width: 80, height: 10, color: Colors.white),
// //                 Container(width: 60, height: 10, color: Colors.white),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // ================= DELETE USER =================
// //   void deleteUserPopup(String userId, String userName) {
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //         title: Row(
// //           children: const [
// //             Icon(Icons.warning_rounded, color: Colors.red, size: 28),
// //             SizedBox(width: 12),
// //             Text("Delete User"),
// //           ],
// //         ),
// //         content: Text(
// //           "Are you sure you want to delete $userName? This action cannot be undone.",
// //           style: const TextStyle(fontSize: 15),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: Text(
// //               "Cancel",
// //               style: TextStyle(
// //                 color: Colors.grey[600],
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //           ),
// //           ElevatedButton(
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Colors.red,
// //               elevation: 0,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
// //             ),
// //             onPressed: () async {
// //               await _firestore.collection("customer_detail").doc(userId).delete();
// //               Navigator.pop(context);
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 SnackBar(
// //                   content: Row(
// //                     children: const [
// //                       Icon(Icons.check_circle, color: Colors.white),
// //                       SizedBox(width: 12),
// //                       Text("User deleted successfully"),
// //                     ],
// //                   ),
// //                   backgroundColor: Colors.green,
// //                   behavior: SnackBarBehavior.floating,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                 ),
// //               );
// //             },
// //             child: const Text(
// //               "Delete",
// //               style: TextStyle(fontWeight: FontWeight.w600),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // ================= EDIT USER =================
// //   void openEditUserModal(String id, Map<String, dynamic> data) {
// //     final nameCtrl = TextEditingController(text: data["name"] ?? "");
// //     final emailCtrl = TextEditingController(text: data["email"] ?? "");
// //     final phoneCtrl = TextEditingController(text: data["phone"] ?? "");
// //
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: Colors.transparent,
// //       builder: (_) => Container(
// //         decoration: const BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
// //         ),
// //         padding: EdgeInsets.fromLTRB(
// //           24,
// //           24,
// //           24,
// //           MediaQuery.of(context).viewInsets.bottom + 24,
// //         ),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 const Text(
// //                   "Edit User",
// //                   style: TextStyle(
// //                     fontSize: 22,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.black87,
// //                   ),
// //                 ),
// //                 IconButton(
// //                   onPressed: () => Navigator.pop(context),
// //                   icon: const Icon(Icons.close_rounded),
// //                   style: IconButton.styleFrom(
// //                     backgroundColor: Colors.grey[100],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 24),
// //             _buildEditField(nameCtrl, "Full Name", Icons.person_outline_rounded),
// //             const SizedBox(height: 16),
// //             _buildEditField(emailCtrl, "Email", Icons.email_outlined),
// //             const SizedBox(height: 16),
// //             _buildEditField(phoneCtrl, "Phone", Icons.phone_outlined),
// //             const SizedBox(height: 24),
// //             SizedBox(
// //               width: double.infinity,
// //               height: 52,
// //               child: ElevatedButton(
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: const Color(0xFF1ABC9C),
// //                   elevation: 0,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(14),
// //                   ),
// //                 ),
// //                 onPressed: () async {
// //                   await _firestore.collection("customer_detail").doc(id).update({
// //                     "name": nameCtrl.text.trim(),
// //                     "email": emailCtrl.text.trim(),
// //                     "phone": phoneCtrl.text.trim(),
// //                   });
// //                   Navigator.pop(context);
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                       content: Row(
// //                         children: const [
// //                           Icon(Icons.check_circle, color: Colors.white),
// //                           SizedBox(width: 12),
// //                           Text("User updated successfully"),
// //                         ],
// //                       ),
// //                       backgroundColor: Colors.green,
// //                       behavior: SnackBarBehavior.floating,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                   );
// //                 },
// //                 child: const Text(
// //                   "Save Changes",
// //                   style: TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.w600,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildEditField(TextEditingController controller, String label, IconData icon) {
// //     return TextField(
// //       controller: controller,
// //       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
// //       decoration: InputDecoration(
// //         labelText: label,
// //         prefixIcon: Icon(icon, color: const Color(0xFF1ABC9C)),
// //         filled: true,
// //         fillColor: Colors.grey[50],
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(14),
// //           borderSide: BorderSide.none,
// //         ),
// //         enabledBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(14),
// //           borderSide: BorderSide(color: Colors.grey[200]!),
// //         ),
// //         focusedBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(14),
// //           borderSide: const BorderSide(color: Color(0xFF1ABC9C), width: 2),
// //         ),
// //         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
// //       ),
// //     );
// //   }
// //
// //   // ================= USER LIST =================
// //   Widget buildUserList() {
// //     return StreamBuilder<QuerySnapshot>(
// //       stream: _firestore
// //           .collection("customer_detail")
// //           .orderBy("created_at", descending: true)
// //           .snapshots(),
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           return ListView.builder(
// //             itemCount: 5,
// //             itemBuilder: (context, index) => _buildShimmerCard(),
// //           );
// //         }
// //
// //         if (!snapshot.hasData) {
// //           return const Center(child: CircularProgressIndicator());
// //         }
// //
// //         final users = snapshot.data!.docs.where((doc) {
// //           final data = doc.data() as Map<String, dynamic>;
// //           final name = (data["name"] ?? "").toString().toLowerCase();
// //           return name.contains(searchController.text.toLowerCase());
// //         }).toList();
// //
// //         if (users.isEmpty) {
// //           return Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.all(24),
// //                   decoration: BoxDecoration(
// //                     color: Colors.grey[100],
// //                     shape: BoxShape.circle,
// //                   ),
// //                   child: Icon(
// //                     searchController.text.isNotEmpty
// //                         ? Icons.search_off_rounded
// //                         : Icons.people_outline_rounded,
// //                     size: 64,
// //                     color: Colors.grey[400],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 24),
// //                 Text(
// //                   searchController.text.isNotEmpty
// //                       ? "No users found"
// //                       : "No users yet",
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.w600,
// //                     color: Colors.grey[700],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   searchController.text.isNotEmpty
// //                       ? "Try a different search term"
// //                       : "Users will appear here",
// //                   style: TextStyle(
// //                     fontSize: 14,
// //                     color: Colors.grey[500],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }
// //
// //         return ListView.builder(
// //           physics: const BouncingScrollPhysics(),
// //           itemCount: users.length,
// //           itemBuilder: (context, i) {
// //             final userDoc = users[i];
// //             final userId = userDoc.id;
// //             final data = userDoc.data() as Map<String, dynamic>;
// //
// //             final Timestamp? ts = data["created_at"];
// //             final joinDate = ts != null
// //                 ? DateFormat("dd MMM yyyy").format(ts.toDate())
// //                 : "N/A";
// //
// //             return Container(
// //               margin: const EdgeInsets.only(bottom: 12),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(16),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black.withOpacity(0.04),
// //                     blurRadius: 8,
// //                     offset: const Offset(0, 2),
// //                   ),
// //                 ],
// //               ),
// //               child: Material(
// //                 color: Colors.transparent,
// //                 child: InkWell(
// //                   borderRadius: BorderRadius.circular(16),
// //                   onTap: () {
// //                     // Navigate to user details
// //                   },
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(16),
// //                     child: Column(
// //                       children: [
// //                         Row(
// //                           children: [
// //                             Container(
// //                               width: 56,
// //                               height: 56,
// //                               decoration: BoxDecoration(
// //                                 gradient: LinearGradient(
// //                                   colors: [
// //                                     const Color(0xFF1ABC9C),
// //                                     const Color(0xFF16A085),
// //                                   ],
// //                                 ),
// //                                 borderRadius: BorderRadius.circular(14),
// //                               ),
// //                               child: data["image"] != null && data["image"].toString().isNotEmpty
// //                                   ? ClipRRect(
// //                                 borderRadius: BorderRadius.circular(14),
// //                                 child: Image.network(
// //                                   data["image"],
// //                                   fit: BoxFit.cover,
// //                                 ),
// //                               )
// //                                   : const Icon(
// //                                 Icons.person_rounded,
// //                                 color: Colors.white,
// //                                 size: 28,
// //                               ),
// //                             ),
// //                             const SizedBox(width: 16),
// //                             Expanded(
// //                               child: Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   Text(
// //                                     data["name"] ?? "Unknown",
// //                                     style: const TextStyle(
// //                                       fontSize: 17,
// //                                       fontWeight: FontWeight.bold,
// //                                       color: Colors.black87,
// //                                     ),
// //                                   ),
// //                                   const SizedBox(height: 4),
// //                                   Row(
// //                                     children: [
// //                                       Icon(
// //                                         Icons.email_outlined,
// //                                         size: 14,
// //                                         color: Colors.grey[600],
// //                                       ),
// //                                       const SizedBox(width: 6),
// //                                       Expanded(
// //                                         child: Text(
// //                                           data["email"] ?? "N/A",
// //                                           style: TextStyle(
// //                                             fontSize: 13,
// //                                             color: Colors.grey[600],
// //                                           ),
// //                                           overflow: TextOverflow.ellipsis,
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                   const SizedBox(height: 2),
// //                                   Row(
// //                                     children: [
// //                                       Icon(
// //                                         Icons.phone_outlined,
// //                                         size: 14,
// //                                         color: Colors.grey[600],
// //                                       ),
// //                                       const SizedBox(width: 6),
// //                                       Text(
// //                                         data["phone"] ?? "N/A",
// //                                         style: TextStyle(
// //                                           fontSize: 13,
// //                                           color: Colors.grey[600],
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         const SizedBox(height: 16),
// //                         Container(
// //                           padding: const EdgeInsets.all(12),
// //                           decoration: BoxDecoration(
// //                             color: Colors.grey[50],
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: Row(
// //                             children: [
// //                               Expanded(
// //                                 child: Column(
// //                                   crossAxisAlignment: CrossAxisAlignment.start,
// //                                   children: [
// //                                     Text(
// //                                       "Join Date",
// //                                       style: TextStyle(
// //                                         fontSize: 11,
// //                                         color: Colors.grey[600],
// //                                         fontWeight: FontWeight.w500,
// //                                       ),
// //                                     ),
// //                                     const SizedBox(height: 4),
// //                                     Text(
// //                                       joinDate,
// //                                       style: const TextStyle(
// //                                         fontSize: 13,
// //                                         fontWeight: FontWeight.w600,
// //                                         color: Colors.black87,
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                               Container(
// //                                 width: 1,
// //                                 height: 32,
// //                                 color: Colors.grey[300],
// //                               ),
// //                               Expanded(
// //                                 child: StreamBuilder<QuerySnapshot>(
// //                                   stream: _firestore
// //                                       .collection("booking_details")
// //                                       .where("customer_id", isEqualTo: userId)
// //                                       .snapshots(),
// //                                   builder: (context, bookingSnap) {
// //                                     final count = bookingSnap.hasData
// //                                         ? bookingSnap.data!.docs.length
// //                                         : 0;
// //
// //                                     return Column(
// //                                       crossAxisAlignment: CrossAxisAlignment.center,
// //                                       children: [
// //                                         Text(
// //                                           "Bookings",
// //                                           style: TextStyle(
// //                                             fontSize: 11,
// //                                             color: Colors.grey[600],
// //                                             fontWeight: FontWeight.w500,
// //                                           ),
// //                                         ),
// //                                         const SizedBox(height: 4),
// //                                         Text(
// //                                           "$count",
// //                                           style: const TextStyle(
// //                                             fontSize: 13,
// //                                             fontWeight: FontWeight.w600,
// //                                             color: Colors.black87,
// //                                           ),
// //                                         ),
// //                                       ],
// //                                     );
// //                                   },
// //                                 ),
// //                               ),
// //                               Container(
// //                                 width: 1,
// //                                 height: 32,
// //                                 color: Colors.grey[300],
// //                               ),
// //                               Expanded(
// //                                 child: Row(
// //                                   mainAxisAlignment: MainAxisAlignment.end,
// //                                   children: [
// //                                     _iconButton(
// //                                       Icons.edit_rounded,
// //                                       const Color(0xFF3B82F6),
// //                                           () => openEditUserModal(userId, data),
// //                                     ),
// //                                     const SizedBox(width: 8),
// //                                     _iconButton(
// //                                       Icons.delete_rounded,
// //                                       Colors.red,
// //                                           () => deleteUserPopup(userId, data["name"] ?? "User"),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// //
// //   Widget _iconButton(IconData icon, Color color, VoidCallback onTap) {
// //     return InkWell(
// //       onTap: onTap,
// //       borderRadius: BorderRadius.circular(10),
// //       child: Container(
// //         padding: const EdgeInsets.all(8),
// //         decoration: BoxDecoration(
// //           color: color.withOpacity(0.1),
// //           borderRadius: BorderRadius.circular(10),
// //         ),
// //         child: Icon(icon, size: 18, color: color),
// //       ),
// //     );
// //   }
// //
// //   // ================= UI =================
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF8F9FD),
// //       // appBar: AppBar(
// //       //   backgroundColor: Colors.white,
// //       //   elevation: 0,
// //       //   // leading: IconButton(
// //       //   //   icon: const Icon(Icons.arrow_back_ios_new, size: 20),
// //       //   //   color: Colors.black87,
// //       //   //   onPressed: () => Navigator.pop(context),
// //       //   // ),
// //       //   title: const Column(
// //       //     crossAxisAlignment: CrossAxisAlignment.start,
// //       //     children: [
// //       //       Center(
// //       //         child: Text(
// //       //           "User Management",
// //       //           style: TextStyle(
// //       //             fontSize: 20,
// //       //             fontWeight: FontWeight.bold,
// //       //             color: Colors.black87,
// //       //             letterSpacing: 0.2,
// //       //           ),
// //       //         ),
// //       //       ),
// //       //       // Text(
// //       //       //   "Manage all customers",
// //       //       //   style: TextStyle(
// //       //       //     fontSize: 12,
// //       //       //     color: Colors.grey,
// //       //       //     fontWeight: FontWeight.w500,
// //       //       //   ),
// //       //       // ),
// //       //     ],
// //       //   ),
// //       // ),
// //       body: Column(
// //         children: [
// //           Container(
// //             color: Colors.white,
// //             padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
// //             child: Column(
// //               children: [
// //                 const Divider(height: 5),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     const Text(
// //                       "All Users",
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.black87,
// //                       ),
// //                     ),
// //                     StreamBuilder<QuerySnapshot>(
// //                       stream: _firestore.collection("customer_detail").snapshots(),
// //                       builder: (_, snapshot) {
// //                         final total = snapshot.hasData ? snapshot.data!.docs.length : 0;
// //                         return Container(
// //                           padding: const EdgeInsets.symmetric(
// //                             horizontal: 12,
// //                             vertical: 6,
// //                           ),
// //                           decoration: BoxDecoration(
// //                             color: const Color(0xFF1ABC9C).withOpacity(0.1),
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: Text(
// //                             "$total Users",
// //                             style: const TextStyle(
// //                               fontSize: 13,
// //                               fontWeight: FontWeight.w600,
// //                               color: Color(0xFF1ABC9C),
// //                             ),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 16),
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 16),
// //                   decoration: BoxDecoration(
// //                     color: Colors.grey[100],
// //                     borderRadius: BorderRadius.circular(14),
// //                     border: Border.all(color: Colors.grey[200]!),
// //                   ),
// //                   child: TextField(
// //                     controller: searchController,
// //                     onChanged: (_) => setState(() {}),
// //                     style: const TextStyle(fontSize: 15),
// //                     decoration: InputDecoration(
// //                       icon: Icon(Icons.search_rounded, color: Colors.grey[600]),
// //                       hintText: "Search by name...",
// //                       hintStyle: TextStyle(color: Colors.grey[500]),
// //                       border: InputBorder.none,
// //                       contentPadding: const EdgeInsets.symmetric(vertical: 14),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             child: Padding(
// //               padding: const EdgeInsets.all(20),
// //               child: buildUserList(),
// //             ),
// //           ),
// //         ],
// //       ),
// //       // bottomNavigationBar: Container(
// //       //   decoration: BoxDecoration(
// //       //     color: Colors.white,
// //       //     boxShadow: [
// //       //       BoxShadow(
// //       //         color: Colors.black.withOpacity(0.05),
// //       //         blurRadius: 10,
// //       //         offset: const Offset(0, -5),
// //       //       ),
// //       //     ],
// //       //   ),
// //       //   child: SafeArea(
// //       //     child: BottomNavigationBar(
// //       //       currentIndex: selectedIndex,
// //       //       onTap: (i) {
// //       //         if (i == selectedIndex) return;
// //       //         if (i == 0)
// //       //           Navigator.pushReplacement(
// //       //             context,
// //       //             MaterialPageRoute(builder: (_) => admin_dashboard(uid: '')),
// //       //           );
// //       //         if (i == 2)
// //       //           Navigator.pushReplacement(
// //       //             context,
// //       //             MaterialPageRoute(builder: (_) => admin_employe_list()),
// //       //           );
// //       //         if (i == 3)
// //       //           Navigator.pushReplacement(
// //       //             context,
// //       //             MaterialPageRoute(builder: (_) => admin_services()),
// //       //           );
// //       //       },
// //       //       selectedItemColor: const Color(0xFF1ABC9C),
// //       //       unselectedItemColor: Colors.grey,
// //       //       selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
// //       //       type: BottomNavigationBarType.fixed,
// //       //       elevation: 0,
// //       //       backgroundColor: Colors.transparent,
// //       //       items: const [
// //       //         BottomNavigationBarItem(
// //       //           icon: Icon(Icons.dashboard_rounded),
// //       //           label: "Dashboard",
// //       //         ),
// //       //         BottomNavigationBarItem(
// //       //           icon: Icon(Icons.people_rounded),
// //       //           label: "Users",
// //       //         ),
// //       //         BottomNavigationBarItem(
// //       //           icon: Icon(Icons.engineering_rounded),
// //       //           label: "Providers",
// //       //         ),
// //       //         BottomNavigationBarItem(
// //       //           icon: Icon(Icons.home_repair_service_rounded),
// //       //           label: "Services",
// //       //         ),
// //       //       ],
// //       //     ),
// //       //   ),
// //       // ),
// //     );
// //   }
// // }
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shimmer/shimmer.dart';
//
// import 'admin_dashboard.dart';
// import 'admin_employe.dart';
// import 'admin_services.dart';
//
// class admin_user_list extends StatefulWidget {
//   const admin_user_list({super.key});
//
//   @override
//   State<admin_user_list> createState() => _admin_user_listState();
// }
//
// class _admin_user_listState extends State<admin_user_list> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final TextEditingController searchController = TextEditingController();
//
//   int selectedIndex = 1;
//
//
//   String? selectedCityId;
//   String? selectedCityName;
//
//   List<QueryDocumentSnapshot> cityDocs = [];
//   TextEditingController citySearchCtrl = TextEditingController();
//
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCities();
//   }
//
//   Future<void> fetchCities() async {
//     final snap = await _firestore
//         .collection("cities")
//         .orderBy("name_lowercase")
//         .get();
//
//     print("Cities count: ${snap.docs.length}");
//
//     setState(() {
//       cityDocs = snap.docs;
//     });
//   }
//
//
//   // ================= SHIMMER =================
//   Widget _buildShimmerCard() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const CircleAvatar(radius: 24),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         height: 14,
//                         color: Colors.white,
//                       ),
//                       const SizedBox(height: 8),
//                       Container(
//                         width: 150,
//                         height: 12,
//                         color: Colors.white,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(width: 80, height: 10, color: Colors.white),
//                 Container(width: 60, height: 10, color: Colors.white),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void openCityFilterSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (_) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             final filteredCities = cityDocs.where((doc) {
//               final name =
//               doc["name"].toString().toLowerCase();
//               return name.contains(
//                 citySearchCtrl.text.toLowerCase(),
//               );
//             }).toList();
//
//             return Padding(
//               padding: EdgeInsets.fromLTRB(
//                 20,
//                 20,
//                 20,
//                 MediaQuery.of(context).viewInsets.bottom + 20,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     "Select City",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//
//                   TextField(
//                     controller: citySearchCtrl,
//                     onChanged: (_) => setModalState(() {}),
//                     decoration: InputDecoration(
//                       hintText: "Search city...",
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   SizedBox(
//                     height: 300,
//                     child: ListView.builder(
//                       itemCount: filteredCities.length,
//                       itemBuilder: (_, i) {
//                         final doc = filteredCities[i];
//
//                         return ListTile(
//                           title: Text(doc["name"]),
//                           onTap: () {
//                             setState(() {
//                               selectedCityId = doc.id;
//                               selectedCityName = doc["name"];
//                             });
//                             citySearchCtrl.clear();
//                             Navigator.pop(context);
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//
//   // ================= DELETE USER =================
//   void deleteUserPopup(String userId, String userName) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: const [
//             Icon(Icons.warning_rounded, color: Colors.red, size: 28),
//             SizedBox(width: 12),
//             Text("Delete User"),
//           ],
//         ),
//         content: Text(
//           "Are you sure you want to delete $userName? This action cannot be undone.",
//           style: const TextStyle(fontSize: 15),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               "Cancel",
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             ),
//             onPressed: () async {
//               await _firestore.collection("customer_detail").doc(userId).delete();
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Row(
//                     children: const [
//                       Icon(Icons.check_circle, color: Colors.white),
//                       SizedBox(width: 12),
//                       Text("User deleted successfully"),
//                     ],
//                   ),
//                   backgroundColor: Colors.green,
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               );
//             },
//             child: const Text(
//               "Delete",
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ================= EDIT USER =================
//   void openEditUserModal(String id, Map<String, dynamic> data) {
//     final nameCtrl = TextEditingController(text: data["name"] ?? "");
//     final emailCtrl = TextEditingController(text: data["email"] ?? "");
//     final phoneCtrl = TextEditingController(text: data["phone"] ?? "");
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         padding: EdgeInsets.fromLTRB(
//           24,
//           24,
//           24,
//           MediaQuery.of(context).viewInsets.bottom + 24,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Edit User",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () => Navigator.pop(context),
//                   icon: const Icon(Icons.close_rounded),
//                   style: IconButton.styleFrom(
//                     backgroundColor: Colors.grey[100],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             _buildEditField(nameCtrl, "Full Name", Icons.person_outline_rounded),
//             const SizedBox(height: 16),
//             _buildEditField(emailCtrl, "Email", Icons.email_outlined),
//             const SizedBox(height: 16),
//             _buildEditField(phoneCtrl, "Phone", Icons.phone_outlined),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               height: 52,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1ABC9C),
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 onPressed: () async {
//                   await _firestore.collection("customer_detail").doc(id).update({
//                     "name": nameCtrl.text.trim(),
//                     "email": emailCtrl.text.trim(),
//                     "phone": phoneCtrl.text.trim(),
//                   });
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Row(
//                         children: const [
//                           Icon(Icons.check_circle, color: Colors.white),
//                           SizedBox(width: 12),
//                           Text("User updated successfully"),
//                         ],
//                       ),
//                       backgroundColor: Colors.green,
//                       behavior: SnackBarBehavior.floating,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   );
//                 },
//                 child: const Text(
//                   "Save Changes",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEditField(TextEditingController controller, String label, IconData icon) {
//     return TextField(
//       controller: controller,
//       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: const Color(0xFF1ABC9C)),
//         filled: true,
//         fillColor: Colors.grey[50],
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide(color: Colors.grey[200]!),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(color: Color(0xFF1ABC9C), width: 2),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       ),
//     );
//   }
//
//   // ================= USER LIST =================
//   Widget buildUserList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore
//           .collection("customer_detail")
//           .orderBy("created_at", descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return ListView.builder(
//             itemCount: 5,
//             itemBuilder: (context, index) => _buildShimmerCard(),
//           );
//         }
//
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         // final users = snapshot.data!.docs.where((doc) {
//         //   final data = doc.data() as Map<String, dynamic>;
//         //   final name = (data["name"] ?? "").toString().toLowerCase();
//         //   return name.contains(searchController.text.toLowerCase());
//         // }).toList();
//
//         final users = snapshot.data!.docs.where((doc) {
//           final data = doc.data() as Map<String, dynamic>;
//
//           final name =
//           (data["name"] ?? "").toString().toLowerCase();
//           final cityId = data["city_id"];
//
//           final nameMatch =
//           name.contains(searchController.text.toLowerCase());
//
//           final cityMatch =
//               selectedCityId == null || cityId == selectedCityId;
//
//           return nameMatch && cityMatch;
//         }).toList();
//
//
//         if (users.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     searchController.text.isNotEmpty
//                         ? Icons.search_off_rounded
//                         : Icons.people_outline_rounded,
//                     size: 64,
//                     color: Colors.grey[400],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Text(
//                   searchController.text.isNotEmpty
//                       ? "No users found"
//                       : "No users yet",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey[700],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   searchController.text.isNotEmpty
//                       ? "Try a different search term"
//                       : "Users will appear here",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[500],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return ListView.builder(
//           physics: const BouncingScrollPhysics(),
//           itemCount: users.length,
//           itemBuilder: (context, i) {
//             final userDoc = users[i];
//             final userId = userDoc.id;
//             final data = userDoc.data() as Map<String, dynamic>;
//
//             final Timestamp? ts = data["created_at"];
//             final joinDate = ts != null
//                 ? DateFormat("dd MMM yyyy").format(ts.toDate())
//                 : "N/A";
//
//             return Container(
//               margin: const EdgeInsets.only(bottom: 12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.04),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   borderRadius: BorderRadius.circular(16),
//                   onTap: () {
//                     // Navigate to user details
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               width: 56,
//                               height: 56,
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     const Color(0xFF1ABC9C),
//                                     const Color(0xFF16A085),
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(14),
//                               ),
//                               child: data["image"] != null && data["image"].toString().isNotEmpty
//                                   ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(14),
//                                 child: Image.network(
//                                   data["image"],
//                                   fit: BoxFit.cover,
//                                 ),
//                               )
//                                   : const Icon(
//                                 Icons.person_rounded,
//                                 color: Colors.white,
//                                 size: 28,
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     data["name"] ?? "Unknown",
//                                     style: const TextStyle(
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black87,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         Icons.email_outlined,
//                                         size: 14,
//                                         color: Colors.grey[600],
//                                       ),
//                                       const SizedBox(width: 6),
//                                       Expanded(
//                                         child: Text(
//                                           data["email"] ?? "N/A",
//                                           style: TextStyle(
//                                             fontSize: 13,
//                                             color: Colors.grey[600],
//                                           ),
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 2),
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         Icons.phone_outlined,
//                                         size: 14,
//                                         color: Colors.grey[600],
//                                       ),
//                                       const SizedBox(width: 6),
//                                       Text(
//                                         data["phone"] ?? "N/A",
//                                         style: TextStyle(
//                                           fontSize: 13,
//                                           color: Colors.grey[600],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[50],
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Join Date",
//                                       style: TextStyle(
//                                         fontSize: 11,
//                                         color: Colors.grey[600],
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       joinDate,
//                                       style: const TextStyle(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 width: 1,
//                                 height: 32,
//                                 color: Colors.grey[300],
//                               ),
//                               Expanded(
//                                 child: StreamBuilder<QuerySnapshot>(
//                                   stream: _firestore
//                                       .collection("booking_details")
//                                       .where("customer_id", isEqualTo: userId)
//                                       .snapshots(),
//                                   builder: (context, bookingSnap) {
//                                     final count = bookingSnap.hasData
//                                         ? bookingSnap.data!.docs.length
//                                         : 0;
//
//                                     return Column(
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           "Bookings",
//                                           style: TextStyle(
//                                             fontSize: 11,
//                                             color: Colors.grey[600],
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           "$count",
//                                           style: const TextStyle(
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.black87,
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 ),
//                               ),
//                               Container(
//                                 width: 1,
//                                 height: 32,
//                                 color: Colors.grey[300],
//                               ),
//                               Expanded(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     _iconButton(
//                                       Icons.edit_rounded,
//                                       const Color(0xFF3B82F6),
//                                           () => openEditUserModal(userId, data),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     _iconButton(
//                                       Icons.delete_rounded,
//                                       Colors.red,
//                                           () => deleteUserPopup(userId, data["name"] ?? "User"),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _iconButton(IconData icon, Color color, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(10),
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Icon(icon, size: 18, color: color),
//       ),
//     );
//   }
//
//   // ================= UI =================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FD),
//       // appBar: AppBar(
//       //   backgroundColor: Colors.white,
//       //   elevation: 0,
//       //   // leading: IconButton(
//       //   //   icon: const Icon(Icons.arrow_back_ios_new, size: 20),
//       //   //   color: Colors.black87,
//       //   //   onPressed: () => Navigator.pop(context),
//       //   // ),
//       //   title: const Column(
//       //     crossAxisAlignment: CrossAxisAlignment.start,
//       //     children: [
//       //       Center(
//       //         child: Text(
//       //           "User Management",
//       //           style: TextStyle(
//       //             fontSize: 20,
//       //             fontWeight: FontWeight.bold,
//       //             color: Colors.black87,
//       //             letterSpacing: 0.2,
//       //           ),
//       //         ),
//       //       ),
//       //       // Text(
//       //       //   "Manage all customers",
//       //       //   style: TextStyle(
//       //       //     fontSize: 12,
//       //       //     color: Colors.grey,
//       //       //     fontWeight: FontWeight.w500,
//       //       //   ),
//       //       // ),
//       //     ],
//       //   ),
//       // ),
//       body: Column(
//         children: [
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//             child: Column(
//               children: [
//                 const Divider(height: 5),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "All Users",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     StreamBuilder<QuerySnapshot>(
//                       stream: _firestore.collection("customer_detail").snapshots(),
//                       builder: (_, snapshot) {
//                         final total = snapshot.hasData ? snapshot.data!.docs.length : 0;
//                         return Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 6,
//                           ),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF1ABC9C).withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             "$total Users",
//                             style: const TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF1ABC9C),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(14),
//                     border: Border.all(color: Colors.grey[200]!),
//                   ),
//                   child: TextField(
//                     controller: searchController,
//                     onChanged: (_) => setState(() {}),
//                     style: const TextStyle(fontSize: 15),
//                     decoration: InputDecoration(
//                       icon: Icon(Icons.search_rounded, color: Colors.grey[600]),
//                       hintText: "Search by name...",
//                       hintStyle: TextStyle(color: Colors.grey[500]),
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.symmetric(vertical: 14),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 Row(
//                   children: [
//                     Expanded(
//                       child: selectedCityName == null
//                           ? const Text(
//                         "All Cities",
//                         style: TextStyle(fontSize: 14, color: Colors.grey),
//                       )
//                           : Chip(
//                         label: Text(selectedCityName!),
//                         onDeleted: () {
//                           setState(() {
//                             selectedCityId = null;
//                             selectedCityName = null;
//                           });
//                         },
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.filter_list_rounded),
//                       onPressed: openCityFilterSheet,
//                     ),
//                   ],
//                 ),
//
//               ],
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: buildUserList(),
//             ),
//           ),
//         ],
//       ),
//       // bottomNavigationBar: Container(
//       //   decoration: BoxDecoration(
//       //     color: Colors.white,
//       //     boxShadow: [
//       //       BoxShadow(
//       //         color: Colors.black.withOpacity(0.05),
//       //         blurRadius: 10,
//       //         offset: const Offset(0, -5),
//       //       ),
//       //     ],
//       //   ),
//       //   child: SafeArea(
//       //     child: BottomNavigationBar(
//       //       currentIndex: selectedIndex,
//       //       onTap: (i) {
//       //         if (i == selectedIndex) return;
//       //         if (i == 0)
//       //           Navigator.pushReplacement(
//       //             context,
//       //             MaterialPageRoute(builder: (_) => admin_dashboard(uid: '')),
//       //           );
//       //         if (i == 2)
//       //           Navigator.pushReplacement(
//       //             context,
//       //             MaterialPageRoute(builder: (_) => admin_employe_list()),
//       //           );
//       //         if (i == 3)
//       //           Navigator.pushReplacement(
//       //             context,
//       //             MaterialPageRoute(builder: (_) => admin_services()),
//       //           );
//       //       },
//       //       selectedItemColor: const Color(0xFF1ABC9C),
//       //       unselectedItemColor: Colors.grey,
//       //       selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
//       //       type: BottomNavigationBarType.fixed,
//       //       elevation: 0,
//       //       backgroundColor: Colors.transparent,
//       //       items: const [
//       //         BottomNavigationBarItem(
//       //           icon: Icon(Icons.dashboard_rounded),
//       //           label: "Dashboard",
//       //         ),
//       //         BottomNavigationBarItem(
//       //           icon: Icon(Icons.people_rounded),
//       //           label: "Users",
//       //         ),
//       //         BottomNavigationBarItem(
//       //           icon: Icon(Icons.engineering_rounded),
//       //           label: "Providers",
//       //         ),
//       //         BottomNavigationBarItem(
//       //           icon: Icon(Icons.home_repair_service_rounded),
//       //           label: "Services",
//       //         ),
//       //       ],
//       //     ),
//       //   ),
//       // ),
//     );
//   }
// }
//



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'admin_dashboard.dart';
import 'admin_employe.dart';
import 'admin_services.dart';

class admin_user_list extends StatefulWidget {
  const admin_user_list({super.key});

  @override
  State<admin_user_list> createState() => _admin_user_listState();
}

class _admin_user_listState extends State<admin_user_list> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _citySearchController = TextEditingController();

  int selectedIndex = 1;
  static const Color _primaryColor = Color(0xFF1ABC9C);
  static const Color _secondaryColor = Color(0xFF16A085);

  String? _selectedCityId;
  String? _selectedCityName;
  List<QueryDocumentSnapshot> _cityDocs = [];

  @override
  void initState() {
    super.initState();
    _fetchCities();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _citySearchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCities() async {
    try {
      final snapshot = await _firestore
          .collection("cities")
          .orderBy("name_lowercase")
          .get();

      if (mounted) {
        setState(() {
          _cityDocs = snapshot.docs;
        });
      }
    } catch (e) {
      debugPrint("Cities loaded: ${_cityDocs.length}");

    }
  }

  // ================= SHIMMER LOADING =================
  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 200,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 160,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(height: 1, color: Colors.grey[200]),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(height: 40, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(height: 40, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Container(width: 80, height: 40, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

// ================= CITY FILTER SHEET =================
  void _openCityFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModal) {
            final filteredCities = _cityDocs.where((d) {
              final name =
                  (d.data() as Map<String, dynamic>)["name_lowercase"] ?? "";
              return name
                  .toString()
                  .contains(_citySearchController.text.toLowerCase());
            }).toList();



            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Filter Users",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            child: const Icon(
                              Icons.close,
                              size: 24,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        0,
                        20,
                        MediaQuery.of(context).viewInsets.bottom + 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Filter by City
                          Text(
                            "Filter by City",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 10),

                          // City Search
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: _citySearchController,
                              onChanged: (_) => setModal(() {}),
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "Search city...",
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.location_city,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // City List
                          Container(
                            constraints: const BoxConstraints(maxHeight: 300),
                            child: filteredCities.isEmpty
                                ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.location_off_outlined,
                                      size: 48,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "No cities found",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                : ListView(
                              shrinkWrap: true,
                              children: filteredCities.map((doc) {
                                final isSelected = _selectedCityId == doc.id;
                                return InkWell(
                                  onTap: () {
                                    setModal(() {
                                      if (isSelected) {
                                        _selectedCityId = null;
                                        _selectedCityName = null;
                                      } else {
                                        _selectedCityId = doc.id;
                                        _selectedCityName = doc["name"];
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          doc["name"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: isSelected
                                                ? const Color(0xFF1ABC9C)
                                                : Colors.black87,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        if (isSelected)
                                          const Icon(
                                            Icons.check_circle,
                                            color: Color(0xFF1ABC9C),
                                            size: 20,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Buttons
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedCityId = null;
                                  _selectedCityName = null;
                                });
                                setModal(() {});
                                _citySearchController.clear();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: BorderSide(color: Colors.grey[300]!),
                              ),
                              child: Text(
                                "Clear All",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {});
                                _citySearchController.clear();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1ABC9C),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "Apply Filters",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ================= DELETE USER DIALOG =================
  void _showDeleteUserDialog(String userId, String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(28),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Delete User",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Are you sure you want to delete $userName? This action cannot be undone.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        await _firestore
                            .collection("customer_detail")
                            .doc(userId)
                            .delete();
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: const [
                                  Icon(Icons.check_circle_rounded,
                                      color: Colors.white, size: 20),
                                  SizedBox(width: 12),
                                  Text("User deleted successfully"),
                                ],
                              ),
                              backgroundColor: Colors.green[600],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.all(16),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error: $e"),
                              backgroundColor: Colors.red[600],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.all(16),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= EDIT USER MODAL =================
  void _openEditUserModal(String id, Map<String, dynamic> data) {
    final nameController = TextEditingController(text: data["name"] ?? "");
    final emailController = TextEditingController(text: data["email"] ?? "");
    final phoneController = TextEditingController(text: data["phone"] ?? "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Edit User Details",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: -0.5,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, size: 20),
                    color: Colors.grey[700],
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildEditField(
                nameController, "Full Name", Icons.person_outline_rounded),
            const SizedBox(height: 16),
            _buildEditField(
                emailController, "Email Address", Icons.email_outlined),
            const SizedBox(height: 16),
            _buildEditField(
                phoneController, "Phone Number", Icons.phone_outlined),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  try {
                    await _firestore
                        .collection("customer_detail")
                        .doc(id)
                        .update({
                      "name": nameController.text.trim(),
                      "email": emailController.text.trim(),
                      "phone": phoneController.text.trim(),
                    });
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: const [
                              Icon(Icons.check_circle_rounded,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 12),
                              Text("User updated successfully"),
                            ],
                          ),
                          backgroundColor: Colors.green[600],
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error: $e"),
                          backgroundColor: Colors.red[600],
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(
      TextEditingController controller, String label, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          prefixIcon: Icon(icon, color: _primaryColor, size: 22),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    );
  }

  // ================= USER LIST BUILDER =================
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection("customer_detail")
          .orderBy("created_at", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) =>
                _buildShimmerCard(),
          );
        }

        if (!snapshot.hasData || snapshot.hasError) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final name = (data["name"] ?? "").toString().toLowerCase();
          final cityId = data["city_id"];

          final nameMatch =
          name.contains(_searchController.text.toLowerCase());
          final cityMatch =
              _selectedCityId == null || cityId == _selectedCityId;

          return nameMatch && cityMatch;
        }).toList();

        if (users.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            final userDoc = users[index];
            final userId = userDoc.id;
            final data = userDoc.data() as Map<String, dynamic>;

            return _buildUserCard(userId, data);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              _searchController.text.isNotEmpty || _selectedCityId != null
                  ? Icons.search_off_rounded
                  : Icons.people_outline_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _searchController.text.isNotEmpty || _selectedCityId != null
                ? "No users found"
                : "No users yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _searchController.text.isNotEmpty || _selectedCityId != null
                  ? "Try adjusting your search or filter criteria"
                  : "Users will appear here once they're added to the system",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(String userId, Map<String, dynamic> data) {
    final Timestamp? timestamp = data["created_at"];
    final joinDate = timestamp != null
        ? DateFormat("MMM dd, yyyy").format(timestamp.toDate())
        : "N/A";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to user details
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserAvatar(data),
                    const SizedBox(width: 16),
                    Expanded(child: _buildUserInfo(data)),
                  ],
                ),
                const SizedBox(height: 18),
                Divider(height: 1, color: Colors.grey[200]),
                const SizedBox(height: 18),
                _buildUserStats(userId, joinDate, data),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(Map<String, dynamic> data) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_primaryColor, _secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: data["image"] != null && data["image"].toString().isNotEmpty
          ? ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          data["image"],
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.person_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
      )
          : const Icon(
        Icons.person_rounded,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget _buildUserInfo(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data["name"] ?? "Unknown User",
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.email_outlined, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                data["email"] ?? "No email",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.phone_outlined, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 6),
            Text(
              data["phone"] ?? "No phone",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserStats(
      String userId, String joinDate, Map<String, dynamic> data) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            icon: Icons.calendar_today_outlined,
            label: "Joined",
            value: joinDate,
          ),
        ),
        Container(
          width: 1,
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          color: Colors.grey[200],
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection("booking_details")
                .where("customer_id", isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
              return _buildStatItem(
                icon: Icons.receipt_long_outlined,
                label: "Bookings",
                value: "$count",
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Row(
          children: [
            _buildActionButton(
              icon: Icons.edit_outlined,
              color: const Color(0xFF3B82F6),
              onTap: () => _openEditUserModal(userId, data),
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              icon: Icons.delete_outline_rounded,
              color: Colors.red,
              onTap: () =>
                  _showDeleteUserDialog(userId, data["name"] ?? "User"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: color.withOpacity(0.2),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }

  // ================= MAIN UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _buildUserList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "All Users",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: -0.8,
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection("customer_detail").snapshots(),
                builder: (_, snapshot) {
                  final total =
                  snapshot.hasData ? snapshot.data!.docs.length : 0;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _primaryColor.withOpacity(0.15),
                          _primaryColor.withOpacity(0.08)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border:
                      Border.all(color: _primaryColor.withOpacity(0.25)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.people_outline_rounded,
                          size: 18,
                          color: _primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "$total",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _primaryColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search_rounded,
                    color: Colors.grey[600], size: 22),
                hintText: "Search by name...",
                hintStyle: TextStyle(
                    color: Colors.grey[500], fontWeight: FontWeight.w400),
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _selectedCityName == null
                    ? Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 18, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      "All Cities",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
                    : Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: _primaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_city_rounded,
                          size: 16, color: _primaryColor),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _selectedCityName!,
                          style: const TextStyle(
                            color: _primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCityId = null;
                            _selectedCityName = null;
                          });
                        },
                        child: const Icon(Icons.close_rounded,
                            size: 18, color: _primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: IconButton(
                  icon: const Icon(Icons.filter_list_rounded, size: 20),
                  color: Colors.grey[700],
                  onPressed: _openCityFilterSheet,
                  padding: const EdgeInsets.all(12),
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}