// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nextonmaps/pages/HomePage.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:pinput/pin_put/pin_put.dart';
import 'package:nextonmaps/services/Auth_Service.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final storage = FlutterSecureStorage();
  late Timer timer;
  int start = 30;
  String? verificationCode;
  final TextEditingController _pinOTPCodeController = TextEditingController();
  final FocusNode _pinOTPCodeFocus = FocusNode();
  bool wait = false;
  String buttonName = "Send";
  AuthClass authClass = AuthClass();
  String verificationIDFinal = "";
  String smsCode = "";
  final TextEditingController _phoneNumber = TextEditingController();

  final BoxDecoration pinOTPCodeDecoration = BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white, width: 3));

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

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
              RichText(
                  text: TextSpan(
                children: [
                  TextSpan(
                    text: "Send OTP again in ",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(
                    text: "00:$start",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  TextSpan(
                    text: " sec ",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              )),
              SizedBox(
                height: 150,
              ),
              InkWell(
                onTap: () {
                  dispose();
                  authClass.signInWithPhoneNumber(
                      verificationIDFinal, smsCode, context);
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

  void startTimer() {
    const onesec = Duration(seconds: 1);
    timer = Timer.periodic(onesec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  Widget otpField() {
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width,
      fieldWidth: 50,
      otpFieldStyle: OtpFieldStyle(
        backgroundColor: Colors.black,
        borderColor: Colors.white,
      ),
      style: TextStyle(fontSize: 17, color: Colors.white),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.box,
      onCompleted: (pin) {
        setState(() {
          setData(smsCode = pin);
        });
      },
    ).pOnly(left: 12, right: 12);
  }

  Widget otpField2() {
    return PinPut(
      separator: SizedBox(width: 15.0),
      fieldsCount: 6,
      textStyle: TextStyle(fontSize: 25, color: Colors.white),
      eachFieldWidth: 50,
      eachFieldHeight: 55,
      focusNode: _pinOTPCodeFocus,
      controller: _pinOTPCodeController,
      submittedFieldDecoration: pinOTPCodeDecoration,
      selectedFieldDecoration: pinOTPCodeDecoration,
      followingFieldDecoration: pinOTPCodeDecoration,
      pinAnimationType: PinAnimationType.rotation,
      onSubmit: (pin) async {
        setState(() {
          smsCode = pin;
          authClass.signInWithPhoneNumber(
              verificationIDFinal, smsCode, context);
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
              onTap: wait
                  ? null
                  : () async {
                      setState(() {
                        start = 30;
                        wait = true;
                        buttonName = "Resend";
                      });
                      await authClass.verifyPhoneNumber(
                          "+91 ${_phoneNumber.text}", context, setData);
                    },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Text(
                  buttonName,
                  style: TextStyle(
                    color: wait ? Colors.grey : Colors.black,
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

  void setData(String verificationID) {
    setState(() {
      verificationIDFinal = verificationID;
    });
    startTimer();
  }
}
