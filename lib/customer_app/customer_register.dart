import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homebuddy/login.dart';
import 'package:flutter/services.dart';
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

  // CONTROLLERS
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  String? selectedCity;

  // REGISTER USER
  Future<void> registerUser() async {
    if (nameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        phoneCtrl.text.isEmpty ||
        addressCtrl.text.isEmpty ||
        selectedCity == null ||
        passwordCtrl.text.length < 6 ||
        !agreeTerms) {
      Snackbar("Please fill all fields and accept terms.");
      return;
    }

    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: emailCtrl.text.trim(),
          password: passwordCtrl.text.trim());

      String uid = user.user!.uid;

      await _firestore.collection("customer_detail").doc(uid).set({
        "uid": uid,
        "name": nameCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "phone": phoneCtrl.text.trim(),
        "city_id": selectedCity,
        "address": addressCtrl.text.trim(),
        "created_at": Timestamp.now(),
      });

      Snackbar("Account Created Successfully!");
      Navigator.push(context, MaterialPageRoute(builder: (_) => login_screen()));

    } catch (e) {
      Snackbar("Error: $e");
    }
  }

  Snackbar(msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(         // <-- STATUS BAR ADDED HERE
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,               // Change color if needed
          statusBarIconBrightness: Brightness.dark,         // Light/Dark based on BG
        ),

    child:  Scaffold(
      backgroundColor: const Color(0xFFEEF1F7),

      body: Center(
        child: SingleChildScrollView(   // solves bottom overflow permanently
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),

          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420), // nice professional view

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 20),

                Center(
                  child: Text("Customer Registration",
                    style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text("Register to continue",
                    style: TextStyle(color: Colors.grey,fontSize: 15),
                  ),
                ),

                const SizedBox(height: 30),

                fieldTitle("Full Name"),
                inputField(controller: nameCtrl, hint: "John Doe", icon: Icons.person_outline),
                const SizedBox(height: 18),

                fieldTitle("Email"),
                inputField(controller: emailCtrl, hint: "example@gmail.com", icon: Icons.email_outlined),
                const SizedBox(height: 18),

                fieldTitle("Phone Number"),
                inputField(controller: phoneCtrl, hint: "9876543210", icon: Icons.phone_outlined),
                const SizedBox(height: 18),

                fieldTitle("City"),
                StreamBuilder(
                    stream: _firestore.collection("cities").snapshots(),
                    builder:(context,snapshot){
                      if(!snapshot.hasData){
                        return SizedBox(height:50,child: Center(child:CircularProgressIndicator()));
                      }
                      return DropdownButtonFormField(
                        value:selectedCity,
                        decoration: inputDecoration(Icons.location_city,"Select City"),
                        items:snapshot.data!.docs.map((d)=>DropdownMenuItem(
                          value:d.id,
                          child:Text(d["name"]),
                        )).toList(),
                        onChanged:(v)=>setState(()=>selectedCity=v),
                      );
                    }),
                const SizedBox(height: 18),

                fieldTitle("Address"),
                inputField(controller: addressCtrl, hint: "House No, Area, City", icon: Icons.location_on_outlined),
                const SizedBox(height: 18),

                fieldTitle("Password"),
                TextField(
                  controller: passwordCtrl,
                  obscureText: !passwordVisible,
                  decoration: inputDecoration(Icons.lock_outline,"Minimum 6 characters").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible?Icons.visibility:Icons.visibility_off),
                      onPressed: ()=>setState(()=>passwordVisible=!passwordVisible),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
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

                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: registerUser,
                    child: const Text("Register", style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),

                const SizedBox(height: 18),

                Center(
                  child: InkWell(
                    onTap: ()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>login_screen())),
                    child: Text("Already have an account? Login",
                      style: TextStyle(color:Colors.deepPurple,fontWeight:FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    )
    );
  }

  // UI ELEMENTS
  Widget fieldTitle(String text) => Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)));

  Widget inputField({required TextEditingController controller, required String hint, required IconData icon, TextInputType keyboard = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: inputDecoration(icon, hint),
    );
  }

  InputDecoration inputDecoration(IconData icon, String hint) => InputDecoration(
    prefixIcon: Icon(icon, color: Colors.deepPurple),
    hintText: hint,
    filled: true,
    fillColor: Color(0xFFF6F6F8),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.deepPurple)),
  );
}
