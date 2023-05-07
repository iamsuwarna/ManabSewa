import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:manav_sewa/FrontEnd/NGO/services/bookmarkService.dart';
import 'package:manav_sewa/FrontEnd/provider/Donor_provider.dart';
import 'package:manav_sewa/FrontEnd/services/donor_work_likedonates/donor_service.dart';
import 'package:manav_sewa/FrontEnd/services/ngo_work_likeaccpet/ngo-details-services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../CustomWidgets/custom_appbar_donor.dart';
import '../../CustomWidgets/custom_appbar_ngo.dart';
import '../../NGO/services/ngo_login_service.dart';
import '../../constants/below_appbar.dart';
import '../../constants/bookmark.dart';
import '../../models/donation_model.dart';
import '../../provider/ngo_provider.dart';

class CompletedDonations extends StatefulWidget {
  const CompletedDonations({Key? key}) : super(key: key);

  @override
  State<CompletedDonations> createState() => _CompletedDonationsState();
}

class _CompletedDonationsState extends State<CompletedDonations> {
  final DisplayNGODonations displayDonations = DisplayNGODonations();
  final DonorService donorService = DonorService();
  final NGODetailsServices ngoDetailsServices = NGODetailsServices();
  String _searchKeyword = '';
  final TextEditingController _searchController = TextEditingController();
//     final ngoProvider = Provider.of<NGOProvider>(context);

  final pdf = pw.Document();
  late String savePath;
  @override
  void initState() {
    super.initState();
    _getPermission();
    getdata();
  }

  void _getPermission() async {
    if (await Permission.storage.request().isGranted) {
      savePath = await _createFolderInExternalStorage();
    }
  }

  Future<String> _createFolderInExternalStorage() async {
    final root = await getExternalStorageDirectory();
    final folderName = 'PDFs';
    final folder = Directory('${root?.path}/$folderName/');
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    if (await folder.exists()) {
      return folder.path;
    } else {
      final createdFolder = await folder.create(recursive: true);
      return createdFolder.path;
    }
  }

  List<DonationModel> donationModel = [];
  final BookmarkService bookmarkService = BookmarkService();
  void getdata() async {
    donationModel = await displayDonations.getCompletedDonations(context);
    setState(() {
      print(donationModel.length);
    });
  }

  void onSearchTextChanged(String value) {
    setState(() {
      _searchKeyword = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ngoProvider = Provider.of<NGOProvider>(context).ngo;
    final donorProvider = Provider.of<DonorProvider>(context).donor;
    return Scaffold(
      appBar: CustomAppBarDonor(
          donorName: donorProvider.name,
          donorId: donorProvider.id,
          donorAddress: donorProvider.address,
          donorPhoneNumber: donorProvider.address),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 100, top: 10),
              child: Text('Completed Donations',
                  style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by donation description',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: onSearchTextChanged,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 500,
              child: donationModel.isNotEmpty
                  ? ListView.builder(
                      itemCount: donationModel.length,
                      itemBuilder: ((context, index) {
                        // Sort the donationModel list in descending order based on donationid
                        donationModel.sort(
                            (a, b) => b.donationid.compareTo(a.donationid));
                        Future<void> _savePdf() async {
                          // Add app logo to the PDF
                          final ByteData imageData =
                              await rootBundle.load('assets/logo1.PNG');
                          final Uint8List imageBytes =
                              imageData.buffer.asUint8List();
                          final image =
                              PdfImage.file(pdf.document, bytes: imageBytes);

                          final pw.Widget content = pw.Container(
                            //decoration: pw.BoxDecoration(color: PdfColors.grey300),
                            padding: pw.EdgeInsets.all(20.0),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Center(
                                  child: pw.Image(
                                    pw.MemoryImage(imageBytes),
                                  ),
                                ),
                                pw.SizedBox(height: 20),
                                pw.Text(
                                  'Donor Name: ${donationModel[0].donorName}',
                                  style: pw.TextStyle(),
                                ),
                                pw.SizedBox(height: 15),
                                pw.Text(
                                  'Phone Number: ${donationModel[0].phone_number}',
                                  style: pw.TextStyle(),
                                ),
                                pw.SizedBox(height: 15),
                                pw.Text(
                                  'Address: ${donationModel[0].address}',
                                ),
                                pw.SizedBox(height: 15),
                                pw.Divider(height: 1),
                                pw.SizedBox(height: 15),
                                pw.Text(
                                  'Donation Description: ${donationModel[0].description}',
                                ),
                                pw.SizedBox(height: 15),
                                pw.Divider(height: 1),
                                pw.SizedBox(height: 25),
                                pw.Text(
                                  'Thank you for your donation!',
                                ),
                                pw.SizedBox(height: 5),
                              ],
                            ),
                          );

                          pdf.addPage(
                              pw.Page(build: (pw.Context context) => content));
                          final file = File(
                              '$savePath/${donationModel[0].donorName}.pdf');
                          await file.writeAsBytes(await pdf.save());
                          OpenFile.open(file.path);
                        }

                        if (_searchKeyword.isNotEmpty &&
                            !donationModel[index]
                                .description
                                .contains(_searchKeyword))
                          return const SizedBox.shrink();
                        return Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Donor: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      TextSpan(
                                        text: donationModel[index].donorName,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Donation From: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      TextSpan(
                                        text: donationModel[index].address,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Donation Type: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      TextSpan(
                                        text: donationModel[index].type,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Donation Description: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      TextSpan(
                                        text: donationModel[index].description,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Donated To: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      TextSpan(
                                        text: donationModel[index].ngo_name,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Donated on: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      TextSpan(
                                        text: donationModel[index].date != null
                                            ? DateFormat('yyyy-MM-dd').format(
                                                donationModel[index].date!)
                                            : '',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    'Rate the NGO',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                //for rating
                                RatingBar.builder(
                                  initialRating: 0,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.orangeAccent,
                                  ),
                                  onRatingUpdate: (rating) {
                                    ngoDetailsServices.RateNgo(
                                        context: context,
                                        ngo_to_rate:
                                            donationModel[index].ngo_id,
                                        rating: rating);

                                    // donorService.rateNGO(
                                    //     context: context,
                                    //     ngo: ngoProvider.ngo,
                                    //     rating: rating);
                                  },
                                ),

                                const SizedBox(height: 15),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 160, top: 20),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                int num = int.parse(
                                                    donationModel[index]
                                                        .ngo_id);
                                                bookmarkService.bookmarkNGO(
                                                    context: context,
                                                    ngo_id: num,
                                                    donor_id:
                                                        donationModel[index]
                                                            .donorId,
                                                    ngo_name:
                                                        donationModel[index]
                                                            .ngo_name!,
                                                    ngo_address:
                                                        donationModel[index]
                                                            .ngo_address!,
                                                    ngo_emailaddress:
                                                        donationModel[index]
                                                            .ngo_emailaddress!,
                                                    ngo_phonenumber:
                                                        donationModel[index]
                                                            .ngo_phonenumber!);
                                              },
                                              child:
                                                  Icon(Icons.bookmark_outline)),
                                          Text(
                                            'Favourite NGO',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                _savePdf();
                                              },
                                              child: Icon(
                                                  Icons.download_outlined)),
                                          Text(
                                            'Download Receipt',
                                            style: TextStyle(fontSize: 10),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                                // Row(
                                //   children: [
                                //     GestureDetector(
                                //       onTap: () {
                                //         int num = int.parse(
                                //             donationModel[index].ngo_id);
                                //         bookmarkService.bookmarkNGO(
                                //             context: context,
                                //             ngo_id: num,
                                //             donor_id:
                                //                 donationModel[index].donorId,
                                //             ngo_name:
                                //                 donationModel[index].ngo_name!,
                                //             ngo_address: donationModel[index]
                                //                 .ngo_address!,
                                //             ngo_emailaddress:
                                //                 donationModel[index]
                                //                     .ngo_emailaddress!,
                                //             ngo_phonenumber:
                                //                 donationModel[index]
                                //                     .ngo_phonenumber!);
                                //         // Navigator.pushReplacement(
                                //         //   context,
                                //         //   MaterialPageRoute(
                                //         //       builder: (context) =>
                                //         //           BookmarkScreen()),
                                //         // );
                                //       },
                                //       child: Text(
                                //         'Bookmark',
                                //         style: TextStyle(fontSize: 16),
                                //       ),

                                //       //forget password
                                //     ),
                                //     GestureDetector(
                                //         onTap: () {
                                //           _savePdf();
                                //         },
                                //         child: Text('download receipt'))
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        );
                      }),
                    )
                  : Center(child: const Text('No completed donations')),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

// import '../../NGO/services/ngo_login_service.dart';
// import '../../models/donation_model.dart';

// class CompletedDonations extends StatefulWidget {
//   const CompletedDonations({Key? key}) : super(key: key);

//   @override
//   State<CompletedDonations> createState() => _CompletedDonationsState();
// }

// class _CompletedDonationsState extends State<CompletedDonations> {
//   final DisplayNGODonations displayDonations = DisplayNGODonations();

//   @override
//   void initState() {
//     super.initState();
//     getdata();
//   }

//   List<DonationModel> donationModel = [];

//   void getdata() async {
//     donationModel = await displayDonations.getNgoDonations(context, false);
//     setState(() {
//       print(donationModel.length);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Completed Donations'),
//       ),
//       body: ListView.builder(
//         itemCount: donationModel.length,
//         itemBuilder: (context, index) {
//           return Card(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     donationModel[index].donorName,
//                     style: TextStyle(
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     donationModel[index].address,
//                     style: TextStyle(
//                       fontSize: 16.0,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'Donation Type: ${donationModel[index].type}',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'Donation Count: ${donationModel[index].count}',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'Donation Description: ${donationModel[index].description}',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:manav_sewa/FrontEnd/provider/ngo_provider.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:manav_sewa/FrontEnd/constants/receipt.dart';
// import 'package:manav_sewa/FrontEnd/services/donor_work_likedonates/donor_service.dart';
// import 'package:provider/provider.dart';
// import '../../NGO/services/ngo_login_service.dart';
// import '../../models/donation_model.dart';
// import '../../models/ngo_model.dart';
// import '../../provider/Donor_provider.dart';

// class CompletedDonations extends StatefulWidget {
//   //final NGO ngo;
//   const CompletedDonations({
//     Key? key,
//     //required this.ngo,
//   }) : super(key: key);
//   @override
//   State<CompletedDonations> createState() => _CompletedDonationsState();
// }

// class _CompletedDonationsState extends State<CompletedDonations> {
//   final DisplayNGODonations displayDonations = DisplayNGODonations();
//   final DonorService donorService = DonorService();

//   final pdf = pw.Document();
//   late String savePath;
//   @override
//   void initState() {
//     super.initState();
//     _getPermission();
//     getdata();
//   }

//   void _getPermission() async {
//     if (await Permission.storage.request().isGranted) {
//       savePath = await _createFolderInExternalStorage();
//     }
//   }

//   Future<String> _createFolderInExternalStorage() async {
//     final root = await getExternalStorageDirectory();
//     final folderName = 'PDFs';
//     final folder = Directory('${root?.path}/$folderName/');
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }

//     if (await folder.exists()) {
//       return folder.path;
//     } else {
//       final createdFolder = await folder.create(recursive: true);
//       return createdFolder.path;
//     }
//   }

//   List<DonationModel> donationModel = [];

//   void getdata() async {
//     donationModel = await displayDonations.getNgoDonations(context, false);
//     setState(() {
//       print('This is the length');
//       print(donationModel.length);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ngoProvider = Provider.of<NGOProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Completed Donations'),
//       ),
//       body: ListView.builder(
//         itemCount: donationModel.length,
//         itemBuilder: (context, index) {
//           Future<void> _savePdf() async {
//             // Add app logo to the PDF
//             final ByteData imageData =
//                 await rootBundle.load('assets/logo1.PNG');
//             final Uint8List imageBytes = imageData.buffer.asUint8List();
//             final image = PdfImage.file(pdf.document, bytes: imageBytes);

//             final pw.Widget content = pw.Container(
//               //decoration: pw.BoxDecoration(color: PdfColors.grey300),
//               padding: pw.EdgeInsets.all(20.0),
//               child: pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Center(
//                     child: pw.Image(
//                       pw.MemoryImage(imageBytes),
//                     ),
//                   ),
//                   pw.SizedBox(height: 20),
//                   pw.Text(
//                     'Donor Name: ${donationModel[0].donorName}',
//                     style: pw.TextStyle(),
//                   ),
//                   pw.SizedBox(height: 5),
//                   pw.Text(
//                     'Address: ${donationModel[0].address}',
//                   ),
//                   pw.SizedBox(height: 5),
//                   pw.Divider(height: 1),
//                   pw.SizedBox(height: 5),
//                   pw.Text(
//                     'Donation Description: ${donationModel[0].description}',
//                   ),
//                   pw.SizedBox(height: 5),
//                   pw.Divider(height: 1),
//                   pw.SizedBox(height: 5),
//                   pw.Text(
//                     'Thank you for your donation!',
//                   ),
//                   pw.SizedBox(height: 5),
//                 ],
//               ),
//             );

//             pdf.addPage(pw.Page(build: (pw.Context context) => content));
//             final file = File('$savePath/${donationModel[0].donorName}.pdf');
//             await file.writeAsBytes(await pdf.save());
//             OpenFile.open(file.path);
//           }

//           return Card(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     donationModel[index].donorName,
//                     style: TextStyle(
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     donationModel[index].address,
//                     style: TextStyle(
//                       fontSize: 16.0,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'Donation Type: ${donationModel[index].type}',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'Donation Count: ${donationModel[index].count}',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'Donation Description: ${donationModel[index].description}',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     child: Text(
//                       'Rate the NGO',
//                       style:
//                           TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                     ),
//                   ),

//                   //for rating
//                   RatingBar.builder(
//                       initialRating: 0,
//                       minRating: 1,
//                       direction: Axis.horizontal,
//                       allowHalfRating: true,
//                       itemCount: 5,
//                       itemPadding: const EdgeInsets.symmetric(horizontal: 4),
//                       itemBuilder: (context, _) =>
//                           const Icon(Icons.star, color: Colors.red),
//                       onRatingUpdate: (rating) {
//                         donorService.rateNGO(
//                             context: context,
//                             ngo: ngoProvider.ngo,
//                             rating: rating);
//                       }),
//                   SizedBox(height: 10.0),
//                   GestureDetector(
//                     onTap: () {
//                       _savePdf();
//                     },
//                     child: Row(
//                       children: [
//                         Text('download receipt'),
//                         Icon(Icons.download)
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
