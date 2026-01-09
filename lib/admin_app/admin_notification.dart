// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class AdminNotificationScreen extends StatefulWidget {
//   const AdminNotificationScreen({super.key});
//
//   @override
//   State<AdminNotificationScreen> createState() => _AdminNotificationScreenState();
// }
//
// class _AdminNotificationScreenState extends State<AdminNotificationScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final adminId = FirebaseAuth.instance.currentUser!.uid;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Notifications",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         elevation: 0,
//       ),
//       backgroundColor: const Color(0xFFF8F9FD),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("notifications")
//             .where("receiver_id", isEqualTo: adminId)
//             .where("receiver_type", isEqualTo: "admin")
//             .orderBy("created_at", descending: true)
//             .snapshots(),
//
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 "Something went wrong",
//                 style: TextStyle(color: Colors.red),
//               ),
//             );
//           }
//
//
//           if (snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No notifications",
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             );
//           }
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               final doc = snapshot.data!.docs[index];
//               final data = doc.data() as Map<String, dynamic>;
//
//               final isRead = data["is_read"] ?? false;
//
//               return GestureDetector(
//                 onTap: () async {
//                   if (!isRead) {
//                     await doc.reference.update({"is_read": true});
//                   }
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: isRead ? Colors.white : const Color(0xFFECFDF5),
//                     borderRadius: BorderRadius.circular(14),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.04),
//                         blurRadius: 6,
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF1ABC9C).withOpacity(0.15),
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.notifications_active,
//                           color: Color(0xFF1ABC9C),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               data["title"] ?? "",
//                               style: TextStyle(
//                                 fontWeight:
//                                 isRead ? FontWeight.w600 : FontWeight.bold,
//                                 fontSize: 15,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               data["message"] ?? "",
//                               style: TextStyle(
//                                 color: Colors.grey[700],
//                                 fontSize: 13,
//                               ),
//                             ),
//                             const SizedBox(height: 6),
//                             Text(
//                               _formatDate(data["created_at"]),
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 color: Colors.grey[500],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   String _formatDate(Timestamp timestamp) {
//     final date = timestamp.toDate();
//     return "${date.day}/${date.month}/${date.year}";
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminNotificationScreen extends StatefulWidget {
  const AdminNotificationScreen({super.key});

  @override
  State<AdminNotificationScreen> createState() =>
      _AdminNotificationScreenState();
}

class _AdminNotificationScreenState extends State<AdminNotificationScreen> {

  String? adminId;

  @override
  void initState() {
    super.initState();
    adminId = FirebaseAuth.instance.currentUser?.uid;
    debugPrint("ADMIN UID: $adminId");
  }

  @override
  Widget build(BuildContext context) {
    if (adminId == null) {
      return const Scaffold(
        body: Center(
          child: Text("Admin not logged in"),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("notifications")
            .where("receiver_type", isEqualTo: "admin")
            .where("receiver_id", isEqualTo: adminId)
            .orderBy("created_at", descending: true)
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            debugPrint("FIRESTORE ERROR: ${snapshot.error}");
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            );
          }


          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No notifications",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {

              final doc = notifications[index];
              final data = doc.data() as Map<String, dynamic>;
              final bool isRead = data["is_read"] ?? false;

              return InkWell(
                onTap: () async {
                  if (!isRead) {
                    await doc.reference.update({"is_read": true});
                  }
                },

                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isRead
                        ? Colors.white
                        : const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ICON
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1ABC9C).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_active_rounded,
                          color: Color(0xFF1ABC9C),
                          size: 22,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // CONTENT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data["title"] ?? "Notification",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isRead
                                    ? FontWeight.w600
                                    : FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              data["message"] ?? "",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatDate(data["created_at"]),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (!isRead)
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(top: 6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1ABC9C),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return "";
    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }
}

