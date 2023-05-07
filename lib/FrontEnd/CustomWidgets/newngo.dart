import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:manav_sewa/FrontEnd/CustomWidgets/custom_buttom.dart';
import 'package:manav_sewa/FrontEnd/constants/bottom_bar.dart';
import 'package:manav_sewa/FrontEnd/donations/food_donation.dart';
import 'package:manav_sewa/FrontEnd/screens/homescreen.dart/HomeScreen.dart';
import 'package:manav_sewa/FrontEnd/services/donor_work_likedonates/donor_service.dart';
import 'package:provider/provider.dart';
import '../constants/utils.dart';
import '../provider/Donor_provider.dart';
import '../provider/ngo_provider.dart';
import 'custom_appbar_donor.dart';

class NGONear extends StatefulWidget {
  final String donorName; // can be "food", "cloth", or "book"
  final String description;
  final int count;
  final String address;
  final String type;
  final List<String> areasOfInterest;
  final List<File> imagee;

  const NGONear({
    Key? key,
    required this.donorName,
    required this.description,
    required this.count,
    required this.address,
    required this.type,
    required this.areasOfInterest,
    required this.imagee,
  }) : super(key: key);

  @override
  State<NGONear> createState() => _NGONearState();
}

class _NGONearState extends State<NGONear> {
  Position? _position;
  List<String>? _nearbyNGOs;

  final DonorService donorService = DonorService();
  // String ngoName = '';
  // String ngoAddress = '';
  // String ngoEmailAddress = '';
  // String ngoPhoneNumber = '';
  final FoodDonationPage foodDonationPage = FoodDonationPage();
  List<dynamic> data = [];

  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _position = position;
    });

    // Get nearby NGOs based on user's latitude and longitude
    List<String> nearbyNGOs = await getNearbyNGOs();
    setState(() {
      _nearbyNGOs = nearbyNGOs;
    });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<List<String>> getNearbyNGOs() async {
    final ngosData = await rootBundle.loadString('assets/ngo_data.csv');

    // Parse the CSV data
    final ngos = const CsvToListConverter().convert(ngosData);

    // Define the distance threshold in meters
    final distanceThreshold = 10000;

    // Get the user's current location
    final userLocation = await Geolocator.getCurrentPosition();

    // Initialize a map to store the distances and NGO information
    final Map<String, Map<String, dynamic>> nearbyNGOs = {};

    // Calculate distances between user location and NGO locations
    for (var ngo in ngos) {
      final ngoName = ngo[2].toString();
      final ngoLatitude = double.parse(ngo[3].toString().trim());
      final ngoLongitude = double.parse(ngo[4].toString().trim());
      final ngoAddress = ngo[5].toString().trim();
      final ngoPhoneNumber = ngo[7].toString().trim();
      final ngoEmailAddress = ngo[8].toString().trim();
      final ngoId = ngo[0].toString().trim();
      final distance = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        ngoLatitude,
        ngoLongitude,
      );
      if (distance <= distanceThreshold) {
        if (!nearbyNGOs.containsKey(ngoName)) {
          nearbyNGOs[ngoName] = {
            'distance': distance,
            'address': ngoAddress,
            'phoneNumber': ngoPhoneNumber,
            'emailAddress': ngoEmailAddress,
            'ngoId': ngoId
          };
        } else if (nearbyNGOs[ngoName]!['distance']!.compareTo(distance) == 1) {
          nearbyNGOs[ngoName] = {
            'distance': distance,
            'address': ngoAddress,
            'phoneNumber': ngoPhoneNumber,
            'emailAddress': ngoEmailAddress,
            'ngoId': ngoId
          };
        }
      }
    }

    // Sort NGOs by distance
    final sortedNGOs = nearbyNGOs.entries.toList()
      ..sort((a, b) => a.value['distance']!.compareTo(b.value['distance']!));

    // Return the list of nearby NGOs with name, address, phone number, and email address
    if (sortedNGOs.isNotEmpty &&
        sortedNGOs.first.value['distance']! <= distanceThreshold) {
      final topNGOs = sortedNGOs
          .take(6)
          .map((entry) =>
              '${entry.key} - ${entry.value['address']} - ${entry.value['phoneNumber']} - ${entry.value['emailAddress']} - ${entry.value['ngoId']}')
          .toList();
      return topNGOs;
    } else {
      return [];
    }
  }

  void sendData(String ngoId, String ngoName, String ngoAddress,
      String ngoEmailAddress, String ngoPhoneNumber) {
    print("reached here");
    donorService.donation(
        context: context,
        description: widget.description,
        count: widget.count,
        address: widget.address,
        areasOfInterest: widget.areasOfInterest,
        images: widget.imagee,
        donorName: widget.donorName,
        type: widget.type,
        ngo_id: ngoId,
        ngo_name: ngoName,
        ngo_address: ngoAddress,
        ngo_emailaddress: ngoEmailAddress,
        ngo_phonenumber: ngoPhoneNumber);
  }

  // void sendDataforclothes(String ngoId, String ngoName, String ngoAddress,
  //     String ngoEmailAddress, String ngoPhoneNumber) {
  //   print("reached here");
  //   donorService.donation(
  //       context: context,
  //       description: widget.description,
  //       count: widget.count,
  //       address: 'damak',
  //       areasOfInterest: widget.areasOfInterest,
  //       images: widget.imagee,
  //       donorName: widget.donorName,
  //       type: 'Cloth-Donation',
  //       ngo_id: ngoId,
  //       ngo_name: ngoName,
  //       ngo_address: ngoAddress,
  //       ngo_emailaddress: ngoEmailAddress,
  //       ngo_phonenumber: ngoPhoneNumber);
  // }

  // void sendDataforbooks(String ngoId, String ngoName, String ngoAddress,
  //     String ngoEmailAddress, String ngoPhoneNumber) {
  //   print("reached here");
  //   donorService.donation(
  //       context: context,
  //       description: widget.description,
  //       count: widget.count,
  //       address: 'damak',
  //       areasOfInterest: widget.areasOfInterest,
  //       images: widget.imagee,
  //       donorName: widget.donorName,
  //       type: 'Book-Donation',
  //       ngo_id: ngoId,
  //       ngo_name: ngoName,
  //       ngo_address: ngoAddress,
  //       ngo_emailaddress: ngoEmailAddress,
  //       ngo_phonenumber: ngoPhoneNumber);
  // }

  @override
  void initState() {
    super.initState();
    getNearbyNGOs();
  }

  @override
  Widget build(BuildContext context) {
    final ngo = Provider.of<NGOProvider>(context).ngo;
    final donor = Provider.of<DonorProvider>(context).donor;
    return Scaffold(
      appBar: CustomAppBarDonor(
        donorAddress: donor.address,
        donorName: donor.name,
        donorId: donor.email,
        donorPhoneNumber: donor.address,
      ),
      body: Center(
        child: _position != null
            ? Column(
                children: <Widget>[
                  Text('Current Location: ' + _position.toString()),
                  _nearbyNGOs != null ? Text('Nearby NGOs:') : Container(),
                  _nearbyNGOs != null
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: _nearbyNGOs!.length,
                            itemBuilder: (BuildContext context, int index) {
                              final ngoData = _nearbyNGOs![index].split(' - ');
                              final ngoname = ngoData[0];
                              final ngoAddress = ngoData[1];
                              final ngoPhoneNumber = ngoData[2];
                              final ngoEmailAddress = ngoData[3];
                              final ngoId = ngoData[4];
                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            "Are you sure you want to donate?"),
                                        actions: [
                                          TextButton(
                                            child: Text("No"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                              child: Text("Yes"),
                                              onPressed: () {
                                                sendData(
                                                  ngoId,
                                                  ngoname,
                                                  ngoAddress,
                                                  ngoEmailAddress,
                                                  ngoPhoneNumber,
                                                );
                                                //selectedAddress);
                                                print(ngoId);
                                                Navigator.pop(context);
                                                showSnackBar(context,
                                                    "Donation Sucessfully added to the pending list!");
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BottomBar()),
                                                );

                                                donorService
                                                    .sendNotificationToNGO(
                                                        donor.id,
                                                        donor.name,
                                                        ngoId,
                                                        ngoname);
                                              }),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start, // Align texts to the start
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.business), // Add icon
                                            SizedBox(width: 8.0), // Add spacing
                                            Text(
                                              ngoname,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.0), // Add spacing
                                        Row(
                                          children: [
                                            Icon(Icons.location_on), // Add icon
                                            SizedBox(width: 8.0), // Add spacing
                                            Text(ngoAddress),
                                          ],
                                        ),
                                        SizedBox(height: 8.0), // Add spacing
                                        Row(
                                          children: [
                                            Icon(Icons.phone), // Add icon
                                            SizedBox(width: 8.0), // Add spacing
                                            Text(ngoPhoneNumber),
                                          ],
                                        ),
                                        SizedBox(height: 8.0), // Add spacing
                                        Row(
                                          children: [
                                            Icon(Icons.email), // Add icon
                                            SizedBox(width: 8.0), // Add spacing
                                            Text(ngoEmailAddress),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Container(),
                ],
              )
            : const Text('No Location Data'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        tooltip: 'Find Nearby NGOs',
        child: const Icon(Icons.search),
      ),
    );
  }
}
