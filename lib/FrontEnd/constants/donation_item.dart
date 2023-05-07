import 'package:flutter/material.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/donations/book_donation.dart';
import 'package:manav_sewa/FrontEnd/donations/cloth_donation.dart';
import 'package:manav_sewa/FrontEnd/donations/food_donation.dart';
import 'package:provider/provider.dart';

import '../provider/Donor_provider.dart';
import '../provider/ngo_provider.dart';

class DonateIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final donor = Provider.of<DonorProvider>(context, listen: false).donor;
    final ngo = Provider.of<NGOProvider>(context, listen: false).ngo;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: GlobalVariables.selectedNavBarColor,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FoodDonationPage()));
                },
                child: Icon(
                  Icons.local_dining,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Food",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(width: 20),
        Column(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: GlobalVariables.selectedNavBarColor,
              ),
              child: GestureDetector(
                onTap: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClothDonationPage()));
                }),
                child: Icon(
                  Icons.local_laundry_service,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Cloth",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(width: 20),
        Column(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: GlobalVariables.selectedNavBarColor,
              ),
              child: GestureDetector(
                onTap: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookDonationPage()));
                }),
                child: Icon(
                  Icons.book,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Book",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
