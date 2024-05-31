import 'package:firebase_test/db/auth_db.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController uNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 150),
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const Text(
                'Sign Up',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
              textField(label: 'Username', controller: uNameController),
              sizedBox(),
              textField(label: 'Email', controller: emailController),
              sizedBox(),
              textField(label: 'Password', controller: passController),
              sizedBox(),
              textField(
                  label: 'Confirm Password', controller: confirmPassController),
              sizedBox(),
              ElevatedButton(
                  onPressed: () async {
                    String email = emailController.text.trim();
                    String pass = passController.text.trim();
                    await Controller.handleSignUp(
                            email: email, password: pass)
                        .then((resp) {
                      if (resp != null) {
                        Navigator.pop(context);
                      }
                    });
                  },
                  child: const Text('Sign up'))
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(
      {required String label, required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget sizedBox() {
    return const SizedBox(
      height: 20,
    );
  }
}
