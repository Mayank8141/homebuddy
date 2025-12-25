import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'customer_bill.dart';

class CustomerNotificationPage extends StatefulWidget {
  final String customerId;

  const CustomerNotificationPage({
    super.key,
    required this.customerId,
  });

  @override
  State<CustomerNotificationPage> createState() =>
      _CustomerNotificationPageState();
}

class _CustomerNotificationPageState
    extends State<CustomerNotificationPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("notifications")
            .where("receiver_id", isEqualTo: widget.customerId)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No notifications yet",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          // ✅ SORT LOCALLY (NO INDEX NEEDED)
          final notifications = snapshot.data!.docs;
          notifications.sort((a, b) {
            final aTime =
                (a['created_at'] as Timestamp?)?.toDate() ?? DateTime(2000);
            final bTime =
                (b['created_at'] as Timestamp?)?.toDate() ?? DateTime(2000);
            return bTime.compareTo(aTime);
          });

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final doc = notifications[index];
              final data = doc.data() as Map<String, dynamic>;

              final bool isRead = data['is_read'] ?? false;

              return InkWell(
                //onTap: () => markAsRead(doc.id),

                onTap: () async {
                  await markAsRead(doc.id);

                  // 🔥 IF PAYMENT NOTIFICATION
                  if (data.containsKey("bill_id") && data["bill_id"] != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BillPaymentPage(
                          billId: data["bill_id"],
                          customerId: widget.customerId,
                          employeeId: data["sender_id"],
                        ),
                      ),
                    );
                  }
                },


                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isRead ? Colors.white : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor:
                        isRead ? Colors.grey.shade300 : Colors.green,
                        child: Icon(
                          Icons.notifications,
                          color: isRead ? Colors.grey : Colors.white,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['title'] ?? "Notification",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isRead
                                    ? FontWeight.w500
                                    : FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data['message'] ?? "",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              formatTime(data['created_at']),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 6),
                          decoration: const BoxDecoration(
                            color: Colors.green,
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

  // --------------------------------------------------
  // MARK AS READ
  // --------------------------------------------------
  Future<void> markAsRead(String notificationId) async {
    await FirebaseFirestore.instance
        .collection("notifications")
        .doc(notificationId)
        .update({
      "is_read": true,
    });
  }

  // --------------------------------------------------
  // TIME FORMAT
  // --------------------------------------------------
  String formatTime(Timestamp? timestamp) {
    if (timestamp == null) return "";

    final date = timestamp.toDate();
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hours ago";
    return "${date.day}/${date.month}/${date.year}";
  }
}
