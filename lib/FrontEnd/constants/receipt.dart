// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:open_file/open_file.dart';

// class PdfDownloadScreen extends StatefulWidget {
//   @override
//   _PdfDownloadScreenState createState() => _PdfDownloadScreenState();
// }

// class _PdfDownloadScreenState extends State<PdfDownloadScreen> {
//   final pdf = pw.Document();
//   late String savePath;

//   @override
//   void initState() {
//     super.initState();
//     _getPermission();
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

//   Future<void> _savePdf() async {
//     pdf.addPage(pw.Page(
//         build: (pw.Context context) => pw.Center(
//               child: pw.Text(nameController.text),
//             )));
//     final file = File('$savePath/${nameController.text}.pdf');
//     await file.writeAsBytes(await pdf.save());
//     OpenFile.open(file.path);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Download'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             Text(
//               'Enter your name:',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: TextFormField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Your name',
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _savePdf,
//               child: Text('Download PDF'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
