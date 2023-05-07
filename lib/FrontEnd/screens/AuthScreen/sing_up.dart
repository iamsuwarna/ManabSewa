import 'package:flutter/material.dart';
import 'package:manav_sewa/FrontEnd/CustomWidgets/custom_texfield.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/constants/utils.dart';
import 'package:manav_sewa/FrontEnd/screens/AuthScreen/sign_in.dart';
import 'package:manav_sewa/FrontEnd/screens/carousal_slider/donor_or_donee.dart';
import 'package:manav_sewa/FrontEnd/services/AuthService.dart';
import '../../CustomWidgets/custom_buttom.dart';
import '../../CustomWidgets/password_textfield.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<SignUpPage> {
  // creating global variables
  final _signUpFormKey = GlobalKey<FormState>();

  // creating controllers for validation
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // List of country codes

  final AuthService authService = AuthService();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
  }

  void signUpDonor() {
    authService.signUpDonor(
      context: context,
      email: _emailController.text,
      phone_number: _phoneController.text,
      password: _passwordController.text,
      name: _nameController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Column(children: [
          //  for app logo
          AppIcon(top: 15, left: 10, right: 20),

          // Use of form for validation
          Container(
            padding: const EdgeInsets.all(20),
            //color: Colors.yellow.shade300,
            child: Form(
                key: _signUpFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      hintText: "Name",
                      obscureText: false,
                      // enableSuggestions: true,
                      // autocorrect: false,
                      icon: Icon(Icons.person),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: _emailController,
                      obscureText: false,
                      hintText: "Email",
                      icon: Icon(Icons.email),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: _phoneController,
                      showNumber: true,
                      hintText: 'Phone Number',
                      icon: Icon(Icons.phone),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PasswordTextField(
                        controller: _passwordController,
                        label: 'password',
                        hintText: 'password',
                        obText: true),

                    // Use of custom Button
                    SizedBox(height: 10),
                    CustomButton(
                      text: 'Sign Up',
                      color: Color.fromARGB(255, 243, 182, 91),
                      onTap: () {
                        if (_signUpFormKey.currentState!.validate()) {
                          if (_passwordController.text.length < 6) {
                            showSnackBar(
                                context, 'Please enter a longer password');
                          } else if (_phoneController.text.length < 10) {
                            showSnackBar(context, 'Invalid Phone Number');
                          } else {
                            signUpDonor();
                          }
                        }
                      },
                    ),

                    //no account
                    Padding(
                      padding: EdgeInsets.only(left: 60, top: 25),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          const SignUpPage())));
                            },
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignInPage()));
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
