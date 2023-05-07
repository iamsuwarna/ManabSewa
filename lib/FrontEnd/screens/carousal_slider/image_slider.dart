// import 'package:flutter/material.dart';

// class ImageSlider extends StatefulWidget {
//   @override
//   _ImageSliderState createState() => _ImageSliderState();
// }

// class _ImageSliderState extends State<ImageSlider> {
//   int _current = 0;
//   final List<String> _images = [
//     'assets/education.jpg',
//     'assets/childfood.jpg',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
//       height: 250,
//       margin: const EdgeInsets.only(left: 25, right: 25),
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
//         elevation: 10,
//         child: Container(
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
//           height: 250,
//           margin: const EdgeInsets.only(left: 25, right: 25),
//           child: PageView.builder(
//             itemCount: _images.length,
//             onPageChanged: (index) {
//               setState(() {
//                 _current = index;
//               });
//             },
//             itemBuilder: (context, index) {
//               return Image.asset(_images[index], fit: BoxFit.cover);
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _current = 0;
  final List<String> _images = [
    'assets/dukha.jpg',
    'assets/childfood.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        elevation: 10,
        child: SizedBox(
          height: 250,
          child: PageView.builder(
            itemCount: _images.length,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                _images[index],
                fit: BoxFit.contain,
                height: 250,
                width: double.infinity,
              );
            },
          ),
        ),
      ),
    );
  }
}
