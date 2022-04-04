import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nextonmaps/pages/HomePage.dart';
import 'package:nextonmaps/pages/MapPage.dart';
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
  Widget currentPage = const MapSampleTwo();
  AuthClass authClass = AuthClass();

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  void checkLogin() async {
    String? token = await authClass.getToken();
    if (token != null) {
      setState(() {
        currentPage = const MapSampleTwo();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: currentPage,
    );
  }
}
