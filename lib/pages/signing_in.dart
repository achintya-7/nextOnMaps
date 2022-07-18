import 'package:flutter/material.dart';
import 'package:nextonmaps/pages/home_page.dart';
import 'package:nextonmaps/pages/phone_auth.dart';
import 'package:nextonmaps/services/auth_service.dart';
import 'package:nextonmaps/widgets/ButtonItems.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  AuthClass authClass = AuthClass();

  void _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) throw 'Could not launch $uri';
  }

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
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/Bikaner.jpg"),
                fit: BoxFit.cover)),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            const Text(
              "Sign In",
              style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
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
                  MaterialPageRoute(builder: (builder) => const PhoneAuth()),
                );
              },
            ),
            ButtonItem(
                imagePath: "assets/images/profile.svg",
                onClick: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => const HomePage()),
                      (route) => false);
                },
                text: "Continue Anonymously",
                size: 25),
            const Spacer(),
            InkWell(
              child: const Text.rich(TextSpan(
                  text: 'By continuing, you agree to our ',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  children: [
                    TextSpan(
                        text: 'Terms and Condition',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 12,
                            color: Colors.blue))
                  ])),
              onTap: () {
                Uri uri = Uri.parse(
                    'https://sites.google.com/view/nextonmap-privacypolicy/home');
                _launchUrl(uri);
              },
            ).pOnly(bottom: 15).centered()
          ],
        ),
      ),
    );
  }
}
