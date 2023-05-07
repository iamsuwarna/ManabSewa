// import 'package:flutter/material.dart';
// import 'package:manav_sewa/FrontEnd/provider/ngo_provider.dart';
// import 'package:provider/provider.dart';

// import '../provider/user_provider.dart';
// import 'globalvariables.dart';

// class NGOBelowAppBar extends StatelessWidget {
//   const NGOBelowAppBar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final ngo = Provider.of<NGOProvider>(context).ngo;

//     return Container(
//       decoration: const BoxDecoration(color: Colors.white),
//       padding: const EdgeInsets.only(left: 25, right: 10, bottom: 10, top: 15),
//       child: Row(
//         children: [
//           RichText(
//             text: TextSpan(
//               text: 'Welcome ',
//               style: const TextStyle(
//                 fontSize: 22,
//                 color: Colors.black,
//               ),
//               children: [
//                 TextSpan(
//                   text: ngo.name,
//                   style: const TextStyle(
//                     fontSize: 22,
//                     color: Colors.black,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
