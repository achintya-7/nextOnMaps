import 'package:flutter/material.dart';
import 'package:nextonmaps/models/all_places.dart';

class WashroomDetailPage extends StatelessWidget {
  final Item washroom;

  const WashroomDetailPage(this.washroom, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(washroom.name),
        ),
        body: Container());
  }
}
