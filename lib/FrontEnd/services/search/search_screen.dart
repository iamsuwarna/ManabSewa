import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manav_sewa/FrontEnd/NGO/services/ngo_login_service.dart';
import 'package:manav_sewa/FrontEnd/models/ngo_model.dart';
import 'package:manav_sewa/FrontEnd/services/search/search_service.dart';
import 'package:provider/provider.dart';

import '../../constants/globalvariables.dart';
import '../../models/donation_model.dart';
import '../../provider/Donor_provider.dart';
import '../../provider/ngo_provider.dart';

class SearchScreen extends StatefulWidget {
  final String searchQuery;
  SearchScreen({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<NGO>? ngos;
  final SearchServices searchServices = SearchServices();
  final DisplayNGODonations displayDonations = DisplayNGODonations();

  List<DonationModel> donationModel = [];

  // void navigateToSearchScreen(String query) {
  //   Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetechSearchedNGO();
    _getData();
  }

  void _getData() async {
    donationModel = await displayDonations.getOwnDonations(context);
    setState(() {});
  }

  fetechSearchedNGO() async {
    ngos = await searchServices.fetchSearchedNGO(
        context: context, searchQuery: widget.searchQuery);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final donor = Provider.of<DonorProvider>(context, listen: false).donor;
    final ngo = Provider.of<NGOProvider>(context, listen: false).ngo;
    return ngos == null
        ? const CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              title: Text('Search Screen Donations'),
            ),
            body: donationModel.isNotEmpty
                ? ListView.builder(
                    itemCount: donationModel.length,
                    itemBuilder: (context, index) => Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height:
                                  100, // set the height of the image list widget
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: donationModel[index].images?.length,
                                itemBuilder: (context, i) {
                                  return Image.network(
                                      donationModel[index].images![i]);
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Donor: ${donationModel[index].donorName}',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Address: ${donationModel[index].address}',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Description: ${donationModel[index].description}',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Count: ${donationModel[index].count}',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Type: ${donationModel[index].type}',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: donationModel[index].rejectionStatus
                                    ? Colors.red
                                    : Colors.blueGrey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              child: Text(
                                donationModel[index].rejectionStatus
                                    ? 'Rejected'
                                    : 'Pending',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const Center(child: Text('No Pending Donations!')),
          );
  }
}
