import 'package:flutter/cupertino.dart';
import 'package:manav_sewa/FrontEnd/models/food_donation_model.dart';
import 'package:manav_sewa/FrontEnd/provider/Donor_provider.dart';
import 'package:manav_sewa/FrontEnd/provider/ngo_provider.dart';
import 'package:provider/provider.dart';

class FoodDonationProvider extends ChangeNotifier {
  FoodDonationModel _foodDonation = FoodDonationModel(
    food_description: '',
    food_count: 0,
    address: '',
    areasOfInterest: [],
    images: [],
    donorName: '',
    ngo_id: '',
  );

  FoodDonationModel get foodDonation => _foodDonation;

  void setFoodDonation(String foodDonation) {
    _foodDonation = FoodDonationModel.fromJson(foodDonation);
    notifyListeners();
  }

  void setFoodDonationFromModel({
    required BuildContext context,
    required String foodDescription,
    required int foodCount,
    required String address,
    required List<String> areasOfInterest,
    required List<String> images,
  }) {
    final donor = Provider.of<DonorProvider>(context, listen: false).donor;
    final ngo = Provider.of<NGOProvider>(context, listen: false).ngo;
    _foodDonation = FoodDonationModel(
        food_description: foodDescription,
        food_count: foodCount,
        address: address,
        areasOfInterest: areasOfInterest,
        images: images,
        donorName: donor.name,
        ngo_id: ngo.ngo_id);
    notifyListeners();
  }
}
