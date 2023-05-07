import 'dart:convert';

class NGO {
  final String ngo_id;
  final String name;
  final String address;
  final String password;
  final String phone_number;
  final String email1;
  final String email;
  final String token;
  //final List<Rating>? rating;
  NGO({
    //required this.address,
    required this.ngo_id,
    required this.name,
    required this.address,
    required this.password,
    required this.phone_number,
    required this.email1,
    required this.email,
    required this.token,
    //this.rating,
  });
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'ngo_id': ngo_id}); // include the _id field here
    result.addAll({'name': name});
    result.addAll({'address': address});
    result.addAll({'password': password});
    result.addAll({'phone_number': phone_number});
    result.addAll({'email1': email1});
    result.addAll({'email': email});
    result.addAll({'token': token});
    //result.addAll({'rating': rating});

    return result;
  }

  factory NGO.fromMap(Map<String, dynamic> map) {
    return NGO(
      ngo_id: map['ngo_id'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      password: map['password'] ?? '',
      phone_number: map['phone_number'] ?? '',
      email1: map['email1'] ?? '',
      email: map['email'] ?? '',
      token: map['token'] ?? '',
      // rating: map['ratings'] != null
      //     ? List<Rating>.from(
      //         map['ratings']?.map((x) => Rating.fromMap(x)),
      //       )
      //     : null);
    );
  }

  String toJson() => json.encode(toMap());

  factory NGO.fromJson(String source) => NGO.fromMap(json.decode(source));
}
