import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'customer_amployee_servicelist.dart';
import 'customer_profile.dart';

class customer_home_screen extends StatefulWidget {
  final String uid;
  const customer_home_screen({super.key, required this.uid});
  @override
  State<customer_home_screen> createState() => _customer_home_screenState();
}

class _customer_home_screenState extends State<customer_home_screen> {
  String userName = "User";
  String userEmail = "email";
  String userPhone = "Phone";
  String userAddress = "Address";

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  // Fetch customer name from Firestore
  getUserData() async {
    var data = await FirebaseFirestore.instance
        .collection("customer_detail")
        .doc(widget.uid)
        .get();

    if (data.exists) {
      setState(() {
        userName = data["name"];
        userPhone = data["phone"];
        userEmail = data["email"];
        userAddress = data["address"];

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6FAFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello, $userName 👋",
                        style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.w600),
                      ),

                      Text("What do you need today?",
                        style: GoogleFonts.poppins(fontSize: 14,color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.notifications_none, size: 28),

                      const SizedBox(width: 12),
                      IconButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => customer_profile(
                            name: userName,
                            email: userEmail,
                            phone: userPhone,
                            address: userAddress,
                          ),
                        ));
                      }, icon:Icon(Icons.person_outline,size: 28,))
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   decoration: BoxDecoration(
              //     color: Colors.white, borderRadius: BorderRadius.circular(30),
              //   ),
              //   child: TextField(
              //     decoration: const InputDecoration(
              //       icon: Icon(Icons.search),
              //       hintText: "Search services...",
              //       border: InputBorder.none,
              //     ),
              //   ),
              // ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.teal),
                  const SizedBox(width: 5),
                  Text(userAddress,
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors:[Color(0xffFF4F86),Color(0xffFF006E)]),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("25% OFF",style:GoogleFonts.poppins(color:Colors.white,fontSize:26,fontWeight:FontWeight.bold)),
                    Text("On your first cleaning service",
                        style:GoogleFonts.poppins(color:Colors.white.withOpacity(.9),fontSize:14)),
                    const SizedBox(height:15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.white,foregroundColor:Colors.black,
                        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
                      ),
                      onPressed:(){},
                      child: const Text("Book Now"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ----------------- Categories (Auto from Firebase) -----------------
              Text("Categories",
                  style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),

              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("services").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  var services = snapshot.data!.docs;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: services.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemBuilder: (context, index) {
                      var service = services[index];
                      return categoryCard(
                        service["name"],
                        service.id,
                      );
                    },
                  );
                },
              ),



              const SizedBox(height:15),
              Text("Trending Services",
                  style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),

              trendingServiceCard(
                image:"https://picsum.photos/200",
                title:"Deep Cleaning",
                rating:"4.8",
                price:"₹299",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryCard(String serviceName, String serviceId) {

    // Dynamic icon based on service
    IconData icon;
    Color color;

    switch (serviceName.toLowerCase()) {
      case "cleaning":
        icon = Icons.cleaning_services;
        color = Colors.pink.shade100;
        break;
      case "electrician":
        icon = Icons.flash_on;
        color = Colors.orange.shade100;
        break;
      case "plumber":
        icon = Icons.water_drop;
        color = Colors.blue.shade100;
        break;
      case "carpenter":
        icon = Icons.handyman;
        color = Colors.yellow.shade200;
        break;
      case "ac repair":
        icon = Icons.ac_unit;
        color = Colors.teal.shade100;
        break;
      case "painting":
        icon = Icons.format_paint;
        color = Colors.purple.shade100;
        break;
      default:
        icon = Icons.home_repair_service_outlined; // default icon
        color = Colors.grey.shade200;
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CustomerServiceList(
              serviceId: serviceId,
              title: serviceName,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,3))
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color,
              child: Icon(icon, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(serviceName,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget trendingServiceCard({required String image,required String title,required String rating,required String price}){
    return Container(
      padding:const EdgeInsets.all(12),
      decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18)),
      child:Row(
        children:[
          ClipRRect(borderRadius:BorderRadius.circular(15),
              child:Image.network(image,width:80,height:80,fit:BoxFit.cover)),
          const SizedBox(width:12),
          Expanded(
            child:Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children:[
                Text(title,style:GoogleFonts.poppins(fontSize:15,fontWeight:FontWeight.w600)),
                Text("⭐ $rating",style:GoogleFonts.poppins(fontSize:13,color:Colors.grey[700])),
                Text(price,style:GoogleFonts.poppins(fontSize:16,fontWeight:FontWeight.w600)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed:(){},
            style:ElevatedButton.styleFrom(backgroundColor:Colors.teal,
                shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25))),
            child:const Text("Book"),
          )
        ],
      ),
    );
  }
}
