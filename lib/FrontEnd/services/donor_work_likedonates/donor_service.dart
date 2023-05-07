import 'dart:convert';
import 'dart:io';
//mport 'dart:js';
import 'package:manav_sewa/FrontEnd/screens/homescreen.dart/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manav_sewa/FrontEnd/NGO/ngo_screen/view_ngodonations.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/constants/notification.dart';
import 'package:manav_sewa/FrontEnd/models/cloth_donation_model.dart';
import 'package:manav_sewa/FrontEnd/models/donation_model.dart';
import 'package:manav_sewa/FrontEnd/models/food_donation_model.dart';
import 'package:http/http.dart' as http;
import 'package:manav_sewa/FrontEnd/provider/Donor_provider.dart';
import 'package:manav_sewa/FrontEnd/provider/ngo_provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import '../../constants/ErrorHandeling.dart';
import '../../constants/ngo_bottom_bar.dart';
import '../../constants/utils.dart';
import '../../models/ngo_model.dart';
import '../../provider/Donor_provider.dart';

class DonorService {
  NotificationService notificationService = NotificationService();

  void rateNGO({
    required BuildContext context,
    required NGO ngo,
    required double rating,
  }) async {
    final donorProvider = Provider.of<DonorProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/rate-ngo'),
        headers: {
          'Content-Type': 'application/json;charset= UTF-8',
          'x-auth-token': donorProvider.donor.token,
        },
        body: jsonEncode({
          'id': ngo.ngo_id,
          'rating': rating,
        }),
      );
      httpErrorHandle(response: res, context: context, onSuccess: () {});
    } catch (e) {}
  }

  //for push notification
  void sendNotificationToNGO(
      String donorId, String donorName, String ngo_id, String ngo_name) async {
    try {
      // Initialize OneSignal
      await OneSignal.shared.setAppId("b3f6bbb6-34cb-47aa-9308-f36ba09d1129");
      // Send the notification request to your server
      var url = Uri.parse('$uri/notification');
      var headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      };
      var body = jsonEncode(<String, dynamic>{
        'donorId': donorId,
        'donorName': donorName,
        'ngo_id': ngo_id,
        'ngo_name': ngo_name
      });

      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        // Add the NGO's ngo_id as a tag in OneSignal
        await OneSignal.shared.sendTag('ngo_id', ngo_id);
        print('Notification sent successfully');
      } else {
        print('Error sending notification');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<void> rateNgo(String donorId, String ngoId, double rating) async {
    final String apiUrl = '/rate_ngo';
    final Map<String, dynamic> requestBody = {
      'donorId': donorId,
      'ngo_id': ngoId,
      'rating': rating,
    };

    final response = await http.post(Uri.parse(apiUrl), body: requestBody);

    if (response.statusCode == 200) {
      print('NGO rating updated successfully.');
    } else {
      print('Error updating NGO rating.');
    }
  }

  //method for donation
  void donation({
    required BuildContext context,
    required String donorName,
    required String ngo_id,
    required String ngo_name,
    required String ngo_address,
    required String ngo_emailaddress,
    required String ngo_phonenumber,
    required String description,
    required int count,
    required String address,
    required String type,
    required List<String> areasOfInterest,
    required List<File> images,
  }) async {
    notificationService.initialiseNotifications();

    final ngo = Provider.of<NGOProvider>(context, listen: false).ngo;
    final donor = Provider.of<DonorProvider>(context, listen: false).donor;
    try {
      final cloudinary = CloudinaryPublic('dmh6tssvz', 'cjfepanz');

      List<String> imageUrls = [];
      print(images);

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(images[i].path, folder: description[0]));
        imageUrls.add(res.secureUrl);
      }
      print(imageUrls);
      //calling Donation model
      DonationModel donationModel = DonationModel(
          donationid: '',
          donationStatus: false,
          donorId: donor.id,
          donorName: donorName,
          phone_number: donor.phone_number,
          ngo_id: ngo_id,
          description: description,
          count: count,
          ngo_name: ngo_name,
          ngo_address: ngo_address,
          ngo_emailaddress: ngo_emailaddress,
          ngo_phonenumber: ngo_phonenumber,
          address: address,
          type: type,
          areasOfInterest: areasOfInterest,
          rejectionStatus: false,
          images: imageUrls,
          isHidden: false);

      http.Response res = await http.post(
        Uri.parse('$uri/donate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': ngo.token,
        },
        body: donationModel.toJson(),
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            showSnackBar(context, "Donation Item added to the pending list");
          });
    } catch (e) {
      print("Failed here only");
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }
}
