import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_test/features/home/ui/home.dart';
import 'package:firebase_test/features/login/ui/login.dart';
import 'package:firebase_test/features/splash.dart';
import 'package:firebase_test/firebase_options.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
