import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manav_sewa/FrontEnd/NGO/ngo_screen/view_ngodonations.dart';
import 'package:manav_sewa/FrontEnd/constants/ngo_bottom_bar.dart';
import 'package:manav_sewa/FrontEnd/provider/Donor_provider.dart';
import 'package:manav_sewa/FrontEnd/provider/ngo_provider.dart';
import 'package:manav_sewa/FrontEnd/screens/homescreen.dart/completeddonation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants/ErrorHandeling.dart';
import '../../constants/globalvariables.dart';
import '../../constants/utils.dart';
import 'package:http/http.dart' as http;

import '../../models/donation_model.dart';
import '../../provider/ngo_provider.dart';
import '../../provider/ngo_provider.dart';

class DisplayNGODonations {
  Future<List<DonationModel>> fetchAllFeedbacks(BuildContext context) async {
    final ngoProvider = Provider.of<NGOProvider>(context, listen: false);
    List<DonationModel> donationList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/ngo/received-donations'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': ngoProvider.ngo.token,
      });
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              donationList.add(
                  DonationModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return donationList;
  }

  List<DonationModel> getDonations = [];
  List<DonationModel> getSelfDonations = [];
  List<DonationModel> getcompletedDonations = [];
  List<DonationModel> getNGODonations = [];
  List<DonationModel> getcompDonations = [];

  Future<List<DonationModel>> getOwnDonations(
    BuildContext context,
  ) async {
    final donor = Provider.of<DonorProvider>(context, listen: false).donor;
    getDonations = await fetchAllFeedbacks(context);

    for (int i = 0; i < getDonations.length; i++) {
      if (getDonations[i].donorId == donor.id &&
          getDonations[i].donationStatus == false) {
        getSelfDonations.add(getDonations[i]);
      }
    }
    return getSelfDonations;
  }

  Future<List<DonationModel>> getCompletedDonations(
    BuildContext context,
  ) async {
    final donor = Provider.of<DonorProvider>(context, listen: false).donor;

    getcompDonations = await fetchAllFeedbacks(context);

    for (int i = 0; i < getcompDonations.length; i++) {
      if (getcompDonations[i].donorId == donor.id) {
        if (getcompDonations[i].donationStatus == true &&
            getcompDonations[i].rejectionStatus == false) {
          getcompletedDonations.add(getcompDonations[i]);
        }
      }
      // print(getDonations[i].ngo_id);
      // print(ngo.ngo_id);
      // print("reached here");
    }
    return getcompletedDonations;
  }

  Future<List<DonationModel>> getNgoDonations(
    BuildContext context,
    bool value,
  ) async {
    final ngo = Provider.of<NGOProvider>(context, listen: false).ngo;

    getDonations = await fetchAllFeedbacks(context);

    for (int i = 0; i < getDonations.length; i++) {
      if (getDonations[i].ngo_id == ngo.ngo_id) {
        if (getDonations[i].donationStatus == value &&
            getDonations[i].rejectionStatus == false) {
          getNGODonations.add(getDonations[i]);
        }
      }
      // print(getDonations[i].ngo_id);
      // print(ngo.ngo_id);
      // print("reached here");
    }
    return getNGODonations;
  }

//update project status
  void updateProjectStatus({
    required BuildContext context,
    required String projectID,
  }) async {
    final userProvider = Provider.of<NGOProvider>(context, listen: false);
    try {
      http.Response res = await http.put(
        Uri.parse('$uri/ngo/change-status'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.ngo.token,
        },
        body: jsonEncode({
          'projectId': projectID,
        }),
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NGOBottomBar()));
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

//SEND accept NOTIFICATION TO USER
  void sendAcceptNotificationToDonor(
      String donorId, String ngo_id, String ngoName, String donorName) async {
    try {
      // Initialize OneSignal
      await OneSignal.shared.setAppId("b3f6bbb6-34cb-47aa-9308-f36ba09d1129");
      // Send the notification request to the NGO's server
      var url = Uri.parse('$uri/accept/notification-to-donor');
      var headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      };
      var body = jsonEncode(<String, dynamic>{
        'donor_id': donorId,
        'ngo_id': ngo_id,
        'ngoName': ngoName,
        'donorName': donorName,
      });
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Error sending notification');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  //SEND rejeceted NOTIFICATION TO USER
  void sendRejectNotificationToDonor(
      String donorId, String ngo_id, String ngoName, String donorName) async {
    try {
      // Initialize OneSignal
      await OneSignal.shared.setAppId("b3f6bbb6-34cb-47aa-9308-f36ba09d1129");
      // Send the notification request to the NGO's server
      var url = Uri.parse('$uri/reject/notification-to-donor');
      var headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      };
      var body = jsonEncode(<String, dynamic>{
        'donor_id': donorId,
        'ngo_id': ngo_id,
        'ngoName': ngoName,
        'donorName': donorName,
      });
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Error sending notification');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  //update project status
  void updateRejectionStatus({
    required BuildContext context,
    required String projectID,
  }) async {
    final userProvider = Provider.of<NGOProvider>(context, listen: false);
    try {
      http.Response res = await http.put(
        Uri.parse('$uri/ngo/reject-status'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.ngo.token,
        },
        body: jsonEncode({
          'projectId': projectID,
        }),
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NGOBottomBar()));
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
