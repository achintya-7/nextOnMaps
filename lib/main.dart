import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nextonmaps/my_services/auth_service_custom.dart';
import 'package:nextonmaps/pages/home_page.dart';
import 'package:nextonmaps/pages/signing_in.dart';


List<String> testDevices = ['CAF14E87AAF593178862481BDD790971'];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();

  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: testDevices);
  MobileAds.instance.updateRequestConfiguration(configuration);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthClass authClass = AuthClass();
  late StreamSubscription<User?> user;
  late bool isSignIn;
  List<String> testDevices = ['CAF14E87AAF593178862481BDD790971'];

  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser == null) {
      isSignIn = false;
    } else {
      isSignIn = true;
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
}
