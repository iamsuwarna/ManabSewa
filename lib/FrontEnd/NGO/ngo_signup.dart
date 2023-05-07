import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manav_sewa/FrontEnd/CustomWidgets/custom_texfield.dart';
import 'package:manav_sewa/FrontEnd/NGO/ngo_signin.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/constants/utils.dart';
import 'package:manav_sewa/FrontEnd/screens/AuthScreen/sign_in.dart';
import 'package:manav_sewa/FrontEnd/screens/AuthScreen/sing_up.dart';
import 'package:manav_sewa/FrontEnd/screens/carousal_slider/donor_or_donee.dart';
import 'package:manav_sewa/FrontEnd/services/AuthService.dart';
import '../CustomWidgets/custom_buttom.dart';
import '../CustomWidgets/password_textfield.dart';

class NGOSignUp extends StatefulWidget {
  const NGOSignUp({Key? key}) : super(key: key);

  @override
  State<NGOSignUp> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<NGOSignUp> {
  // creating global variables
  final _NGOsignUpFormKey = GlobalKey<FormState>();

  // creating controllers for validation
  final TextEditingController _idcontroller = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //final TextEditingController _phonenumberController = TextEditingController();
  //final TextEditingController _addressController = TextEditingController();
  final AuthService authService = AuthService();
  bool isFound = false;

  List<dynamic> data = [];
  Future<List<List<dynamic>>> loadAsset() async {
    final String response = await rootBundle.loadString('assets/ngo_data.csv');
    final List<String> csvList = LineSplitter().convert(response);
    return csvList.map((String row) => row.split(',')).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    data = await loadAsset();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _idcontroller.dispose();
    _nameController.dispose();

    _passwordController.dispose();
    //_addressController.dispose();
    // _passwordController.dispose();
    // _nameController.dispose();
  }

  void NGOSignUp(
      String address, String email1, String phoneNumber, String name) {
    authService.signUpNGO(
      context: context,
      ngo_id: _idcontroller.text,
      name: name,
      address: address,
      password: _passwordController.text,
      phone_number: phoneNumber,
      email1: email1,
      email: _nameController.text,
    );
    print(name);
  }

  void matchID(String id, BuildContext context) {
    for (int i = 0; i < data.length; i++) {
      if (_idcontroller.text == data[i][0]) {
        NGOSignUp(data[i][5], data[i][7], data[i][6], data[i][2]);
        // NGOSignUp(data[i][5], data[i][7], data[i][6], data[i][2]);
        isFound = true;
        break;
      }
    }
    if (!isFound) {
      showSnackBar(context, "Id not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Column(children: [
          //  for app logo
          AppIcon(top: 0, left: 10, right: 20),

          // Use of form for validation
          Container(
            padding: const EdgeInsets.all(20),
            //color: Colors.yellow.shade300,
            child: Form(
                key: _NGOsignUpFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _idcontroller,
                      hintText: "NGO's ID",
                      obscureText: false,
                      // enableSuggestions: true,
                      // autocorrect: false,
                      icon: Icon(Icons.account_circle),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                        controller: _nameController,
                        obscureText: false,
                        hintText: "Name of the NGO",
                        icon: Icon(Icons.person)),
                    SizedBox(
                      height: 10,
                    ),
                    PasswordTextField(
                        controller: _passwordController,
                        label: 'password',
                        hintText: 'password',
                        obText: true),
                    SizedBox(
                      height: 10,
                    ),
                    // CustomTextField(
                    //     controller: _addressController,
                    //     obscureText: false,
                    //     // autocorrect: false,
                    //     // enableSuggestions: false,
                    //     hintText: "Address",
                    //     icon: Icon(Icons.location_city)),
                    SizedBox(
                      height: 10,
                    ),
                    // CustomTextField(
                    //     controller: _phonenumberController,
                    //     obscureText: false,
                    //     // autocorrect: false,
                    //     // enableSuggestions: false,
                    //     hintText: "NGO's Phone number",
                    //     icon: Icon(Icons.phone)),

                    // Use of custom Button
                    SizedBox(height: 10),
                    CustomButton(
                      text: 'Sign Up NGO',
                      color: Color.fromARGB(255, 243, 182, 91),
                      onTap: () {
                        if (_NGOsignUpFormKey.currentState!.validate()) {
                          if (_passwordController.text.length < 6) {
                            showSnackBar(
                                context, 'Please enter a longer password');
                          } else {
                            SignUpPage();
                          }

                          matchID(_idcontroller.text, context);
                        }
                      },
                    ),

                    //no account
                    Padding(
                      padding: EdgeInsets.only(left: 60, top: 10),
                      child: Row(
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: ((context) => NGOSignUp())));
                            },
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NGOSignIn()));
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 243, 182, 91),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ]),
      ),
    );
  }
}
