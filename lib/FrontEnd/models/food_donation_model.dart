import 'dart:convert';

class FoodDonationModel {
  final String donorName;
  final String ngo_id; // can be "food", "cloth", or "book"
  final String food_description;
  final int food_count;
  final String address;
  final List<String> areasOfInterest;
  final List<String> images;

  FoodDonationModel({
    required this.donorName,
    required this.ngo_id,
    required this.food_description,
    required this.food_count,
    required this.address,
    required this.areasOfInterest,
    required this.images,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'donorName': donorName});
    result.addAll({'ngo_id': ngo_id});
    result.addAll({'food_description': food_description});
    result.addAll({'food_count': food_count});
    result.addAll({'address': address});
    result.addAll({'areasOfInterest': areasOfInterest});
    result.addAll({'images': images});

    return result;
  }

  factory FoodDonationModel.fromMap(Map<String, dynamic> map) {
    return FoodDonationModel(
      donorName: map['donorName'] ?? '',
      ngo_id: map['ngo_id'] ?? '',
      food_description: map['food_description'] ?? '',
      food_count: map['food_count']?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
      areasOfInterest: List<String>.from(map['areasOfInterest']),
      images: List<String>.from(map['images']),
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodDonationModel.fromJson(String source) =>
      FoodDonationModel.fromMap(json.decode(source));
}
