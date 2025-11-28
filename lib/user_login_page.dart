import 'package:flutter/material.dart';


class user_login extends StatefulWidget {
  const user_login({super.key});

  @override
  State<user_login> createState() => _user_loginState();
}

class _user_loginState extends State<user_login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child:SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24,vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome Back",style: TextStyle(fontSize: 16,color: Colors.black),),
                Text("Welcome Back",style: TextStyle(fontSize: 16,color: Colors.black),)

              ],
            ),
          )

      ),
    );
  }
}
