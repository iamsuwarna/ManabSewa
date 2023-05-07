// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:io';

// class CameraApp extends StatefulWidget {
//   @override
//   _CameraAppState createState() => _CameraAppState();
// }

// class _CameraAppState extends State<CameraApp> {
//   CameraController _controller;
//   List<CameraDescription> cameras;
//   String _imagePath;

//   @override
//   void initState() {
//     super.initState();
//     _getCameras();
//   }

//   Future<void> _getCameras() async {
//     cameras = await availableCameras();
//     if (cameras.length > 0) {
//       _controller = CameraController(cameras[0], ResolutionPreset.medium);
//       await _controller.initialize();
//       setState(() {});
//     } else {
//       print("No Camera Found");
//     }
//   }

//   Future<void> _takePicture() async {
//     final path =
//         join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');
//     await _controller.takePicture(path);
//     setState(() {
//       _imagePath = path;
//     });
//   }

//   Future<void> _askPermission() async {
//     final status = await Permission.camera.status;
//     if (status.isUndetermined) {
//       final result = await Permission.camera.request();
//       if (result == PermissionStatus.granted) {
//         _getCameras();
//       }
//     } else if (status.isDenied) {
//       openAppSettings();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _controller != null
//           ? CameraPreview(_controller)
//           : Center(child: Text('No Camera Found')),
//       floatingActionButton: _controller != null
//           ? FloatingActionButton(
//               onPressed: _takePicture,
//               child: Icon(Icons.camera),
//             )
//           : Container(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }
