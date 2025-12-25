import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homebuddy/login.dart';
import 'package:image_picker/image_picker.dart';

class customer_register_screen extends StatefulWidget {
  const customer_register_screen({super.key});

  @override
  State<customer_register_screen> createState() =>
      _customer_register_screenState();
}

class _customer_register_screenState extends State<customer_register_screen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool passwordVisible = false;
  bool agreeTerms = false;
  bool loading = false;

  // Controllers
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  String? selectedCity;

  // ================= IMAGE =================
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  Future<String> uploadImage(File imageFile) async {
    const cloudinaryUrl =
        "https://api.cloudinary.com/v1_1/drsaz2xgk/image/upload";
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path),
      'upload_preset': 'homebuddy',
    });
    final response = await Dio().post(cloudinaryUrl, data: formData);
    return response.data['secure_url'];
  }

  // ================= VALIDATION HELPERS =================
  bool isValidName(String name) {
    return name.length >= 3 &&
        RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(name);
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$')
        .hasMatch(email);
  }

  bool isValidPhone(String phone) {
    return RegExp(r'^[0-9]{10}$').hasMatch(phone);
  }

  // ================= FIRESTORE CHECKS =================
  Future<bool> isNameExists(String name) async {
    final query = await _firestore
        .collection("customer_detail")
        .where("name_lowercase",
        isEqualTo: name.trim().toLowerCase())
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }

  Future<bool> isEmailExists(String email) async {
    final query = await _firestore
        .collection("customer_detail")
        .where("email", isEqualTo: email.trim())
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }

  // ================= REGISTER CUSTOMER =================
  Future<void> registerCustomer() async {
    if (_profileImage == null) {
      showMsg("Please select profile picture", Colors.orange);
      return;
    }

    if (!isValidName(nameCtrl.text.trim())) {
      showMsg("Enter a valid full name", Colors.orange);
      return;
    }

    if (!isValidEmail(emailCtrl.text.trim())) {
      showMsg("Enter valid Gmail address (.com only)", Colors.orange);
      return;
    }

    if (!isValidPhone(phoneCtrl.text.trim())) {
      showMsg("Enter valid 10-digit phone number", Colors.orange);
      return;
    }

    if (addressCtrl.text.isEmpty ||
        selectedCity == null ||
        passwordCtrl.text.length < 6 ||
        !agreeTerms) {
      showMsg("Please fill all fields correctly", Colors.orange);
      return;
    }

    setState(() => loading = true);

    // 🔍 CHECK NAME
    if (await isNameExists(nameCtrl.text.trim())) {
      showMsg("Name already exists", Colors.red);
      setState(() => loading = false);
      return;
    }

    // 🔍 CHECK EMAIL
    if (await isEmailExists(emailCtrl.text.trim())) {
      showMsg("Email already registered", Colors.red);
      setState(() => loading = false);
      return;
    }

    try {
      final imageUrl = await uploadImage(_profileImage!);

      final UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      final uid = userCredential.user!.uid;

      await _firestore.collection("customer_detail").doc(uid).set({
        "customer_id": uid,
        "name": nameCtrl.text.trim(),
        "name_lowercase": nameCtrl.text.trim().toLowerCase(),
        "email": emailCtrl.text.trim(),
        "phone": phoneCtrl.text.trim(),
        "city_id": selectedCity,
        "address": addressCtrl.text.trim(),
        "created_at": Timestamp.now(),
        "image": imageUrl,
      });

      showMsg("Customer registered successfully", Colors.green);

      await Future.delayed(const Duration(milliseconds: 1500));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => login_screen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showMsg("Email already registered", Colors.red);
      } else {
        showMsg(e.message ?? "Registration failed", Colors.red);
      }
    } catch (e) {
      showMsg("Error: $e", Colors.red);
    } finally {
      setState(() => loading = false);
    }
  }

  // ================= UI =================
  void showMsg(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == Colors.green
                  ? Icons.check_circle
                  : color == Colors.orange
                  ? Icons.warning_amber_rounded
                  : Icons.error_outline,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Back Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 32),

                // Header
                const Text(
                  "Customer Registration",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Register to continue",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 40),

                // Profile Image Picker
                Center(
                  child: GestureDetector(
                    onTap: pickImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: _profileImage == null
                                ? LinearGradient(
                              colors: [
                                const Color(0xFF1ABC9C),
                                const Color(0xFF16A085),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                                : null,
                            image: _profileImage != null
                                ? DecorationImage(
                              image: FileImage(_profileImage!),
                              fit: BoxFit.cover,
                            )
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1ABC9C).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: _profileImage == null
                              ? const Icon(
                            Icons.person_rounded,
                            size: 50,
                            color: Colors.white,
                          )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1ABC9C),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    _profileImage == null ? "Tap to add photo" : "Tap to change photo",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Full Name
                fieldTitle("Full Name"),
                const SizedBox(height: 8),
                inputField(
                  controller: nameCtrl,
                  hint: "John Doe",
                  icon: Icons.person_outline_rounded,
                ),

                const SizedBox(height: 20),

                // Email
                fieldTitle("Email"),
                const SizedBox(height: 8),
                inputField(
                  controller: emailCtrl,
                  hint: "example@gmail.com",
                  icon: Icons.email_outlined,
                ),

                const SizedBox(height: 20),

                // Phone Number
                fieldTitle("Phone Number"),
                const SizedBox(height: 8),
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: inputDecoration(
                    Icons.phone_outlined,
                    "9876543210",
                  ),
                ),

                const SizedBox(height: 20),

                // City
                fieldTitle("City"),
                const SizedBox(height: 8),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection("cities").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        height: 58,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: const CircularProgressIndicator(
                          color: Color(0xFF1ABC9C),
                        ),
                      );
                    }

                    return DropdownButtonFormField<String>(
                      value: selectedCity,
                      decoration: inputDecoration(
                        Icons.location_city_rounded,
                        "Select City",
                      ),
                      items: snapshot.data!.docs.map((doc) {
                        return DropdownMenuItem<String>(
                          value: doc.id,
                          child: Text(doc["name"]),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => selectedCity = v),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Address
                fieldTitle("Address"),
                const SizedBox(height: 8),
                inputField(
                  controller: addressCtrl,
                  hint: "House No, Area, City",
                  icon: Icons.location_on_outlined,
                ),

                const SizedBox(height: 20),

                // Password
                fieldTitle("Password"),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordCtrl,
                  obscureText: !passwordVisible,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration:
                  inputDecoration(Icons.lock_outline_rounded, "Minimum 6 characters")
                      .copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey[600],
                        size: 22,
                      ),
                      onPressed: () =>
                          setState(() => passwordVisible = !passwordVisible),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Terms & Conditions
                // Material(
                //   color: Colors.transparent,
                //   child: InkWell(
                //     onTap: () => setState(() => agreeTerms = !agreeTerms),
                //     borderRadius: BorderRadius.circular(12),
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(vertical: 8),
                //       child: Row(
                //         children: [
                //           Container(
                //             width: 24,
                //             height: 24,
                //             decoration: BoxDecoration(
                //               color: agreeTerms
                //                   ? const Color(0xFF1ABC9C)
                //                   : Colors.transparent,
                //               border: Border.all(
                //                 color: agreeTerms
                //                     ? const Color(0xFF1ABC9C)
                //                     : Colors.grey[400]!,
                //                 width: 2,
                //               ),
                //               borderRadius: BorderRadius.circular(6),
                //             ),
                //             child: agreeTerms
                //                 ? const Icon(
                //               Icons.check,
                //               color: Colors.white,
                //               size: 18,
                //             )
                //                 : null,
                //           ),
                //           const SizedBox(width: 12),
                //           Expanded(
                //             child: Text(
                //               "I agree to Terms & Privacy Policy",
                //               style: TextStyle(
                //                 fontSize: 15,
                //                 color: Colors.grey[700],
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),

                const SizedBox(height: 32),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1ABC9C),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                    onPressed: loading ? null : registerCustomer,
                    child: loading
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                        : const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Login Link
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => login_screen()),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15,
                        ),
                        children: const [
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              color: Color(0xFF1ABC9C),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= UI HELPERS =================
  Widget fieldTitle(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
  );

  Widget inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: inputDecoration(icon, hint),
    );
  }

  InputDecoration inputDecoration(IconData icon, String hint) => InputDecoration(
    prefixIcon: Icon(icon, color: const Color(0xFF1ABC9C), size: 22),
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
    filled: true,
    fillColor: Colors.grey[50],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.grey[200]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFF1ABC9C), width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 18,
    ),
  );

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }
}