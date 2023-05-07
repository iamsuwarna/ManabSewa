import 'package:flutter/material.dart';
import 'package:manav_sewa/FrontEnd/models/ngo_model.dart';
import 'package:provider/provider.dart';

import 'package:manav_sewa/FrontEnd/CustomWidgets/custom_buttom.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/provider/Donor_provider.dart';
import 'package:manav_sewa/FrontEnd/screens/carousal_slider/carousal_slider.dart';
import 'package:manav_sewa/FrontEnd/screens/homescreen.dart/completeddonation.dart';

class AboutUser extends StatefulWidget {
  final String name;
  final String? email;
  final String? ngo_id;
  final String? phone_number;

  const AboutUser(
      {Key? key,
      required this.name,
      this.email,
      this.ngo_id,
      this.phone_number})
      : super(key: key);

  @override
  _AboutUserState createState() => _AboutUserState();
}

class _AboutUserState extends State<AboutUser> {
  @override
  Widget build(BuildContext context) {
    final donor = Provider.of<DonorProvider>(context).donor;
    return Scaffold(
      appBar: AppBar(
        title: Text('About User'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 32),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Center(
                    child: Text(
                      donor.name[0],
                      style: TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text(
                      donor.name,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.email),
                    SizedBox(width: 10),
                    Text(
                      donor.email,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.phone),
                    SizedBox(width: 10),
                    Text(
                      donor.phone_number,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                //card
                Card(
                  margin: EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: () {
                      // handle on tap event
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CompletedDonations()));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.monetization_on),
                          SizedBox(width: 16),
                          Text("Your donations"),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_right),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                //logout button
                CustomButton(
                    text: "Logout",
                    color: GlobalVariables.selectedNavBarColor,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Logout'),
                              content: Text('Are you sure you want to logout?'),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    FlatButton.icon(
                                      icon: Icon(Icons.check,
                                          color: Colors.green),
                                      label: Text('Yes'),
                                      onPressed: () {
                                        // Perform logout action
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ScreenSlider()));
                                      },
                                    ),
                                    FlatButton.icon(
                                      icon:
                                          Icon(Icons.clear, color: Colors.red),
                                      label: Text('No'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          });
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
