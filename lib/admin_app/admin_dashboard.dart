import 'package:flutter/material.dart';

class admin_dashboard extends StatefulWidget {
  const admin_dashboard({super.key});

  @override
  State<admin_dashboard> createState() => _admin_dashboardState();
}

class _admin_dashboardState extends State<admin_dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard"),),
    );
  }
}
