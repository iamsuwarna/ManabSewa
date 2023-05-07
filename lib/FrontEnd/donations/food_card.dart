import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manav_sewa/FrontEnd/CustomWidgets/custom_buttom.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';

import 'food_donation.dart';

class FoodCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 300,
      child: Card(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.network(
                  'https://images.unsplash.com/photo-1504159506876-f8338247a14a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8aHVuZ3J5fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60',
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black54,
                          Colors.black26,
                          Colors.transparent,
                        ],
                        stops: [0.1, 0.5, 0.9],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Help feed a hungry family',
                            style: GoogleFonts.kanit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white), //TextStyle(

                            // fontWeight: FontWeight.bold,

                            // fontSize: 18.0,
                            // color: Colors.white
                            //),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Center(
              child: CustomButton(
                text: "Donate Food",
                color: GlobalVariables.selectedNavBarColor,
                onTap: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FoodDonationPage()));
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
