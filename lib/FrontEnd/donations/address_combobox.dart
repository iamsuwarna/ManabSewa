// import 'package:flutter/material.dart';

// class NepalAddress extends StatefulWidget {
//   @override
//   _NepalAddressState createState() => _NepalAddressState();
// }

// class _NepalAddressState extends State<NepalAddress> {
//   String _selectedAddress = "Kathmandu";
//   final List<String> _addresses = [
//     "Kathmandu",
//     "Pokhara",
//     "Lumbini",
//     "Chitwan",
//     "Biratnagar"
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Form(
//         child: Column(
//           children: [
//             FormField(
//               builder: (FormFieldState state) {
//                 return InputDecorator(
//                   decoration: InputDecoration(
//                     labelText: 'Address',
//                     errorText: state.hasError ? state.errorText : null,
//                   ),
//                   isEmpty: _selectedAddress == '',
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton(
//                       value: _selectedAddress,
//                       isDense: true,
//                       onChanged: (String? value) {
//                         setState(() {
//                           _selectedAddress = value ?? "";
//                         });
//                       },
//                       items: _addresses.map((address) {
//                         return DropdownMenuItem(
//                           child: Text(address),
//                           value: address,
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 );
//               },
//               validator: (val) {
//                 return val == '' ? 'Please select an address' : null;
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

// class NepalAddress extends StatefulWidget {
//   @override
//   _NepalAddressState createState() => _NepalAddressState();
// }

// class _NepalAddressState extends State<NepalAddress> {
//   String _selectedAddress = "Kathmandu";
//   final List<String> _addresses = [
//     "Kathmandu",
//     "Pokhara",
//     "Lumbini",
//     "Chitwan",
//     "Biratnagar"
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           FormField(
//             builder: (FormFieldState state) {
//               return InputDecorator(
//                 decoration: InputDecoration(
//                   labelText: 'Address',
//                   errorText: state.hasError ? state.errorText : null,
//                 ),
//                 isEmpty: _selectedAddress == '',
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton(
//                     value: _selectedAddress,
//                     isDense: true,
//                     onChanged: (String? value) {
//                       setState(() {
//                         _selectedAddress = value ?? "Kathmandu";
//                       });
//                     },
//                     items: _addresses.map((address) {
//                       return DropdownMenuItem(
//                         child: Text(address),
//                         value: address,
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               );
//             },
//             validator: (val) {
//               return val == '' ? 'Please select an address' : null;
//             },
//           ),
//           SizedBox(height: 20),
//           Text(
//             'Selected Address: $_selectedAddress',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class NepalAddress extends StatefulWidget {
  @override
  _NepalAddressState createState() => _NepalAddressState();
}

class _NepalAddressState extends State<NepalAddress> {
  String _selectedAddress = "Kathmandu";
  final List<String> _addresses = [
    "Kathmandu",
    "Pokhara",
    "Lumbini",
    "Chitwan",
    "Biratnagar"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Address',
          border: OutlineInputBorder(),
        ),
        readOnly: true,
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Container(
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: _addresses.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_addresses[index]),
                      onTap: () {
                        setState(() {
                          _selectedAddress = _addresses[index];
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
        controller: TextEditingController(text: _selectedAddress),
      ),
    );
  }
}
