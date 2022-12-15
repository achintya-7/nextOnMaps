// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomPopUpWidget extends StatefulWidget {
  const CustomPopUpWidget({
    Key? key,
    required this.reviewController,
    required this.placeName,
  }) : super(key: key);

  final TextEditingController reviewController;
  final String placeName;

  @override
  State<CustomPopUpWidget> createState() => _CustomPopUpWidgetState();
}

class _CustomPopUpWidgetState extends State<CustomPopUpWidget> {
  double rating = 0.0;
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      title: const Text('Add a Review'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widget.reviewController,
            maxLength: 1000,
            decoration: const InputDecoration(
              labelText: "Write a Review here",
            ),
            maxLines: 3,
          ),
          buildRating(),
          ElevatedButton(
              onPressed: () {
                if (widget.reviewController.text.isNotEmpty) {
                  if (rating != 0) {
                    print("Rating : $rating");
                    try {
                      db.collection(widget.placeName).doc().set({
                        'review': widget.reviewController.text,
                        'rating': rating,
                        'time': Timestamp.fromDate(DateTime.now()).seconds
                      });
                      Fluttertoast.showToast(
                          msg: "Thank you for your feedback");
                      Navigator.pop(context);
                    } on Exception catch (e) {
                      print("Error : $e");
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Please give atleast 1 start");
                  }
                } else {
                  Fluttertoast.showToast(msg: "Please add a Review");
                }
              },
              child: const Text("Send"))
        ],
      ),
    );
  }

  Widget buildRating() => RatingBar.builder(
        itemBuilder: (context, _) =>
            const Icon(Icons.star, color: Colors.amber),
        initialRating: rating,
        minRating: 1,
        updateOnDrag: true,
        onRatingUpdate: (rating) => setState(() => this.rating = rating),
      );
}
