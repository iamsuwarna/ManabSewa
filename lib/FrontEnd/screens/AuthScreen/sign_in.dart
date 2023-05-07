import 'package:flutter/material.dart';
import 'package:manav_sewa/FrontEnd/CustomWidgets/password_textfield.dart';
import 'package:manav_sewa/FrontEnd/constants/bottom_bar.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/screens/AuthScreen/sing_up.dart';
import 'package:manav_sewa/FrontEnd/screens/carousal_slider/donor_or_donee.dart';

import 'package:manav_sewa/FrontEnd/services/AuthService.dart';
import '../../CustomWidgets/custom_buttom.dart';
import '../../CustomWidgets/custom_texfield.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // creating global variables
  final _signInFormKey = GlobalKey<FormState>();

  // creating controllers for validation
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  // function for signInUser
  void signInDonor() {
    authService.signInDonor(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          //for app icon
          AppIcon(top: 15, left: 20, right: 10),

          // Use of form for validation
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              //color: Colors.yellow.shade300,
              child: Form(
                  key: _signInFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                          controller: _emailController,
                          hintText: "Email",
                          obscureText: false,
                          // enableSuggestions: true,
                          // autocorrect: false,
                          icon: Icon(Icons.email)),

                      const SizedBox(
                        height: 10,
                      ),

                      PasswordTextField(
                          controller: _passwordController,
                          label: 'password',
                          hintText: 'password',
                          obText: true),

                      // Use of custom Button
                      SizedBox(height: 15),
                      CustomButton(
                        text: 'Login',
                        color: Color.fromARGB(255, 252, 181, 74),
                        onTap: () {
                          if (_signInFormKey.currentState!.validate()) {
                            signInDonor();
                          }
                        },
                      ),

                      SizedBox(
                        height: 15,
                      ),

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
                                        builder: ((context) => SignUpPage())));
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
