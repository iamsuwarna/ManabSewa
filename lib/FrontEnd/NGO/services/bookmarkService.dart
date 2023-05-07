import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/models/bookmark_model.dart';
import 'package:manav_sewa/FrontEnd/models/donation_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../constants/ErrorHandeling.dart';
import '../../constants/utils.dart';
import '../../provider/Donor_provider.dart';
import '../../provider/ngo_provider.dart';

class BookmarkService {
  void bookmarkNGO({
    required BuildContext context,
    required int ngo_id,
    required String ngo_name,
    required String ngo_address,
    required String ngo_phonenumber,
    required String ngo_emailaddress,
    required String donor_id,
  }) async {
    final ngo = Provider.of<NGOProvider>(context, listen: false).ngo;
    final donor = Provider.of<DonorProvider>(context, listen: false).donor;
    try {
      BookmaarkModel bookmaarkModel = BookmaarkModel(
        BookmarkId: '',
        donorId: donor_id,
        NGOId: ngo_id,
        NGOName: ngo_name,
        NGOAddress: ngo_address,
        NGOPhoneNumber: ngo_phonenumber,
        NGOEmailAddress: ngo_emailaddress,
      );
      http.Response res = await http.post(
        Uri.parse('$uri/bookmark'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': donor.token,
        },
        body: bookmaarkModel.toJson(),
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, "NGO added as a favourite");
          });
    } catch (e) {
      print("Failed here only");
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  // for fetching bookmark
  Future<List<BookmaarkModel>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<DonorProvider>(context, listen: false);
    List<BookmaarkModel> eventList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/fetch-bookmark'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.donor.token,
      });
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            // convert received json response into product model
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              eventList.add(
                  BookmaarkModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return eventList;
  }
}
