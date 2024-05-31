import 'package:firebase_test/features/home/ui/home.dart';
import 'package:firebase_test/features/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../signup/ui/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  LoginBloc loginBloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listener: (context, state) {
        if (state is LoginSuccessStateActionState) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Home()));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 150),
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                  sizedBox(),
                  textField(label: 'Email', controller: emailController),
                  sizedBox(),
                  textField(label: 'Password', controller: passController),
                  sizedBox(),
                  ElevatedButton(
                      onPressed: () async {
                        String email = emailController.text.trim();
                        String pass = passController.text.trim();
                        loginBloc.add(
                            LoginInitialEvent(email: email, password: pass));
                      },
                      child: const Text('Login')),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const SignUp()));
                      },
                      child: const Text('Not a user? Signup'))
                ],
              ),
            ),
          ),
        );
      },
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
