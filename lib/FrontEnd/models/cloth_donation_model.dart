import 'dart:convert';

class ClothDonationModel {
  final String donorName;
  final String ngo_id;
  final String cloth_description;
  final int cloth_count;
  final String address;
  final List<String> areasOfInterest;
  final List<String> images;

  ClothDonationModel({
    required this.donorName,
    required this.ngo_id,
    required this.cloth_description,
    required this.cloth_count,
    required this.address,
    required this.areasOfInterest,
    required this.images,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'donorName': donorName});
    result.addAll({'ngo_id': ngo_id});
    result.addAll({'cloth_description': cloth_description});
    result.addAll({'cloth_count': cloth_count});
    result.addAll({'address': address});
    // result.addAll({'areasOfInterest': areasOfInterest});
    // result.addAll({'images': images});

    return result;
  }

  factory ClothDonationModel.fromMap(Map<String, dynamic> map) {
    return ClothDonationModel(
      donorName: map['donorName'] ?? '',
      ngo_id: map['ngo_id'] ?? '',
      cloth_description: map['cloth_description'] ?? '',
      cloth_count: map['cloth_count']?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
      areasOfInterest: List<String>.from(map['areasOfInterest']),
      images: List<String>.from(map['images']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClothDonationModel.fromJson(String source) =>
      ClothDonationModel.fromMap(json.decode(source));
}
