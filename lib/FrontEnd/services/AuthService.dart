import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:manav_sewa/FrontEnd/constants/about_user.dart';
import 'package:manav_sewa/FrontEnd/constants/bottom_bar.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/constants/ngo_bottom_bar.dart';
import 'package:manav_sewa/FrontEnd/constants/utils.dart';
import 'package:manav_sewa/FrontEnd/models/ngo_model.dart';
import 'package:manav_sewa/FrontEnd/models/donor_model.dart';
import 'package:http/http.dart' as http;
import 'package:manav_sewa/FrontEnd/provider/ngo_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/ErrorHandeling.dart';
import '../provider/Donor_provider.dart';

class AuthService {
  // signup user
  void signUpDonor({
    required BuildContext context,
    required String email,
    required String phone_number,
    required String password,
    required String name,
  }) async {
    try {
      Donor donor = Donor(
        id: '',
        name: name,
        email: email,
        phone_number: phone_number,
        password: password,
        token: '',
        address: '',
        type: '',
        bookmark: [],
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: donor.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
              context,
              'Account created! Login with the same credentials!',
            );
            Navigator.pop(context);
          });
    } catch (e) {
      showSnackBar(context, e.toString() + "failed here");
    }
  }

  void signInDonor({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({"email": email, "password": password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          String token = jsonDecode(res.body)["token"];
          // Store the token in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String state_token = prefs.getString("x-auth-token").toString();
          await prefs.setString("x-auth-token", token);

          // Update the user's data in the provider
          Provider.of<DonorProvider>(context, listen: false).setDonor(res.body);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomBar()),
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

//this is final
  void getUserData({
    required BuildContext context,
    //required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
  }) async {
    try {
      // get sharedpreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // getting token from shared prefernces
      String? token = prefs.getString("x-auth-token");

      // checking the status of token
      if (token == null) {
        // it means user have open the app for first time and there is no data in the input fields.
        prefs.setString("x-auth-token", '');
      }
      // calling api for token validation
      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      // This response will give us true or false
      var response = jsonDecode(tokenRes.body);
      // print('token----> ' + "response" + response);

      if (response == true) {
        // get user data
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );
        var userProvider = Provider.of<DonorProvider>(context, listen: false);
        userProvider.setDonor(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInNGO({
    required BuildContext context,
    required String ngo_id,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin/ngo'),
        body: jsonEncode({"ngo_id": ngo_id, "password": password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          // for signin token must be stored and for storing token
          // SharedPreferences is used to store data into app's memory
          SharedPreferences prefs = await SharedPreferences.getInstance();
          // Now provider comes into Action to store user's data
          Provider.of<NGOProvider>(context, listen: false).setNGO(res.body);
          await prefs.setString("x-auth-token", jsonDecode(res.body)["token"]);

          // after success in signin load to the homescreen
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => NGOBottomBar())));
        },
      );
    } catch (e) {
      print("failed in sign in ngo");
      showSnackBar(context, e.toString());
    }
  }

//for ngo signup
  void signUpNGO(
      {required BuildContext context,
      required String ngo_id,
      required String name,
      required String address,
      required String password,
      required String phone_number,
      required String email1,
      required String email}) async {
    try {
      NGO ngo = NGO(
        ngo_id: ngo_id,
        name: name,
        address: address,
        password: password,
        phone_number: phone_number,
        email1: email1,
        email: email,
        token: '123',
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup/ngo'),
        body: ngo.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
              context,
              'New Account for NGO has been created!',
            );
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get ngo data
  void getNGOData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokens = prefs.getString('x-auth-token');
      if (tokens == null) {
        prefs.setString('x-auth-token', '');
      }

      var ngores = await http.post(Uri.parse('$uri/ngo-tokenisvalid'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': tokens!
          });

      var answer = jsonDecode(ngores.body);

      if (answer == true) {
        http.Response ngoRes = await http.get(Uri.parse('$uri/ngo'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': tokens
            });

        var ngo_provider = Provider.of<NGOProvider>(context, listen: false);
        ngo_provider.setNGO(ngoRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    void notification({
      required BuildContext context,
      required String ngoId,
      required String ngoName,
      required String donationAmount,
    }) async {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');

      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
      );
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        //'donation_notification_channel_id',
        'Donation Notification',
        'Notification for when a donor donates to an NGO',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      // create the notification
      await flutterLocalNotificationsPlugin.show(
        0,
        'New Donation Received',
        'You have received a new donation of $donationAmount from $ngoName (ID: $ngoId).',
        platformChannelSpecifics,
      );
    }
  }
}
