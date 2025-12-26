// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'customer_amployee_servicelist.dart';
// import 'customer_profile.dart';
//
// class customer_home_screen extends StatefulWidget {
//   final String uid;
//   const customer_home_screen({super.key, required this.uid});
//   @override
//   State<customer_home_screen> createState() => _customer_home_screenState();
// }
//
// class _customer_home_screenState extends State<customer_home_screen> {
//   String userName = "User";
//   String userEmail = "email";
//   String userPhone = "Phone";
//   String userAddress = "Address";
//
//   @override
//   void initState() {
//     super.initState();
//     getUserData();
//   }
//
//   // Fetch customer name from Firestore
//   getUserData() async {
//     var data = await FirebaseFirestore.instance
//         .collection("customer_detail")
//         .doc(widget.uid)
//         .get();
//
//     if (data.exists) {
//       setState(() {
//         userName = data["name"];
//         userPhone = data["phone"];
//         userEmail = data["email"];
//         userAddress = data["address"];
//
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF6FAFF),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(18),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Hello,",
//                         style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.w600),
//                       ),
//
//                       Text("What do you need today?",
//                         style: GoogleFonts.poppins(fontSize: 14,color: Colors.grey.shade600),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Icon(Icons.notifications_none, size: 28),
//
//                       const SizedBox(width: 12),
//                       IconButton(onPressed: (){
//                         Navigator.push(context, MaterialPageRoute(
//                           builder: (_) => customer_profile(uid: widget.uid,
//
//                           ),
//                         ));
//                       }, icon:Icon(Icons.person_outline,size: 28,))
//                     ],
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 20),
//
//               // Container(
//               //   padding: const EdgeInsets.symmetric(horizontal: 15),
//               //   decoration: BoxDecoration(
//               //     color: Colors.white, borderRadius: BorderRadius.circular(30),
//               //   ),
//               //   child: TextField(
//               //     decoration: const InputDecoration(
//               //       icon: Icon(Icons.search),
//               //       hintText: "Search services...",
//               //       border: InputBorder.none,
//               //     ),
//               //   ),
//               // ),
//
//               const SizedBox(height: 10),
//
//               Row(
//                 children: [
//                   Icon(Icons.location_on, color: Colors.teal),
//                   const SizedBox(width: 5),
//                   Text(userAddress,
//                     style: GoogleFonts.poppins(fontSize: 13),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 20),
//
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(colors: [Color(0xffFF4F86), Color(0xffFF006E)]),
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 padding: const EdgeInsets.all(20),
//
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("25% OFF",
//                       style: GoogleFonts.poppins(
//                         color: Colors.white,
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       "On your first cleaning service",
//                       style: GoogleFonts.poppins(
//                         color: Colors.white.withOpacity(.9),
//                         fontSize: 14,
//                       ),
//                     ),
//
//                     const SizedBox(height: 15),
//
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: Colors.black,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//                           padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
//                         ),
//                         onPressed: () {},
//                         child: const Text("Book Now"),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//
//
//               const SizedBox(height: 25),
//
//               // ----------------- Categories (Auto from Firebase) -----------------
//               Text("Categories",
//                   style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600)),
//               const SizedBox(height: 15),
//
//               StreamBuilder(
//                 stream: FirebaseFirestore.instance.collection("services").snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//
//                   var services = snapshot.data!.docs;
//
//                   return GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: services.length,
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                       crossAxisSpacing: 15,
//                       mainAxisSpacing: 15,
//                     ),
//                     itemBuilder: (context, index) {
//                       var service = services[index];
//                       return categoryCard(
//                         service["name"],
//                         service.id,
//                       );
//                     },
//                   );
//                 },
//               ),
//
//
//
//               const SizedBox(height:15),
//               Text("Trending Services",
//                   style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600)),
//               const SizedBox(height: 15),
//
//               trendingServiceCard(
//                 image:"https://picsum.photos/200",
//                 title:"Deep Cleaning",
//                 rating:"4.8",
//                 price:"₹299",
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget categoryCard(String serviceName, String serviceId) {
//
//     // Dynamic icon based on service
//     IconData icon;
//     Color color;
//
//     switch (serviceName.toLowerCase()) {
//       case "cleaning":
//         icon = Icons.cleaning_services;
//         color = Colors.pink.shade100;
//         break;
//       case "electrician":
//         icon = Icons.flash_on;
//         color = Colors.orange.shade100;
//         break;
//       case "plumber":
//         icon = Icons.water_drop;
//         color = Colors.blue.shade100;
//         break;
//       case "carpenter":
//         icon = Icons.handyman;
//         color = Colors.yellow.shade200;
//         break;
//       case "ac repair":
//         icon = Icons.ac_unit;
//         color = Colors.teal.shade100;
//         break;
//       case "painting":
//         icon = Icons.format_paint;
//         color = Colors.purple.shade100;
//         break;
//       default:
//         icon = Icons.home_repair_service_outlined; // default icon
//         color = Colors.grey.shade200;
//     }
//
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => CustomerServiceList(
//               serviceId: serviceId,
//               title: serviceName,
//               customerId: widget.uid,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,3))
//           ],
//         ),
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 22,
//               backgroundColor: color,
//               child: Icon(icon, color: Colors.black),
//             ),
//             const SizedBox(height: 8),
//             Text(serviceName,
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget trendingServiceCard({required String image,required String title,required String rating,required String price}){
//     return Container(
//       padding:const EdgeInsets.all(12),
//       decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18)),
//       child:Row(
//         children:[
//           ClipRRect(borderRadius:BorderRadius.circular(15),
//               child:Image.network(image,width:80,height:80,fit:BoxFit.cover)),
//           const SizedBox(width:12),
//           Expanded(
//             child:Column(
//               crossAxisAlignment:CrossAxisAlignment.start,
//               children:[
//                 Text(title,style:GoogleFonts.poppins(fontSize:15,fontWeight:FontWeight.w600)),
//                 Text("⭐ $rating",style:GoogleFonts.poppins(fontSize:13,color:Colors.grey[700])),
//                 Text(price,style:GoogleFonts.poppins(fontSize:16,fontWeight:FontWeight.w600)),
//               ],
//             ),
//           ),
//           ElevatedButton(
//             onPressed:(){},
//             style:ElevatedButton.styleFrom(backgroundColor:Colors.teal,
//                 shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25))),
//             child:const Text("Book"),
//           )
//         ],
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import 'customer_amployee_servicelist.dart';
import 'customer_categories_page.dart';
import 'customer_notification.dart';
import 'customer_profile.dart';

class customer_home_screen extends StatefulWidget {
  final String uid;
  const customer_home_screen({super.key, required this.uid});
  @override
  State<customer_home_screen> createState() => _customer_home_screenState();
}

class _customer_home_screenState extends State<customer_home_screen> with SingleTickerProviderStateMixin {
  String userName = "User";
  String userEmail = "email";
  String userPhone = "Phone";
  String userAddress = "Address";
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    getUserData();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  getUserData() async {
    try {
      var data = await FirebaseFirestore.instance
          .collection("customer_detail")
          .doc(widget.uid)
          .get();

      if (data.exists && mounted) {
        setState(() {
          userName = data["name"] ?? "User";
          userPhone = data["phone"] ?? "Phone";
          userEmail = data["email"] ?? "email";
          userAddress = data["address"] ?? "Address";
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await getUserData();
          },
          color: const Color(0xFF00BFA5),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  //_buildSearchBar(),
                  _buildLocationBar(),
                  _buildPromoBanner(),
                  _buildCategoriesSection(),
                  _buildTrendingSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello👋",
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1F36),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "What service do you need today?",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildIconButton(
                Icons.notifications_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CustomerNotificationPage(
                        customerId: widget.uid,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(width: 8),
              _buildIconButton(
                Icons.person_outline_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => customer_profile(uid: widget.uid),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          ),
          child: Icon(icon, size: 22, color: const Color(0xFF374151)),
        ),
      ),
    );
  }

  // Widget _buildSearchBar() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(16),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.04),
  //             blurRadius: 10,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       child: TextField(
  //         decoration: InputDecoration(
  //           prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
  //           hintText: "Search for services...",
  //           hintStyle: GoogleFonts.inter(
  //             fontSize: 15,
  //             color: const Color(0xFF9CA3AF),
  //             fontWeight: FontWeight.w400,
  //           ),
  //           border: InputBorder.none,
  //           contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  //         ),
  //         onChanged: (value) {
  //           // Handle search
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _buildLocationBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF00BFA5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: Color(0xFF00BFA5),
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              userAddress,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF374151),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // TextButton(
          //   onPressed: () {
          //     // Change location
          //   },
          //   child: Text(
          //     "Change",
          //     style: GoogleFonts.inter(
          //       fontSize: 13,
          //       color: const Color(0xFF00BFA5),
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Widget _buildPromoBanner() {
  //   return Padding(
  //     padding: const EdgeInsets.all(20),
  //     child: Container(
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //         gradient: const LinearGradient(
  //           colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         ),
  //         borderRadius: BorderRadius.circular(20),
  //         boxShadow: [
  //           BoxShadow(
  //             color: const Color(0xFF00BFA5).withOpacity(0.3),
  //             blurRadius: 20,
  //             offset: const Offset(0, 10),
  //           ),
  //         ],
  //       ),
  //       child: Stack(
  //         children: [
  //           Positioned(
  //             right: -20,
  //             top: -20,
  //             child: Container(
  //               width: 120,
  //               height: 120,
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 color: Colors.white.withOpacity(0.1),
  //               ),
  //             ),
  //           ),
  //           Positioned(
  //             right: 40,
  //             bottom: -30,
  //             child: Container(
  //               width: 100,
  //               height: 100,
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 color: Colors.white.withOpacity(0.08),
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(24),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Container(
  //                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //                   decoration: BoxDecoration(
  //                     color: Colors.white.withOpacity(0.2),
  //                     borderRadius: BorderRadius.circular(20),
  //                   ),
  //                   child: Text(
  //                     "SPECIAL OFFER",
  //                     style: GoogleFonts.inter(
  //                       color: Colors.white,
  //                       fontSize: 11,
  //                       fontWeight: FontWeight.w700,
  //                       letterSpacing: 1,
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 12),
  //                 Text(
  //                   "25% OFF",
  //                   style: GoogleFonts.inter(
  //                     color: Colors.white,
  //                     fontSize: 36,
  //                     fontWeight: FontWeight.w800,
  //                     letterSpacing: -1,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 Text(
  //                   "On your first cleaning service\nBook now and save big!",
  //                   style: GoogleFonts.inter(
  //                     color: Colors.white.withOpacity(0.95),
  //                     fontSize: 15,
  //                     fontWeight: FontWeight.w400,
  //                     height: 1.5,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.white,
  //                     foregroundColor: const Color(0xFF00BFA5),
  //                     elevation: 0,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
  //                   ),
  //                   onPressed: () {},
  //                   child: Text(
  //                     "Book Now",
  //                     style: GoogleFonts.inter(
  //                       fontSize: 15,
  //                       fontWeight: FontWeight.w700,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00BFA5).withOpacity(0.35),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 🔵 DECORATIVE CIRCLES
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              left: -20,
              bottom: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),

            // 🔥 CONTENT
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TAG
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "WHY CHOOSE US",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // TITLE
                  Text(
                    "Trusted Home Services",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // SUBTITLE
                  Text(
                    "Professional services at your doorstep with safety, speed & reliability.",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ADVANTAGES LIST
                  _advantageRow(Icons.verified_rounded, "Verified Professionals"),
                  const SizedBox(height: 10),
                  _advantageRow(Icons.flash_on_rounded, "Quick & Hassle-Free Booking"),
                  const SizedBox(height: 10),
                  _advantageRow(Icons.lock_rounded, "Secure Payments"),
                  const SizedBox(height: 10),
                  _advantageRow(Icons.support_agent_rounded, "24×7 Customer Support"),

                  const SizedBox(height: 22),

                  // CTA BUTTON
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.white,
                  //     foregroundColor: const Color(0xFF00BFA5),
                  //     elevation: 0,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(14),
                  //     ),
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 28, vertical: 14),
                  //   ),
                  //   onPressed: () {
                  //     // Scroll to services or open categories
                  //   },
                  //   child: Text(
                  //     "Explore Services",
                  //     style: GoogleFonts.inter(
                  //       fontSize: 15,
                  //       fontWeight: FontWeight.w700,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _advantageRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Categories",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1F36),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CustomerCategoriesPage(
                        customerId: widget.uid,
                      ),
                    ),
                  );
                },
                child: Text(
                  "See All",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF00BFA5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            ],
          ),
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance.collection("services").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return _buildCategoriesShimmer();
            }

            var services = snapshot.data!.docs.take(6).toList();


            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  var service = services[index];
                  return _buildCategoryCard(
                    service["name"],
                    service.id,
                    index,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoriesShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(String serviceName, String serviceId, int index) {
    final categoryData = _getCategoryData(serviceName);

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CustomerServiceList(
                  serviceId: serviceId,
                  title: serviceName,
                  customerId: widget.uid,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: categoryData['color'],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    categoryData['icon'],
                    color: categoryData['iconColor'],
                    size: 26,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    serviceName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF374151),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getCategoryData(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case "cleaning":
        return {
          'icon': Icons.cleaning_services_rounded,
          'color': const Color(0xFFFCE4EC),
          'iconColor': const Color(0xFFE91E63),
        };
      case "electrician":
        return {
          'icon': Icons.electric_bolt_rounded,
          'color': const Color(0xFFFFF3E0),
          'iconColor': const Color(0xFFFF9800),
        };
      case "plumber":
        return {
          'icon': Icons.water_drop_rounded,
          'color': const Color(0xFFE3F2FD),
          'iconColor': const Color(0xFF2196F3),
        };
      case "carpenter":
        return {
          'icon': Icons.handyman_rounded,
          'color': const Color(0xFFFFF9C4),
          'iconColor': const Color(0xFFFBC02D),
        };
      case "ac repair":
        return {
          'icon': Icons.ac_unit_rounded,
          'color': const Color(0xFFE0F2F1),
          'iconColor': const Color(0xFF009688),
        };
      case "painting":
        return {
          'icon': Icons.format_paint_rounded,
          'color': const Color(0xFFF3E5F5),
          'iconColor': const Color(0xFF9C27B0),
        };
      case "gardening":
        return {
          'icon': Icons.local_florist,
          'color': const Color(0xFFFFF9C4),
          'iconColor': const Color(0xFFFBC02D),
        };
      default:
        return {
          'icon': Icons.home_repair_service_rounded,
          'color': const Color(0xFFF5F5F5),
          'iconColor': const Color(0xFF757575),
        };
    }
  }

  Widget _buildTrendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Text(
            "Trending Services",
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1F36),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildTrendingCard(
            image: "https://picsum.photos/200",
            title: "Deep Cleaning",
            rating: "4.8",
            reviews: "1.2k",
            price: "₹299",
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingCard({
    required String image,
    required String title,
    required String rating,
    required String reviews,
    required String price,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                image,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1F36),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFFFA726), size: 18),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "($reviews reviews)",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        price,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF00BFA5),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00BFA5),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: Text(
                          "Book",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}