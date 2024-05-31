import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Controller {
  static Future<User?> handleSignUp(
      {required String email, required String password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (email.isEmpty) {
        print('Email address is required');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<User?> handleSignIn(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch(e) {
      print('Error: $e');
    return null;
    }
  }

  static Future<void> addUser({
    required BuildContext context,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required CollectionReference userCollection,
  }) async {
    final String name = nameController.text;
    final String email = emailController.text;
    final String phone = phoneController.text;
    final user = FirebaseAuth.instance.currentUser;

    if (name.isNotEmpty && email.isNotEmpty) {
      await userCollection
          .add({
        'userId' : user?.uid,
        'Name': name,
        'Email': email,
        'Phone': phone})
          .then((value) {
        nameController.clear();
        emailController.clear();
        phoneController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add user: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fields are empty')));
    }
  }
}
