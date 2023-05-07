// import 'dart:convert';

// class Rating {
//   final String donorId;
//   final String rating;
//   Rating({
//     required this.donorId,
//     required this.rating,
//   });

//   Map<String, dynamic> toMap() {
//     final result = <String, dynamic>{};

//     result.addAll({'donorId': donorId});
//     result.addAll({'rating': rating});

//     return result;
//   }

//   factory Rating.fromMap(Map<String, dynamic> map) {
//     return Rating(
//       donorId: map['donorId'] ?? '',
//       rating: map['rating'] ?? '',
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Rating.fromJson(String source) => Rating.fromMap(json.decode(source));
// }
