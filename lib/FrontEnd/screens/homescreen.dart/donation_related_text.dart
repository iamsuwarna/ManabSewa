import 'package:flutter/cupertino.dart';

class DonationRelatedText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
  const DonationRelatedText({
    Key? key,
    required this.text,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontStyle: fontStyle,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
