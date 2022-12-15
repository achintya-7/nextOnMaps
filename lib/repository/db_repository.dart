// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nextonmaps/models/review_model.dart';

class DBRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;

  static Stream<List<ReviewModel>> getReviews(String placeName, FirebaseFirestore db) async* {
    List<ReviewModel> reviews = [];
    try {
      var snapshot = await db.collection(placeName).orderBy('time', descending: true).get();
      var docs = snapshot.docs;
      for (var doc in docs) {
        reviews.add(ReviewModel.fromMap(doc.data()));
      }
      yield reviews;
    } catch (e) {
      print("Error : $e");
    }
  }
}
