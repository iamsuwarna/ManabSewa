import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manav_sewa/FrontEnd/constants/about_user.dart';

import '../NGO/ngo_signup.dart';
import '../constants/about_ngo.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String ngoName;
  final String ngoId;
  final String ngoAddress;
  final String ngoPhoneNumber;

  const CustomAppBar({
    Key? key,
    required this.ngoName,
    required this.ngoId,
    required this.ngoAddress,
    required this.ngoPhoneNumber,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _CustomAppBarState extends State<CustomAppBar> {
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
              if (widget.ngoName != null && widget.ngoId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutNGO(
                      name: widget.ngoName, address: widget.ngoAddress,
                      phone_number: widget.ngoPhoneNumber,
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
                    child: widget.ngoName.isNotEmpty
                        ? Text(
                            widget.ngoName[0],
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
