import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:manav_sewa/FrontEnd/CustomWidgets/custom_buttom.dart';
import 'package:manav_sewa/FrontEnd/CustomWidgets/custom_texfield.dart';
import 'package:manav_sewa/FrontEnd/CustomWidgets/newngo.dart';
import 'package:manav_sewa/FrontEnd/constants/area_of_interest.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/donations/address_combobox.dart';
//import 'package:manav_sewa/FrontEnd/donations/food_donation_service/donatefood.dart';
import 'package:manav_sewa/FrontEnd/models/donor_model.dart';
import 'package:manav_sewa/FrontEnd/provider/Donor_provider.dart';
import 'package:manav_sewa/FrontEnd/provider/ngo_provider.dart';
import 'package:manav_sewa/FrontEnd/screens/carousal_slider/carousal_slider.dart';
import 'package:manav_sewa/FrontEnd/screens/homescreen.dart/HomeScreen.dart';
import 'package:manav_sewa/FrontEnd/screens/homescreen.dart/donation_related_text.dart';
import 'package:manav_sewa/FrontEnd/services/AuthService.dart';
import 'package:manav_sewa/FrontEnd/constants/utils.dart';
import 'package:manav_sewa/FrontEnd/services/donor_work_likedonates/donor_service.dart';
import 'package:provider/provider.dart';
import '../constants/food-count-textfiled.dart';
import '../constants/ngo_recommendation.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FoodDonationPage extends StatefulWidget {
  @override
  _FoodDonationPageState createState() => _FoodDonationPageState();
}

class _FoodDonationPageState extends State<FoodDonationPage> {
  // creating global variables
  final _fooddonationFormKey = GlobalKey<FormState>();
  final TextEditingController _fooddescription = TextEditingController();
  final TextEditingController _foodcount = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final DonorService donorService = DonorService();

  //final TextEditingController _nameController = TextEditingController();
  final AuthService authService = AuthService();
  final NepalAddress nepalAddress = NepalAddress();

  List<String> _selectedAreaOfInterest = [];
  List<File> images = [];

//for picking up images from phone's gallery
  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
      print("immm");
      print(images);
    });
  }

  String _selectedDistrict = 'Bhojpur';
  String _selectedZone = 'Kosi';
  List<Map<String, dynamic>> recommendedNGOs = [];
  String _selectedAddress = "Kathmandu";
  final List<String> _addresses = [
    "Kathmandu",
    "Pokhara",
    "Lumbini",
    "Chitwan",
    "Biratnagar"
  ];
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
    final ngo = Provider.of<NGOProvider>(context).ngo;
    final donor = Provider.of<DonorProvider>(context).donor;

    void navigateto(BuildContext context) async {
      // NearbyNGOsPage(title: 'js');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NGONear(
                    donorName: donor.name,
                    description: _fooddescription.text,
                    count: _foodcount.text.length,
                    address: _selectedAddress,
                    type: "Food-Donation",
                    areasOfInterest: _selectedAreaOfInterest,
                    imagee: images,
                  )));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Donate Food'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _fooddonationFormKey,
            child: Column(
              children: <Widget>[
                //add food's picture
                images.isNotEmpty
                    ? CarouselSlider(
                        items: images.map((i) {
                          return Builder(
                            builder: (BuildContext context) => Image.file(
                              i,
                              fit: BoxFit.cover,
                              height: 200,
                            ),
                          );
                        }).toList(),
                        options:
                            CarouselOptions(viewportFraction: 1, height: 200))
                    : GestureDetector(
                        onTap: () {
                          selectImages();
                        },
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Add Food Images',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  controller: _fooddescription,
                  hintText: "Food's Description",
                ),
                SizedBox(
                  height: 20,
                ),

                //for food count
                FoodCountTextField(
                    CountName: 'Food-Count', controller: _foodcount),
                //CustomTextField(controller: _foodcount, hintText: "Food Count"),

                SizedBox(
                  height: 20,
                ),
                //address
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Container(
                          width: double.maxFinite,
                          child: ListView.builder(
                            itemCount: _addresses.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_addresses[index]),
                                onTap: () {
                                  setState(() {
                                    _selectedAddress = _addresses[index];
                                  });
                                  Navigator.of(context).pop();
                                  print(_selectedAddress);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  controller: TextEditingController(text: _selectedAddress),
                ),

                SizedBox(
                  height: 20,
                ),
                // AreaOfInterestTextField(),
                Column(
                  children: <Widget>[
                    DonationRelatedText(
                      text: "In which area of NGO, do you want to donate?",
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        FlatButton(
                          child: Text("Children"),
                          onPressed: () {
                            setState(() {
                              if (_selectedAreaOfInterest
                                  .contains("Children")) {
                                _selectedAreaOfInterest.remove("Children");
                              } else {
                                _selectedAreaOfInterest.add("Children");
                              }
                            });
                          },
                          color: _selectedAreaOfInterest.contains("Children")
                              ? GlobalVariables.selectedNavBarColor
                              : Colors.grey[300],
                          textColor:
                              _selectedAreaOfInterest.contains("Children")
                                  ? Colors.white
                                  : Colors.black,
                        ),
                        FlatButton(
                          child: Text("Women"),
                          onPressed: () {
                            setState(() {
                              if (_selectedAreaOfInterest.contains("Women")) {
                                _selectedAreaOfInterest.remove("Women");
                              } else {
                                _selectedAreaOfInterest.add("Women");
                              }
                            });
                          },
                          color: _selectedAreaOfInterest.contains("Women")
                              ? GlobalVariables.selectedNavBarColor
                              : Colors.grey[300],
                          textColor: _selectedAreaOfInterest.contains("Women")
                              ? Colors.white
                              : Colors.black,
                        ),
                        FlatButton(
                          child: Text("Elderly"),
                          onPressed: () {
                            setState(() {
                              if (_selectedAreaOfInterest.contains("Elderly")) {
                                _selectedAreaOfInterest.remove("Elderly");
                              } else {
                                _selectedAreaOfInterest.add("Elderly");
                              }
                            });
                          },
                          color: _selectedAreaOfInterest.contains("Elderly")
                              ? GlobalVariables.selectedNavBarColor
                              : Colors.grey[300],
                          textColor: _selectedAreaOfInterest.contains("Elderly")
                              ? Colors.white
                              : Colors.black,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                //button for finding ngo
                CustomButton(
                  text: "Find NGOs near you",
                  onTap: () {
                    if (_fooddonationFormKey.currentState!.validate()) {
                      if (images.isEmpty) {
                        showSnackBar(context,
                            "Please add the image of an item to donate!");
                      } else if (_foodcount.text.isEmpty) {
                        showSnackBar(context, "Please specify the food count!");
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => NGONear(
                                    donorName: donor.name,
                                    description: _fooddescription.text,
                                    count: int.parse(_foodcount.text),
                                    address: _selectedAddress,
                                    type: 'Food-Donor',
                                    areasOfInterest: _selectedAreaOfInterest,
                                    imagee: images))));
                      }
                    }
                  },
                  color: GlobalVariables.selectedNavBarColor,
                ),

                const SizedBox(
                  height: 5,
                ),
                //Recommended Text
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Recommended NGOs for you",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //button for finding ngo
                      CustomButton(
                        text: "Recommend me NGOS",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      NGORecommendationPage())));
                        },
                        color: GlobalVariables.selectedNavBarColor,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
