// ignore_for_file: prefer_const_constructors, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nextonmaps/pages/HomePage.dart';
import 'package:pinput/pinput.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  // final storage = FlutterSecureStorage();
  final snackBar = SnackBar(content: Text("Invalid OTP"));
  String pinNumber = "";
  final snackBar2 =
      SnackBar(content: Text("Please enter a 10 digit Phone Number"));
  final snackBar3 = SnackBar(content: Text("Please enter a 6 digit OTP pin"));
  String? verificationCode;
  final TextEditingController _pinOTPCodeController = TextEditingController();
  final FocusNode _pinOTPCodeFocus = FocusNode();
  bool wait = false;
  String buttonName = "Send";
  String verificationIDFinal = "";
  String smsCode = "";
  final TextEditingController _phoneNumber = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  final BoxDecoration pinOTPCodeDecoration = BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white, width: 3));

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
              SizedBox(
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
                    fixedSize: MaterialStateProperty.all(const Size(280, 50)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                            side: const BorderSide(
                                color: Colors.black, width: 3)))),
                onPressed: () async {

                  await verifyCode();

                  // if (pinNumber.length == 6) {
                  //   smsCode = pinNumber;
                  //   //     try {
                  //   //       await auth
                  //   //           .signInWithCredential(PhoneAuthProvider.credential(
                  //   //               verificationId: verificationIDFinal,
                  //   //               smsCode: smsCode))
                  //   //           .then((value) async {
                  //   //         if (value.user != null) {
                  //   //           print("Pass to home");

                  //   //           // await storage.write(key: "OtpSignIn", value: "True");

                  //   //           Navigator.pushAndRemoveUntil(
                  //   //               context,
                  //   //               MaterialPageRoute(
                  //   //                   builder: (builder) => HomePage()),
                  //   //               (route) => false);
                  //   //         }
                  //   //       });
                  //   //     } catch (e) {
                  //   //       FocusScope.of(context).unfocus();
                  //   //       final snackBar = SnackBar(content: Text(e.toString()));
                  //   //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  //   //     }
                  //   //     // authClass.signInWithPhoneNumber(
                  //   //     //     verificationIDFinal, smsCode, context);
                  // }
                },
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  verifyPhone() async {
    await auth.verifyPhoneNumber(
        phoneNumber: "+91${_phoneNumber.text}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) async {
            if (value.user != null) {
              print("user logged in");
              // await storage.write(key: "OtpSignIn", value: "True");

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => HomePage()),
                  (route) => false);
            }
          });
          final verifySnackBar = SnackBar(content: Text("OTP Verified"));
          ScaffoldMessenger.of(context).showSnackBar(verifySnackBar);
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationID, int? resendToken) {
          setState(() {
            verificationIDFinal = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            verificationIDFinal = verificationID;
          });
        },
        timeout: Duration(seconds: 90));
  }

  verifyCode() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIDFinal, smsCode: pinNumber.toString());

    if (pinNumber.length == 6) {
      try {
        await auth.signInWithCredential(credential).then((value) async {
          if (value.user != null) {
            print("Pass to home");

            // await storage.write(key: "OtpSignIn", value: "True");

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => HomePage()),
                (route) => false);
          }
        });
      } catch (e) {
        print("\n" + e.toString() + "\n");
        FocusScope.of(context).unfocus();
        final snackBar = SnackBar(content: Text("Invalid OTP, try again"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar3);
    }
  }

  Widget otpField2() {
    return Pinput(
      length: 6,
      separator: SizedBox(width: 15.0),
      focusNode: _pinOTPCodeFocus,
      controller: _pinOTPCodeController,
      pinAnimationType: PinAnimationType.fade,
      onChanged: (pin) {
        setState(() {
          pinNumber = pin;
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
              onTap: () async {
                if (_phoneNumber.text.length != 10) {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                } else {
                  FocusManager.instance.primaryFocus?.unfocus();
                  await verifyPhone();
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
}
