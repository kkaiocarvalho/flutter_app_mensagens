import 'package:firebase_core/firebase_core.dart';
import 'Pages/Login e Cad/Login.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp Clone2a3a',
      theme: ThemeData(
          primaryColor: Colors.white,
          shadowColor: const Color(0xff128c7e)
      ),
      home: Login(),
    );
  }
}
