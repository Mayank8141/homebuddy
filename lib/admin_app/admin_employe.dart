// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shimmer/shimmer.dart';
//
// import 'admin_dashboard.dart';
// import 'admin_users.dart';
// import 'admin_services.dart';
//
// class admin_employe_list extends StatefulWidget {
//   const admin_employe_list({super.key});
//
//   @override
//   State<admin_employe_list> createState() => _admin_employe_listState();
// }
//
// class _admin_employe_listState extends State<admin_employe_list> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   TextEditingController searchController = TextEditingController();
//
//   int selectedIndex = 2;
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
//                       Container(width: double.infinity, height: 14, color: Colors.white),
//                       const SizedBox(height: 8),
//                       Container(width: 150, height: 12, color: Colors.white),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(width: 60, height: 10, color: Colors.white),
//                 Container(width: 60, height: 10, color: Colors.white),
//                 Container(width: 60, height: 10, color: Colors.white),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ================= DELETE =================
//   void deleteEmployee(String id, String name) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: const [
//             Icon(Icons.warning_rounded, color: Colors.red, size: 28),
//             SizedBox(width: 12),
//             Text("Delete Employee"),
//           ],
//         ),
//         content: Text(
//           "Are you sure you want to delete $name? This action cannot be undone.",
//           style: const TextStyle(fontSize: 15),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               "Cancel",
//               style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               elevation: 0,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             ),
//             onPressed: () async {
//               await _firestore.collection("employe_detail").doc(id).delete();
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Row(
//                     children: const [
//                       Icon(Icons.check_circle, color: Colors.white),
//                       SizedBox(width: 12),
//                       Text("Employee deleted successfully"),
//                     ],
//                   ),
//                   backgroundColor: Colors.green,
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//               );
//             },
//             child: const Text("Delete", style: TextStyle(fontWeight: FontWeight.w600)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ================= EDIT MODAL =================
//   void openEditEmployee(String id, Map<String, dynamic> data) {
//     TextEditingController nameCtrl = TextEditingController(text: data["name"]);
//     TextEditingController emailCtrl = TextEditingController(text: data["email"]);
//     TextEditingController phoneCtrl = TextEditingController(text: data["phone"]);
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
//                   "Edit Employee",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () => Navigator.pop(context),
//                   icon: const Icon(Icons.close_rounded),
//                   style: IconButton.styleFrom(backgroundColor: Colors.grey[100]),
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
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//                 ),
//                 onPressed: () async {
//                   await _firestore.collection("employe_detail").doc(id).update({
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
//                           Text("Employee updated successfully"),
//                         ],
//                       ),
//                       backgroundColor: Colors.green,
//                       behavior: SnackBarBehavior.floating,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     ),
//                   );
//                 },
//                 child: const Text(
//                   "Save Changes",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
//   // ================= LIST UI =================
//   Widget buildEmployeeList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore.collection("employe_detail").snapshots(),
//       builder: (_, snapshot) {
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
//         final docs = snapshot.data!.docs;
//
//         final employees = docs.where((d) {
//           final data = d.data() as Map<String, dynamic>;
//           final name = (data["name"] ?? "").toString().toLowerCase();
//           return name.contains(searchController.text.toLowerCase());
//         }).toList();
//
//         if (employees.isEmpty) {
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
//                         : Icons.engineering_outlined,
//                     size: 64,
//                     color: Colors.grey[400],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Text(
//                   searchController.text.isNotEmpty
//                       ? "No employees found"
//                       : "No employees yet",
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
//                       : "Employees will appear here",
//                   style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return ListView.builder(
//           physics: const BouncingScrollPhysics(),
//           itemCount: employees.length,
//           itemBuilder: (_, index) {
//             final emp = employees[index];
//             final empId = emp.id;
//             final data = emp.data() as Map<String, dynamic>;
//
//             String joinDate = "N/A";
//
//             Timestamp? created;
//
//             if (data["createdAt"] != null && data["createdAt"] is Timestamp) {
//               created = data["createdAt"];
//             } else if (data["created_at"] != null && data["created_at"] is Timestamp) {
//               created = data["created_at"];
//             }
//
//             if (created != null) {
//               joinDate = DateFormat("dd MMM yyyy").format(created.toDate());
//             }
//
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
//                     // Navigate to employee details
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
//                                     const Color(0xFF10B981),
//                                     const Color(0xFF059669),
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(14),
//                               ),
//                               child: data["image"] != null &&
//                                   data["image"].toString().isNotEmpty
//                                   ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(14),
//                                 child: Image.network(
//                                   data["image"],
//                                   fit: BoxFit.cover,
//                                 ),
//                               )
//                                   : const Icon(
//                                 Icons.engineering_rounded,
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
//                                       .where("employe_id", isEqualTo: empId)
//                                       .snapshots(),
//                                   builder: (_, jobSnap) {
//                                     final count = jobSnap.hasData
//                                         ? jobSnap.data!.docs.length
//                                         : 0;
//
//                                     return Column(
//                                       children: [
//                                         Text(
//                                           "Jobs",
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
//                                 child: StreamBuilder<QuerySnapshot>(
//                                   stream: _firestore
//                                       .collection("feedback_details")
//                                       .where("employee_id", isEqualTo: empId)
//                                       .snapshots(),
//                                   builder: (_, rateSnap) {
//                                     if (!rateSnap.hasData ||
//                                         rateSnap.data!.docs.isEmpty) {
//                                       return Column(
//                                         children: [
//                                           Text(
//                                             "Rating",
//                                             style: TextStyle(
//                                               fontSize: 11,
//                                               color: Colors.grey[600],
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 4),
//                                           Text(
//                                             "--",
//                                             style: TextStyle(
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.grey[500],
//                                             ),
//                                           ),
//                                         ],
//                                       );
//                                     }
//
//                                     double sum = 0;
//                                     for (var d in rateSnap.data!.docs) {
//                                       sum += (d["rating"] ?? 0).toDouble();
//                                     }
//                                     final avg = sum / rateSnap.data!.docs.length;
//
//                                     return Column(
//                                       children: [
//                                         Text(
//                                           "Rating",
//                                           style: TextStyle(
//                                             fontSize: 11,
//                                             color: Colors.grey[600],
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                           children: [
//                                             const Icon(
//                                               Icons.star_rounded,
//                                               color: Colors.amber,
//                                               size: 14,
//                                             ),
//                                             const SizedBox(width: 4),
//                                             Text(
//                                               avg.toStringAsFixed(1),
//                                               style: const TextStyle(
//                                                 fontSize: 13,
//                                                 fontWeight: FontWeight.w600,
//                                                 color: Colors.black87,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 32,
//                                 child: VerticalDivider(
//                                   thickness: 1,
//                                   color: Colors.grey[300],
//                                 ),
//                               ),
//
//
//                               SizedBox(
//                                 width: 78, // 🔥 fixed width prevents overflow
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     _iconButton(
//                                       Icons.edit_rounded,
//                                       const Color(0xFF3B82F6),
//                                           () => openEditEmployee(empId, data),
//                                     ),
//                                     const SizedBox(width: 6),
//                                     _iconButton(
//                                       Icons.delete_rounded,
//                                       Colors.red,
//                                           () => deleteEmployee(empId, data["name"] ?? "Employee"),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//
//
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
//       //           "Employee Management",
//       //           style: TextStyle(
//       //             fontSize: 20,
//       //             fontWeight: FontWeight.bold,
//       //             color: Colors.black87,
//       //             letterSpacing: 0.2,
//       //           ),
//       //         ),
//       //       ),
//       //       // Text(
//       //       //   "Manage all service providers",
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
//
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "All Employees",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     StreamBuilder<QuerySnapshot>(
//                       stream: _firestore.collection("employe_detail").snapshots(),
//                       builder: (_, snapshot) {
//                         final total =
//                         snapshot.hasData ? snapshot.data!.docs.length : 0;
//                         return Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 6,
//                           ),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF10B981).withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             "$total Providers",
//                             style: const TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF10B981),
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
//               ],
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: buildEmployeeList(),
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
//       //       onTap: (index) {
//       //         if (index == selectedIndex) return;
//       //         if (index == 0)
//       //           Navigator.pushReplacement(
//       //             context,
//       //             MaterialPageRoute(builder: (_) => admin_dashboard(uid: '')),
//       //           );
//       //         if (index == 1)
//       //           Navigator.pushReplacement(
//       //             context,
//       //             MaterialPageRoute(builder: (_) => admin_user_list()),
//       //           );
//       //         if (index == 3)
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'admin_dashboard.dart';
import 'admin_users.dart';
import 'admin_services.dart';

class admin_employe_list extends StatefulWidget {
  const admin_employe_list({super.key});

  @override
  State<admin_employe_list> createState() => _admin_employe_listState();
}

class _admin_employe_listState extends State<admin_employe_list> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();

  int selectedIndex = 2;


  String? selectedCityId;
  String? selectedCityName;

  String? selectedServiceId;
  String? selectedServiceName;

  List<QueryDocumentSnapshot> cityDocs = [];
  List<QueryDocumentSnapshot> serviceDocs = [];

  TextEditingController citySearchCtrl = TextEditingController();
  TextEditingController serviceSearchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCities();
    fetchServices();
  }

  Future<void> fetchCities() async {
    final snap = await _firestore.collection("cities").get();
    setState(() => cityDocs = snap.docs);
  }

  Future<void> fetchServices() async {
    final snap = await _firestore.collection("services").get();
    setState(() => serviceDocs = snap.docs);
  }


  void openEmployeeFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModal) {
            final cityFiltered = cityDocs.where((d) {
              final name = d["name"].toString().toLowerCase();
              return name.contains(citySearchCtrl.text.toLowerCase());
            }).toList();

            final serviceFiltered = serviceDocs.where((d) {
              final name = d["name"].toString().toLowerCase();
              return name.contains(serviceSearchCtrl.text.toLowerCase());
            }).toList();

            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SizedBox(
                height: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Filter Employees",
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// CITY SEARCH
                    TextField(
                      controller: citySearchCtrl,
                      onChanged: (_) => setModal(() {}),
                      decoration: const InputDecoration(
                        labelText: "Search City",
                        prefixIcon: Icon(Icons.location_city),
                      ),
                    ),
                    const SizedBox(height: 8),

                    SizedBox(
                      height: 120,
                      child: ListView(
                        children: cityFiltered.map((doc) {
                          return ListTile(
                            title: Text(doc["name"]),
                            onTap: () {
                              setState(() {
                                selectedCityId = doc.id;
                                selectedCityName = doc["name"];
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),

                    const Divider(),

                    /// SERVICE SEARCH
                    TextField(
                      controller: serviceSearchCtrl,
                      onChanged: (_) => setModal(() {}),
                      decoration: const InputDecoration(
                        labelText: "Search Service",
                        prefixIcon: Icon(Icons.home_repair_service),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Expanded(
                      child: ListView(
                        children: serviceFiltered.map((doc) {
                          return ListTile(
                            title: Text(doc["name"]),
                            onTap: () {
                              setState(() {
                                selectedServiceId = doc.id;
                                selectedServiceName = doc["name"];
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          citySearchCtrl.clear();
                          serviceSearchCtrl.clear();
                          Navigator.pop(context);
                        },
                        child: const Text("Apply Filter"),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  // ================= SHIMMER =================
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: double.infinity, height: 14, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(width: 150, height: 12, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 60, height: 10, color: Colors.white),
                Container(width: 60, height: 10, color: Colors.white),
                Container(width: 60, height: 10, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= DELETE =================
  void deleteEmployee(String id, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.warning_rounded, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text("Delete Employee"),
          ],
        ),
        content: Text(
          "Are you sure you want to delete $name? This action cannot be undone.",
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () async {
              await _firestore.collection("employe_detail").doc(id).delete();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: const [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Text("Employee deleted successfully"),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: const Text("Delete", style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ================= EDIT MODAL =================
  void openEditEmployee(String id, Map<String, dynamic> data) {
    TextEditingController nameCtrl = TextEditingController(text: data["name"]);
    TextEditingController emailCtrl = TextEditingController(text: data["email"]);
    TextEditingController phoneCtrl = TextEditingController(text: data["phone"]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Edit Employee",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(backgroundColor: Colors.grey[100]),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildEditField(nameCtrl, "Full Name", Icons.person_outline_rounded),
            const SizedBox(height: 16),
            _buildEditField(emailCtrl, "Email", Icons.email_outlined),
            const SizedBox(height: 16),
            _buildEditField(phoneCtrl, "Phone", Icons.phone_outlined),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1ABC9C),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () async {
                  await _firestore.collection("employe_detail").doc(id).update({
                    "name": nameCtrl.text.trim(),
                    "email": emailCtrl.text.trim(),
                    "phone": phoneCtrl.text.trim(),
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: const [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 12),
                          Text("Employee updated successfully"),
                        ],
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1ABC9C)),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF1ABC9C), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  // ================= LIST UI =================
  Widget buildEmployeeList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("employe_detail").snapshots(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => _buildShimmerCard(),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        // final employees = docs.where((d) {
        //   final data = d.data() as Map<String, dynamic>;
        //   final name = (data["name"] ?? "").toString().toLowerCase();
        //   return name.contains(searchController.text.toLowerCase());
        // }).toList();

        final employees = docs.where((d) {
          final data = d.data() as Map<String, dynamic>;

          final name =
          (data["name"] ?? "").toString().toLowerCase();
          final cityId = data["city_id"];
          final serviceId = data["service_id"];

          final nameMatch =
          name.contains(searchController.text.toLowerCase());

          final cityMatch =
              selectedCityId == null || cityId == selectedCityId;

          final serviceMatch =
              selectedServiceId == null || serviceId == selectedServiceId;

          return nameMatch && cityMatch && serviceMatch;
        }).toList();


        if (employees.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    searchController.text.isNotEmpty
                        ? Icons.search_off_rounded
                        : Icons.engineering_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  searchController.text.isNotEmpty
                      ? "No employees found"
                      : "No employees yet",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  searchController.text.isNotEmpty
                      ? "Try a different search term"
                      : "Employees will appear here",
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: employees.length,
          itemBuilder: (_, index) {
            final emp = employees[index];
            final empId = emp.id;
            final data = emp.data() as Map<String, dynamic>;

            String joinDate = "N/A";

            Timestamp? created;

            if (data["createdAt"] != null && data["createdAt"] is Timestamp) {
              created = data["createdAt"];
            } else if (data["created_at"] != null && data["created_at"] is Timestamp) {
              created = data["created_at"];
            }

            if (created != null) {
              joinDate = DateFormat("dd MMM yyyy").format(created.toDate());
            }


            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    // Navigate to employee details
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF10B981),
                                    const Color(0xFF059669),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: data["image"] != null &&
                                  data["image"].toString().isNotEmpty
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  data["image"],
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : const Icon(
                                Icons.engineering_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data["name"] ?? "Unknown",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.email_outlined,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          data["email"] ?? "N/A",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone_outlined,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        data["phone"] ?? "N/A",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Join Date",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      joinDate,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 32,
                                color: Colors.grey[300],
                              ),
                              Expanded(
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: _firestore
                                      .collection("booking_details")
                                      .where("employe_id", isEqualTo: empId)
                                      .snapshots(),
                                  builder: (_, jobSnap) {
                                    final count = jobSnap.hasData
                                        ? jobSnap.data!.docs.length
                                        : 0;

                                    return Column(
                                      children: [
                                        Text(
                                          "Jobs",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "$count",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 32,
                                color: Colors.grey[300],
                              ),
                              Expanded(
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: _firestore
                                      .collection("feedback_details")
                                      .where("employee_id", isEqualTo: empId)
                                      .snapshots(),
                                  builder: (_, rateSnap) {
                                    if (!rateSnap.hasData ||
                                        rateSnap.data!.docs.isEmpty) {
                                      return Column(
                                        children: [
                                          Text(
                                            "Rating",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "--",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      );
                                    }

                                    double sum = 0;
                                    for (var d in rateSnap.data!.docs) {
                                      sum += (d["rating"] ?? 0).toDouble();
                                    }
                                    final avg = sum / rateSnap.data!.docs.length;

                                    return Column(
                                      children: [
                                        Text(
                                          "Rating",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              color: Colors.amber,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              avg.toStringAsFixed(1),
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 32,
                                child: VerticalDivider(
                                  thickness: 1,
                                  color: Colors.grey[300],
                                ),
                              ),


                              SizedBox(
                                width: 78, // 🔥 fixed width prevents overflow
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _iconButton(
                                      Icons.edit_rounded,
                                      const Color(0xFF3B82F6),
                                          () => openEditEmployee(empId, data),
                                    ),
                                    const SizedBox(width: 6),
                                    _iconButton(
                                      Icons.delete_rounded,
                                      Colors.red,
                                          () => deleteEmployee(empId, data["name"] ?? "Employee"),
                                    ),
                                  ],
                                ),
                              ),


                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _iconButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   // leading: IconButton(
      //   //   icon: const Icon(Icons.arrow_back_ios_new, size: 20),
      //   //   color: Colors.black87,
      //   //   onPressed: () => Navigator.pop(context),
      //   // ),
      //   title: const Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Center(
      //         child: Text(
      //           "Employee Management",
      //           style: TextStyle(
      //             fontSize: 20,
      //             fontWeight: FontWeight.bold,
      //             color: Colors.black87,
      //             letterSpacing: 0.2,
      //           ),
      //         ),
      //       ),
      //       // Text(
      //       //   "Manage all service providers",
      //       //   style: TextStyle(
      //       //     fontSize: 12,
      //       //     color: Colors.grey,
      //       //     fontWeight: FontWeight.w500,
      //       //   ),
      //       // ),
      //     ],
      //   ),
      // ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                const Divider(height: 5),
                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "All Employees",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection("employe_detail").snapshots(),
                      builder: (_, snapshot) {
                        final total =
                        snapshot.hasData ? snapshot.data!.docs.length : 0;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "$total Providers",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      icon: Icon(Icons.search_rounded, color: Colors.grey[600]),
                      hintText: "Search by name...",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        children: [
                          if (selectedCityName != null)
                            Chip(
                              label: Text(selectedCityName!),
                              onDeleted: () {
                                setState(() {
                                  selectedCityId = null;
                                  selectedCityName = null;
                                });
                              },
                            ),
                          if (selectedServiceName != null)
                            Chip(
                              label: Text(selectedServiceName!),
                              onDeleted: () {
                                setState(() {
                                  selectedServiceId = null;
                                  selectedServiceName = null;
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list_rounded),
                      onPressed: openEmployeeFilterSheet,
                    ),
                  ],
                ),

              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: buildEmployeeList(),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.05),
      //         blurRadius: 10,
      //         offset: const Offset(0, -5),
      //       ),
      //     ],
      //   ),
      //   child: SafeArea(
      //     child: BottomNavigationBar(
      //       currentIndex: selectedIndex,
      //       onTap: (index) {
      //         if (index == selectedIndex) return;
      //         if (index == 0)
      //           Navigator.pushReplacement(
      //             context,
      //             MaterialPageRoute(builder: (_) => admin_dashboard(uid: '')),
      //           );
      //         if (index == 1)
      //           Navigator.pushReplacement(
      //             context,
      //             MaterialPageRoute(builder: (_) => admin_user_list()),
      //           );
      //         if (index == 3)
      //           Navigator.pushReplacement(
      //             context,
      //             MaterialPageRoute(builder: (_) => admin_services()),
      //           );
      //       },
      //       selectedItemColor: const Color(0xFF1ABC9C),
      //       unselectedItemColor: Colors.grey,
      //       selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      //       type: BottomNavigationBarType.fixed,
      //       elevation: 0,
      //       backgroundColor: Colors.transparent,
      //       items: const [
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.dashboard_rounded),
      //           label: "Dashboard",
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.people_rounded),
      //           label: "Users",
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.engineering_rounded),
      //           label: "Providers",
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.home_repair_service_rounded),
      //           label: "Services",
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
