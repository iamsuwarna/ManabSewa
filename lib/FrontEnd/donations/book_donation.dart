import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manav_sewa/FrontEnd/CustomWidgets/custom_buttom.dart';
import 'package:manav_sewa/FrontEnd/CustomWidgets/custom_texfield.dart';
import 'package:manav_sewa/FrontEnd/constants/area_of_interest.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/donations/address_combobox.dart';
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

import '../CustomWidgets/newngo.dart';
import '../constants/food-count-textfiled.dart';

class BookDonationPage extends StatefulWidget {
  @override
  _BookDonationPageState createState() => _BookDonationPageState();
}

class _BookDonationPageState extends State<BookDonationPage> {
  // creating global variables
  final _bookdonationFormKey = GlobalKey<FormState>();
  final TextEditingController _bookdescription = TextEditingController();
  final TextEditingController _bookcount = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final DonorService donorService = DonorService();

  //final TextEditingController _nameController = TextEditingController();
  final AuthService authService = AuthService();
  final NepalAddress nepalAddress = NepalAddress();

  List<String> _selectedAreaOfInterest = [];
  List<File> images = [];
  String _selectedAddress = "Kathmandu";
  final List<String> _addresses = [
    "Kathmandu",
    "Pokhara",
    "Lumbini",
    "Chitwan",
    "Biratnagar"
  ];
  @override
  void dispose() {
    super.dispose();
    _bookdescription.dispose();
    _bookcount.dispose();
    _address.dispose();
  }

//for picking up images from phone's gallery
  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
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
                    description: _bookdescription.text,
                    count: _bookcount.text.length,
                    address: _selectedAddress,
                    type: "Book-Donation",
                    areasOfInterest: _selectedAreaOfInterest,
                    imagee: images,
                  )));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Donate Books'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _bookdonationFormKey,
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
                                  'Add Book Images',
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
                  controller: _bookdescription,
                  hintText: "Book's Description",
                ),
                SizedBox(
                  height: 20,
                ),
                FoodCountTextField(
                    CountName: 'Book-Count', controller: _bookcount),
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
                      text: "Select your area of interest",
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
                              ? Colors.blue
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
                              ? Colors.blue
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
                    if (_bookdonationFormKey.currentState!.validate()) {
                      if (images.isEmpty) {
                        showSnackBar(context,
                            "Please add the image of an item to donate!");
                      } else if (_bookcount.text.isEmpty) {
                        showSnackBar(context, "Please specify the book count!");
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => NGONear(
                                    donorName: donor.name,
                                    description: _bookdescription.text,
                                    count: int.parse(_bookcount.text),
                                    address: _selectedAddress,
                                    type: 'Book-Donation',
                                    areasOfInterest: _selectedAreaOfInterest,
                                    imagee: images))));
                      }
                    }
                  },
                  color: GlobalVariables.selectedNavBarColor,
                ),

                SizedBox(
                  height: 5,
                ),
                //Recommended Text
                const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Recommended NGOs for you",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
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
