import 'dart:convert';

class BookmaarkModel {
  final String donorId;
  final int NGOId;
  final String NGOName;
  final String NGOAddress;
  final String NGOPhoneNumber;
  final String NGOEmailAddress;
  final String BookmarkId;
  BookmaarkModel({
    required this.donorId,
    required this.NGOId,
    required this.NGOName,
    required this.NGOAddress,
    required this.NGOPhoneNumber,
    required this.NGOEmailAddress,
    required this.BookmarkId,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'donorId': donorId});
    result.addAll({'NGOId': NGOId});
    result.addAll({'NGOName': NGOName});
    result.addAll({'NGOAddress': NGOAddress});
    result.addAll({'NGOPhoneNumber': NGOPhoneNumber});
    result.addAll({'NGOEmailAddress': NGOEmailAddress});
    result.addAll({'BookmarkId': BookmarkId});

    return result;
  }

  factory BookmaarkModel.fromMap(Map<String, dynamic> map) {
    return BookmaarkModel(
      donorId: map['donorId'] ?? '',
      NGOId: map['NGOId']?.toInt() ?? 0,
      NGOName: map['NGOName'] ?? '',
      NGOAddress: map['NGOAddress'] ?? '',
      NGOPhoneNumber: map['NGOPhoneNumber'] ?? '',
      NGOEmailAddress: map['NGOEmailAddress'] ?? '',
      BookmarkId: map['_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BookmaarkModel.fromJson(String source) =>
      BookmaarkModel.fromMap(json.decode(source));
}
