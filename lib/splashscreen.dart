import 'dart:async';

import 'package:face_mark/authscreens/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Container(
          width: 180,
          height: 150,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/facemark.png'),
            fit: BoxFit.fill,
          )),
        ),
      ),
    ));
  }
}
