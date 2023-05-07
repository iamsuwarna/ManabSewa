import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manav_sewa/FrontEnd/CustomWidgets/custom_buttom.dart';
import 'package:manav_sewa/FrontEnd/NGO/ngo_screen/view_ngodonations.dart';
import 'package:manav_sewa/FrontEnd/NGO/ngo_signup.dart';
import 'package:manav_sewa/FrontEnd/constants/about_ngo.dart';
import 'package:manav_sewa/FrontEnd/constants/about_user.dart';
import 'package:provider/provider.dart';

import '../../../CustomWidgets/custom_appbar_ngo.dart';
import '../../../constants/below_appbar.dart';
import '../../../constants/globalvariables.dart';
import '../../../provider/Donor_provider.dart';
import '../../../provider/ngo_provider.dart';
import '../ngo_completed_donation.dart';

class HomeScreenNGO extends StatefulWidget {
  const HomeScreenNGO({Key? key}) : super(key: key);

  @override
  State<HomeScreenNGO> createState() => _HomeScreenNGOState();
}

class _HomeScreenNGOState extends State<HomeScreenNGO> {
  @override
  Widget build(BuildContext context) {
    final ngo = Provider.of<NGOProvider>(context).ngo;
    final donor = Provider.of<DonorProvider>(context, listen: false).donor;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BelowAppBar(
              role: 'ngo',
              welcomeText: 'Welcome',
            ),
            SizedBox(height: 20),
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 16 / 9,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
              ),
              items: [
                NetworkImage(
                    'https://images.unsplash.com/photo-1594708767771-a7502209ff51?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8TkdPfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60'),
                NetworkImage(
                    'https://images.unsplash.com/photo-1509239767605-0703ef611f08?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fGhlbHAlMjBwZW9wbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60'),
                NetworkImage(
                    'https://missionnewswire.org/wp-content/uploads/2015/05/nepal-300x225.jpg'),
                NetworkImage(
                    'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8ODd8fGhlbHB8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60'),
                NetworkImage('https://static.dw.com/image/18408239_604.jpg')
              ].map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Image(image: image),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'About our NGO',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'We are a non-profit organization dedicated to supporting communities in need. Our mission is to provide access to basic needs such as food, clothing and education to underserved populations of Nepal.',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              color: Colors.white,
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: MediaQuery.of(context).size.width / 2),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 25),
                    child: CustomButton(
                        text: 'See Donations',
                        color: GlobalVariables.selectedNavBarColor,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewNGODonations()));
                        })),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 25),
                  child: CustomButton(
                      text: 'Completed donations',
                      color: GlobalVariables.selectedNavBarColor,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NGOCompletedDonation()));
                      }),
                ),
              ],
            ),

            //for last text
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                  child: Text(
                '@' + ngo.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
