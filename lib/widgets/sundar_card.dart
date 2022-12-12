import 'package:flutter/material.dart';

class SundarCard extends StatelessWidget {
  const SundarCard({super.key, required this.widget, required this.radius, this.height});
  final Widget widget;
  final double radius;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 50,
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: widget,
      ),
    );
  }
}
