import 'package:flutter/cupertino.dart';
import 'package:manav_sewa/FrontEnd/models/ngo_model.dart';

class NGOProvider extends ChangeNotifier {
  NGO _ngo = NGO(
      ngo_id: '',
      name: '',
      address: '',
      password: '',
      phone_number: '',
      token: '',
      email1: '',
      email: ''
      // type: '',
      );
  NGO get ngo => _ngo;
  void setNGO(String ngo) {
    _ngo = NGO.fromJson(ngo);
    notifyListeners();
  }

  void setNGOFromModel(NGO ngo) {
    _ngo = ngo;
    notifyListeners();
  }
}
