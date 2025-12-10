import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerServiceList extends StatefulWidget {
  final String serviceId;
  final String title;

  const CustomerServiceList({
    super.key,
    required this.serviceId,
    required this.title,
  });

  @override
  State<CustomerServiceList> createState() => _CustomerServiceListState();
}

class _CustomerServiceListState extends State<CustomerServiceList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FF),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff6C63FF), Color(0xff8A4DFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "${widget.title} Providers",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("employe_detail")
            .where("service_id", isEqualTo: widget.serviceId)
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Color(0xff6C63FF)));
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.sentiment_dissatisfied, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("No Providers Available",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey)),
                ],
              ),
            );
          }

          var data = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: data.length,
            itemBuilder: (context, index) {
              var emp = data[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),

                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xffECE9FF),
                    child: Icon(Icons.person, color: Color(0xff6C63FF), size: 30),
                  ),

                  title: Text(
                    emp["name"],
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xff30304A)),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("📍 City : ${emp["city_id"]}", style: const TextStyle(fontSize: 13)),
                        Text("💰 Visit Charge : ₹${emp["visit_charge"]}", style: const TextStyle(fontSize: 13)),
                        const SizedBox(height: 6),

                        // Rating Badge (optional)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              SizedBox(width: 4),
                              Text("4.7", style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  trailing: ElevatedButton(
                    onPressed: () {
                      // TODO : Navigate to booking page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff6C63FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    ),
                    child: const Text("Book", style: TextStyle(color: Colors.white)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
