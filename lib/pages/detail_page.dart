// ignore_for_file: deprecated_member_use, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nextonmaps/models/all_places.dart';
import 'package:nextonmaps/models/review_model.dart';
import 'package:nextonmaps/repository/db_repository.dart';
import 'package:nextonmaps/themes.dart';
import 'package:nextonmaps/widgets/custom_pop_up_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class DetailsPage extends StatelessWidget {
  final Item item;
  DetailsPage({Key? key, required this.item}) : super(key: key);

  TextEditingController reviewController = TextEditingController();
  DBRepository dbRepository = DBRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                .withGradient(const LinearGradient(colors: [
                  Color.fromARGB(255, 141, 31, 192),
                  Color.fromARGB(255, 204, 63, 106)
                ], begin: Alignment.bottomRight, end: Alignment.topLeft))
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
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                height: 300,
                child: StreamBuilder<List<ReviewModel>>(
                  stream: dbRepository.getReviews(item.name),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<ReviewModel> data = snapshot.data;
                      if (data.isEmpty) {
                        return const Center(
                          child: Text(
                            'No Reviews yet',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            DateTime date = DateTime.fromMillisecondsSinceEpoch(data[index].time * 1000);
                            String formatDate = DateFormat.yMMMd().format(date);
                            return VxBox(
                              child: ListTile(
                                title: Text(data[index].review),
                                subtitle: Text(formatDate),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("${data[index].rating.toInt()}/5"),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    )
                                  ],
                                ),
                              ),
                            )
                                .color(Colors.white)
                                .rounded
                                .border(color: Colors.black, width: 3)
                                .make()
                                .pOnly(left: 8, right: 8, top: 4, bottom: 4);
                          },
                        );
                      }
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Something Went Wrong',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  ElevatedButton(
                      style: Mytheme.customButtonStyle,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => CustomPopUpWidget(
                                  reviewController: reviewController,
                                  placeName: item.name,
                                ));
                      },
                      child: const Text(
                        "Give Review",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                      style: Mytheme.customButtonStyle,
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
                      child: const Text(
                        "Get Directions",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                      style: Mytheme.customButtonStyle,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Go Back",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
            ).pOnly(bottom: 20)
          ],
        ));
  }
}
