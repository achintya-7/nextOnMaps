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
            VxAnimatedBox()
                .size(context.screenWidth, context.screenHeight)
                .withGradient(const LinearGradient(
                    colors: [Color.fromARGB(255, 141, 31, 192), Color.fromARGB(255, 204, 63, 106)],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft))
                .make(),
                

            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    height: 1,
                    color: Colors.white54,
                  ).p(8),
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ).p(8),
                  Container(
                    height: 1,
                    color: Colors.white54,
                  ).p(8),
                  Text(item.address,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))
                      .p(8),
                  Container(
                    height: 1,
                    color: Colors.white54,
                  ).p(8),
                ],
              ).centered(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          enableFeedback: true,
                          overlayColor:
                              MaterialStateProperty.resolveWith((states) {
                            return states.contains(MaterialState.pressed)
                                ? Colors.grey
                                : null;
                          }),
                          elevation: MaterialStateProperty.all(8),
                          fixedSize:
                              MaterialStateProperty.all(const Size(250, 50)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                      side: const BorderSide(
                                          color: Colors.black, width: 3)))),
                      onPressed: () async {
                        const urlOpen = "https://g.co/kgs/8v65s1";
                        try {
                          if (await canLaunch(item.link)) {
                            await launch(
                              item.link,
                              forceWebView: false,
                              enableJavaScript: true,
                            );
                          }
                        } catch (e) {
                          print("Error : " + e.toString());
                        }
                        print(item.link);
                      },
                      child: Text(
                        "Get Directions",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          enableFeedback: true,
                          overlayColor:
                              MaterialStateProperty.resolveWith((states) {
                            return states.contains(MaterialState.pressed)
                                ? Colors.grey
                                : null;
                          }),
                          elevation: MaterialStateProperty.all(8),
                          fixedSize:
                              MaterialStateProperty.all(const Size(250, 50)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                      side: const BorderSide(
                                          color: Colors.black, width: 3)))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Go Back",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
            ).pOnly(bottom: MediaQuery.of(context).size.height * 0.1)
          ],
        ));
  }
}
