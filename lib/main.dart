import 'package:flutter/material.dart';
import 'package:home_serviece_app/HOME_SERVICE_APP_USERPANEL/mobile_otp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),   // Now works
    );
  }
}
