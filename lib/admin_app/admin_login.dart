import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'admin_dashboard.dart';

class admin_login extends StatefulWidget {
  const admin_login({super.key});

  @override
  State<admin_login> createState() => _admin_loginState();
}

class _admin_loginState extends State<admin_login> {

  final TextEditingController _admin_email_controller=TextEditingController();
  final TextEditingController _admin_pass_controller=TextEditingController();

  Future<bool> validateAdminCredentials(String email,String password) async{
    try{
      final QuerySnapshot adminsnapshot=await
          FirebaseFirestore.instance.collection('admin').where('email',isEqualTo: email).limit(1).get();
          if(adminsnapshot.docs.isEmpty) return false;
          final adminData =adminsnapshot.docs.first.data() as Map<String,dynamic>;
          return adminData['password'] == password;
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      return false;
    }
  }
  Future<void>LoginAsAdmin() async{
    final email=_admin_email_controller.text.trim();
    final pass=_admin_pass_controller.text.trim();

    if(email.isEmpty||pass.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("plese fill detail")));
      return;

    }
    try{
      final isAdminValid =await validateAdminCredentials(email,pass);
      if(isAdminValid){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>admin_dashboard()));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("plese fill detail")));
      }
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin login"),),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _admin_email_controller,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller:_admin_pass_controller,
              obscureText: true,
              decoration: InputDecoration(labelText: "password"),
            ),
            SizedBox(height: 16,),
            ElevatedButton(onPressed:(){},
                child: Text("Login")),
          ],


        ),

      ),
    );
  }
}

