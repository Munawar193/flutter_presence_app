import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFormInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  const CustomFormInput({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white60.withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          color: Colors.black54,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
          icon: Icon(icon),
        ),
      ),
    );
  }
}
