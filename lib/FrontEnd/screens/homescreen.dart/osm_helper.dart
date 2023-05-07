// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class OSMHelper {
//   final String consumerKey;
//   final String consumerSecret;

//   OSMHelper({required this.consumerKey, required this.consumerSecret});
//   Future<List<String>> getPlaces(
//       {required double lat,
//       required double lon,
//       required String tag,
//       required String value}) async {
//     var uri = Uri.parse(
//         'https://api.openstreetmap.org/api/0.6/map?bbox=$lon,$lat,$lon,$lat');
//     var response = await http.get(uri,
//         headers: {'Authorization': 'Basic $consumerKey:$consumerSecret'});

//     if (response.statusCode == 200) {
//       var jsonResponse = jsonDecode(response.body);
//       var places = jsonResponse['elements']
//           .where((element) => element['tags'][tag] == value);
//       List<String> nearbyNGOs =
//           places.map((place) => place['tags']['name']).toList();
//       return nearbyNGOs;
//     } else {
//       throw Exception('Failed to fetch places');
//     }
//   }
// }
