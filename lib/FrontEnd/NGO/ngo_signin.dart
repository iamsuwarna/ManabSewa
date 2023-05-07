import 'package:flutter/material.dart';
import 'package:manav_sewa/FrontEnd/NGO/ngo_signup.dart';
import 'package:manav_sewa/FrontEnd/constants/bottom_bar.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/constants/ngo_bottom_bar.dart';
import 'package:manav_sewa/FrontEnd/screens/AuthScreen/sing_up.dart';
import 'package:manav_sewa/FrontEnd/screens/carousal_slider/donor_or_donee.dart';
import 'package:manav_sewa/FrontEnd/screens/homescreen.dart/HomeScreen.dart';
import 'package:manav_sewa/FrontEnd/services/AuthService.dart';
import '../CustomWidgets/custom_buttom.dart';
import '../CustomWidgets/custom_texfield.dart';
import '../CustomWidgets/password_textfield.dart';
import 'ngo_screen/view_ngodonations.dart';

class NGOSignIn extends StatefulWidget {
  const NGOSignIn({Key? key}) : super(key: key);

  @override
  State<NGOSignIn> createState() => _NGOSignInState();
}

class _NGOSignInState extends State<NGOSignIn> {
  // creating global variables
  final _NGOsignInFormKey = GlobalKey<FormState>();

  // creating controllers for validation
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //final TextEditingController _nameController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  void dispose() {
    super.dispose();
    _idController.dispose();
    _passwordController.dispose();
    //_nameController.dispose();
  }

  // function for signInUser
  void NGOSignIn() {
    authService.signInNGO(
      context: context,
      ngo_id: _idController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          //for app icon
          const AppIcon(top: 15, left: 20, right: 10),

          // Use of form for validation
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              //color: Colors.yellow.shade300,
              child: Form(
                  key: _NGOsignInFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                          controller: _idController,
                          hintText: "NGO's Id",
                          obscureText: false,
                          // enableSuggestions: true,
                          // autocorrect: false,
                          icon: Icon(Icons.account_circle)),

                      SizedBox(
                        height: 10,
                      ),
                      PasswordTextField(
                          controller: _passwordController,
                          label: 'password',
                          hintText: 'password',
                          obText: true),

                      // Use of custom Button
                      const SizedBox(height: 15),
                      CustomButton(
                        text: 'Login',
                        color: const Color.fromARGB(255, 252, 181, 74),
                        onTap: () {
                          if (_NGOsignInFormKey.currentState!.validate()) {
                            NGOSignIn();
                          }
                        },
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      // skip Button

                      // for text
                      Padding(
                        padding: EdgeInsets.only(left: 60, top: 25),
                        child: Row(
                          children: [
                            const Text(
                              "Don" + "'" + "t have an account?",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => NGOSignUp())));
                              },
                              child: const Text(
                                "Signup Now",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 243, 182, 91),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ]),
      ),
    );
  }
}
