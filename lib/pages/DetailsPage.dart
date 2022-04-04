// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:nextonmaps/models/allPlaces.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class DetailsPage extends StatelessWidget {
  final Item item;
  const DetailsPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Details',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
              ),
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      height: 1,
                      color: Colors.black,
                    ).p(8),
                    Text(
                      item.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ).p(8),
                    Container(
                      height: 1,
                      color: Colors.black,
                    ).p(8),
                    Text(item.address,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold))
                        .p(8),
                    Container(
                      height: 1,
                      color: Colors.black,
                    ).p(8),
                  ],
                ).centered(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  style: ButtonStyle(
                      enableFeedback: true,
                      overlayColor: MaterialStateProperty.resolveWith((states) {
                        return states.contains(MaterialState.pressed)
                            ? Colors.grey
                            : null;
                      }),
                      elevation: MaterialStateProperty.all(8),
                      fixedSize: MaterialStateProperty.all(const Size(250, 50)),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                              side: const BorderSide(
                                  color: Colors.black, width: 3)))),
                  onPressed: () async {
                    final urlOpen = "comgooglemaps://?daddr=${Uri.encodeFull(item.link)}&directionsmode=driving";
                    try {
                      if (await canLaunch(urlOpen)) {
                        await launch(
                          urlOpen,
                          forceWebView: true,
                          enableJavaScript: true,
                        );
                      }
                    } catch (e) {
                      print("Error : " + e.toString());
                    }
                    print(item.link);
                  },
                  child: Text(
                    "Go to URL Page",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ).pOnly(bottom: MediaQuery.of(context).size.height * 0.1)
          ],
        ));
  }
}

