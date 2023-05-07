import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manav_sewa/FrontEnd/NGO/ngo_signin.dart';
import 'package:manav_sewa/FrontEnd/NGO/ngo_signup.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/screens/AuthScreen/sign_in.dart';

//import 'package:manav_sewa/FrontEnd/registration/user_registartion.dart';
import 'package:manav_sewa/FrontEnd/screens/AuthScreen/sing_up.dart';

import '../../CustomWidgets/custom_buttom.dart';

class AskPeople extends StatelessWidget {
  const AskPeople({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        //for icon's image
        const AppIcon(top: 15, left: 10, right: 20),
        const SizedBox(
          height: 50,
        ),
        //for welcome text
        Padding(
          padding: const EdgeInsets.only(top: 25, right: 70),
          child: Text("Welcome to ManavSewa",
              style:
                  GoogleFonts.kanit(fontSize: 23, fontWeight: FontWeight.bold)),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10, right: 90),
          child: Text("Changing lives, one donation at a time.",
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13)),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 22, left: 25),
          child: Text(
            "Manavsewa is a donation-based mobile app that connects individuals and organizations with a passion for giving back to their communities. With Manavsewa, users can easily donate their leftover food, clothes, and books to NGOs working on the ground to help those in need.",
            style: GoogleFonts.kanit(
              fontSize: 14,
            ),
          ),
        ),
        //for question
        // Padding(
        //   padding: EdgeInsets.only(top: 20, right: 170),
        //   child: Text(
        //     "Who Are You?",
        //     style: GoogleFonts.kanit(fontSize: 23, fontWeight: FontWeight.bold),
        //   ),
        // ),
        //for buttons
        Row(
          children: [
            //gesture detector for 'donor' button
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: CustomButton(
                  color: Color.fromARGB(255, 243, 182, 91),
                  text: "Donor",
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignInPage()));
                  }),
            ),
            SizedBox(
              width: 15,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: CustomButton(
                  color: Color.fromARGB(255, 243, 182, 91),
                  text: "NGO",
                  icon: Icon(Icons.share),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NGOSignIn()));
                  }),
            ),
          ],
        ),
      ],
    ));
  }
}

class AppIcon extends StatelessWidget {
  final double top;
  final double left;
  final double right;
  const AppIcon({
    Key? key,
    required this.top,
    required this.left,
    required this.right,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: top, left: left, right: right),
      child: Image.asset(
        'assets/logo1.PNG',
        height: 220,
      ),
    );
  }
}
