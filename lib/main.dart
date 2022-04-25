import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextonmaps/pages/HomePage.dart';
import 'package:nextonmaps/pages/SignInPage.dart';
import 'package:nextonmaps/services/Auth_Service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthClass authClass = AuthClass();
  late StreamSubscription<User?> user;
  final storage = new FlutterSecureStorage();
  late bool isSignIn;

  @override
  void initState() {
    super.initState();

    // user = FirebaseAuth.instance.authStateChanges().listen((user) {
    //   if (user != null) {
    //     print("User Signed In");
    //   } else {
    //     print("User NOT signed in");
    //   }
    // });

    if (readVerification() == null ||
        FirebaseAuth.instance.currentUser == null) {
      isSignIn = false;
      print("signed out");
    } else {
      isSignIn = true;
      print("signed in");
    }
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: const SignInPage(),
      home: isSignIn ? const SignInPage() : const SignInPage(),
    );
  }

  Future<String?> readVerification() async {
    String? val = await storage.read(key: "OtpSignIn");
    return val;
  }
}
