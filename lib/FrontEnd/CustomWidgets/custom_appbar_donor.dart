import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:manav_sewa/FrontEnd/constants/about_user.dart';

import '../NGO/ngo_signup.dart';
import '../constants/about_ngo.dart';

class CustomAppBarDonor extends StatefulWidget implements PreferredSizeWidget {
  final String donorName;
  final String donorId;
  final String donorAddress;
  final String donorPhoneNumber;

  const CustomAppBarDonor({
    Key? key,
    required this.donorName,
    required this.donorId,
    required this.donorAddress,
    required this.donorPhoneNumber,
  }) : super(key: key);

  @override
  _CustomAppBarDonorState createState() => _CustomAppBarDonorState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _CustomAppBarDonorState extends State<CustomAppBarDonor> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: SizedBox(
          height: 200,
          child: Image.asset(
            'assets/logo2.png',
          ),
        ),
      ),
      title: Text(
        "ManavSewa",
        style: GoogleFonts.kanit(
          fontSize: 20,
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10, top: 10),
          child: GestureDetector(
            onTap: () {
              if (widget.donorName != null && widget.donorId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutUser(
                      name: widget.donorName,
                      // : widget.ngoAddress,
                      // phone_number: widget.ngoPhoneNumber,
                    ),
                  ),
                );
              }
            },
            child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: Center(
                    child: widget.donorName.isNotEmpty
                        ? Text(
                            widget.donorName[0],
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Warning",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Text("Please login first"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("Login"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NGOSignUp()));
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              child:
                              Icon(Icons.favorite);
                            },
                            child: Icon(Icons.person)))),
          ),
        ),
      ],
    );
  }
}
