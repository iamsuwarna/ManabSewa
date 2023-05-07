import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:manav_sewa/FrontEnd/models/ngo_model.dart';
import 'package:manav_sewa/FrontEnd/provider/Donor_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../constants/ErrorHandeling.dart';
import '../../constants/globalvariables.dart';
import '../../constants/utils.dart';

class SearchServices {
  Future<List<NGO>> fetchSearchedNGO({
    required BuildContext context,
    required String searchQuery,
  }) async {
    final donorProvider = Provider.of<DonorProvider>(context, listen: false);
    List<NGO> ngoList = [];
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/ngo/search/$searchQuery'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': donorProvider.donor.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            ngoList.add(
              NGO.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return ngoList;
  }
}
