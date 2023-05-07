import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manav_sewa/FrontEnd/NGO/ngo_signup.dart';
import 'package:manav_sewa/FrontEnd/NGO/services/ngo_login_service.dart';
import 'package:manav_sewa/FrontEnd/constants/about_ngo.dart';
import 'package:manav_sewa/FrontEnd/constants/below_appbar.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/constants/phone.dart';
import 'package:manav_sewa/FrontEnd/constants/view_donation.dart';
import 'package:manav_sewa/FrontEnd/models/donation_model.dart';
import 'package:manav_sewa/FrontEnd/provider/Donor_provider.dart';
import 'package:manav_sewa/FrontEnd/provider/ngo_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../CustomWidgets/custom_appbar_ngo.dart';
import '../../constants/about_user.dart';
import '../../models/ngo_model.dart';

class ViewNGODonations extends StatefulWidget {
  const ViewNGODonations({Key? key}) : super(key: key);
  @override
  State<ViewNGODonations> createState() => _ViewNGODonationsState();
}

class _ViewNGODonationsState extends State<ViewNGODonations> {
  final DisplayNGODonations displayDonations = DisplayNGODonations();
  final PhoneCall phoneCall = PhoneCall();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  List<DonationModel> donationModel = [];
  DateTime now = DateTime.now();

  List<NGO> ngoModel = [];

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
    //ngo provider
    final ngo = Provider.of<NGOProvider>(context).ngo;
    final donor = Provider.of<DonorProvider>(context, listen: false).donor;
    Future<void> _makePhoneCall() async {
      String phoneNumber = donor.phone_number;
      String url = "tel:$phoneNumber";
      print(url);
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Unable to make phone call'),
        ));
      }
    }

    //for email
    Future<void> _sendEmail() async {
      //List<List<dynamic>> rowsList = [];
      //String fileContent = await rootBundle.loadString('assets/ngo_data.csv');
      // rowsList = CsvToListConverter().convert(fileContent);
      String emailAddress = donor.email;
      final Uri _emailLaunchUri = Uri(
          scheme: 'mailto',
          path: emailAddress,
          queryParameters: {
            'subject': 'Enter your subject here',
            'body': 'Enter your email body here'
          });
      await launch(_emailLaunchUri.toString());
    }

    return Scaffold(
      appBar: CustomAppBar(
        ngoAddress: ngo.address,
        ngoId: ngo.ngo_id,
        ngoName: ngo.name,
        ngoPhoneNumber: ngo.phone_number,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 100, top: 10),
              child: Text('Donations Received',
                  style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20),
            Container(
              height: 500,
              child: donationModel.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: donationModel.length,
                      itemBuilder: (BuildContext context, int index) {
                        // Sort the donationModel list in descending order based on donationid
                        donationModel.sort(
                            (a, b) => b.donationid.compareTo(a.donationid));

                        return Card(
                          elevation: 4,
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  donationModel[index].type,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'by ' + donationModel[index].donorName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        _makePhoneCall();
                                      },
                                      child: Icon(Icons.phone),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _sendEmail();
                                      },
                                      child: Icon(Icons.email),
                                    ),
                                    FlatButton(
                                      color: Colors.orange.shade200,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ViewDonations(
                                              donorName: donationModel[index]
                                                  .donorName,
                                              donorAddress:
                                                  donationModel[index].address,
                                              donationCount:
                                                  donationModel[index]
                                                      .count
                                                      .toString(),
                                              donationType:
                                                  donationModel[index].type,
                                              donationDescription:
                                                  donationModel[index]
                                                      .description,
                                              donationImage:
                                                  donationModel[index].images!,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "View Donation",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No donations received',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
