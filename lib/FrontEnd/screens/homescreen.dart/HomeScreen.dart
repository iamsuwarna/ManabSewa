import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manav_sewa/FrontEnd/constants/about_user.dart';
import 'package:manav_sewa/FrontEnd/constants/below_appbar.dart';
import 'package:manav_sewa/FrontEnd/constants/bottom_bar.dart';
import 'package:manav_sewa/FrontEnd/donations/donation_card.dart';
import 'package:manav_sewa/FrontEnd/donations/food_card.dart';
import 'package:manav_sewa/FrontEnd/provider/Donor_provider.dart';
import 'package:manav_sewa/FrontEnd/screens/AuthScreen/sing_up.dart';
import 'package:manav_sewa/FrontEnd/screens/carousal_slider/image_slider.dart';
import 'package:manav_sewa/FrontEnd/screens/homescreen.dart/donation_related_text.dart';
import 'package:manav_sewa/main.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../CustomWidgets/custom_appbar_donor.dart';
import '../../constants/donation_item.dart';
import '../../constants/drawer.dart';
import '../../constants/globalvariables.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final donor = Provider.of<DonorProvider>(context).donor;
    return Scaffold(
      // drawer: const MyDrawer(),
      appBar: CustomAppBarDonor(
          donorName: donor.name,
          donorId: donor.id,
          donorAddress: donor.address,
          donorPhoneNumber: donor.address),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(children: [
          BelowAppBar(
            role: 'donor',
            welcomeText: 'Welcome',
          ),
          GestureDetector(
            onTap: () async {
              String url = 'https://www.ngofederation.org/';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              } else {
                throw 'Could not launch $url';
              }
            },
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 16 / 9,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
              ),
              items: [
                AssetImage('assets/childfood.jpg'),
                AssetImage('assets/food.jpg'),
                NetworkImage(
                    'https://missionnewswire.org/wp-content/uploads/2015/05/nepal-300x225.jpg'),
                NetworkImage(
                    'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8ODd8fGhlbHB8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60'),
                Image.asset('assets/dukha.jpg').image,
              ].map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.3), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image(
                            image: image as ImageProvider<Object>,
                            fit: BoxFit.cover),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),

          //ImageSlider(),
          const SizedBox(
            height: 20,
          ),
          // Text for selection
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Text("Choose your donation item",
                style: GoogleFonts.kanit(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)
                //TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
          ),
          const SizedBox(
            height: 15,
          ),
          //donation items
          DonateIcons(),

          SizedBox(
            height: 20,
          ),

          //donation card
          DonationCard(),

          SizedBox(
            height: 20,
          ),

          // custom text
          Padding(
            padding: const EdgeInsets.only(right: 56),
            child: DonationRelatedText(
              text: "Not sure where to donate food?",
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FoodCard(),
        ]),
      ),
    );
  }
}
