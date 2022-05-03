import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nextonmaps/pages/HomePage.dart';
import 'package:nextonmaps/pages/SignInPage.dart';
import 'package:nextonmaps/services/Auth_Service.dart';

List<String> testDevices = ['CAF14E87AAF593178862481BDD790971'];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();

  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: testDevices);
  MobileAds.instance.updateRequestConfiguration(configuration);

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
  // final storage = new FlutterSecureStorage();
  late bool isSignIn;
  List<String> testDevices = ['CAF14E87AAF593178862481BDD790971'];

  @override
  void initState() {
    super.initState();

    if (// readVerification() == null ||
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
    // ignore: prefer_const_constructors
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: const SignInPage(),
      home: isSignIn ? const HomePage() : const SignInPage(),
    );
  }

  // Future<String?> readVerification() async {
  //   String? val = await storage.read(key: "OtpSignIn");
  //   return val;
  // }
}
