import 'dart:convert';

class Donor {
  final String id;
  final String name;
  final String email;
  final String phone_number;
  final String password;
  final String address;
  final String type;
  final String token;
  final List<dynamic> bookmark;
  Donor({
    //required this.address,
    //required this.type,
    required this.id,
    required this.name,
    required this.email,
    required this.phone_number,
    required this.password,
    required this.address,
    required this.type,
    required this.token,
    required this.bookmark,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'email': email});
    result.addAll({'phone_number': phone_number});
    result.addAll({'password': password});
    result.addAll({'address': address});
    result.addAll({'type': type});
    result.addAll({'token': token});
    result.addAll({'bookmark': bookmark});

    return result;
  }

  factory Donor.fromMap(Map<String, dynamic> map) {
    return Donor(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone_number: map['phone_number'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
      bookmark: List<Map<String, dynamic>>.from(
        map['bookmark']?.map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Donor.fromJson(String source) => Donor.fromMap(json.decode(source));
}
