// ignore_for_file: prefer_const_constructors, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nextonmaps/pages/home_page.dart';
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
  var isLoading = false;
  bool isVerified = false;
  String pinNumber = "";
  final failSnackBar = SnackBar(
      content:
          Text("'Something went wrong, Are you connected with the Internet?'"));
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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/background/otp_background.jpg"),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Phone OTP",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: Row(
          children: [
            Spacer(),
            Visibility(
                visible: isLoading,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                ).p(16),
                replacement: SizedBox()),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.3,
              //   color: Color.fromARGB(255, 14, 134, 233),
              //   child: Center(
              //     child: Column(
              //       children: [
              //         const Spacer(),
              //         Image.asset(
              //           'assets/images/playstore.png',
              //           height: 100,
              //           width: 100,
              //         ),
              //         const Spacer(),
              //         Text(
              //           'Next On Map',
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 30,
              //               fontWeight: FontWeight.bold),
              //         ),
              //         const Spacer()
              //       ],
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
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
                height: 50,
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
                    backgroundColor: MaterialStateProperty.all(isVerified
                        ? Color.fromARGB(255, 14, 134, 233)
                        : Colors.grey),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ))),
                onPressed: isVerified
                    ? () async {
                        await verifyCode();
                      }
                    : null,
                child: const Text(
                  "Continue",
                  style: TextStyle(
                      color: Colors.white,
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
              debugPrint("user logged in");
              setState(() {
                isLoading = false;
              });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => HomePage()),
                  (route) => false);
            }
          });
          final verifySnackBar =
              SnackBar(content: Text("OTP Verified Automatically"));
          ScaffoldMessenger.of(context).showSnackBar(verifySnackBar);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Error : ${e.message}');
          setState(() {
            isLoading = false;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Error : ${e.message}")));
          });
        },
        codeSent: (String verificationID, int? resendToken) {
          verificationIDFinal = verificationID;
          setState(() {
            isVerified = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            isLoading = false;
            verificationIDFinal = verificationID;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Error : OTP Time Out")));
          });
        },
        timeout: Duration(seconds: 50));
  }

  verifyCode() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIDFinal, smsCode: pinNumber.toString());

    if (pinNumber.length == 6) {
      try {
        await auth.signInWithCredential(credential).then((value) async {
          if (value.user != null) {
            print("Pass to home");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => HomePage()),
                (route) => false);
          }
        });
      } on FirebaseAuthException catch (e) {
        print('Error : $e');
        FocusScope.of(context).unfocus();
        final snackBar = SnackBar(content: Text("Error : Invalid OTP"));
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
                  // isVerified = false;
                  await verifyPhone();
                  setState(() {
                    isLoading = true;
                    buttonName = "Sent";
                  });
                }
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
                borderSide: BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(12)))),
      ).pOnly(left: 12, right: 12),
    );
  }
}
