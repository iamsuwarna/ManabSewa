import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:csv/csv.dart';
import 'dart:async';
import 'dart:io';

class PhoneCall extends StatefulWidget {
  @override
  _PhoneCallState createState() => _PhoneCallState();
}

class _PhoneCallState extends State<PhoneCall> {
  Future<void> _makePhoneCall() async {
    List<List<dynamic>> rowsList = [];
    final String response = await rootBundle.loadString('assets/ngo_data.csv');
    rowsList = CsvToListConverter().convert(response);
    String phoneNumber = rowsList[0][7].toString();
    String url = "tel:$phoneNumber";
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Unable to make phone call'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: _makePhoneCall,
          child: Icon(Icons.phone),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:csv/csv.dart';
// import 'dart:io';

// class PhoneCall extends StatefulWidget {
//   @override
//   _PhoneCallState createState() => _PhoneCallState();

//   void makePhoneCall() {}
// }

// class _PhoneCallState extends State<PhoneCall> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   Future<void> makePhoneCall() async {
//     List<List<dynamic>> rowsList = [];
//     final String response = await rootBundle.loadString('assets/ngo_data.csv');

//     // String filePath = "assets/ngo_data.csv";
//     File file = new File(response);
//     String fileContent = await file.readAsString();
//     print(fileContent);
//     rowsList = CsvToListConverter().convert(fileContent);
//     String phoneNumber = rowsList[0][7];
//     String url = "tel:$phoneNumber";
//     print(url);
//     print(url);
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Your message here'),
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       body: Center(
//         child: GestureDetector(
//           onTap: makePhoneCall,
//           child: FlatButton(
//             child: Icon(Icons.phone),
//             onPressed: null,
//           ),
//         ),
//       ),
//     );
//   }
// }
