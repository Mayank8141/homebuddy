import 'package:flutter/material.dart';

class customer_home_screen extends StatefulWidget {
  const customer_home_screen({super.key});

  @override
  State<customer_home_screen> createState() => _customer_home_screenState();
}

class _customer_home_screenState extends State<customer_home_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome Customer"),),
    );
  }
}
