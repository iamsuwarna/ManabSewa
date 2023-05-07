import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:manav_sewa/FrontEnd/NGO/services/bookmarkService.dart';
import 'package:manav_sewa/FrontEnd/NGO/services/ngo_login_service.dart';
import 'package:manav_sewa/FrontEnd/constants/bookmark.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/provider/Donor_provider.dart';
import 'package:manav_sewa/FrontEnd/services/search/search_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import '../../CustomWidgets/custom_appbar_donor.dart';
import '../../constants/below_appbar.dart';
import '../../models/donation_model.dart';
import '../../provider/ngo_provider.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ViewPendingDonations extends StatefulWidget {
  const ViewPendingDonations({Key? key}) : super(key: key);

  @override
  State<ViewPendingDonations> createState() => _CompletedDonationsState();
}

class _CompletedDonationsState extends State<ViewPendingDonations> {
  final DisplayNGODonations displayDonations = DisplayNGODonations();
  final BookmarkService bookmarkService = BookmarkService();
  String _searchKeyword = '';
  final TextEditingController _searchController = TextEditingController();
  List<DonationModel> donationModel = [];

  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    donationModel = await displayDonations.getOwnDonations(context);
    setState(() {});
  }

  void deleteDonation(String donationId) {
    for (int i = 0; i < donationModel.length; i++) {
      if (donationModel[i].donationid == donationId) {
        //donationModel.removeAt(i);
        donationModel[i].isHidden = true;
        setState(() {});
        break;
      }
    }
  }

  void onSearchTextChanged(String value) {
    setState(() {
      _searchKeyword = value;
    });
  }

  TextStyle boldStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  TextStyle normalStyle = TextStyle(
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    final donor = Provider.of<DonorProvider>(context, listen: false).donor;
    final ngo = Provider.of<NGOProvider>(context, listen: false).ngo;

    return Scaffold(
      appBar: CustomAppBarDonor(
          donorName: donor.name,
          donorId: donor.id,
          donorAddress: donor.address,
          donorPhoneNumber: donor.address),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 100, top: 10),
              child: Text('Pending Donations',
                  style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by donation description',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: onSearchTextChanged,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 500,
              child: donationModel.isNotEmpty
                  ? ListView.builder(
                      itemCount: donationModel.length,
                      itemBuilder: ((context, index) {
                        // Sort the donationModel list in descending order based on donationid
                        donationModel.sort(
                            (a, b) => b.donationid.compareTo(a.donationid));
                        if (_searchKeyword.isNotEmpty &&
                            !donationModel[index]
                                .description
                                .contains(_searchKeyword)) {
                          return const SizedBox.shrink();
                        }
                        if (donationModel[index].isHidden) {
                          return SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Image.network(
                                      donationModel[index].images![0],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: SizedBox(
                                    width: 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 16),
                                        const SizedBox(height: 8),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Donor: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              TextSpan(
                                                text: donationModel[index]
                                                    .donorName,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Type: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              TextSpan(
                                                text: donationModel[index].type,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Address: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              TextSpan(
                                                text: donationModel[index]
                                                    .address,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Count(in KGs): ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${donationModel[index].count}',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Description: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${donationModel[index].description}',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Phone: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${donationModel[index].phone_number}',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Donated to: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${donationModel[index].ngo_name}',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Donated on: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text: donationModel[index]
                                                            .date !=
                                                        null
                                                    ? DateFormat('yyyy-MM-dd')
                                                        .format(
                                                            donationModel[index]
                                                                .date!)
                                                    : '',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: donationModel[index]
                                                        .rejectionStatus
                                                    ? Colors.red
                                                    : Colors.blueGrey,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 10),
                                              child: Text(
                                                donationModel[index]
                                                        .rejectionStatus
                                                    ? 'Rejected'
                                                    : 'Pending',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            if (donationModel[index]
                                                .rejectionStatus)
                                              GestureDetector(
                                                onTap: () {
                                                  deleteDonation(
                                                      donationModel[index]
                                                          .donationid);
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.black,
                                                  size: 24.0,
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    )
                  : const Center(child: Text('No Pending Donations!')),
            ),
          ],
        ),
      ),
    );
  }
}
