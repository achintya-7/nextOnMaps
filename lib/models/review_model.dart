import 'dart:convert';

class ReviewModel {
  double rating;
  String review;
  int time;
  ReviewModel({
    required this.rating,
    required this.review,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rating': rating,
      'review': review,
      'time': time,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      rating: map['rating'] as double,
      review: map['review'] as String,
      time: map['time'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
