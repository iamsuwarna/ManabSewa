import 'package:flutter/cupertino.dart';
import 'package:manav_sewa/FrontEnd/models/cloth_donation_model.dart';
import 'package:manav_sewa/FrontEnd/provider/Donor_provider.dart';
import 'package:manav_sewa/FrontEnd/provider/ngo_provider.dart';
import 'package:provider/provider.dart';

class ClothDonationProvider extends ChangeNotifier {
  ClothDonationModel _clothDonation = ClothDonationModel(
    cloth_description: '',
    cloth_count: 0,
    address: '',
    areasOfInterest: [],
    images: [],
    donorName: '',
    ngo_id: '',
  );

  ClothDonationModel get clothDonation => _clothDonation;

  void setClothDonation(String clothDonation) {
    _clothDonation = ClothDonationModel.fromJson(clothDonation);
    notifyListeners();
  }

  void setClothDonationFromModel({
    required BuildContext context,
    required String clothDescription,
    required int clothCount,
    required String address,
    required List<String> areasOfInterest,
    required List<String> images,
  }) {
    final donor = Provider.of<DonorProvider>(context, listen: false).donor;
    final ngo = Provider.of<NGOProvider>(context, listen: false).ngo;
    _clothDonation = ClothDonationModel(
        cloth_description: clothDescription,
        cloth_count: clothCount,
        address: address,
        areasOfInterest: areasOfInterest,
        images: images,
        donorName: donor.name,
        ngo_id: ngo.ngo_id);
    notifyListeners();
  }
}
