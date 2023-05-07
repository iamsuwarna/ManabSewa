import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:manav_sewa/FrontEnd/CustomWidgets/custom_buttom.dart';
import 'package:manav_sewa/FrontEnd/NGO/services/ngo_login_service.dart';
import 'package:manav_sewa/FrontEnd/constants/utils.dart';
import 'package:provider/provider.dart';

import '../models/donation_model.dart';
import '../provider/Donor_provider.dart';
import '../provider/ngo_provider.dart';

class ViewDonations extends StatefulWidget {
  final String donationType;
  final List<String> donationImage;
  final String donorName;
  final String donorAddress;
  final String donationCount;
  final String donationDescription;
  final DateTime? date; // new field for date

  ViewDonations(
      {Key? key,
      required this.donationType,
      required this.donationImage,
      required this.donorName,
      required this.donorAddress,
      required this.donationCount,
      required this.donationDescription,
      this.date})
      : super(key: key);

  @override
  State<ViewDonations> createState() => _ViewDonationsState();
}

class _ViewDonationsState extends State<ViewDonations> {
  final DisplayNGODonations displayDonations = DisplayNGODonations();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  List<DonationModel> donationModel = [];
  void getdata() async {
    donationModel = await displayDonations.getNgoDonations(context, false);
    setState(() {
      print(donationModel.length);
    });
  }

  void changeStatus(BuildContext context, String projectID) {
    displayDonations.updateProjectStatus(
        context: context, projectID: projectID);
  }

  void rejectionStatus(BuildContext context, String projectID) {
    displayDonations.updateRejectionStatus(
        context: context, projectID: projectID);
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    final ngo = Provider.of<NGOProvider>(context).ngo;
    final donor = Provider.of<DonorProvider>(context, listen: false).donor;
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Image.network(
                widget.donationImage[0],
                height: 200,
                width: 200,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.donationType,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade800,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Donor Name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade800,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        donationModel[index].donorName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Donation Count',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade800,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${widget.donationCount}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.blueGrey.shade300,
              thickness: 1,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Donation Description:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade800,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.donationDescription,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey.shade600,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Donated On:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade800,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    donationModel[index].date != null
                        ? '${DateFormat('yyyy-MM-dd').format(donationModel[index].date!)}'
                        : '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey.shade600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    text: 'Accept Donation',
                    color: Color.fromARGB(255, 115, 252, 122),
                    onTap: () {
                      changeStatus(
                        context,
                        donationModel[index].donationid,
                      );
                      displayDonations.sendAcceptNotificationToDonor(
                        donationModel[index].donorId,
                        ngo.ngo_id,
                        ngo.name,
                        donor.name,
                      );
                      showSnackBar(context, 'Donation has been accepted!');
                    },
                  ),
                  CustomButton(
                    text: 'Reject Donation',
                    color: Color.fromARGB(255, 246, 49, 46),
                    onTap: () {
                      rejectionStatus(
                        context,
                        donationModel[index].donationid,
                      );
                      displayDonations.sendRejectNotificationToDonor(
                        donationModel[index].donorId,
                        ngo.ngo_id,
                        ngo.name,
                        donor.name,
                      );
                      showSnackBar(context, 'Donation has been rejected!');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
