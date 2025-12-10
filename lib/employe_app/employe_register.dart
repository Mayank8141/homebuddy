import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../login.dart';

class employe_register_screen extends StatefulWidget {
  const employe_register_screen({super.key});

  @override
  State<employe_register_screen> createState() => _employe_register_screenState();
}

class _employe_register_screenState extends State<employe_register_screen> {
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
  TextEditingController visitchargeCtrl = TextEditingController();

  String? selectedService;
  String? selectedCity;

  // ---------------- Register User with Firebase Auth + Firestore ----------------
  Future<void> registerEmployee() async {
    if (nameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        phoneCtrl.text.isEmpty ||
        visitchargeCtrl.text.isEmpty ||
        selectedCity == null ||
        selectedService == null ||
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
      await _firestore.collection("employe_detail").doc(uid).set({
        "uid": uid,
        "name": nameCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "phone": phoneCtrl.text.trim(),
        "city_id": selectedCity,
        "service_id": selectedService,
        "visit_charge": visitchargeCtrl.text.trim(),
        "address": addressCtrl.text.trim(),
        "created_at": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Employee Registered Successfully!"))
      );

      //Navigator.pop(context); // or move to employee dashboard screen
      Navigator.push(context,  MaterialPageRoute(builder: (_)=>login_screen()));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(         // <-- STATUS BAR ADDED HERE
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,               // Change color if needed
          statusBarIconBrightness: Brightness.dark,         // Light/Dark based on BG
        ),

        child:  Scaffold(
      backgroundColor: const Color(0xFFEEF1F7),

      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(

              maxWidth: 420,     // width limit only
            ),

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30), // SIDE SPACE
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Center(
                    child: Text(
                      "Employee Registration",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Create your employee account",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),

                  const SizedBox(height: 28),

                  label("Full Name"),
                  textField(controller: nameCtrl, hint: "John Doe", icon: Icons.person_outline),
                  SizedBox(height: 14),

                  label("Email"),
                  textField(controller: emailCtrl, hint: "example@gmail.com", icon: Icons.email_outlined,
                      keyboard: TextInputType.emailAddress),
                  SizedBox(height: 14),

                  label("Phone Number"),
                  textField(controller: phoneCtrl, hint: "9876543210", icon: Icons.phone_outlined,
                      keyboard: TextInputType.phone),
                  SizedBox(height: 14),

                  label("Select Service"),
                  StreamBuilder(
                    stream: _firestore.collection("services").snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox(height: 45, child: Center(child: CircularProgressIndicator()));
                      }

                      return DropdownButtonFormField<String>(
                        value: selectedService,
                        items: snapshot.data!.docs.map((d) => DropdownMenuItem(
                          value: d.id,
                          child: Text(d["name"]),
                        )).toList(),
                        onChanged: (v) => setState(() => selectedService = v),

                        // ⚠ Decoration Added here
                        decoration: InputDecoration(
                          hintText: "Select Service",
                          prefixIcon: Icon(Icons.cleaning_services, color: Colors.deepPurple),
                          filled: true,
                          fillColor: Color(0xFFF3F4F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 14),

                  label("City"),
                  StreamBuilder(
                    stream: _firestore.collection("cities").snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox(height: 50, child: Center(child: CircularProgressIndicator()));
                      }

                      return DropdownButtonFormField<String>(
                        value: selectedCity,
                        items: snapshot.data!.docs.map((d) => DropdownMenuItem(
                          value: d.id,
                          child: Text(d["name"]),
                        )).toList(),
                        onChanged: (v) => setState(() => selectedCity = v),

                        // 🔥 Added Decoration Here
                        decoration: InputDecoration(
                          hintText: "Select City",
                          prefixIcon: Icon(Icons.location_city, color: Colors.deepPurple),
                          filled: true,
                          fillColor: Color(0xFFF3F4F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 14),

                  label("Visit Charge"),
                  textField(controller: visitchargeCtrl, hint: "Enter price", icon: Icons.currency_rupee),
                  SizedBox(height: 14),

                  label("Address"),
                  textField(controller: addressCtrl, hint: "House No, Area, City", icon: Icons.location_on),
                  SizedBox(height: 14),

                  label("Password"),
                  passwordField(),
                  SizedBox(height: 8),
                  Text("Minimum 6 characters", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(height: 12),

                  Row(
                    children: [
                      Checkbox(
                        value: agreeTerms,
                        onChanged:(v)=>setState(()=>agreeTerms=v!),
                        activeColor: Colors.deepPurple,
                      ),
                      Expanded(child: Text("I agree to Terms & Privacy Policy")),
                    ],
                  ),

                  SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: registerEmployee,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Register Now", style: TextStyle(fontSize: 17, color: Colors.white)),
                    ),
                  ),

                  SizedBox(height: 18),
                  Center(
                    child: InkWell(
                      onTap: ()=>Navigator.push(context,
                          MaterialPageRoute(builder:(_)=>login_screen())),
                      child: Text(
                        "Already have an account? Login",
                        style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    )
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
