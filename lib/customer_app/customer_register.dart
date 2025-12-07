import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homebuddy/login.dart';
import 'package:image_picker/image_picker.dart';



class customer_register_screen extends StatefulWidget {
  const customer_register_screen({super.key});

  @override
  State<customer_register_screen> createState() => _customer_register_screenState();
}

class _customer_register_screenState extends State<customer_register_screen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  bool passwordVisible = false;
  bool agreeTerms = false;

  // ---------------- Controllers ----------------
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  //String? selectedService;
  String? selectedCity;

  // ---------------- Register User with Firebase Auth + Firestore ----------------
  Future<void> registerUser() async {
    if (nameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        phoneCtrl.text.isEmpty ||
        selectedCity == null ||
        //selectedService == null ||
        addressCtrl.text.isEmpty ||
        passwordCtrl.text.length < 6 ||
        !agreeTerms) {

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Fill all fields, min 6 char password & accept terms!"))
      );
      return;
    }

    try {
      // Create email-password account
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      String uid = userCred.user!.uid;

      // Store employee data in Firestore
      await _firestore.collection("customer_detail").doc(uid).set({
        "uid": uid,
        "name": nameCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "phone": phoneCtrl.text.trim(),
        "city_id": selectedCity,
        //"service_id": selectedService,
        "address": addressCtrl.text.trim(),
        "created_at": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Employee Registered Successfully!"))
      );

      Navigator.pop(context); // or move to employee dashboard screen

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8ECF7),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text("user Registration",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                ),
                SizedBox(height: 30),

                label("Full Name "),
                textField(controller: nameCtrl, hint: "John Doe", icon: Icons.person_outline),
                SizedBox(height: 18),

                label("Email Address "),
                textField(controller: emailCtrl, hint: "john@example.com", icon: Icons.email_outlined, keyboard: TextInputType.emailAddress),
                SizedBox(height: 18),

                label("Phone Number "),
                textField(controller: phoneCtrl, hint: "+1 (555) 000-0000", icon: Icons.phone_outlined, keyboard: TextInputType.phone),
                SizedBox(height: 18),

                // ---------------- Service Dropdown ----------------
                // label("Select Service *"),
                // StreamBuilder<QuerySnapshot>(
                //   stream: _firestore.collection("services").snapshots(),
                //   builder: (context, snapshot) {
                //     if (!snapshot.hasData) return CircularProgressIndicator();
                //     return dropdown(
                //       value: selectedService,
                //       items: snapshot.data!.docs.map((d) => DropdownMenuItem(
                //         value: d.id,
                //         child: Text(d["name"]),
                //       )).toList(),
                //       onChanged: (v) => setState(() => selectedService = v),
                //     );
                //   },
                // ),
                // SizedBox(height: 18),

                // ---------------- City Dropdown ----------------
                label("City "),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection("cities").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return dropdown(
                      value: selectedCity,
                      items: snapshot.data!.docs.map((d) => DropdownMenuItem(
                        value: d.id,
                        child: Text(d["name"]),
                      )).toList(),
                      onChanged: (v) => setState(() => selectedCity = v),
                    );
                  },
                ),
                SizedBox(height: 18),

                label("Address "),
                textField(controller: addressCtrl, hint: "123 Main Street, Apt 4B", icon: Icons.location_on_outlined),
                SizedBox(height: 18),

                label("Password "),
                passwordField(),
                SizedBox(height: 8),
                Text("Minimum 6 characters", style: TextStyle(color: Colors.black54, fontSize: 12)),
                SizedBox(height: 20),

                Row(
                  children: [
                    Checkbox(value: agreeTerms, onChanged: (v) => setState(() => agreeTerms = v!), activeColor: Colors.deepPurple),
                    Expanded(child: Text("I agree to the Terms & Privacy Policy"))
                  ],
                ),
                SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: registerUser,
                    child: Text("Create Account", style: TextStyle(fontSize: 17, color: Colors.white)),
                  ),
                ),

                SizedBox(height: 20),
                Center(child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => login_screen()), // Change where needed
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.black87),
                      children: [
                        TextSpan(
                          text: " Login",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //--------------- UI Components ---------------

  Widget label(String text)=> Text(text,style: TextStyle(fontSize:14,fontWeight:FontWeight.w600));

  Widget textField({required TextEditingController controller,required String hint,required IconData icon,TextInputType keyboard=TextInputType.text}){
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: inputDec(icon,hint),
    );
  }

  Widget passwordField(){
    return TextField(
      controller: passwordCtrl,
      obscureText: !passwordVisible,
      decoration: inputDec(Icons.lock_outline,"Create password").copyWith(
        suffixIcon: IconButton(
          icon: Icon(passwordVisible?Icons.visibility:Icons.visibility_off,color:Colors.grey),
          onPressed: ()=> setState(()=>passwordVisible=!passwordVisible),
        ),
      ),
    );
  }

  Widget dropdown({required String? value,required List<DropdownMenuItem<String>> items,required Function(String?) onChanged}){
    return DropdownButtonFormField<String>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: inputDec(Icons.arrow_drop_down,"Select"),
    );
  }

  InputDecoration inputDec(IconData icon,String hint)=> InputDecoration(
    prefixIcon: Icon(icon,color:Colors.deepPurple),
    hintText: hint,
    filled:true,
    fillColor:Color(0xFFF3F4F6),
    border:OutlineInputBorder(borderRadius:BorderRadius.circular(10),borderSide:BorderSide.none),
  );
}
