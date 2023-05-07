// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:manav_sewa/FrontEnd/provider/ngo_provider.dart';

// import '../provider/user_provider.dart';
// import 'globalvariables.dart';

// class BelowAppBar extends StatefulWidget {
//   final String role;
//   BelowAppBar({
//     Key? key,
//     required this.role,
//   }) : super(key: key);

//   @override
//   State<BelowAppBar> createState() => _BelowAppBarState();
// }

// class _BelowAppBarState extends State<BelowAppBar> {
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<UserProvider>(context).user;
//     final ngo = Provider.of<NGOProvider>(context).ngo;

//     return Container(
//       decoration: const BoxDecoration(color: Colors.white),
//       padding: const EdgeInsets.only(left: 25, right: 10, bottom: 10, top: 15),
//       child: Row(
//         children: [
//           RichText(
//             text: TextSpan(
//               text: "Welcome",
//               style: const TextStyle(
//                 fontSize: 22,
//                 color: Colors.black,
//               ),
//               children: [
//                 TextSpan(
//                   text: " , $this.role",
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:manav_sewa/FrontEnd/provider/ngo_provider.dart';

import '../provider/Donor_provider.dart';
import 'globalvariables.dart';

class BelowAppBar extends StatefulWidget {
  final String? role;
  final String welcomeText;

  const BelowAppBar({
    Key? key,
    this.role,
    required this.welcomeText,
  }) : super(key: key);

  @override
  State<BelowAppBar> createState() => _BelowAppBarState();
}

class _BelowAppBarState extends State<BelowAppBar> {
  @override
  Widget build(BuildContext context) {
    final donor = Provider.of<DonorProvider>(context).donor;
    final ngo = Provider.of<NGOProvider>(context).ngo;
    String userName;
    if (widget.role == 'donor') {
      userName = donor.name;
    } else if (widget.role == 'ngo') {
      userName = ngo.name;
    } else {
      userName = donor.name;
    }
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding:
            const EdgeInsets.only(left: 25, right: 10, bottom: 10, top: 15),
        child: Row(
          children: [
            RichText(
              text: TextSpan(
                text: widget.welcomeText,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: " ",
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                userName,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ));
  }
}
