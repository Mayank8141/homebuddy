// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'customer_provider_profile.dart';
//
// class CustomerServiceList extends StatefulWidget {
//   final String serviceId;
//   final String customerId;
//   final String title;
//
//   const CustomerServiceList({
//     super.key,
//     required this.customerId,
//     required this.serviceId,
//     required this.title,
//   });
//
//   @override
//   State<CustomerServiceList> createState() => _CustomerServiceListState();
// }
//
// class _CustomerServiceListState extends State<CustomerServiceList> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF7F9FF),
//
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Column(
//           children: [
//             Text(widget.title,
//                 style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black)),
//             const SizedBox(height: 2),
//             Text("Providers available",
//                 style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
//           ],
//         ),
//       ),
//
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection("employe_detail")
//             .where("service_id", isEqualTo: widget.serviceId)
//             .snapshots(),
//
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator(color: Colors.teal));
//           }
//
//           if (snapshot.data!.docs.isEmpty) {
//             return Center(
//                 child: Text("No Providers Found",
//                     style: TextStyle(fontSize: 16, color: Colors.grey.shade600)));
//           }
//
//           var data = snapshot.data!.docs;
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(14),
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               var emp = data[index];
//
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => ProviderFullProfile(
//                         providerId: emp.id,
//                         providerData: emp.data(),
//                         customerId: widget.customerId,
//                       ),
//                     ),
//                   );
//                 },
//
//                 child: Container(
//                   margin: const EdgeInsets.only(bottom: 18),
//                   padding: const EdgeInsets.all(15),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(22),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12.withOpacity(0.07),
//                         blurRadius: 12,
//                         offset: const Offset(0, 6),
//                       ),
//                     ],
//                   ),
//
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.network(
//                               emp.data().containsKey("image") &&
//                                   emp["image"].toString().isNotEmpty
//                                   ? emp["image"]
//                                   : "https://cdn-icons-png.flaticon.com/512/847/847969.png",
//                               height: 70,
//                               width: 70,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//
//                           const SizedBox(width: 12),
//
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(emp["name"],
//                                     style: const TextStyle(
//                                         fontSize: 17, fontWeight: FontWeight.w700)),
//                                 const SizedBox(height: 5),
//
//                                 Row(
//                                   children: [
//                                     const Icon(Icons.star, color: Colors.amber, size: 18),
//                                     const SizedBox(width: 4),
//                                     const Text("4.8", style: TextStyle(fontWeight: FontWeight.w600)),
//                                     Text(" • 234 reviews",
//                                         style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 12),
//
//                       Text("₹${emp["visit_charge"]}/service",
//                           style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
//
//                       const SizedBox(height: 10),
//
//                       Wrap(
//                         spacing: 8,
//                         children: const [
//                           skillChip("Pipe Fitting"),
//                           skillChip("Leak Repairs"),
//                           skillChip("Installation"),
//                         ],
//                       ),
//
//                       const SizedBox(height: 12),
//                       Divider(color: Colors.grey.shade300),
//
//                       // -------- FIXED ADDRESS OVERFLOW HERE --------
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Icon(Icons.location_on, size: 18, color: Colors.red),
//                           const SizedBox(width: 6),
//
//                           Expanded(
//                             child: Text(
//                               emp["address"] ?? "No address",
//                               style: const TextStyle(
//                                   fontSize: 14, fontWeight: FontWeight.w500),
//                               softWrap: true,
//                             ),
//                           ),
//
//                           const SizedBox(width: 8),
//
//                           ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                               elevation: 0,
//                               backgroundColor: Colors.teal,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(25)),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 8),
//                             ),
//                             child: const Text("Book",
//                                 style: TextStyle(fontSize: 13,color: Colors.white)),
//                           ),
//                         ],
//                       )
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
// }
//
// // ---------- Reusable Skill Tag ----------
// class skillChip extends StatelessWidget {
//   final String text;
//   const skillChip(this.text, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: const Color(0xffE9F8F6),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(text, style: TextStyle(color: Colors.teal.shade700, fontSize: 12)),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'customer_provider_profile.dart';

class CustomerServiceList extends StatefulWidget {
  final String serviceId;
  final String customerId;
  final String title;

  const CustomerServiceList({
    super.key,
    required this.customerId,
    required this.serviceId,
    required this.title,
  });

  @override
  State<CustomerServiceList> createState() => _CustomerServiceListState();
}

class _CustomerServiceListState extends State<CustomerServiceList>
    with SingleTickerProviderStateMixin {
  String selectedFilter = "All";
  String selectedSort = "Rating";
  late AnimationController _animationController;

  String searchQuery = "";
  bool isSearching = false;
  final TextEditingController searchCtrl = TextEditingController();



  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
               // _buildFilterChips(),
                const SizedBox(height: 16),
              ],
            ),
          ),
          _buildProvidersList(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF00BFA5),

      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),

      actions: [
        IconButton(
          icon: Icon(
            isSearching ? Icons.close : Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              if (isSearching) {
                searchCtrl.clear();
                searchQuery = "";
              }
              isSearching = !isSearching;
            });
          },
        ),
      ],

      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 16),

        title: isSearching
            ? Container(
          height: 30,
          width: 200,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextField(
            controller: searchCtrl,
            autofocus: true,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.white),
                gapPadding: BorderSide.strokeAlignCenter

              ),
              //hintText: "Search provider name...",
              prefixIcon: Icon(Icons.search,size: 20,),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 30),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
          ),
        )
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("employe_detail")
                  .where("service_id", isEqualTo: widget.serviceId)
                  .snapshots(),
              builder: (context, snapshot) {
                final count =
                snapshot.hasData ? snapshot.data!.docs.length : 0;

                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "$count Providers Available",
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


  // Widget _buildFilterChips() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     child: Row(
  //       children: [
  //         _buildFilterChip("All", Icons.apps_rounded),
  //         const SizedBox(width: 10),
  //         _buildFilterChip("Top Rated", Icons.star_rounded),
  //         const SizedBox(width: 10),
  //         _buildFilterChip("Nearby", Icons.location_on_rounded),
  //         const SizedBox(width: 10),
  //         _buildFilterChip("Available", Icons.check_circle_rounded),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildFilterChip(String label, IconData icon) {
  //   final isSelected = selectedFilter == label;
  //   return FilterChip(
  //     label: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(
  //           icon,
  //           size: 16,
  //           color: isSelected ? Colors.white : const Color(0xFF00BFA5),
  //         ),
  //         const SizedBox(width: 6),
  //         Text(
  //           label,
  //           style: GoogleFonts.inter(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w600,
  //             color: isSelected ? Colors.white : const Color(0xFF00BFA5),
  //           ),
  //         ),
  //       ],
  //     ),
  //     selected: isSelected,
  //     onSelected: (selected) {
  //       setState(() {
  //         selectedFilter = label;
  //       });
  //     },
  //     backgroundColor: Colors.white,
  //     selectedColor: const Color(0xFF00BFA5),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(25),
  //       side: BorderSide(
  //         color: isSelected ? const Color(0xFF00BFA5) : const Color(0xFFE5E7EB),
  //       ),
  //     ),
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //     elevation: 0,
  //     pressElevation: 0,
  //   );
  // }

  Widget _buildProvidersList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("employe_detail")
          .where("service_id", isEqualTo: widget.serviceId)
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

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SliverFillRemaining(
            child: _buildEmptyState(),
          );
        }

        //var providers = snapshot.data!.docs;

        var providers = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final name = data["name"]?.toString().toLowerCase() ?? "";
          return name.contains(searchQuery);
        }).toList();


        if (providers.isEmpty) {
          return SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off_rounded,
                    size: 60, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text(
                  "No provider found",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }



        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return _buildProviderCard(providers[index], index);
              },
              childCount: providers.length,
            ),
          ),
        );
      },
    );
  }


  Widget _buildProviderCard(DocumentSnapshot emp, int index) {
    final data = emp.data() as Map<String, dynamic>;

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProviderFullProfile(
                providerId: emp.id,
                providerData: data,
                customerId: widget.customerId,
              ),
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildProviderImage(data),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      data["name"] ?? "Provider",
                                      style: GoogleFonts.inter(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1A1F36),
                                      ),
                                    ),
                                  ),
                                  _buildVerifiedBadge(),
                                ],
                              ),
                              const SizedBox(height: 6),
                              _buildRatingRow(data),
                              const SizedBox(height: 8),
                              _buildExperienceChip(data),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSkillsSection(data),
                    const SizedBox(height: 16),
                    _buildPriceAndLocationRow(data),
                  ],
                ),
              ),
              _buildActionBar(data),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProviderImage(Map<String, dynamic> data) {
    return Hero(
      tag: 'provider_${data["name"]}',
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00BFA5).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            data.containsKey("image") && data["image"].toString().isNotEmpty
                ? data["image"]
                : "https://cdn-icons-png.flaticon.com/512/847/847969.png",
            height: 85,
            width: 85,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 85,
                width: 85,
                color: Colors.grey[200],
                child: const Icon(Icons.person, size: 40, color: Colors.grey),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF00BFA5).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified_rounded,
            size: 14,
            color: Color(0xFF00BFA5),
          ),
          const SizedBox(width: 3),
          Text(
            "Verified",
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF00BFA5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFA726), size: 16),
          const SizedBox(width: 4),
          Text(
            data["rating"]?.toString() ?? "4.8",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1F36),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            "(${data["reviews"]?.toString() ?? "234"})",
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceChip(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.work_outline_rounded, size: 14, color: Color(0xFF4F46E5)),
          const SizedBox(width: 4),
          Text(
            "${data["experience"]?.toString() ?? "5"} years exp",
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4F46E5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(Map<String, dynamic> data) {
    List<String> skills = [];

    if (data.containsKey("skills") && data["skills"] is List) {
      skills = List<String>.from(data["skills"]);
    } else {
      // Default skills if not in database
      skills = ["Professional", "Experienced", "Reliable"];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Skills & Expertise",
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills.take(4).map((skill) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF00BFA5).withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00BFA5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    skill,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF00897B),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceAndLocationRow(Map<String, dynamic> data) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Service Charge",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    "₹${data["visit_charge"] ?? "299"}",
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF00BFA5),
                    ),
                  ),
                  Text(
                    "/visit",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        //   decoration: BoxDecoration(
        //     color: const Color(0xFFFEF2F2),
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       const Icon(
        //         Icons.location_on_rounded,
        //         size: 16,
        //         color: Color(0xFFEF4444),
        //       ),
        //       const SizedBox(width: 4),
        //       Text(
        //         "${data["distance"] ?? "2.5"} km",
        //         style: GoogleFonts.inter(
        //           fontSize: 13,
        //           fontWeight: FontWeight.w600,
        //           color: const Color(0xFFEF4444),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget _buildActionBar(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(color: const Color(0xFFE5E7EB)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        data["address"] ?? "No address provided",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProviderFullProfile(
                    providerId: data["id"] ?? "",
                    providerData: data,
                    customerId: widget.customerId,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BFA5),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.calendar_today_rounded, size: 18),
            label: Text(
              "Book Now",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
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
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 120,
                      height: 14,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 12,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 8),
          Container(
            width: 200,
            height: 12,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
              Icons.search_off_rounded,
              size: 64,
              color: const Color(0xFF00BFA5).withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No Providers Found",
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1F36),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              "We couldn't find any service providers in this category. Try another service or check back later.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF6B7280),
                height: 1.5,
              ),
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
            icon: const Icon(Icons.arrow_back_rounded),
            label: Text(
              "Browse Other Services",
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}