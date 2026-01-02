

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';

class EmployeProfile extends StatefulWidget {
  final String uid;
  const EmployeProfile({super.key, required this.uid});

  @override
  State<EmployeProfile> createState() => _EmployeProfileState();
}

class _EmployeProfileState extends State<EmployeProfile> {
  Map<String, dynamic>? profile;

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final expCtrl = TextEditingController();
  final visitCtrl = TextEditingController();

  List<QueryDocumentSnapshot> _allCities = [];
  List<QueryDocumentSnapshot> _filteredCities = [];


  String? selectedCityId;
  String? selectedServiceId;

  bool imageUploading = false;
  final ImagePicker _picker = ImagePicker();

  static const String defaultAvatar =
      "https://www.transparentpng.com/thumb/user/gray-user-profile-icon-png-fP8Q1P.png";

  bool isValidExperience(String value) {
    final exp = int.tryParse(value);
    return exp != null && exp >= 1 && exp <= 50;
  }

  bool isValidVisitCharge(String value) {
    final charge = int.tryParse(value);
    return charge != null && charge >= 100 && charge <= 500;
  }


  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }



  Future<void> loadProfile() async {
    final doc = await FirebaseFirestore.instance
        .collection("employe_detail")
        .doc(widget.uid)
        .get();

    if (!doc.exists) return;

    profile = doc.data();

    nameCtrl.text = profile?['name'] ?? '';
    phoneCtrl.text = profile?['phone'] ?? '';
    phoneCtrl.text = profile?['phone'] ?? '';
    addressCtrl.text = profile?['address'] ?? '';
    expCtrl.text = profile?['experience'] ?? '';
    visitCtrl.text = profile?['visit_charge'] ?? '';

    selectedCityId = profile?['city_id'];
    selectedServiceId = profile?['service_id'];

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> changeProfileImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked == null) return;

    setState(() => imageUploading = true);

    try {
      final imageUrl = await uploadToCloudinary(File(picked.path));

      await FirebaseFirestore.instance
          .collection("employe_detail")
          .doc(widget.uid)
          .update({"image": imageUrl});

      profile!['image'] = imageUrl;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text("Profile picture updated"),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Text("Image upload failed"),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }

    setState(() => imageUploading = false);
  }


  String getProfileImage() {
    final img = profile?['image'];

    if (img == null || img.toString().isEmpty) {
      return defaultAvatar; // fallback image
    }

    return img.toString();
  }


  Future<String> uploadToCloudinary(File file) async {
    const cloudinaryUrl =
        "https://api.cloudinary.com/v1_1/drsaz2xgk/image/upload";

    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path),
      "upload_preset": "homebuddy",
    });

    final res = await Dio().post(cloudinaryUrl, data: formData);
    return res.data['secure_url'];
  }

  Future<void> saveProfile() async {
    if (nameCtrl.text.isEmpty ||
        phoneCtrl.text.isEmpty ||
        addressCtrl.text.isEmpty ||
        expCtrl.text.isEmpty ||
        visitCtrl.text.isEmpty ||
        selectedCityId == null ||
        selectedServiceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text("Please fill all fields"),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    if (!isValidExperience(expCtrl.text.trim())) {
      showError("Experience must be between 1 and 50 years");
      return;
    }

    if (!isValidVisitCharge(visitCtrl.text.trim())) {
      showError("Visit charge must be between ₹100 and ₹500");
      return;
    }


    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await FirebaseFirestore.instance
        .collection("employe_detail")
        .doc(widget.uid)
        .update({
      "name": nameCtrl.text.trim(),
      "phone": phoneCtrl.text.trim(),
      "address": addressCtrl.text.trim(),
      "experience": expCtrl.text.trim(),
      "visit_charge": visitCtrl.text.trim(),
      "city_id": selectedCityId,
      "service_id": selectedServiceId,
      "profileCompleted": true,
    });

    if (mounted) {
      Navigator.pop(context); // Close loading dialog
      Navigator.pop(context); // Close bottom sheet

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text("Profile saved successfully"),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }

    loadProfile();
  }

  Future<void> logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      // 🔐 Firebase logout
      await FirebaseAuth.instance.signOut();

      // 🧹 Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (!mounted) return;

      // 🔁 Navigate to login & clear stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => login_screen()),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Logout failed. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  void _openCitySearch() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("cities")
        .orderBy("name")
        .get();

    _allCities = snapshot.docs;
    _filteredCities = List.from(_allCities);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),

                  // 🔍 Search Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Search city",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          _filteredCities = _allCities.where((doc) {
                            return doc['name']
                                .toString()
                                .toLowerCase()
                                .contains(value.toLowerCase());
                          }).toList();
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 📋 City List
                  SizedBox(
                    height: 350,
                    child: _filteredCities.isEmpty
                        ? const Center(child: Text("No city found"))
                        : ListView.builder(
                      itemCount: _filteredCities.length,
                      itemBuilder: (_, index) {
                        final city = _filteredCities[index];
                        return ListTile(
                          title: Text(city['name']),
                          onTap: () {
                            setState(() {
                              selectedCityId = city.id;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
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

  String _getCityNameById(String? cityId) {
    if (cityId == null) return "";

    try {
      return _allCities
          .firstWhere((doc) => doc.id == cityId)['name'];
    } catch (_) {
      return "";
    }
  }



  void openProfileSheet() {
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              field("Full Name", nameCtrl, Icons.person_outline),
              field("Phone Number", phoneCtrl, Icons.phone_outlined,
                  type: TextInputType.phone),
              field("Address", addressCtrl, Icons.location_on_outlined,
                  maxLines: 2),

              // field("Experience (Years)", expCtrl, Icons.work_outline,
              //     type: TextInputType.number),

              TextField(
                controller: expCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                decoration: InputDecoration(
                  labelText: "Experience (Years)",
                  prefixIcon: const Icon(Icons.work_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1ABC9C), width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),

              const SizedBox(height: 10),

              // field("Visit Charge (₹)", visitCtrl, Icons.currency_rupee,
              //     type: TextInputType.number),

              TextField(
                controller: visitCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: InputDecoration(
                  labelText: "Visit Charge (₹)",
                  prefixIcon: const Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1ABC9C), width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),




              const SizedBox(height: 8),
              cityDropdown(),
              const SizedBox(height: 16),
              serviceDropdown(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: saveProfile,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Save Profile",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final completed = profile!['profileCompleted'] == true;
    final imageUrl = profile!['image'];

    return Scaffold(
      backgroundColor: const Color(0xFF1ABC9C),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Spacer(),
                  const Text(
                    "My Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (completed)
                    IconButton(
                      onPressed: openProfileSheet,
                      icon: const Icon(Icons.edit, color: Colors.white),
                    )
                  else
                    const SizedBox(width: 48),
                ],
              ),
            ),

            // White Content Area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // Profile Image
                      GestureDetector(
                        onTap: changeProfileImage,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF1ABC9C),
                                  width: 3,
                                ),
                              ),
                              child:CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey[200],
                                backgroundImage:
                                (profile?['image'] != null && profile!['image'].toString().isNotEmpty)
                                    ? NetworkImage(profile!['image'])
                                    : null,
                                child: (profile?['image'] == null ||
                                    profile!['image'].toString().isEmpty)
                                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                                    : null,
                              ),

                            ),
                            if (imageUploading)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1ABC9C),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Name
                      Text(
                        profile!['name'] ?? 'Employee Name',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Email with Icon
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1ABC9C).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.email_outlined,
                              size: 16,
                              color: Color(0xFF1ABC9C),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              profile!['email'] ?? '',
                              style: const TextStyle(
                                color: Color(0xFF1ABC9C),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Stats Cards
                      // if (completed)
                      //   Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 24),
                      //     child: Row(
                      //       children: [
                      //         Expanded(
                      //           child: _statCard(
                      //             Icons.calendar_today,
                      //             "12",
                      //             "Bookings",
                      //             const Color(0xFF1ABC9C),
                      //           ),
                      //         ),
                      //         const SizedBox(width: 12),
                      //         Expanded(
                      //           child: _statCard(
                      //             Icons.check_circle_outline,
                      //             "8",
                      //             "Completed",
                      //             const Color(0xFF1ABC9C),
                      //           ),
                      //         ),
                      //         const SizedBox(width: 12),
                      //         Expanded(
                      //           child: _statCard(
                      //             Icons.star_outline,
                      //             "4.8",
                      //             "Rating",
                      //             const Color(0xFF1ABC9C),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      //
                      // const SizedBox(height: 32),

                      // Personal Information
                      if (completed)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Personal Information",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _infoTile(
                                Icons.phone_outlined,
                                "Phone Number",
                                profile!['phone'] ?? 'Not set',
                                const Color(0xFF1ABC9C),
                              ),
                              const SizedBox(height: 12),
                              _infoTile(
                                Icons.location_on_outlined,
                                "Address",
                                profile!['address'] ?? 'Not set',
                                const Color(0xFF1ABC9C),
                              ),
                              const SizedBox(height: 12),
                              _infoTile(
                                Icons.currency_rupee,
                                "Visit Charge",
                                "₹${profile!['visit_charge']}",
                                const Color(0xFF1ABC9C),
                              ),
                              const SizedBox(height: 12),
                              _infoTile(
                                Icons.work_outline,
                                "Experience",
                                "${profile!['experience']} years",
                                const Color(0xFF1ABC9C),
                              ),
                            ],
                          ),
                        ),

                      // Create Profile Button
                      if (!completed)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              Icon(
                                Icons.person_add_outlined,
                                size: 80,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Complete Your Profile",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Add your details to get started",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: openProfileSheet,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1ABC9C),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text("Create Profile"),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 32),

                      // Settings & Support Section

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                completed ? "Settings & Support" : "Settings & Support",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 16),

                              _menuTile(
                                Icons.logout,
                                "Logout",
                                logout,
                                textColor: Colors.red,
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuTile(IconData icon, String title, VoidCallback onTap,
      {Color? textColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor ?? Colors.black87),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget field(String label, TextEditingController ctrl, IconData icon,
      {TextInputType type = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1ABC9C), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }

  // Widget cityDropdown() {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance.collection("cities").snapshots(),
  //     builder: (_, snapshot) {
  //       if (!snapshot.hasData) {
  //         return const LinearProgressIndicator();
  //       }
  //       return DropdownButtonFormField<String>(
  //         value: selectedCityId,
  //         hint: const Text("Select City"),
  //         items: snapshot.data!.docs
  //             .map((doc) => DropdownMenuItem(
  //           value: doc.id,
  //           child: Text(doc['name']),
  //         ))
  //             .toList(),
  //         onChanged: (v) => setState(() => selectedCityId = v),
  //         decoration: InputDecoration(
  //           labelText: "City",
  //           prefixIcon: const Icon(Icons.location_city_outlined),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           enabledBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12),
  //             borderSide: BorderSide(color: Colors.grey[300]!),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12),
  //             borderSide: const BorderSide(color: Color(0xFF1ABC9C), width: 2),
  //           ),
  //           filled: true,
  //           fillColor: Colors.grey[50],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget cityDropdown() {
    return GestureDetector(
      onTap: _openCitySearch,
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            labelText: "City",
            prefixIcon: const Icon(Icons.location_city_outlined),
            hintText: "Select City",
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: Color(0xFF1ABC9C), width: 2),
            ),
            suffixIcon: const Icon(Icons.keyboard_arrow_down),
          ),
          controller: TextEditingController(
            text: _getCityNameById(selectedCityId),
          ),
        ),
      ),
    );
  }



  Widget serviceDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("services").snapshots(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        }
        return DropdownButtonFormField<String>(
          value: selectedServiceId,
          hint: const Text("Select Service"),
          items: snapshot.data!.docs
              .map((doc) => DropdownMenuItem(
            value: doc.id,
            child: Text(doc['name']),
          ))
              .toList(),
          onChanged: (v) => setState(() => selectedServiceId = v),
          decoration: InputDecoration(
            labelText: "Service",
            prefixIcon: const Icon(Icons.design_services_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1ABC9C), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        );
      },
    );
  }
}

