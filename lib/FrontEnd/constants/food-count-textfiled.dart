// import 'package:flutter/material.dart';

// class FoodCountTextField extends StatefulWidget {
//   final TextEditingController controller;
//   const FoodCountTextField({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);
//   @override
//   _FoodCountTextFieldState createState() => _FoodCountTextFieldState();
// }

// class _FoodCountTextFieldState extends State<FoodCountTextField> {
//   // final TextEditingController _controller = TextEditingController();
//   String _selectedUnit = 'kg';

//   // @override
//   // void dispose() {
//   //   _controller.dispose();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             controller: ,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               labelText: 'Food Count',
//               suffixText: _selectedUnit,
//             ),
//             onChanged: (value) {
//               setState(() {});
//             },
//           ),
//         ),
//         SizedBox(width: 70),
//         Padding(
//           padding: const EdgeInsets.only(top: 15),
//           child: DropdownButton<String>(
//             value: _selectedUnit,
//             onChanged: (String? newValue) {
//               setState(() {
//                 _selectedUnit = newValue!;
//               });
//             },
//             items: <String>['kg', 'piece', 'other'].map((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class FoodCountTextField extends StatelessWidget {
//   final TextEditingController controller;
//   FoodCountTextField({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);

//   final  String _selectedUnit = 'kg';

//   @override
//   Widget build(BuildContext context) {
//         return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             controller: ,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               labelText: 'Food Count',
//               suffixText: _selectedUnit,
//             ),
//             onChanged: (value) {
//               setState(() {

//               });
//             },
//           ),
//         ),
//         SizedBox(width: 70),
//         Padding(
//           padding: const EdgeInsets.only(top: 15),
//           child: DropdownButton<String>(
//             value: _selectedUnit,
//             onChanged: (String? newValue) {
//               setState(() {
//                 _selectedUnit = newValue!;
//               });
//             },
//             items: <String>['kg', 'piece', 'other'].map((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class FoodCountTextField extends StatelessWidget {
  final TextEditingController controller;
  final String CountName;
  final List<String> units = ['kg', 'piece', 'other'];
  String selectedUnit = 'kg';

  FoodCountTextField({required this.controller, required this.CountName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: CountName,
              border: OutlineInputBorder(),
              suffix: Text(selectedUnit),
            ),
          ),
        ),
        SizedBox(width: 10),
        DropdownButton<String>(
          value: selectedUnit,
          onChanged: (String? newValue) {
            if (newValue != null) {
              selectedUnit = newValue;
            }
          },
          items: units.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
