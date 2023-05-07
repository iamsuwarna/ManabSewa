import 'package:flutter/material.dart';
import 'package:manav_sewa/FrontEnd/models/donor_model.dart';

class DonorProvider extends ChangeNotifier {
  Donor _donor = Donor(
      id: '',
      name: '',
      email: '',
      phone_number: '',
      password: '',
      address: '',
      type: '',
      token: '',
      bookmark: []);
  Donor get donor => _donor;
  void setDonor(String donor) {
    _donor = Donor.fromJson(donor);
    notifyListeners();
  }

  void setDonorFromModel(Donor donor) {
    _donor = donor;
    notifyListeners();
  }
}
