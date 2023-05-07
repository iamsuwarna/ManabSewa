import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/provider/Donor_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../constants/ErrorHandeling.dart';
import '../../constants/utils.dart';
import '../../models/ngo_model.dart';

class NGODetailsServices {
  void RateNgo(
      {required BuildContext context,
      required String ngo_to_rate,
      required double rating}) async {
    //provider for donor who gave rating
    final donorProvider = Provider.of<DonorProvider>(context, listen: false);

    try {
      http.Response res = await http.post(Uri.parse('$uri/api/rate_the_ngo'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': donorProvider.donor.token,
          },
          body: jsonEncode({
            'id': ngo_to_rate,
            'rating': rating,
          }));
      httpErrorHandle(response: res, context: context, onSuccess: () {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
