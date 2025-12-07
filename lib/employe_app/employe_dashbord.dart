import 'package:flutter/material.dart';

class employe_deshbord_screen extends StatefulWidget {
  const employe_deshbord_screen({super.key});

  @override
  State<employe_deshbord_screen> createState() => _employe_deshbord_screenState();
}

class _employe_deshbord_screenState extends State<employe_deshbord_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome Employe"),),
    );
  }
}
