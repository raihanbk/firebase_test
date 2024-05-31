import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/features/home/ui/home.dart';
import 'package:firebase_test/features/login/ui/login.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    Timer(const Duration(seconds: 2), () {
      if(user == null) {
        Navigator.push(context, MaterialPageRoute(builder: (_)=> const Login()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (_)=> Home()));
      }
    });
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Icon(
              Icons.logo_dev_outlined,
              size: 50,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
