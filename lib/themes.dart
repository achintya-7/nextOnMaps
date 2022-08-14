// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Mytheme {
  static ThemeData darkTheme(BuildContext context) => ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        cardColor: Colors.black,
        canvasColor: darkcreamColor,
        buttonColor: purpleBluishColor,
        accentColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );

  //Colors
  static Color creamColor = const Color(0xfff5f5f5);
  static Color darkcreamColor = Vx.gray900;
  static Color darkBluishColor = const Color(0xff403b58);
  static Color purpleBluishColor = Vx.indigo500;

  static ButtonStyle customButtonStyle = ButtonStyle(
      enableFeedback: true,
      overlayColor: MaterialStateProperty.resolveWith((states) {
        return states.contains(MaterialState.pressed) ? Colors.grey : null;
      }),
      elevation: MaterialStateProperty.all(8),
      fixedSize: MaterialStateProperty.all(const Size(250, 50)),
      backgroundColor: MaterialStateProperty.all(Colors.white),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
              side: const BorderSide(color: Colors.black, width: 3))));
}
