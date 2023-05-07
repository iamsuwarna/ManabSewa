import 'dart:convert';
import 'package:intl/intl.dart';

class DonationModel {
  final String donorId;
  final bool donationStatus;
  final bool rejectionStatus;
  final String donationid;
  final String donorName;
  final String phone_number;
  final String ngo_id; // can be "food", "cloth", or "book"
  final String description;
  final int count;
  final String? ngo_name;
  final String? ngo_address;
  final String? ngo_phonenumber;
  final String? ngo_emailaddress;
  final String address;
  final String type;
  final List<String>? areasOfInterest;
  final List<String>? images;
  final DateTime? date; // new field for date

  bool isHidden;
  DonationModel({
    required this.donorId,
    required this.donationStatus,
    required this.rejectionStatus,
    required this.donationid,
    required this.donorName,
    required this.phone_number,
    required this.ngo_id,
    required this.description,
    required this.count,
    this.ngo_name,
    this.ngo_address,
    this.ngo_phonenumber,
    this.ngo_emailaddress,
    required this.address,
    required this.type,
    this.areasOfInterest,
    this.images,
    required this.isHidden,
    this.date, // new field for date
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'donorId': donorId});
    result.addAll({'donationStatus': donationStatus});
    result.addAll({'rejectionStatus': rejectionStatus});
    result.addAll({'donationid': donationid});
    result.addAll({'donorName': donorName});
    result.addAll({'phone_number': phone_number});
    result.addAll({'ngo_id': ngo_id});
    result.addAll({'ngo_name': ngo_name});
    result.addAll({'ngo_address': ngo_address});
    result.addAll({'ngo_phonenumber': ngo_phonenumber});
    result.addAll({'ngo_emailaddress': ngo_emailaddress});
    result.addAll({'description': description});
    result.addAll({'count': count});
    if (ngo_name != null) {
      result.addAll({'ngo_name': ngo_name});
    }
    result.addAll({'address': address});
    result.addAll({'type': type});
    if (areasOfInterest != null) {
      result.addAll({'areasOfInterest': areasOfInterest});
    }
    if (images != null) {
      result.addAll({'images': images});
    }
    result.addAll({'isHidden': isHidden});
    // added field for current date and time
    result.addAll(
        {'date': date != null ? DateFormat('yyyy-MM-dd').format(date!) : ''});
// format date to string
    return result;
  }

  factory DonationModel.fromMap(Map<String, dynamic> map) {
    return DonationModel(
      donorId: map['donorId'] ?? '',
      donationStatus: map['donationStatus'] ?? false,
      rejectionStatus: map['rejectionStatus'] ?? false,
      donationid: map['_id'] ?? '',
      donorName: map['donorName'] ?? '',
      phone_number: map['phone_number'] ?? '',
      ngo_id: map['ngo_id'] ?? '',
      description: map['description'] ?? '',
      count: map['count']?.toInt() ?? 0,
      ngo_name: map['ngo_name'],
      ngo_address: map['ngo_address'],
      ngo_phonenumber: map['ngo_phonenumber'],
      ngo_emailaddress: map['ngo_emailaddress'],
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      areasOfInterest: List<String>.from(map['areasOfInterest']),
      images: List<String>.from(map['images']),
      isHidden: map['isHidden'] ?? false,
      date: DateTime.now(),
    );
  }
  String toJson() => json.encode(toMap());

  factory DonationModel.fromJson(String source) =>
      DonationModel.fromMap(json.decode(source));
}
