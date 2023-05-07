import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manav_sewa/FrontEnd/CustomWidgets/custom_buttom.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/screens/carousal_slider/donor_or_donee.dart';
//import 'package:manav_sewa/FrontEnd/screens/carousal_ScreenSlider/donor_or_donee.dart';

class ScreenSlider extends StatefulWidget {
  ScreenSlider({Key? key}) : super(key: key);

  @override
  State<ScreenSlider> createState() => _ScreenSliderState();
}

class _ScreenSliderState extends State<ScreenSlider> {
  final List<String> _images = [
    'assets/childfood.jpg',
    'assets/food.jpg',
    'assets/reason.jpg',
    'assets/education.jpg',
    'assets/muhammad-taha-khan-0oZ7Nas7x4Q-unsplash.jpg',
  ];

  //for all different texts
  final List<TextSpan> texts = [
    const TextSpan(
      text: "2+ million hungry people\n",
      style: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontFamily: "Roboto",
        fontWeight: FontWeight.bold,
      ),
      children: [
        TextSpan(
          text:
              "Fighting hunger is what we do best. \nBut we cannot do it without you.",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ],
    ),
    const TextSpan(
      text: "Text for image 2\n",
      style: TextStyle(color: Colors.white, fontSize: 20),
      children: [
        TextSpan(
          text: "Subtext for image 2",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ],
    ),
    const TextSpan(
      text: "Text for image 3\n",
      style: TextStyle(color: Colors.white, fontSize: 20),
      children: [
        TextSpan(
          text: "Subtext for image 3",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ],
    ),
  ];

  //keep track of current page index
  int _currentPage = 0;
  int _currenttext = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Use the PageView widget to display the images
          PageView.builder(
            itemCount: _images.length,
            onPageChanged: (int index) {
              // Update the current page index when the page changes
              setState(() {
                _currentPage = index;
                _currenttext = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Image.asset(
                //'assets/2.jpg',
                '${_images[index]}',
                fit: BoxFit.cover,
              );
            },
          ),
          // Use a Positioned widget to position the dot indicators
          // at the bottom center of the screen
          Positioned(
              bottom: 120,
              left: 20,
              right: 0,
              child: RichText(
                text: texts[0],
              )),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: DotsIndicator(
                dotsCount: _images.length,
                position: _currentPage,
              ),
            ),
          ),

          Positioned(
              bottom: 16,
              right: 16,
              child: Center(
                child: CustomButton(
                    text: 'Donate Now',
                    color: GlobalVariables.secondaryColor,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AskPeople()));
                    }),
              )),
        ],
      ),
    );
  }
}

class DotsIndicator extends StatelessWidget {
  final int dotsCount;
  final int position;

  DotsIndicator({
    required this.dotsCount,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        dotsCount,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == position ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
