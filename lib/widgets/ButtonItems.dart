// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonItem extends StatelessWidget {
  const ButtonItem(
      {Key? key,
      required this.imagePath,
      required this.onClick,
      required this.text,
      required this.size})
      : super(key: key);
  final String text;
  final String imagePath;
  final Function onClick;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width - 60,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 3),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  imagePath,
                  height: size,
                  width: size,
                  // color: Colors.white,
                ),
                // Icon(iconData),
                SizedBox(width: 15),
                Text(
                  text,
                  style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
