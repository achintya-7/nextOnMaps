// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nextonmaps/pages/HomePage.dart';
import 'package:nextonmaps/services/Auth_Service.dart';
import 'package:pinput/pinput.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final storage = FlutterSecureStorage();
  final snackBar = SnackBar(content: Text("Invalid OTP"));
  String pinNumber = "";
  final snackBar2 =
      SnackBar(content: Text("Please enter a 10 digit Phone Number"));
  final snackBar3 = SnackBar(content: Text("Please enter a 6 digit OTP pin"));
  late String _verificationCode;
  String buttonName = "Send";
  final TextEditingController _pinOTPCodeController = TextEditingController();
  final FocusNode _pinOTPCodeFocus = FocusNode();
  final TextEditingController _phoneNumber = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Phone OTP",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 150),
              textField(),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: 1,
                      color: Colors.black,
                      margin: EdgeInsets.symmetric(horizontal: 12),
                    )),
                    Text("Enter 6 digit OTP",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    Expanded(
                        child: Container(
                      height: 1,
                      color: Colors.black,
                      margin: EdgeInsets.symmetric(horizontal: 12),
                    )),
                  ],
                ),
              ),
              SizedBox(height: 30),
              otpField2(),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 150,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    enableFeedback: true,
                    elevation: MaterialStateProperty.all(8),
                    overlayColor: MaterialStateProperty.resolveWith((states) {
                      return states.contains(MaterialState.pressed)
                          ? Colors.grey
                          : null;
                    }),
                    fixedSize: MaterialStateProperty.all(const Size(250, 50)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                            side: const BorderSide(
                                color: Colors.black, width: 3)))),
                onPressed: () {
                  if (_pinOTPCodeController.text.length < 6) {
                    final otpVerifySnackBar =
                        SnackBar(content: Text("Pls enter a 6 digit OTP"));
                    ScaffoldMessenger.of(context)
                        .showSnackBar(otpVerifySnackBar);
                  } else {
                    try {
                      verifyOTP();
                    } catch (e) {
                      FocusScope.of(context).unfocus();
                      final snackBar = SnackBar(content: Text("Invalid OTP"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
                child: const Text(
                  "Log In",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: () {
                  verifyOTP();
                },
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width - 60,
                  decoration: BoxDecoration(
                      color: Color(0xffff9601),
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      "Lets Go",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget otpField2() {
    return Pinput(
      
      length: 6,
      separator: SizedBox(width: 15.0),
      focusNode: _pinOTPCodeFocus,
      controller: _pinOTPCodeController,
      pinAnimationType: PinAnimationType.fade,
      textCapitalization: TextCapitalization.characters,
      androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
      onChanged: (pin) {
        setState(() {
          pinNumber = pin;
        });
      },
      onSubmitted: (pin) async {
        setState(() {
          try {
            verifyOTP();
          } catch (e) {
            FocusScope.of(context).unfocus();
            final snackBar = SnackBar(content: Text("Invalid OTP"));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        });
      },
    ).pOnly(left: 8, right: 8);
  }

  Widget textField() {
    return Container(
      child: TextFormField(
        maxLength: 10,
        controller: _phoneNumber,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.phone,
        style: TextStyle(
          letterSpacing: 2.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 19, horizontal: 8),
            prefixIcon: SizedBox(width: 20),
            suffixIcon: InkWell(
              splashColor: Colors.black,
              onTap: () {
                if (_phoneNumber.text.length < 10) {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                } else {
                  loginWithPhone();
                }
                setState(() {
                  buttonName = "Sent";
                });
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Text(
                  buttonName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            fillColor: Colors.white,
            filled: true,
            border: InputBorder.none,
            hintText: "Enter your Phone",
            hintStyle: TextStyle(color: Colors.grey),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(32))),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(32)))),
      ).pOnly(left: 12, right: 12),
    );
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      phoneNumber: "+91" + _phoneNumber.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
          final verifySnackBar = SnackBar(content: Text("Phone Verified"));
          ScaffoldMessenger.of(context).showSnackBar(verifySnackBar);
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationCode = verificationId;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationCode, smsCode: _pinOTPCodeController.text);

    try {
      await auth.signInWithCredential(credential).then(
        (value) {
          final logInSnackBar = SnackBar(content: Text("Logged In"));
          ScaffoldMessenger.of(context).showSnackBar(logInSnackBar);
        },
      );

      Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (builder) => HomePage()),
      (route) => false);


    } catch (e) {
      FocusScope.of(context).unfocus();
      final snackBar = SnackBar(content: Text("Invalid OTP"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
