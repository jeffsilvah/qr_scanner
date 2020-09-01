import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextAlign align;
  final Color color;
  final FontWeight weight;
  final double size;
  final double spacing;

  CustomText({this.text, this.align, this.color, this.weight, this.size, this.spacing});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontWeight: weight,
        fontSize: size,
        letterSpacing: spacing,
        fontFamily: 'Saira',
      ),
    );
  }
}