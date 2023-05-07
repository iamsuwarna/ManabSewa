import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:manav_sewa/FrontEnd/CustomWidgets/custom_buttom.dart';
import 'dart:convert';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/constants/utils.dart';
import 'package:provider/provider.dart';

import '../CustomWidgets/custom_appbar_donor.dart';
import '../provider/Donor_provider.dart';
import 'below_appbar.dart';

class NGORecommendationPage extends StatefulWidget {
  @override
  _NGORecommendationPageState createState() => _NGORecommendationPageState();
}

class _NGORecommendationPageState extends State<NGORecommendationPage> {
  String _selectedDistrict = 'Bhojpur';
  //bool isLoading= false;
  String _selectedZone = 'Kosi';
  List<Map<String, dynamic>> recommendedNGOs = [];
  final List<String> _districts = [
    'Bhojpur',
    'Dhankuta',
    'Ilam',
    'Okhaldhunga',
    'Panchthar',
    'Siraha',
    'Solukhumbu',
    'Taplejung'
  ];
  final Map<String, List<String>> _districtToZones = {
    'Bhojpur': ['Kosi'],
    'Dhankuta': ['Kosi'],
    'Ilam': ['Mechi'],
    'Okhaldhunga': ['Sagarmatha'],
    'Panchthar': ['Mechi'],
    'Siraha': ['Sagarmatha'],
    'Solukhumbu': ['Sagarmatha'],
    'Taplejung': ['Mechi']
  };
  void _submitForm() async {
    setState(() {
      bool isLoading = true; // Show loading indicator
    });
    final response = await http.post(
      Uri.parse('$uri/recommend'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'district': _selectedDistrict,
        'zone': _selectedZone,
      }),
    );
    final responseJson = jsonDecode(response.body);
    setState(() {
      recommendedNGOs =
          List<Map<String, dynamic>>.from(responseJson['recommendedNGOs']);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;

    final donor = Provider.of<DonorProvider>(context, listen: false).donor;

    return Scaffold(
      appBar: CustomAppBarDonor(
          donorName: donor.name,
          donorId: donor.id,
          donorAddress: donor.address,
          donorPhoneNumber: donor.address),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 100),
              child: Text('Recommended NGOs',
                  style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 20,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: 'District',
              ),
              value: _selectedDistrict,
              items: _districts
                  .map((district) => DropdownMenuItem(
                        child: Text(district),
                        value: district,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDistrict = value as String;
                  _selectedZone = _districtToZones[value]![0];
                });
              },
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Zone',
              ),
              value: _selectedZone,
              items: _districtToZones[_selectedDistrict]!
                  .map((zone) => DropdownMenuItem(
                        child: Text(zone),
                        value: zone,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedZone = value as String;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Center(
              child: isLoading
                  ? CircularProgressIndicator() // Show loading indicator if isLoading is true
                  : CustomButton(
                      text: "Recommend NGOs",
                      onTap: _submitForm,
                      color: GlobalVariables.selectedNavBarColor,
                    ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Recommended NGOs:',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 8.0),
            Visibility(
              visible: isLoading,
              child: Center(child: Text('finding...')),
              replacement: recommendedNGOs.isNotEmpty
                  ? Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showSnackBar(context,
                              'This NGO is not regsitered! Donations can only be made in registered NGOs');
                        },
                        child: ListView.builder(
                          itemCount: recommendedNGOs.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> ngo = recommendedNGOs[index];

                            return Card(
                                color: Colors.yellow.shade50,
                                elevation: 10,
                                child: ListTile(
                                  title: Text(ngo['name']),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10.0),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on, size: 16.0),
                                          SizedBox(height: 10.0),
                                          Text(ngo['address']),
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      Row(
                                        children: [
                                          Icon(Icons.map, size: 16.0),
                                          SizedBox(width: 4.0),
                                          Text(ngo['geographical_region']),
                                        ],
                                      ),
                                    ],
                                  ),
                                ));
                          },
                        ),
                      ),
                    )
                  : const Text(
                      'No NGOs recommended yet.',
                      style: TextStyle(fontSize: 16.0),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
