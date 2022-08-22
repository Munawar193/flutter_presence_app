import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLargeText extends StatelessWidget {
  final double size;
  final String text;
  final Color color;
  final FontWeight fontWeight;
  const AppLargeText({
    Key? key,
    this.size = 20,
    required this.text,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w700,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: size,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
