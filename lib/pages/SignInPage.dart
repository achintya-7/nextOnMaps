// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:nextonmaps/pages/HomePage.dart';
import 'package:nextonmaps/pages/PhoneAuthPage.dart';
import 'package:nextonmaps/pages/PrivacyPage.dart';
import 'package:nextonmaps/services/Auth_Service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nextonmaps/widgets/ButtonItems.dart';
import 'package:velocity_x/velocity_x.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  AuthClass authClass = AuthClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Next On Maps",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/Bikaner.jpg"),
                fit: BoxFit.cover)),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Text(
              "Sign In",
              style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ButtonItem(
              imagePath: "assets/images/google.svg",
              text: "Continue with Google",
              size: 25,
              onClick: () async {
                await authClass.googleSignIn(context);
              },
            ),
            ButtonItem(
              imagePath: "assets/images/phone.svg",
              text: "Continue with Phone",
              size: 25,
              onClick: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (builder) => PhoneAuth()),
                );
              },
            ),
            Spacer(),
            InkWell(
              child: Text(
                "By continuing, you agree to our Terms.",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => PrivacyPage()));
              },
            ).pOnly(bottom: 15).centered()
          ],
        ),
      ),
    );
  }
}
