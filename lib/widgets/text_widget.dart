import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double letterSpace;
  final double size;
  final FontWeight fontWeight;
  final Color color;

  TextWidget(this.text, this.size, this.color, this.fontWeight,
      {super.key, this.letterSpace = 3});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: fontWeight,
          letterSpacing: letterSpace),
    );
  }
}
