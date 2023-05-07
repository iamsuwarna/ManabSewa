import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manav_sewa/FrontEnd/CustomWidgets/custom_appbar_donor.dart';
import 'package:manav_sewa/FrontEnd/CustomWidgets/custom_appbar_ngo.dart';
import 'package:manav_sewa/FrontEnd/NGO/services/bookmarkService.dart';
import 'package:manav_sewa/FrontEnd/constants/below_appbar.dart';
import 'package:manav_sewa/FrontEnd/provider/ngo_provider.dart';
import 'package:provider/provider.dart';
import '../models/bookmark_model.dart';
import '../models/donation_model.dart';
import '../provider/Donor_provider.dart';

class BookmarkScreen extends StatefulWidget {
  BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final BookmarkService bookmarkService = BookmarkService();
  List<BookmaarkModel> bookmaarkModel = [];
  bool isBookmark = false;
  List<DonationModel> donationModel = [];

  void getData() async {
    bookmaarkModel = await bookmarkService.fetchAllProducts(context);
    setState(() {});
  }

  @override
  void initState() {
    getData();
  }

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
        body: Column(
          children: [
            BelowAppBar(welcomeText: 'Favourite NGOs of'),
            Expanded(
              child: bookmaarkModel.isNotEmpty
                  ? ListView.builder(
                      itemCount: bookmaarkModel.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Card(
                            elevation: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Icon(Icons.business),
                                    SizedBox(width: 8),
                                    Text(bookmaarkModel[index].NGOName),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.location_on),
                                    SizedBox(width: 8),
                                    Text(bookmaarkModel[index].NGOAddress),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.phone),
                                    SizedBox(width: 8),
                                    Text(bookmaarkModel[index].NGOPhoneNumber),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.email),
                                    SizedBox(width: 8),
                                    Text(bookmaarkModel[index].NGOEmailAddress),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        );
                      }),
                    )
                  : const Center(child: Text('No Favourite NGOs!')),
            ),
          ],
        ));
  }
}
