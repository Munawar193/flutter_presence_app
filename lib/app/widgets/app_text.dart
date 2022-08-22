import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final TextAlign textAlign;
  final double size;
  final String text;
  final Color color;
  final FontWeight fontWeight;
  const AppText({
    Key? key,
    this.size = 14,
    required this.text,
    this.color = Colors.black54,
    this.fontWeight = FontWeight.w400,
    this.textAlign = TextAlign.start,
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
      textAlign: textAlign,
    );
  }
}
