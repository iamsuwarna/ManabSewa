import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manav_sewa/FrontEnd/provider/ngo_provider.dart';
import 'package:provider/provider.dart';

import 'package:manav_sewa/FrontEnd/CustomWidgets/custom_buttom.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/provider/Donor_provider.dart';
import 'package:manav_sewa/FrontEnd/screens/carousal_slider/carousal_slider.dart';
import 'package:manav_sewa/FrontEnd/screens/homescreen.dart/completeddonation.dart';

class AboutNGO extends StatefulWidget {
  final String name;
  final String address;
  final String phone_number;

  AboutNGO({
    Key? key,
    required this.name,
    required this.address,
    required this.phone_number,
  }) : super(key: key);

  @override
  _AboutNGOState createState() => _AboutNGOState();
}

class _AboutNGOState extends State<AboutNGO> {
  Widget build(BuildContext context) {
    final ngo = Provider.of<NGOProvider>(context).ngo;
    return Scaffold(
      appBar: AppBar(
        title: Text('About NGO'),
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
                      ngo.name[0],
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
                    Expanded(
                      child: Text(
                        ngo.name,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.location_city),
                    SizedBox(width: 10),
                    Text(
                      ngo.address,
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
                      ngo.email1,
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
                              builder: (context) =>
                                  const CompletedDonations()));
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
