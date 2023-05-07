import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:manav_sewa/FrontEnd/CustomWidgets/custom_appbar_ngo.dart';
import 'package:manav_sewa/FrontEnd/NGO/services/ngo_login_service.dart';
import 'package:manav_sewa/FrontEnd/constants/below_appbar.dart';
import 'package:manav_sewa/FrontEnd/services/donor_work_likedonates/donor_service.dart';
import 'package:manav_sewa/FrontEnd/services/ngo_work_likeaccpet/ngo-details-services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/donation_model.dart';
import '../../provider/Donor_provider.dart';
import '../../provider/ngo_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class NGOCompletedDonation extends StatefulWidget {
  NGOCompletedDonation({Key? key}) : super(key: key);

  @override
  State<NGOCompletedDonation> createState() => _NGOCompletedDonationState();
}

class _NGOCompletedDonationState extends State<NGOCompletedDonation> {
  final DisplayNGODonations displayDonations = DisplayNGODonations();
  final DonorService donorService = DonorService();
  final NGODetailsServices ngoDetailsServices = NGODetailsServices();
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

  void getdata() async {
    donationModel = await displayDonations.getCompletedDonations(context);
    setState(() {
      print(donationModel.length);
    });
  }

  Widget build(BuildContext context) {
    final ngoProvider = Provider.of<NGOProvider>(context).ngo;
    final donorProvider = Provider.of<DonorProvider>(context).donor;
    return Scaffold(
      appBar: CustomAppBar(
        ngoAddress: ngoProvider.address,
        ngoId: ngoProvider.ngo_id,
        ngoName: ngoProvider.name,
        ngoPhoneNumber: ngoProvider.phone_number,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
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
            SizedBox(height: 20),
            Container(
              height: 500,
              child: donationModel.isNotEmpty
                  ? ListView.builder(
                      itemCount: donationModel.length,
                      itemBuilder: ((context, index) {
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

                        return Card(
                          elevation: 4,
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Donation Type: ${donationModel[index].type}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 12.0),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Donation By: ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${donationModel[index].type}',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12.0),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'From: ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${donationModel[index].address}',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Donation Count: ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${donationModel[index].count}',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Donation Description:',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  donationModel[index].description,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Text(
                                      'Donated On: ',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      donationModel[index].date != null
                                          ? '${DateFormat('yyyy-MM-dd').format(donationModel[index].date!)}'
                                          : '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blueGrey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 200, top: 10),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            _savePdf();
                                          },
                                          child: Icon(Icons.download_outlined)),
                                      Text(
                                        'Download Receipt',
                                        style: TextStyle(fontSize: 10),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    )
                  : Center(
                      child: Text(
                        'No completed donations',
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
